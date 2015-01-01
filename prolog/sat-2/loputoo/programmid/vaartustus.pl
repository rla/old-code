%% <module> Väärtustuse lisamiseks/kontrollimiseks kasutatvad protseduurid.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(vaartustus, [
	tyhi_vaartustus/2,
	vaartusta_muutuja/3,
	vaartusta_klausel/3,
	muutuja_vaartuseta/2,
	klausel_vaartuseta/2,
	muutuja_vaartus/3
]).

:-use_module(library(lists)).

%% tyhi_vaartustus(+F:valem, -V:olek).
%
% Valemi F muutujate jaoks tühja väärtustuse koostamine.

tyhi_vaartustus(valem(N, M, _, _), olek(V, K)):-
	length(Vs, N),
	V =.. [v|Vs],
	length(Ks, M),
	K =.. [c|Ks].
	
muutuja_vaartus(olek(Vs, _), I, V):- arg(I, Vs, V).
	
%% muutuja_vaartuseta(+V:olek, +I:int).
%
% Kontrollimine, kas etteantud indeksiga muutuja
% on vaartustuses V väärtustatud hetkel või mitte.

muutuja_vaartuseta(olek(Vs, _), I):- arg(I, Vs, V), var(V).
	
%% klausel_vaartuseta(+V:olek, +I:int).
%
% Kontrollimine, kas etteantud indeksiga klausel
% on vaartustuses V väärtustatud hetkel või mitte.

klausel_vaartuseta(olek(_, Cs), I):- arg(I, Cs, V), var(V).
	
%% vaartusta_muutuja(+V:olek, +I:int, +Val).
%
% Etteantud indeksiga I muutuja väärtustamine
% väärtusega Val väärtustuses V.

vaartusta_muutuja(olek(Vs, _), I, V):- arg(I, Vs, Val), var(Val), !, Val = V.
vaartusta_muutuja(olek(Vs, _), I, V):- arg(I, Vs, V).
	
%% vaartusta_klausel(+V:olek, +I:int, +Val).
%
% Klausli indeksiga I väärtustamine
% väärtusega Val väärtustuses V.

vaartusta_klausel(olek(_, Cs), I, V):- arg(I, Cs, Val), var(Val), !, Val = V.
vaartusta_klausel(olek(_, Cs), I, V):- arg(I, Cs, V).