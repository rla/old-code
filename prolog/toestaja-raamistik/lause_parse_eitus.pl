:-module(lause_parse_eitus, [
	parse_eitus/2
]).

:-use_module('lause_parse_kvantorid').

parse_eitus(I, F):-
	parse_kvantorid(I, F1),
	phrase(lause(F), F1, []).

lause([X|R]) -->
	seo_eitus(X),
	lause(R).

lause([X|R]) -->
	term(X),
	lause(R).

lause([O|R]) -->
	operaator(O),
	lause(R).

lause([K|R]) -->
	kvantor(K),
	lause(R).

lause([L1|R]) -->
	[L], {is_list(L), !, phrase(lause(L1), L, [])},
	lause(R).

lause([]) -->
	"".

seo_eitus('~'(X)) -->
	['~'], term(X).

seo_eitus('~'(X)) -->
	['~'], kvantor(X).

seo_eitus('~'(F1)) -->
	['~', F], {is_list(F), !, phrase(lause(F1), F, [])}.

seo_eitus('~'(X)) -->
	['~'], seo_eitus(X).

term('t'(P/0)) -->
	['t'(P/0)].

term('t'(P/A, As)) -->
	['t'(P/A, As)].

operaator(O) -->
	[O], {member(O, ['v', '&', '=>', '<=', '<=>'])}.

kvantor('V'(X, F)) -->
	['V'(X, F)].

kvantor('E'(X, F)) -->
	['E'(X, F)].