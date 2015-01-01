% Tuletus Bayes'i võrgus kaalutud loendamise abil.
%
% T.Sang, P.Beame, H.Kautz
% Solving Bayesian Networks by Weighted Model Counting (2005)

:-use_module('dpll_loenda_kaalutud').
:-use_module(library('lists')).

% Muutujate nimed võiksid olla termid.
% Hetkel vastavad lihtsalt lausearvutusmuutujatele.

% Olekumuutujad

state_var(1). % G
state_var(2). % F
state_var(3). % H

% Juhumuutujad

chance_var(4, 0.5). % d

chance_var(5, 0.7). % g1
chance_var(6, 0.2). % g0

chance_var(7, 0.6). % f1
chance_var(8, 0.1). % f0

chance_var(9, 0.5).  % h10
chance_var(10, 0.4). % h01

process_vars(Ws):-
	process_state_vars(Ws1),
	process_chance_vars(Ws2),
	append(Ws1, Ws2, Ws).

% Olekumuutujate kaalude listi koostamine.
% Iga olekumuutuja kaal on 1.0.

process_state_vars(Ws):-
	findall(V, state_var(V), Vs),
	process_state_vars(Vs, Ws).

process_state_vars([V|Vs], [V=1.0,Vc=1.0|Ws]):-
	Vc is -V,
	process_state_vars(Vs, Ws).

process_state_vars([], []).

% Juhumuutujate kaalude listi koostamine.
% Juhumuutuja positiivse ja negatiivse esinemise
% summa on 1.

process_chance_vars(Ws):-
	findall(V=W, chance_var(V, W), VWs),
	process_chance_vars(VWs, Ws).

process_chance_vars([V=W|VWs], [V=W,Vc=W1|Ws]):-
	Vc is -V,
	W1 is 1 - W,
	process_chance_vars(VWs, Ws).

process_chance_vars([], []).

% Klauslid, mis moodustavad võrgu teadmistebaasi.

% Get-tired

bn_clause([-4, -5,  1]). % -d, -g1,  G
bn_clause([-4,  5, -1]). % -d,  g1, -G
bn_clause([ 4, -6,  1]). %  d, -g0,  G
bn_clause([ 4,  6, -1]). %  d,  g0, -G

% Finish-work

bn_clause([-4, -7,  2]). % -d, -f1,  F
bn_clause([-4,  7, -2]). % -d,  f1, -F
bn_clause([ 4, -8,  2]). %  d, -f0,  F
bn_clause([ 4,  8, -2]). %  d,  f0, -F

% Have-rest

bn_clause([-2, -1,   3]).     % -F, -G,  H
bn_clause([-2,  1,  -9,  3]). % -F,  G, -h10,  H
bn_clause([-2,  1,   9, -3]). % -F,  G,  h10, -H
bn_clause([ 2, -1, -10,  3]). %  F, -G, -h01,  H
bn_clause([ 2, -1,  10, -3]). %  F, -G,  h01, -H
bn_clause([ 2,  1,  -3]).     %  F,  G,  -H


% Võrgu klauslite korjamine valemiks.

process_bn_clauses(F):-
	findall(C, bn_clause(C), F).

% Päring
% Näidised:
% bn_query([[3], [2], [-1], [4]], P). (H & F & -G & d) P = 0.045
% bn_query([[3], [2], [1], [4]], P). (H & F & G & d) P = 0.21

% H - have rest
% F - finished work
% G - got tired
% d - do work

bn_query(Q, P):-
	process_vars(Ws),      % koosta muutujate kaalude list
	process_bn_clauses(F), % klauslite korjamine valemisse F
	append(F, Q, Fq),
	dpll(Fq, P, Ws).       % kaalutud mudelite arvu (= P(Q) (Q marginaalne tõenäosus)) leidmine