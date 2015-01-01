% Juhuslike valemite generaator.

:-module(genereeri, [
	genereeri/3
]).

genereeri(_, 0, []):- !.

% N > 2 - muutjate arv
% M > 0 - klauslite arv
% F - saadav valem

genereeri(N, M, [[L1,L2,L3]|F]):- !,
	random_bt(V1, N),
	random_bt(V2, N),
	V2 =\= V1,
	random_bt(V3, N),
	V3 =\= V2,
	V3 =\= V1, !,
	juhuslik_literaal(V1, L1),
	juhuslik_literaal(V2, L2),
	juhuslik_literaal(V3, L3),
	M1 is M - 1,
	genereeri(N, M1, F).

% Literaali L saamine muutujast V.
% Tõenäosusega 0.5 võetakse literaaliks L
% V positiivne esinemine.

juhuslik_literaal(V, L):-
	R is random(2),
	(R =:= 0 ->
		L is V
		;
		L is -V
	).

% Tagasipöördumisega juhuarvu võtmine.

random_bt(R, N):-
	R is random(N) + 1.

random_bt(R, N):- random_bt(R, N).