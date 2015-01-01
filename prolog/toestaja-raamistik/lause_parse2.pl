parse(I, F):-
	teisenda(I, F1),
	yhilda(F1, F2),
	teisenda_sulud(F2, F3),
	seo_kvantorid(F3, F4),
	writeln(F4),
	partitsioneeri(F4, F5),
	writeln(F5).

% Kvantori Vx teisendus kujule 'V'(x)

teisenda([K, X|R], ['V'(XCh)|R1]):-
	kood('V', K),
	muutuja(X), !,
	char_code(XCh, X),
	teisenda(R, R1), !.

% Kvantori Ex teisendus kujule 'E'(x)

teisenda([K, X|R], ['E'(XCh)|R1]):-
	kood('E', K),
	muutuja(X), !,
	char_code(XCh, X),
	teisenda(R, R1), !.

% Sulgude teisendus

teisenda([A|R], ['('|R1]):-
	avav_sulg(A), !,
	teisenda(R, R1), !.

teisenda([S|R], [')'|R1]):-
	sulgev_sulg(S), !,
	teisenda(R, R1), !.

% Termi teisendus
% Sümbolist paremal on kvantor, koma, sulg,
% operaator või mitte midagi.

teisenda([P, A|R], ['t'(PCh)|R1]):-
	term(P),
	\+ oper(P),
	(
		kvantor(A)
		;
		oper(A)
		;
		sulg(A)
	), !,
	char_code(PCh, P),
	teisenda([A|R], R1), !.

teisenda([P, A|R], ['t'(PCh),','|R1]):-
	term(P),
	koma(A), !,
	char_code(PCh, P),
	teisenda(R, R1), !.

teisenda([P], ['t'(PCh)]):-
	term(P), !,
	char_code(PCh, P).

% Operaatorite teisendus

teisenda([A, B|R], ['->'|R1]):-
	impl(A, B), !,
	teisenda(R, R1), !.

teisenda([A|R], ['&'|R1]):-
	ja(A), !,
	teisenda(R, R1), !.

teisenda([A|R], ['v'|R1]):-
	voi(A), !,
	teisenda(R, R1), !.

teisenda([A|R], ['~'|R1]):-
	ei(A), !,
	teisenda(R, R1), !.

teisenda([A,B,C|R], ['<->'|R1]):-
	ekv(A,B,C), !,
	teisenda(R, R1), !.

teisenda([], []).

% Ühildame termide argumendid ..,t(X),'(',',',A,',',B,')',.. -> t(X, [A, B])

yhilda(['V'(X)|R], ['V'(X)|R1]):-
	yhilda(R, R1), !.

yhilda(['E'(X)|R], ['E'(X)|R1]):-
	yhilda(R, R1), !.

yhilda([O|R], [O|R1]):-
	oper(O), !,
	yhilda(R, R1), !.

yhilda(['t'(X), '('|R], ['t'(X, As)|R2]):-
	yhilda_term(R, As, R1), !,
	yhilda(R1, R2), !.

yhilda(['t'(X)|R], ['t'(X)|R1]):-
	yhilda(R, R1), !.

yhilda([S|R], [S|R1]):-
	sulg(S), !,
	yhilda(R, R1).

yhilda([], []).

yhilda_term([')'|R], [], R).

yhilda_term(['t'(X), '('|R], ['t'(X, As)|As1], R2):-
	yhilda_term(R, As, R1), !,
	yhilda_term(R1, As1, R2), !.

yhilda_term(['t'(X)|R], ['t'(X)|As], R1):-
	yhilda_term(R, As, R1), !.

yhilda_term([','|R], As, R1):-
	yhilda_term(R, As, R1), !.

% Pärast termide ühildamist saavad sulud määrata ainult
% tehete prioriteete.
% 1. teisendame ..,P,'(',A,v,B,')'.. -> ..,P,[A,v,B]

teisenda_sulud(['('|R], [L|R1]):-
	sulud_listiks(R, L, R2), !,
	teisenda_sulud(R2, R1), !.

teisenda_sulud(['V'(X)|R], ['V'(X)|R1]):-
	teisenda_sulud(R, R1), !.

teisenda_sulud(['E'(X)|R], ['E'(X)|R1]):-
	teisenda_sulud(R, R1), !.

teisenda_sulud([')'|_], _):-
	writeln('Sulgude tasakaal on vale'),
	fail.

teisenda_sulud(['t'(X)|R], [['t'(X)]|R1]):-
	teisenda_sulud(R, R1), !.

teisenda_sulud(['t'(X, As)|R], [['t'(X, As)]|R1]):-
	teisenda_sulud(R, R1), !.

teisenda_sulud([O|R], [O|R1]):-
	oper(O), !,
	teisenda_sulud(R, R1), !.

teisenda_sulud([], []).

sulud_listiks([')'|R], [], R).

sulud_listiks(['t'(X)|R], [['t'(X)]|Xs], R1):- !,
	sulud_listiks(R, Xs, R1).

sulud_listiks(['V'(X)|R], ['V'(X)|Xs], R1):- !,
	sulud_listiks(R, Xs, R1).

sulud_listiks(['E'(X)|R], ['E'(X)|Xs], R1):- !,
	sulud_listiks(R, Xs, R1).

sulud_listiks(['t'(X, As)|R], [['t'(X, As)]|Xs], R1):- !,
	sulud_listiks(R, Xs, R1).

sulud_listiks([O|R], [O|Xs], R1):-
	oper(O), !,
	sulud_listiks(R, Xs, R1).

sulud_listiks(['('|R], [Xs|Xs1], R2):- !,
	sulud_listiks(R, Xs, R1),
	sulud_listiks(R1, Xs1, R2).

% Pärast sulgude teisendamist on mugav kvantorid siduda

seo_kvantorid(['V'(X), F|R], ['V'(X, F1)|R1]):-
	\+ kvantor(F), !,
	seo_kvantorid(F, F1),
	seo_kvantorid(R, R1).

seo_kvantorid(['E'(X), F|R], ['E'(X, F1)|R1]):-
	\+ kvantor(F), !,
	seo_kvantorid(F, F1),
	seo_kvantorid(R, R1).

seo_kvantorid(['V'(X), F|R], ['V'(X, F1)|R1]):-
	kvantor(F), !,
	seo_alamkvantor([F|R], F1, R2),
	seo_kvantorid(R2, R1).

seo_kvantorid(['E'(X), F|R], ['E'(X, F1)|R1]):-
	kvantor(F), !,
	seo_alamkvantor([F|R], F1, R2),
	seo_kvantorid(R2, R1).

seo_kvantorid([O|R], [O|R1]):-
	oper(O), !,
	seo_kvantorid(R, R1).

seo_kvantorid([['t'(X)]|R], [['t'(X)]|R1]):-
	seo_kvantorid(R, R1).

seo_kvantorid([['t'(X, As)]|R], [['t'(X, As)]|R1]):-
	seo_kvantorid(R, R1).

seo_kvantorid(['t'(X)], ['t'(X)]).

seo_kvantorid(['t'(X, As)], ['t'(X, As)]).

seo_kvantorid([F], [F1]):-
	seo_kvantorid(F, F1).

seo_kvantorid([], []).

seo_alamkvantor(['E'(X),F|R], 'E'(X, F), R):-
	\+ kvantor(F), !.

seo_alamkvantor(['E'(X),F|R], 'E'(X, F1), R1):-
	kvantor(F), !,
	seo_alamkvantor([F|R], F1, R1).

seo_alamkvantor(['V'(X),F|R], 'V'(X, F), R):-
	\+ kvantor(F), !.

seo_alamkvantor(['V'(X),F|R], 'V'(X, F1), R1):-
	kvantor(F), !,
	seo_alamkvantor([F|R], F1, R1).

% Pärast kvantorite sidumist on alles jäänud vaid
% valemid ja operaatorid. Teisendame need prioriteetide
% järgi puusse.

% Nõrgima operaatori leidmine.
% Tagastab operaatori asukoha.

leia_viimane(R, N):-
	leia_viimane(R, 0, -1, 0, N).

leia_viimane([V|R], C, Ptf, Ntf, N):-
	bin_oper(V), !,
	priort(V, P),
	C1 is C + 1,
	((P > Ptf) ->
		leia_viimane(R, C1, P, C, N)
		;
		leia_viimane(R, C, Ptf, Ntf, N)
	).

leia_viimane([V|R], C, Ptf, Ntf, N):-
	\+ bin_oper(V), !,
	C1 is C + 1,
	leia_viimane(R, C1, Ptf, Ntf, N).

leia_viimane([], _, Ptf, N, N):-
	Ptf =\= -1.

partitsioneeri(R, T):-
	leia_viimane(R, N), !,
	length(R1, N),
	append(R1, [O|R2], R),
	partitsioneeri(R1, F1),
	partitsioneeri(R2, F2),
	T =.. [O, F1, F2].

partitsioneeri([R], [R1]):-
	partitsioneeri(R, R1).

partitsioneeri(R, R).

% Pärast partitsioneerimist oleme peaaegu saanud nõutava
% analüüsipuu. Eemaldame üleliigsed listimärgid, mis jäid
% sisse sulgudes olevate alamvalemite ümberteisendamisest.
% Lisaks tuleb termide sümbolitele juurde kirjutada aarsus.

jareltootlus('V'(X, F), 'V'(X, F1)):-
	jareltootlus(F, F1).

jareltootlus('E'(X, F), 'E'(X, F1)):-
	jareltootlus(F, F1).

jareltootlus('&'(F, G), '&'(F1, G1)):-
	jareltootlus(F, F1),
	jareltootlus(G, G1).

jareltootlus('v'(F, G), 'v'(F1, G1)):-
	jareltootlus(F, F1),
	jareltootlus(G, G1).

jareltootlus('->'(F, G), '=>'(F1, G1)):-
	jareltootlus(F, F1),
	jareltootlus(G, G1).

% Kahekohaline operaator

bin_oper('&').
bin_oper('v').
bin_oper('->').
bin_oper('#').
bin_oper('<->').

% Kahekohaliste operaatorite prioriteedid

priort('~', 0).
priort('&', 1).
priort('v', 2).
priort('->', 3).
priort('#', 1).
priort('<->', 4).

% Sümbolite koodid

koma(44).

kvantor(86).
kvantor(69).
kvantor('V'(_, _)).
kvantor('E'(_, _)).
kvantor('V'(_)).
kvantor('E'(_)).

kood('V', 86).
kood('E', 69).

% Avav ja sulgev sulg.

sulg(X):-
	avav_sulg(X).

sulg(X):-
	sulgev_sulg(X).

avav_sulg(40).
avav_sulg('(').
sulgev_sulg(41).
sulgev_sulg(')').

% Termiks (predikaatsümbol ja funktsinaalsümbol ja konstant)
% loeme suvalist tähte.

term(X):-
	code_type(X, alpha).

% Muutujaks ja funktsionaalsümboliks
% loeme suvalist väiketähte

muutuja(X):-
	code_type(X, alpha),
	code_type(X, lower),
	\+ (X =:= 118).

% Operaatorid

oper(X):-
	member(X, [45, 62, 38, 118, 126, 60, '&', 'v', '->', '<->', '~']).
impl(45, 62).
ja(38).
voi(118).
ei(126).
ei('~').
ekv(60, 45, 62).