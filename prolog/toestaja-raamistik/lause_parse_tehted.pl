:-module(lause_parse_tehted, [
	parse_tehted/2
]).

:-use_module('lause_parse_eitus').

parse_tehted(I, F):-
	parse_eitus(I, F1),
	tehted(F1, F).

% Opraatorid ja nende prioriteedid

binaarne_operaator('&', 1).
binaarne_operaator('v', 2).
binaarne_operaator('=>', 3).
binaarne_operaator('<=', 3).
binaarne_operaator('<=>', 4).

% Kõrgeima prioriteediga operaatori leidmine
% Tagastab operaatori asukoha

leia_viimane(R, N, O):-
	leia_viimane(R, 0, -1, 0, N, nil, O).

leia_viimane([O|R], C, Ptf, Ntf, N, O1, O2):-
	binaarne_operaator(O, P), !,
	C1 is C + 1,
	((P > Ptf) ->
		leia_viimane(R, C1, P, C, N, O, O2)
		;
		leia_viimane(R, C1, Ptf, Ntf, N, O1, O2)
	).

leia_viimane([V|R], C, Ptf, Ntf, N, O1, O2):-
	\+ binaarne_operaator(V, _), !,
	C1 is C + 1,
	leia_viimane(R, C1, Ptf, Ntf, N, O1, O2).

leia_viimane([], _, Ptf, N, N, O, O):-
	Ptf =\= -1.

tehted([F], F1):-
	tehted(F, F1).

tehted('V'(X, F), 'V'(X, F1)):-
	tehted(F, F1).

tehted('E'(X, F), 'E'(X, F1)):-
	tehted(F, F1).

tehted('~'(F), '~'(F1)):-
	tehted(F, F1).

tehted('t'(P/0), 't'(P/0)).

tehted('t'(P/A, As), 't'(P/A, As)).

tehted(F, T):-
	leia_viimane(F, N, O),
	length(F1, N),
	append(F1, [O|F2], F),
	tehted(F1, G1),
	tehted(F2, G2),
	T =.. [O, G1, G2].

tehted([], []).