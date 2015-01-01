% Randomiseeritud lokaalne otsing lausearvutusvalemi
% lahendi leidmiseks.
% (Ühtlane lahendite otsimine)

:-module(samplesat, [
	samplesat/2
]).

:-use_module(library('random')).
:-use_module(library('lists')).
:-use_module('valem').
:-use_module('walksat').

% SampleSAT algoritm
% Kõigepealt koosta juhuslik
% väärtustus V1 ja tööta sellega edasi
% iteratsioonide kaupa.

samplesat(F, V):- !,
	juhuslik_vaartustus(F, V1),
	iteratsioon(F, V1, V).

% Reegel 1: kui etteantud väärtustuses
% on valem F tõene, siis lõpeta.

iteratsioon(F, V, V):-
	positiivne_valem(F, V), !.

% Reegel 2: tõenäosusega 0.5 tee Wandom Walk,
% muidu kasuta Metropolise algoritmi.

iteratsioon(F, V, Vf):-
	(juhuslik_tegevus(0.5) ->
                random_walk(F, V, V1),
		iteratsioon(F, V1, Vf)
		;
		member(K, F), member(L, K),
		Lc is -L,
		positiivseid_klausleid(F, V, C1),
		delete([L|V], Lc, V1),
		positiivseid_klausleid(F, V, C2),
		Dcost = C1 - C2, % decrease
		((Dcost =< 0) ->
			iteratsioon(F, V1, Vf)
			;
			P is 2.71^(-Dcost/10),
			(juhuslik_tegevus(P) ->
				iteratsioon(F, V1, Vf)
				;
				iteratsioon(F, V, Vf)
			)
		)
		
	).

% Random Walk samm SampleSat algoritmis.

random_walk(F, V, Vf):-
	juhuslik_neg_klausel(F, V, K),
	(juhuslik_tegevus(0.5) ->
		member(L, K),
		\+ member(L, V),
		Lc is -L,
		delete([L|V], Lc, Vf)
		;
		vali_max_sat(K, L, F, V, Vf)
	).