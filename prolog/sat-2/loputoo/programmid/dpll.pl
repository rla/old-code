%% <module> DPLL kehtestatavusalgoritmi peamoodul.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(dpll, [
	dpll/2
]).

:-use_module(library(lists)).

:-use_module(abi).
:-use_module(valem).
:-use_module(vaartustus).
:-use_module(kontrolli).
:-use_module(propageeri).
:-use_module(silur).

%% dpll(+F:valem, -V).
%
% DPLL algoritmi realisatsioon. Valem F on konjuktiivsel
% normaalkujul valem, mis on antud listiesituses ja mille
% muutujad on kodeeritud täisarvudena. Väljund V on muutujate
% väärtustus, mis on antud andmestruktuuriga {\tt olek}.
%
% Näide kasutamisest:
% ?>
% ?- dpll([[1, 2, 3], [-1]], V1).
% V1 = v(0, 1, _G657)
% Yes
% <?

dpll(Fin, V):-
	algvaartustus(Fin, F, S, V),
	silur_valem(F, S, 0),
	(leia_alg_yhik(F, Ys) ->
		samm(yhik(Ys), F, S, 0, 0)
		;
		samm(vali, F, S, 0, 0)
	).

% Muutujate tähendus:
%
% L - viimati tõeseks valitud literaal.
% F - valem.
% S - väärtustus.
% Ct - tõeste klauslite arv.
% D - lahenduspinu sügavus.
% Ys - ühikliteraalide vahepinu.
	
dpll(L, F, S, Ct, D, Ys):-
	silur_oota,
	silur_valem(F, S, D),
	kontrolli(O, L, F, S, Ct, Ys),
	samm(O, F, S, Ct, D).
	
samm(yhik([Y|Ys]), F, S, Ct, D):-
	silur_yhikliteraal(Y, D),
	propageeri(Y, F, S, Cf, Ct1),
	(Cf > 0 ->
		write_konflikt(D),
		fail
		;
		Ct2 is Ct + Ct1,
		D1 is D + 1,
		dpll(Y, F, S, Ct2, D1, Ys)
	).
	
samm(vali, F, S, Ct, D):-
	vali_muutuja(F, S, L),
	silur_literaal(L, D),
	propageeri(L, F, S, Cf, Ct1),
	(Cf > 0 ->
		write_konflikt(D),
		fail
		;
		Ct2 is Ct + Ct1,
		D1 is D + 1,
		dpll(L, F, S, Ct2, D1, [])
	).
	
samm(sat, _, _, _, _).

% Valemist muutuja valimine.

vali_muutuja(valem(N, _, _, _), S, L):-
	between(1, N, I),
	muutuja_vaartuseta(S, I), !,
	(L is I ; L is -I).