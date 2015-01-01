% Othello
% Arvuti poolse käigu sooritaja
% Alfa-Beta üldine algoritm
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 19.11.06

:-module(alfabeta, [
	alfabeta/8
]).

:-use_module(laud).
:-use_module(othello).

% Põhiprotseduur.

alfabeta(_, 0, P, _, _, _, V, AR):-
	vaartus(AR, P, V).

alfabeta(M, D, P, A, B, K, V, AR):-
	D > 0,
	leia_kaidavad(P, Ks, M),
	A1 is -B,
	B1 is -A,
	D1 is D - 1,
	arvuta_ja_vali(M, Ks, P, D1, A1, B1, nil, (K, V), AR).

% Parima haru võtmine.

arvuta_ja_vali(M, [(X, Y)|Ks], P, D, A, B, R, PK, AR):-
	paiguta(P, X, Y, M, P1),
	vastane(M, M1),
	alfabeta(M1, D, P1, A, B, _, V, AR),
	V1 is -V,
	loika(M, (X, Y), V1, D, A, B, Ks, P, R, PK, AR).

arvuta_ja_vali(_, [], _, _, A, _, K, (K, A), _).

% Mittemõistlike harude ära lõikamine.

loika(_, K, V, _, _, B, _, _, _, (K, V), _):-
	V >= B, !.

loika(M, K, V, D, A, B, Ks, P, _, PK, AR):- 
	A < V, V < B, !, 
	arvuta_ja_vali(M, Ks, P, D, V, B, K, PK, AR).

loika(M, _, V, D, A, B, Ks, P, R, PK, AR) :- 
	V =< A, !, 
	arvuta_ja_vali(M, Ks, P, D, A, B, R, PK, AR).