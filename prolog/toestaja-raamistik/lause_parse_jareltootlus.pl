% Valemi parsimise järeltöötlus.
% A <= B kirjutame ümber tehteks B => A
% A <=> B kirjutame ümber tehteks A => B & B => A

:-module(lause_parse_jareltootlus, [
	parse_jareltootlus/2
]).

parse_jareltootlus('V'(X, F), 'V'(X, F1)):-
	parse_jareltootlus(F, F1).

parse_jareltootlus('E'(X, F), 'E'(X, F1)):-
	parse_jareltootlus(F, F1).

parse_jareltootlus('~'(F), '~'(F1)):-
	parse_jareltootlus(F, F1).

parse_jareltootlus('=>'(F, G), '=>'(F1, G1)):-
	parse_jareltootlus(F, F1),
	parse_jareltootlus(G, G1).

parse_jareltootlus('&'(F, G), '&'(F1, G1)):-
	parse_jareltootlus(F, F1),
	parse_jareltootlus(G, G1).

parse_jareltootlus('v'(F, G), 'v'(F1, G1)):-
	parse_jareltootlus(F, F1),
	parse_jareltootlus(G, G1).

parse_jareltootlus('<=>'(F, G), '&'('=>'(F1, G1), '=>'(G1, F1))):-
	parse_jareltootlus(F, F1),
	parse_jareltootlus(G, G1).

parse_jareltootlus('<='(F, G), '=>'(G1, F1)):-
	parse_jareltootlus(F, F1),
	parse_jareltootlus(G, G1).

parse_jareltootlus('t'(P/0), 't'(P/0)).

parse_jareltootlus('t'(P/A, As), 't'(P/A, As)).