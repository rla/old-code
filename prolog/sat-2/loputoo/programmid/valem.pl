%% <module> Valemiga tegevuste sooritamise moodul.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(valem, [
	teisenda/2,
	muutuja_klauslid/4,
	klausli_muutujad/4,
	pos_muutuja_klauslid/3,
	neg_muutuja_klauslid/3,
	klausli_pos_muutujad/3,
	klausli_neg_muutujad/3,
	klauslite_arv/2,
	muutujate_arv/2,
	literaali_klauslid/3,
	klausli_literaalid/3
]).

:-use_module(abi).
:-use_module(library(lists)).

klausli_literaalid(F, Ci, Ls):-
	klausli_pos_muutujad(F, Ci, Ls1),
	klausli_neg_muutujad(F, Ci, Ns),
	poora_literaalid(Ns, Ls2),
	append(Ls1, Ls2, Ls).

literaali_klauslid(F, L, Cs):-
	(L > 0 ->
		neg_muutuja_klauslid(F, L, Cs)
		;
		M is -L,
		pos_muutuja_klauslid(F, M, Cs)
	), !.

klauslite_arv(valem(_, M, _, _), M).
muutujate_arv(valem(N, _, _, _), N).

%% klausli_muutujad(+F:valem, +I:int, -Ps:list, -Ns:list).
%
% Leia valemist F klauslis indeksiga I positiivse
% literaalina esinevate muutujate indeksid Ps
% ja negatiivsena esinevate muutujate indeksid Ns.

klausli_muutujad(valem(_, _, _, CV), C, Ps, Ns):- arg(C, CV, v(Ps, Ns)).

%% klausli_pos_muutujad(+F:valem, +I:int, -Ps:list).
%
% Leia valemist F klauslis indeksiga I positiivse
% literaalina esinevate muutujate indeksid Ps.

klausli_pos_muutujad(valem(_, _, _, CV), C, Ps):- arg(C, CV, v(Ps, _)).

%% klausli_neg_muutujad(+F:valem, +I:int, -Ps:list).
%
% Leia valemist F klauslis indeksiga I negatiivse
% literaalina esinevate muutujate indeksid Ns.

klausli_neg_muutujad(valem(_, _, _, CV), C, Ns):- arg(C, CV, v(_, Ns)).

%% muutuja_klauslid(+F:valem, +I:int, -Ps:list, -Ns:list).
%
% Leia valemist F klauslite indeksid Ps,
% kus muutuja indeksiga I esineb positiivselt ja klauslite
% indeksid Ns, kus muutuja indeksiga I esineb negatiivselt.

muutuja_klauslid(valem(_, _, VC, _), M, Ps, Ns):- arg(M, VC, c(Ps, Ns)).

%% pos_muutuja_klauslid(+F:valem, +I:int, -Ps:list).
%
% Leia valemist F klauslite indeksid Ps,
% kus muutuja indeksiga I esineb positiivselt.

pos_muutuja_klauslid(valem(_, _, VC, _), M, Ps):- arg(M, VC, c(Ps, _)).

%% neg_muutuja_klauslid(+F:valem, +I:int, -Ps:list).
%
% Leia valemist F klauslite indeksid Ns,
% kus muutuja indeksiga I esineb negatiivselt.

neg_muutuja_klauslid(valem(_, _, VC, _), M, Ns):- arg(M, VC, c(_, Ns)).

%% teisenda(+F1:valem, -F2:valem).
%
% Konjuktiivsel normaalkujul listiesituses valemi F1 teisendamine sisekujule F2.
%
% Näide kasutamisest:
% ?>
% ?- teisenda([[-1, 2, -3], [-2, -4], [4]], T).
% T = valem(
%	4,
%	3,
%	vc(c([], [1]), c([1], [2]), c([], [1]), c([3], [2])),
%	cv(v([2], [1, 3]), v([], [2, 4]), v([4], []))
% )
% <?

teisenda(F, valem(N, M, VC, CV)):-
	muutujad(F, Vs),
	length(F, M),
	length(Vs, N),
	koosta_cv(F, M, CV),
	koosta_vc(Vs, M, CV, VC).
	
% Muutuja indeks - klauslid termi (vc) koostamine.

koosta_vc(Vs, M, CV, T):-
	list_max(Vs, VM),
	length(As, VM),
	T =.. [vc|As],
	koosta_vc1(As, M, CV, 1).
koosta_vc1([A|As], M, CV, I):-
	leia_klauslid(I, M, CV, Ps, Ns),
	A =.. [c, Ps, Ns],
	I1 is I + 1,
	koosta_vc1(As, M, CV, I1).
koosta_vc1([], _, _, _).

% Leia indekseeritud klasulite termis need klauslid, mis sisaldavad antud
% indeksiga muutujat.
% Näide:
% ?- valem:leia_klauslid(2, 3, cv(v([2], [1, 3]), v([4], [2, 5]), v([9], [])), Ps, Ns).
% Ps = [1],
% Ns = [2]


leia_klauslid(I, M, CV, Ps, Ns):-
	findall(CI, (
		between(1, M, CI),
		arg(CI, CV, v(Ps1, _)),
		member(I, Ps1)
	), Ps),
	findall(CI, (
		between(1, M, CI),
		arg(CI, CV, v(_, Ns1)),
		member(I, Ns1)
	), Ns).

% Listi maksimaalse elemendi leidmine.
% ?- valem:list_max([9, 5, 4, 3, 2, 1], M).
% M = 9

list_max([H|T], M):- list_max(T, H, M).
list_max([H|T], A, M):- H > A, !, list_max(T, H, M).
list_max([_|T], A, M):- list_max(T, A, M).
list_max([], M, M).
	
% Klausli indeks - muutujad termi (cv) koostamine.
% Näide:
% ?- valem:koosta_cv([[-1, 2, -3], [-2, 4, -5], [9]], 3, T).
% T = cv(v([2], [1, 3]), v([4], [2, 5]), v([9], []))

koosta_cv(F, M, T):-
	length(As, M),
	T =.. [cv|As],
	koosta_cv(F, As).
koosta_cv([K|F], [A|As]):-
	literaalid(K, Ps, Ns),
	A =.. [v, Ps, Ns],
	koosta_cv(F, As).
koosta_cv([], []).

% Klausli positiivsete ja negatiivsete muutujate leidmine
% vastavalt nende esinemisele literaalidena.
% Näide:
% ?- valem:literaalid([-1, 2, -3], Ps, Ns).
% Ps = [2],
% Ns = [1, 3]

literaalid([L|K], [L|Ps], Ns):- L > 0, !, literaalid(K, Ps, Ns).
literaalid([L|K], Ps, [Lc|Ns]):- Lc is -L, literaalid(K, Ps, Ns).
literaalid([], [], []).

% Valemi erinevate muutujate leidmine.
% Näide:
% ?- valem:muutujad([[-1, 2, -3], [-2, 4, -5], [9]], Vs).
% Vs = [9, 5, 4, 3, 2, 1]

muutujad(F, Vs):- flatten(F, F1), muutujad(F1, [], Vs).
muutujad([], Vs, Vs).
muutujad([L|F], Vs, Vs1):-
	muutuja(L, V),
	(member(V, Vs) ->
		muutujad(F, Vs, Vs1)
		;
		muutujad(F, [V|Vs], Vs1)
	).

% Literaalina esineva muutuja saamine.

muutuja(L, L):- L > 0, !.
muutuja(L, M):- M is -L.

% Literaali komplementaari leidmine.
% Näited:
% ?- valem:komplementaar(-1, Lc).
% Lc = 1
% ?- valem:komplementaar(1, Lc).
% Lc = -1

komplementaar(L, Lc):- Lc is -L.
