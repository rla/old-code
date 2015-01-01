% Othello
% Arvuti poolse käigu sooritaja
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 19.11.06

:-module(othello, [
	kaik/4,
	vaartus/3
]).

:-use_module(laud).
:-use_module(alfabeta).

% Käigu valimine otsides mängupuus
% fikseeritud sügavuseni.
% Kui hetkeseisu laual on vabu ruute 10
% või rohkem, otsime sügavuseni 4,
% vastasel juhul sügavuseni 10.

kaik(B, AR, X, Y):-
	findall((X, Y), nupp(B, X, Y, 0), XYs),
	length(XYs, L),
	((L > 10) ->
		alfabeta(AR, 4, B, -10000, 10000, (X, Y), _, AR)
		;
		alfabeta(AR, 10, B, -10000, 10000, (X, Y), _, AR)
	).

kaik(B, AR, X, Y):-
	leia_kaidavad(B, [(X, Y)|_], AR).

% Arvuti poolt vaadatuna laua kaalu leidmine.
% Suurem väärtus => parem laud.

vaartus(A, B, V):-
	((A > 0) ->
		tasakaal(B, V1)
		;
		tasakaal(B, V11),
		V1 is -V11
	),
	findall(NV, (nurk(X, Y), nurga_vaartus(A, B, X, Y, NV)), NVs),
	sumlist(NVs, NVS),
	findall(AV, (aar(X, Y), aare_vaartus(A, B, X, Y, AV)), AVs),
	sumlist(AVs, AVS),
	V is V1 + NVS + AVS.



% Ääre väärtuse arvutamine

aare_vaartus(_, B, X, Y, 0):-
	nupp(B, X, Y, 0).

aare_vaartus(A, B, X, Y, 5):-
	nupp(B, X, Y, A).

aare_vaartus(A, B, X, Y, -10):-
	vastane(A, A1),
	nupp(B, X, Y, A1).

% Nurga väärtuse arvutamine.

nurga_vaartus(_, B, X, Y, 0):-
	nupp(B, X, Y, 0).

nurga_vaartus(A, B, X, Y, 20):-
	nupp(B, X, Y, A).

nurga_vaartus(A, B, X, Y, -50):-
	vastane(A, A1),
	nupp(B, X, Y, A1).