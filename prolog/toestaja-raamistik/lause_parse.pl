% Predikaatloogika lausete parser
% Hetkel on implikatsioon välja võetud, sest
% muidu oli liiga aeglane.
%
% Raivo Laanemets

:-module(lause_parse, [
	parse/2,
	parsi_laused/2
]).

:-use_module('lause_parse_tehted').
:-use_module('lause_parse_jareltootlus').

parse(I, F):-
	parse_tehted(I, F1),
	parse_jareltootlus(F1, F).

parsi_laused([], []).

parsi_laused([L|Ls], [P|Ps]):-
	parse(L, P),
	parsi_laused(Ls, Ps).