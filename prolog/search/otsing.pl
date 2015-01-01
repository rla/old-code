% Prologi moodul otsingustrateegiate jaoks.
% Raivo Laanemets, rlaanemt@ut.ee, 29.11.06

:-module(otsing, [
	otsing/5,
	otsing/7
]).

:-use_module(priority_queue).

:-dynamic(kaidud/1).
:-index(kaidud(1)).

% Laiuti pimeotsing.

% A - algseis
% L - lõppseis
% E - otsingut laiendav predikaat
% P - tee lõppseisuni

otsing(laiuti, A, L, E, P):-
	otsing_laiuti(A, L, E, P).

% Iteratiivne süvitsiotsing

% A - algseis
% L - lõppseis
% E - otsingut laiendav predikaat
% P - tee lõppseisuni

otsing(iteratiivne-suvitsi, A, L, E, P):-
	otsing_id(A, L, E, P).

% Heuristiline otsing A*

% A - algseis
% L - lõppseis
% E - otsingut laiendav predikaat
% SH - seisu hindav predikaat
% KH - käiku hindav predikaat
% T - tee algseisust lõppseisuni

otsing(a-tarn, A, A, _, _, _, _):- !.

otsing(a-tarn, A, L, LP, SH, KH, T):-
	otsing_atarn(A, L, LP, SH, KH, T).

% Heuristiline otsing A* prioriteetidega
% järjekorra abil.

otsing(a-tarn-q, A, A, _, _, _, _):- !.

otsing(a-tarn-q, A, L, LP, SH, KH, T):-
	otsing_atarn_q(A, L, LP, SH, KH, T).

% Laiutiotsing

% A - algseis
% L - lõppseis
% E - laiendav predikaat
% P - tee lõppseisuni

otsing_laiuti(A, L, E, P):-
	otsing_laiuti(L, E, P, [([], A)], []).

% L - lõppseis
% E - laiendav predikaat
% P - tee
% Ks - käidavad tipud
% Vs - seni läbi käidud tipud

% Tegemist lõppseisuga.

otsing_laiuti(L, _, P, [(P, L)|_], _).

% Peame edasi otsima mingist seisust K.

otsing_laiuti(L, E, P, [(P1, K)|Ks], Vs):-
	(member(K, Vs) ->
		% Seisu on varem jõutud, ära laienda
		otsing_laiuti(L, E, P, Ks, Vs)
		;
		% Leia käidavad seisud koos teedega
		call(E, P1, K, Ns),
		% Lisa listi
		append(Ks, Ns, Ks1),
		% Otsi edasi
		otsing_laiuti(L, E, P, Ks1, [K|Vs])
	).

% Iteratiivne süvitsiotsing

otsing_id(A, L, E, P):-
	% Fikseeri sügavuslimiit
	between(1, 1000000, D),
	% Alusta otsingut
	otsing_id(A, L, E, P, D, [], []).

% Jõudsime lõpptipuni

otsing_id(L, L, _, S, _, S, _).

% Otsingusügavus on ammendatud

otsing_id(_, _, _, _, 0, _, _):- !, fail.

otsing_id(A, L, E, P, D, S, Vs):-
	% Leia käidavad seisud koos teedega
	call(E, S, A, Ns),
	% Võta üks seis, mis pole veel läbitud
	member((S1, A1), Ns),
	\+ member(A1, Vs),
	% Ja otsi sealt edasi
	D1 is D - 1,
	otsing_id(A1, L, E, P, D1, S1, [A1|Vs]).

otsing_atarn(A, L, LP, SH, KH, T):-
	% Laiendame algseisu
	call(LP, [], A, Ks),
	% Hindame saadud seisud
	hinda_seisud(Ks, 0, SH, KH, HKs),
	% Alustame otsingut
	otsing_atarn_r(L, LP, SH, KH, T, HKs, [A]).

% Rekursiivne otsinguprotseduur A* jaoks

% L - lõppseid
% LP - otsingut laiendav predikaat
% SH - seisu hindav predikaat
% KH - käiku hindav predikaat
% T - tee lõppseisuni
% HKs - seini läbi vaadatud seisud koos hinnangutega
% Vs - läbi käidud seisud

otsing_atarn_r(L, LP, SH, KH, T, HKs, Vs):-
	% Võtame parima seni leitud käigu,
	vota_parim(HKs, S, T1, H0, Vs),
	% mis ei ole läbitud ..
	%\+ member(S, Vs),
	% Vaatame, kas tegemist lõppseisuga
	((L = S) ->
		% Leiame tee
		T = T1
		;
		% Laiendame otsingut
		call(LP, T1, S, Ks),
		% Hindame saadud seisud
		hinda_seisud(Ks, H0, SH, KH, HKs1),
		% Paneme seisud listi
		append(HKs, HKs1, HKs2),
		% Otsime edasi
		otsing_atarn_r(L, LP, SH, KH, T, HKs2, [S|Vs])
	).

% Parima käigu võtmine hinnatud käikude hulgast

vota_parim(HKs, S, T, H, Vs):-
	% Sorteerime esimese parameetri (hinnang) järgi
	keysort(HKs, HKs1),
	% Hakkame otsast võtma
	member((H-(T, S)), HKs1),
	\+ member(S, Vs), !.

% Seisude hindamine A* jaoks

% Ks - list seisudest ([O|Os], S)
% H0 - eelmise seisu hinnang
% SH - seisu hindav predikaat
% KH - käiku hindav predikaat
% HKs - hinnatud seisud (H, [[O|Os], S])

hinda_seisud([([O|Os], S)|Ks], H0, SH, KH, [(H-([O|Os], S))|HKs]):-
	% Leiame seni tehtud käikude arvu
	length([O|Os], L),
	% Leiame seisu hinnangu (h(n))
	call(SH, S, H1),
	% Leiame käigu hinnangu (g(n))
	call(KH, O, L, H2),
	% Arvutame koguhinnangu
	H is H0 + H1 + H2,
	hinda_seisud(Ks, H0, SH, KH, HKs).

hinda_seisud([], _, _, _, []).

% A* prioriteetidega järjendi abil.

otsing_atarn_q(A, L, LP, SH, KH, T):-
	% Tühjendame käidud seisude listi
	retractall(kaidud(_)),
	% Teeme uue järjekorra
	empty(Q),
	% Laiendame algseisu
	call(LP, [], A, Ks),
	% Hindame saadud seisud ja salvestame
	% need järjekorda
	hinda_seisud_q(Ks, Q, 0, SH, KH, Q1),
	%popmin(Q1, (H0, T1, S), _),
	%writeln((H0, T1, S)).
	hash_term(A, AH),
	assert(kaidud(AH)),
	% Alustame otsingut
	otsing_atarn_q_r(L, LP, SH, KH, T, Q1).

% Rekursiivne otsinguprotseduur A* jaoks

% L - lõppseid
% LP - otsingut laiendav predikaat
% SH - seisu hindav predikaat
% KH - käiku hindav predikaat
% T - tee lõppseisuni

otsing_atarn_q_r(L, LP, SH, KH, T, Q):-
	% Võtame parima seni leitud käigu,
	popmin(Q, (H0, T1, S), Q1),
	% Vaatame, kas tegemist lõppseisuga
	((L = S) ->
		% Leiame tee
		T = T1
		;
		% Laiendame otsingut
		call(LP, T1, S, Ks),
		% Hindame saadud seisud
		hinda_seisud_q(Ks, Q1, H0, SH, KH, Q2),
		hash_term(S, SHash),
		assert(kaidud(SHash)),
		% Otsime edasi
		otsing_atarn_q_r(L, LP, SH, KH, T, Q2)
	).

% Seisude hindamine a-tarn-q jaoks

% Ks - list seisudest ([O|Os], S)
% Q - seisude järjend
% H0 - eelmise seisu hinnang
% SH - seisu hindav predikaat
% KH - käiku hindav predikaat
% HKs - hinnatud seisud (H, [[O|Os], S])
% Q2 - lisamisel saadud järjend

hinda_seisud_q([([O|Os], S)|Ks], Q, H0, SH, KH, Q2):- !,
	hash_term(S, SHash),
	(kaidud(SHash) ->
		hinda_seisud_q(Ks, Q, H0, SH, KH, Q2)
		;
		% Leiame seni tehtud käikude arvu
		length([O|Os], L),
		% Leiame seisu hinnangu (h(n))
		call(SH, S, H1),
		% Leiame käigu hinnangu (g(n))
		call(KH, O, L, H2),
		% Arvutame koguhinnangu
		H is H0 + H1 + H2,
		% Paneme järjendisse
		push(Q, H, (H, [O|Os], S), Q1),
		hinda_seisud_q(Ks, Q1, H0, SH, KH, Q2)
	).

hinda_seisud_q([], Q, _, _, _, Q).