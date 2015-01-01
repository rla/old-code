one(1,2).
one(3,4).
one(2,3).

sym_trans_closure(Pairs, Solution):-
	findall((Y,X), (member((X,Y), Pairs), \+ member((Y,X), Pairs)), Sym),
	append(Pairs, Sym, SymPairs),
	findall((X,Z), (member((X,Y), SymPairs), member((Y,Z), SymPairs), \+ member((X,Z), SymPairs)), Trans),
	append(SymPairs, Trans, SymTransPairs),
	length(Pairs, Before),
	length(SymTransPairs, After),
	(Before = After ->
		Solution = SymTransPairs
		;
		sym_trans_closure(SymTransPairs, Solution)
	).

sym_trans_one(X,Y):-
	findall((X,Y), one(X, Y), List),
	sym_trans_closure(List, Solution),
	member((X,Y), Solution).