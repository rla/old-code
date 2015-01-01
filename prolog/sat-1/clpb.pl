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

% Kitsenduste ehitamine.

numsat(F, V):-
	numsat(F, [], V).

numsat([], V, V).

numsat([K|F], NV, NV2):-
	numsat_clause(K, NV, NV1, 0),
	numsat(F, NV1, NV2).

numsat_clause([], NV, NV, 1).
	
numsat_clause([L|Ls], NV, NV1, R):-
	(member(L=V, NV) ->
		or(V, R, R1),
		numsat_clause(Ls, NV, NV1, R1)
		;
		Lc is -L,
		(member(Lc=Vc, NV) ->
			var(V),
			not(Vc, V),
			or(V, R, R1),
			V in 0..1,
			numsat_clause(Ls, [L=V|NV], NV1, R1)
			;
			var(V),
			or(V, R, R1),
			V in 0..1,
			numsat_clause(Ls, [L=V|NV], NV1, R1)
		)
	).