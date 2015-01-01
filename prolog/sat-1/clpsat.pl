% SAT kasutades CLP(FD).
%
% P.Codognet, D.Diaz
% Boolean Constraint Solving Using clp(FD) (1993)
%
% Vaata ka:
% http://hcs.science.uva.nl/projects/SWI-Prolog/Manual/clpbounds.html

:-use_module(library('clp/bounds')).

% Primitiivsed kitsendused.

and(X, Y, Z):-
	Z #= X * Y,
	Z #=< X, X #=< Z * Y + 1 - Y,
	Z #=< Y, Y #=< Z * X + 1 - X.

or(X, Y, Z):-
	Z #= X + Y - X * Y,
	Z * (1 - Y) #=< X, X #=< Z,
	Z * (1 - X) #=< Y, Y #=< Z.

not(X, Y):-
	X #= 1 - Y,
	Y #= 1 - X.

label_vars([]).

label_vars([_=Var|V]):-
	indomain(Var),
	label_vars(V).

clpsat_label(F, V):-
	clpsat(F, V),
	label_vars(V).

% Kitsenduste ehitamine.

clpsat(F, V):-
	clpsat(F, [], V).

clpsat([], V, V):- !.

clpsat([K|F], NV, NV2):-
	clpsat_clause(K, NV, NV1, 0),
	clpsat(F, NV1, NV2).

clpsat_clause([], NV, NV, 1).
	
clpsat_clause([L|Ls], NV, NV1, R):-
	(member(L=V, NV) ->
		or(V, R, R1),
		clpsat_clause(Ls, NV, NV1, R1)
		;
		Lc is -L,
		(member(Lc=Vc, NV) ->
			var(V),
			not(Vc, V),
			or(V, R, R1),
			V in 0..1,
			clpsat_clause(Ls, [L=V|NV], NV1, R1)
			;
			var(V),
			or(V, R, R1),
			V in 0..1,
			clpsat_clause(Ls, [L=V|NV], NV1, R1)
		)
	).