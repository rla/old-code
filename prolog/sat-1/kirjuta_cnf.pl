% Valemi kirjutamine .cnf faili.

:-module(kirjuta_cnf, [
	kirjuta_cnf/2
]).

:-use_module(library('lists')).

% F - valem
% FN - faili nimi, millesse kirjutada

kirjuta_cnf(F, FN):-
	open(FN, write, S, []),
	kirjuta_cnf1(F, S),
	close(S).
	
kirjuta_cnf1([], _).

kirjuta_cnf1([C|F], S):-
	kirjuta_klausel(C, S),
	kirjuta_cnf1(F, S).
	
kirjuta_klausel([], S):-
	write(S, '0'), nl(S).
	
kirjuta_klausel([L|Ls], S):-
	write(S, L), write(S, ' '),
	kirjuta_klausel(Ls, S).