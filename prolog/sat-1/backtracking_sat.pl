:-module(backtracking_sat, [
	sat/2
]).

:-use_module('valem').

sat(F, V):- sat(F, [], V).

sat([K|F], V1, V2):-
	member(L, K),
	Lc is -L,
	\+ member(Lc, V1),
	sat(F, [L|V1], V2).

sat([], V, V).