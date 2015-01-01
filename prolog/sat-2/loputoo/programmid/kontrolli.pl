%% <module> Valemi kontrollimine vahetult pärast muutuja väärtustamist.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(kontrolli, [
	kontrolli/6
]).

:-use_module(library(lists)).

:-use_module(abi).
:-use_module(vaartustus).
:-use_module(valem).

%% kontrolli(-O:otsus, +L:int, +F:valem, +V:olek, +Ct:int, +Ys:list).
%
% Kontrolli hetkel väärtustust viimati tehtud
% lahendussammu järgi. O - väljund, L - viimati tõeseks
% valitud literaal, F - valem, mida lahendatakse, V - hetkel
% kehtiv väärtustus, Ct - seni tõeseks saadud klauslite arv,
% Ys - ühikliteraalide pinu.
%
% Väljund O võib olla üks järgmistest: \texttt{sat} - valem on tõene;
% \texttt{yhik(Ls)} - võta järgmistes sammudes tõeseks ühikliteraalid \texttt{Ls};
% \texttt{vali} - vali järgmises sammus suvaline muutuja.

kontrolli(sat, _, valem(_, Ct, _, _), _, Ct, _):- !.

kontrolli(yhik(Ys), L, F, S, _, Acc):-
	literaali_klauslid(F, L, Cs),
	y_literaalid(Cs, Acc, Ys, S, F),
	(length(Ys, 0) -> fail ; true), !.
	
kontrolli(vali, _, _, _, _, _):- !.

% Leia klauslitest Cs põhjendustega ühikliteraalid Ys.

y_literaalid([], Ys, Ys, _, _):- !.
y_literaalid([C|Cs], Acc, Ys, S, F):-
	y_literaal(C, Y, Acc, F, S), !,
	y_literaalid(Cs, [Y|Acc], Ys, S, F).
y_literaalid([_|Cs], Acc, Ys, S, F):- y_literaalid(Cs, Acc, Ys, S, F).

y_literaal(C, Y, Ys, F, S):-
	klausel_vaartuseta(S, C),
	klausli_muutujad(F, C, Ps, Ns),
	m_filtreeri_vaartuseta(Ps, S, Ps1),
	m_filtreeri_vaartuseta(Ns, S, Ns1),
	(
		(Ps1 = [Y], Ns1 = [])
		;
		(Ps1 = [], Ns1 = [Yc], Y is -Yc)
	),
	\+ member(Y, Ys).