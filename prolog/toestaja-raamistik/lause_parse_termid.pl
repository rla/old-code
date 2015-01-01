% Termide alampuude koostamine.

:-module(lause_parse_termid, [
	parse_termid/2
]).

:-use_module('lause_parse_nimed').

parse_termid(I, F):-
	parse_nimed(I, F1),
	phrase(lause(F), F1, []).

lause(['t'(P/A, As)|R]) -->
	[P, As1], {is_list(As1), predikaat(P), length(As1, A), phrase(lause(As), As1, [])},
	lause(R).

lause(['t'(P/A, As)|R]) -->
	[P, As1], {is_list(As1), term(P), length(As1, A), phrase(lause(As), As1, [])},
	lause(R).

lause(['t'(P/0)|R]) -->
	[P], {predikaat(P), !},
	lause(R).

lause([X|R]) -->
	[X], {term(X), !},
	lause(R).

lause([K, X|R]) -->
	[K, X], {kvantor(K), term(X), !},
	lause(R).

lause([O|R]) -->
	[O], {operaator(O), !},
	lause(R).

lause([F|R]) -->
	[L], {is_list(L), !, phrase(lause(F), L, [])},
	lause(R).

lause([]) -->
	"".

kvantor('V').

kvantor('E').

operaator('&').

operaator('v').

operaator('~').

operaator('=>').

operaator('<=').

operaator('<=>').

predikaat(P):-
	\+ operaator(P),
	\+ P = 'V',
	\+ P = 'E',
	\+ is_list(P),
	char_code(P, X),
	code_type(X, alpha),
	code_type(X, upper).

term(T):-
	\+ operaator(T),
	\+ is_list(T),
	char_code(T, X),
	code_type(X, alpha),
	code_type(X, lower),
	\+ (X =:= 118).