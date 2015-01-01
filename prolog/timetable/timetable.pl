% Tunniplaan
% Raivo Laanemets

:-encoding(utf8).

% Tunniplaani kirjeldus
ainetund('E', 10, 'Tehisintellekt I', 1-16, loeng).
ainetund('E', 12, 'Andmeturve', 1-16, loeng).
ainetund('E', 14, 'Graafid', 1-16, loeng).

ainetund('T', 12, 'Arvutikomponendid', 1-15, loeng).
ainetund('T', 14, 'Loogiline programmeerimine', 1-16, loeng).

ainetund('K', 10, 'Arvutikomponendid', 1-15, loeng).
ainetund('K', 12, 'Andmeturve', 1-16, praktikum).
ainetund('K', 14, 'Tehisintellekt I', 1-16, loeng).
ainetund('K', 16, 'Tõenäosusteooria I', 1-16, praktikum).

ainetund('N', 8, 'Tõenäosusteooria I', 1-16, loeng).
ainetund('N', 10, 'Graafid', 1-16, praktikum).
ainetund('N', 12, 'Telekommunikatsiooni alused', 7-15, loeng).

ainetund('R', 10, 'Loogiline programmeerimine', 1-16, loeng).

% Aine toimumist mingil päeval
% mingil kellaajal iseloomustav predikaat.
toimub(P, AT, X, N, L):-
	ainetund(P, AT, X, A-B, L),
	B >= N,
	A =< N.
	

% Tunniplaan on vastuoluline, kui
% kaks ainet satuvad ühele ajale.
inconsistent:-
	ainetund(P1, AT1, X1, A1-B1, L1),
	ainetund(P2, AT2, X2, A2-B2, L2),
	((P1 = P2, AT1 = AT2, intersect(A1-B1, A2-B2), X1 \== X2) -> (
		writerow([P1:2, AT1:5, X1:30, L1:15, A1:2, '-':1, B1:2]), nl,
		writerow([P2:2, AT2:5, X2:30, L2:15, A2:2, '-':1, B2:2]))
	).

% Toimumisaja väljastamine
writetime(AT):-
	LT is AT+2,
	write(AT:'15'-LT:'00').

% Päeva P ja nädala N tunniplaani
% väljastamine.
writetable(P, N):-
	toimub(P, AT, X, N, L),
	writetime(AT),
	writerow([X:20, L:15]), nl.

% Andmekirje väljastamine.
writerow([]).
writerow([X:N|Xs]):-
	string_length(X, L),
	N1 is N-L,
	pad(N1),
	write(X),
	writerow(Xs).

% Kahe toimumisnädalate võrdlus.
intersect(A1-B1, A2-B2):-
	A1 =< A2, B1 >= A2;
	A2 =< A1, B2 >= A1.

% Andmeelemendi väljastamine.
pad(0).
pad(N):- write(' '), N1 is N-1, pad(N1).