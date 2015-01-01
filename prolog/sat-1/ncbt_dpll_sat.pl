% Mittekronoloogilise tagasipöördumisega DPLL SAT protseduur.

:-use_module('valem').

sat(F, V):-
	sat(F, 0, [], V).

vali_literaal([K|F], V1, L):-
	member(L, K),
	Lc is -L,
	\+ member((_, Lc), V1).

lihtsusta(F, L, F1):-
	propageeri(F, L, F1).

analyysi(F, konflikt):-
	member([], F).
	
sat(F, D, V1, V2):-
	vali_literaal(F, D, V1, L),
	lihtsusta(F, L, F1),
	(analyysi(F1, konflikt) ->
	)
	D1 is D + 1,
	sat(F, D1, [(D, L)|V1], V2).