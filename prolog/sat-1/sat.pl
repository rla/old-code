% Lihtne SAT algoritm

:-module(sat, [
	sat/2
]).

:-use_module('read_cnf').

sat(Ds, As):-
	sat(Ds, [], As).

sat([], As, As).

sat([D|Ds], As1, As2):-
	member(V, D),
	((V < 0) ->
		V1 is -V,
		\+ member(V1=1, As1),
		sort([V1=0|As1], As3),
		sat(Ds, As3, As2)
		;
		\+ member(V=0, As1),
		sort([V=1|As1], As3),
		sat(Ds, As3, As2)
	).

test:-
	read_cnf('test.cnf', Ds),
	sat(Ds, _).