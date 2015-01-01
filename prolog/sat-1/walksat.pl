% Randomiseeritud lokaalne otsing lausearvutusvalemi
% lahendi leidmiseks.

:-module(walksat, [
	walksat/4,
	vali_max_sat/5
]).

:-use_module(library('random')).
:-use_module('valem').

% F - valem
% P - tõenäosus, et muudetav literaal valitakse juhuslikult (0..1).
% M - maksimaalne iteratsioonide arv
% V - saadav väärtustus (tõesed literaalid)

walksat(F, P, M, V):-
	juhuslik_vaartustus(F, V1), !,
	otsi(F, P, 0, M, V1, V).

% Üks otsinguiteratsioon.
% otsi(F, P, I, M, V1, V2)
% F - valem
% P - sama, mis walksat/4 kirjelduses
% I - seni tehtud iteratsioonide arv
% M - maksimaalne iteratsioonide arv
% V1 - seni leitud väärtustus
% V2 - lõpp-väärtustus

% Reegel 1:
% Kui valemis F on kõik klauslid rahuldatud, siis sobib
% lõppväärtustuseks seni leitud väärtustus V.

otsi(F, _, _, _, V, V):- positiivne_valem(F, V), !.

% Reegel 2:
% Kui iteratsioonide arv on suurem kui lubatud,
% siis lõpeta töö. Lõpp-väärtustust sel
% juhul ei saa.

otsi(_, _, I, M, _, _):- I > M, !, write('lopp').

% Reegel 3:
% Kõigepealt vali väär klausel K,
% seejärel võta juhuslik muutuja R (0..1).
% Kui R < P, siis vali juhuslik literaal L
% klauslist K ja senises väärtustuses V1
% vaheta L tema komplementaari Lc vastu.
% Seejärel jätka järgmise iteratsiooniga.
% Kui R > P, siis vali selline literaal
% klauslist K, mis maksimeerib tõeste klauslite
% arvu valemis F. Seejärel jätka järgmise
% iteratsiooniga.

otsi(F, P, I, M, V1, V2):-
	I =< M, !,
	I1 is I + 1,
	juhuslik_neg_klausel(F, V1, K), !,
	(juhuslik_tegevus(P) ->
		member(L, K),
		\+ member(L, V1),
		Lc is -L,
		delete([L|V1], Lc, V3)
		;
		vali_max_sat(K, L, F, V1, V3)
	),
	otsi(F, P, I1, M, V3, V2).

% Literaali valik etteantud klauslist, mis
% maksimeerib tõeste klauslite hulga valemis F.

% [L1|K] - klausel, millest literaali valida
% L - valitud literaal
% F - esialgne valem
% V1 - esialgne väärtustus
% V3 - lõpp-väärtustus

vali_max_sat([L1|K], L, F, V1, V3):- !,
	Lc is -L1,
	delete([L1|V1], Lc, V4),
	positiivseid_klausleid(F, V4, C1),
	vali_max_sat(K, L, F, V1, V3, L1, C1, V4).

% [L1|K] - klausel, millest literaali valida
% L - valitud literaal
% F - esialgne valem
% V1 - esialgne väärtustus
% V3 - lõpp-väärtustus
% L2 - seni valitud parim literaal (akumulaator)
% C2 - seni parima valiku hinnang - pos. klauslite arv (akumulaator)
% V4 - senisele parimale valikule vastav väärtustus

vali_max_sat([L1|K], L, F, V1, V3, L2, C2, V4):-
	Lc is -L1,
	delete([L1|V1], Lc, V5),
	positiivseid_klausleid(F, V5, C1),
	((C1 > C2) ->
		vali_max_sat(K, L, F, V1, V3, L1, C1, V5)
		;
		vali_max_sat(K, L, F, V1, V3, L2, C2, V4)
	).

vali_max_sat([], L, _, _, V, L, _, V).
	
% Väära klausli K valimine valemist F
% väärtustuse V põhjal. Väärtustus V
% peab olema täielik (sisaldab kõiki
% valemis F esinevaid muutujaid positiivse
% või negatiivse literaalina).

vali_neg_klausel(F, V, K):-
	member(K, F),
	\+ (member(L, K), member(L, V)).