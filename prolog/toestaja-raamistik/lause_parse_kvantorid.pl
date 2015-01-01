:-module(lause_parse_kvantorid, [
	parse_kvantorid/2
]).

:-use_module('lause_parse_termid').

parse_kvantorid(I, F):-
	parse_termid(I, F1),
	phrase(lause(F), F1, []).

lause([X|R]) -->
	kvantor(X),
	lause(R).

lause([X|R]) -->
	term(X),
	lause(R).

lause([O|R]) -->
	operaator(O),
	lause(R).

lause([L1|R]) -->
	[L], {is_list(L), !, phrase(lause(L1), L, [])},
	lause(R).

lause([]) -->
	"".

kvantor('V'(X, F1)) -->
	['V', X, F], {muutuja(X), is_list(F), !, phrase(lause(F1), F, [])}.

kvantor('E'(X, F1)) -->
	['E', X, F], {muutuja(X), is_list(F), !, phrase(lause(F1), F, [])}.

kvantor('V'(X, F)) -->
	['V', X], kvantor(F).

kvantor('E'(X, F)) -->
	['E', X], kvantor(F).

kvantor('V'(X, 't'(P/A, As))) -->
	['V', X, 't'(P/A, As)].

kvantor('E'(X, 't'(P/A, As))) -->
	['E', X, 't'(P/A, As)].

kvantor('V'(X, '~'('t'(P/A, As)))) -->
	['V', X, '~', 't'(P/A, As)].

kvantor('E'(X, '~'('t'(P/A, As)))) -->
	['E', X, '~', 't'(P/A, As)].

kvantor('V'(X, '~'(F1))) -->
	['V', X, '~', F], {is_list(F), !, phrase(lause(F1), F, [])}.

kvantor('E'(X, '~'(F1))) -->
	['E', X, '~', F], {is_list(F), !, phrase(lause(F1), F, [])}.

term('t'(P/0)) -->
	['t'(P/0)].

term('t'(P/A, As)) -->
	['t'(P/A, As)].

operaator(O) -->
	[O], {member(O, ['~', 'v', '&', '=>', '<=', '<=>'])}.

muutuja(T):-
	atom(T),
	char_code(T, X),
	code_type(X, alpha),
	code_type(X, lower),
	\+ (X =:= 118).