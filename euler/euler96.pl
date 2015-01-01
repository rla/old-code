/*
Project Euler, Problem 96

lahendus: Raivo Laanemets, rlaanemt@ut.ee, 30.01.07
*/

:-use_module(library('clp/bounds')).
:-use_module(library('readutil')).

/*
Testlaud. Laud on ka tegelikult sellisel kujul.
*/

laud([
	[_, _, 3, _, 2, _, 6, _, _],
	[9, _, _, 3, _, 5, _, _, 1], 
	[_, _, 1, 8, _, 6, 4, _, _],

	[_, _, 8, 1, _, 2, 9, _, _],
	[7, _, _, _, _, _, _, _, 8],
	[_, _, 6, 7, _, 8, 2, _, _],

	[_, _, 2, 6, _, 9, 5, _, _],
	[8, _, _, 2, _, 3, _, _, 9],
	[_, _, 5, _, 1, _, 3, _, _]
]).

/*
Kontroll, kas kõik numbrid reas/veerus/plokis
on erinevad. Kasutab CLP vahendeid.
*/

erinevad(Rs):-
	Rs in 1..9,
	all_different(Rs).

/*
Sudoku lahendaja.
Rakenda ülalolevat protseduuri
igal reale/veerule/plokile. CLP kasutamise
tulemusena üle lõpliku väärtuste varu
saadakse igale muutujale väärtuste varu,
mille korral on kitsendused rahuldatud.
Pärast viimast kontrolli peaks
igal elemendil olema ainult üks väärtus.
*/

lahenda([
	[A1, A2, A3, A4, A5, A6, A7, A8, A9],
	[B1, B2, B3, B4, B5, B6, B7, B8, B9],
	[C1, C2, C3, C4, C5, C6, C7, C8, C9],

	[D1, D2, D3, D4, D5, D6, D7, D8, D9],
	[E1, E2, E3, E4, E5, E6, E7, E8, E9],
	[F1, F2, F3, F4, F5, F6, F7, F8, F9],

	[G1, G2, G3, G4, G5, G6, G7, G8, G9],
	[H1, H2, H3, H4, H5, H6, H7, H8, H9],
	[I1, I2, I3, I4, I5, I6, I7, I8, I9]
	]):-
		erinevad([A1, A2, A3, A4, A5, A6, A7, A8, A9]),
		erinevad([B1, B2, B3, B4, B5, B6, B7, B8, B9]),
		erinevad([C1, C2, C3, C4, C5, C6, C7, C8, C9]),

		erinevad([D1, D2, D3, D4, D5, D6, D7, D8, D9]),
		erinevad([E1, E2, E3, E4, E5, E6, E7, E8, E9]),
		erinevad([F1, F2, F3, F4, F5, F6, F7, F8, F9]),

		erinevad([G1, G2, G3, G4, G5, G6, G7, G8, G9]),
		erinevad([H1, H2, H3, H4, H5, H6, H7, H8, H9]),
		erinevad([I1, I2, I3, I4, I5, I6, I7, I8, I9]),

		erinevad([A1, B1, C1, D1, E1, F1, G1, H1, I1]),
		erinevad([A2, B2, C2, D2, E2, F2, G2, H2, I2]),
		erinevad([A3, B3, C3, D3, E3, F3, G3, H3, I3]),

		erinevad([A4, B4, C4, D4, E4, F4, G4, H4, I4]),
		erinevad([A5, B5, C5, D5, E5, F5, G5, H5, I5]),
		erinevad([A6, B6, C6, D6, E6, F6, G6, H6, I6]),

		erinevad([A7, B7, C7, D7, E7, F7, G7, H7, I7]),
		erinevad([A8, B8, C8, D8, E8, F8, G8, H8, I8]),
		erinevad([A9, B9, C9, D9, E9, F9, G9, H9, I9]),

		erinevad([A1, A2, A3, B1, B2, B3, C1, C2, C3]),
		erinevad([D1, D2, D3, E1, E2, E3, F1, F2, F3]),
		erinevad([G1, G2, G3, H1, H2, H3, I1, I2, I3]),

		erinevad([A4, A5, A6, B4, B5, B6, C4, C5, C6]),
		erinevad([D4, D5, D6, E4, E5, E6, F4, F5, F6]),
		erinevad([G4, G5, G6, H4, H5, H6, I4, I5, I6]),

		erinevad([A7, A8, A9, B7, B8, B9, C7, C8, C9]),
		erinevad([D7, D8, D9, E7, E8, E9, F7, F8, F9]),
		erinevad([G7, G8, G9, H7, H8, H9, I7, I8, I9]).

valjasta(L):-
	flatten(L, LF),
	label(LF),
	writeln(LF).

euler:-
	loe_sisse(Ls), !,
	leia_vastus(Ls, 0, V),
	format('Vastus on ~a\n', V).

leia_vastus([L|Ls], Acc, V):-
	lahenda(L), !,
	flatten(L, L1),
	label(L1),
	L1 = [A, B, C|_],
	Acc1 is A * 100 + B * 10 + C + Acc,
	leia_vastus(Ls, Acc1, V).

leia_vastus([], Acc, Acc).

/*
Wrapper grammatika kasutamiseks.
*/

loe_sisse(Ls):-
	read_file_to_codes('sudoku.txt', Cs, []),
	phrase(lauad(Ls), Cs, []).

/*
Grammatika sisendfaili parsimiseks.
*/

lauad([L|Ls]) -->
	laud_pealkirjaga(L),
	lauad(Ls).

lauad([L]) -->
	laud_pealkirjaga(L).

laud_pealkirjaga(L) -->
	"Grid ", grid_number, realopp,
	laud(L).

realopp -->
	"\r\n".

laud([R|Rs]) -->
	rida(R), laud(Rs).

laud([R]) -->
	rida(R).

rida([N1, N2, N3, N4, N5, N6, N7, N8, N9]) -->
	number(N1),
	number(N2),
	number(N3),
	number(N4),
	number(N5),
	number(N6),
	number(N7),
	number(N8),
	number(N9),
	realopp.

number(N1) -->
	[X], {
		member(X, "0123456789"),
		N is X - 48,
		((N =:= 0) ->
			var(N1)
			;
			N1 is N
		)
	}.

grid_number -->
	number(_), number(_).




