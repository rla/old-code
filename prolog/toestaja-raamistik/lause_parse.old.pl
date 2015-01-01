% Predikaatloogika lausete parser
% Hetkel on implikatsioon välja võetud, sest
% muidu oli liiga aeglane.
%
% Raivo Laanemets

:-module(lause_parse, [
	parse/2,
	parsi_laused/2
]).

:-use_module(lause).

parsi_laused([], []).

parsi_laused([L|Ls], [P|Ps]):-
	parse(L, P),
	parsi_laused(Ls, Ps).

parse(I, F):-
	phrase(valem(F), I, []), !.

valem(X) -->
	osavalem(X).

valem(X) -->
	implikatsioon(X).

valem(X) -->
	disjunktsioon(X).

valem(X) -->
	konjuktsioon(X).

implikatsioon('=>'(F, G)) -->
	disjunktsioon(F), "->", disjunktsioon(G).

implikatsioon('=>'(F, G)) -->
	disjunktsioon(F), "->", valem(G).

disjunktsioon(X) -->
	osavalem(X).

disjunktsioon('v'(F, G)) -->
	konjuktsioon(F), "v", konjuktsioon(G).

disjunktsioon('v'(F, G)) -->
	konjuktsioon(F), "v", valem(G).

disjunktsioon(X) -->
	konjuktsioon(X).

konjuktsioon(X) -->
	osavalem(X).

konjuktsioon('&'(F, G)) -->
	osavalem(F), "&", osavalem(G).

konjuktsioon('&'(F, G)) -->
	osavalem(F), "&", valem(G).

osavalem(X) -->
	"(", valem(X), ")".

osavalem('t'(F/0)) -->
	funktor(F), "".

osavalem('t'(F/0)) -->
	funktor(F), [X], {X =\= 40}.

osavalem('t'(F/Ar,As)) -->
	funktor(F), "(", argumendid(As, Ar), ")".

osavalem('~'(F)) -->
	"~", osavalem(F).

osavalem(X) -->
	kvantor(X).

kvantor('V'(X, F)) -->
	"V", seotud_valem(X, F).

kvantor('E'(X, F)) -->
	"E", seotud_valem(X, F).

seotud_valem(X, F) -->
	muutuja(X), osavalem(F).

argumendid([A], 1) -->
	muutuja(A).

argumendid([A], 1) -->
	konstant(A).

argumendid(['t'(F/Ar,As)], 1) -->
	funktor(F), "(", argumendid(As, Ar), ")".

argumendid([A|As], Ar) -->
	muutuja(A), ",", argumendid(As, Ar1), {Ar is Ar1 + 1}.

argumendid([A|As], Ar) -->
	konstant(A), ",", argumendid(As, Ar1), {Ar is Ar1 + 1}.

muutuja(x) --> "x".
muutuja(y) --> "y".
muutuja(z) --> "z".
muutuja(u) --> "u".
muutuja(v) --> "v".
muutuja(w) --> "w".

funktor('D') --> "D".
funktor('L') --> "L".
funktor('M') --> "M".
funktor('O') --> "O".
funktor('P') --> "P".
funktor('Q') --> "Q".
funktor('R') --> "R".
funktor('S') --> "S".
funktor('T') --> "T".
funktor('W') --> "W".
funktor('E') --> "E".
funktor('D') --> "D".

funktor('f') --> "f".
funktor('g') --> "g".
funktor('h') --> "h".

konstant(a) --> "a".
konstant(b) --> "b".
konstant(c) --> "c".
konstant(e) --> "e".