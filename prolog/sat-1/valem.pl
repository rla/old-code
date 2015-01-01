% Mimesugused lausearvutusvalemiga töötamiseks
% mõeldud protseduurid.

:-module(valem, [
	juhuslik_vaartustus/2,
	juhuslik_neg_klausel/3,
	juhuslik_valem/3,
	juhuslik_tegevus/1,
	positiivne_valem/2,
	positiivseid_klausleid/3,
	propageeri/3
]).

:-use_module(library('random')).
:-use_module(library('lists')).
:-use_module('genereeri').

% Valemi F propageerimine literaali L
% järgi. Eemaldatakse kõik klauslid,
% milles L esineb ja kõikidest klauslitest
% eemaldatakse L komplementaar Lc.

propageeri(F, L, F1):-
	Lc is -L,
	eemalda(F, L, Lc, F1).
	
eemalda([K|F], L, Lc, F1):-
	(member(L, K) ->
		F1 = F2
		;
		delete(K, Lc, K1),
		F1 = [K1|F2]
	),
	eemalda(F, L, Lc, F2).

eemalda([], _, _, []).

% Positiivsete klauslite arvu leidmine
% valemis F väärtustusel V.

positiivseid_klausleid(F, V, C):-
	positiivseid_klausleid(F, V, 0, C).

% C1 -akumulaator

positiivseid_klausleid([K|F], V, C1, C2):-
	((member(L, K), member(L, V)) ->
		C3 is C1 + 1,
		positiivseid_klausleid(F, V, C3, C2)
		;
		positiivseid_klausleid(F, V, C1, C2)
	).

positiivseid_klausleid([], _, C, C).

% Valemi tõesuse kontroll etteantud
% väärtustuses.

positiivne_valem([], _).

positiivne_valem([K|F], V):-
	member(L, K),
	member(L, V),
	positiivne_valem(F, V).

% Tõene etteantud tõenäosusega.
% P = (0..1)

juhuslik_tegevus(P):- random(R), !, R < P.

juhuslik_valem(N, M, F):- genereeri(N, M, F).

% Juhusliku negatiivse klausli K valik
% valemist F, väärtustuses V.

juhuslik_neg_klausel(F, V, K):-
	member(K, F),
	\+ (member(L, K), member(L, V)).

% Juhusliku väärtustuse genereerimine valemile
% F. Genereerimisalgoritm:
% Vaata järjest läbi kõik F-s esinevad literaalid.
% Kui literaal L ega tema komplementaar Lc ei esine
% hetke väärtustuses V1, siis tõenäosusega 0.5 võta
% L tõeste literaalide hulka, vastasel korral võta Lc.

juhuslik_vaartustus(F, V):-
	flatten(F, FL),
	juhuslik_vaartustus(FL, [], V).



juhuslik_vaartustus([L|Ls], V1, V2):-
	Lc is -L,
	((\+ member(L, V1), \+member(Lc, V1)) ->
		random(R),
		((R > 0.5) ->
			juhuslik_vaartustus(Ls, [L|V1], V2)
			;
			juhuslik_vaartustus(Ls, [Lc|V1], V2)
		)
		;
		juhuslik_vaartustus(Ls, V1, V2)
	).

juhuslik_vaartustus([], V, V).