% Examples of higher order predicates.

:-use_module(webmp3_list).

square(A, B):-
	B is A * A.

sum(Xs, S):-
	fold(Xs, plus, S).