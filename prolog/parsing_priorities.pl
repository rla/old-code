% Parsing with priorities.
% R.A.O'Keefe The Craft of Prolog, pages 300-302
% Expects tokenized input

max_priority(10).

gnumber('1').
gnumber('2').
gnumber('3').

prefix_operator('-', X, '-'(X)).

infix_operator('+', 9, X, Y, '+'(X, Y)).
infix_operator('*', 8, X, Y, '*'(X, Y)).

expression(E) -->
	{max_priority(M)},
	expression(M, E).

expression(M, E) -->
	primary(P),
	rest_expression(P, 0, M, E).

primary(P) -->
	[T], primary(T, P).

primary(gnumber(X), gnumber(X)) -->
	"".

primary('(', E) -->
	expression(E), [')'].

primary(operator(O), E) -->
	{prefix_operator(O, A, E)},
	primary(A).

rest_expression(L, P, M, E) -->
	[operator(O)],
	{infix_operator(O, P1, L, R, T), P1 >= P, P1 < M}, !,
	expression(P1, R),
	rest_expression(T, P1, M, E).

rest_expression(E, _, _, E) -->
	[].