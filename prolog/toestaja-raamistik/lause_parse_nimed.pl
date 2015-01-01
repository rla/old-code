% Termide ja operaatorite ja muutujate teisendamine nende nimedeks.
% Rakendatav pärast sulgude parsimist.

:-module(lause_parse_nimed, [
	parse_nimed/2
]).

:-use_module('lause_parse_sulud').

parse_nimed(I, F):-
	parse_sulud(I, F1),
	phrase(lause(F), F1, []), !.

lause(R) -->
	" ", lause(R).

lause(['~'|R]) -->
	eitus, lause(R).

lause(['&'|R]) -->
	konjuktsioon, lause(R).

lause(['v'|R]) -->
	disjunktsioon, lause(R).

lause(['=>'|R]) -->
	"=>", lause(R).

lause(['<='|R]) -->
	"<=", lause(R).

lause(['<=>'|R]) -->
	"<=>", lause(R).

lause([K|R]) -->
	kvantor(K), lause(R).

lause([P|R]) -->
	predikaat(P), lause(R).

lause([M|R]) -->
	muutuja(M), lause(R).

lause([S|R]) -->
	[L], {is_list(L), phrase(lause(S), L, [])}, lause(R).

lause(R) -->
	",", lause(R).

lause([]) -->
	"".

predikaat(C) -->
	[P], {predikaat(P), char_code(C, P)}.

muutuja(C) -->
	[M], {muutuja(M), char_code(C, M)}.

muutuja(X):-
	\+ operaator(X),
	\+ is_list(X),
	code_type(X, alpha),
	code_type(X, lower),
	\+ (X =:= 118).

predikaat(X):-
	\+ operaator(X),
	\+ is_list(X),
	code_type(X, alpha),
	code_type(X, upper).

kvantor('V') -->
	"V".

kvantor('V') -->
	"iga".

kvantor('V') -->
	"forall".

kvantor('E') -->
	"E".

kvantor('E') -->
	"leidub".

kvantor('E') -->
	"exists".

operaator('&').

operaator('v').

operaator('~').

operaator('=>').

operaator('<=').

operaator('<=>').

disjunktsioon -->
	"v".

disjunktsioon -->
	"or".

disjunktsioon -->
	"|".

disjunktsioon -->
	"või".

disjunktsioon -->
	"voi".

konjuktsioon -->
	"&".

konjuktsioon -->
	"and".

konjuktsioon -->
	"ja".

eitus -->
	"~".

eitus -->
	"ei".

eitus -->
	"!".

eitus -->
	"not".

eitus -->
	"eitus".