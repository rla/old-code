% Tagasipöördumisega DPLL SAT protseduur.

:-module(bt_dpll_sat, [
	sat/2
]).

:-use_module('valem').

sat(F, V):- sat(F, [], V).

sat([[L]|F], V1, V2):- !,
	Lc is -L,
	\+ member(Lc, V1),
	propageeri(F, L, F1),
	sat(F1, [L|V1], V2).

sat([K|F], V1, V2):-
	member(L, K),
	Lc is -L,
	\+ member(Lc, V1),
	propageeri(F, L, F1),
	sat(F1, [L|V1], V2).

sat([], V, V).