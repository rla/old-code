% Wang'i algoritmi testid (prove correctness but test anyway)
% Raivo Laanemets, suvi 2006

:-compile(operators).
:-compile(wang).

% Positiivsed juhud
% Aksioomid

:-wang([], []).
:-wang([a & b & c & d], [a]).
:-wang([a & -a], [b]).
:-wang([], [-a v a]).

% Tuntud loogilised samaväärsused

:-wang([b & a], [a & b]), wang([a & b], [b & a]).

% Muud

:-wang([], [a > (b > a)]).

% Negatiivsed juhud

:- \+ wang([a], [-a]).
:- \+ wang([a], []).
:- \+ wang([], [a]).
% Implikatsiooni mitteassotsiatiivsus
:- \+ wang([], [a > (b > c) <> (a > b) > c]).