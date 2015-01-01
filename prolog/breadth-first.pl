step(1, 2).
step(2, 4).
step(3, 2).
step(4, 1).
step(4, 3).
step(4, 5).
step(5, 2).
step(5, 4).
step(5, 6).
step(6, 1).

%% search(+A:node, +B:node, -P:path).

search(A, B, P):- search1(B, P, [(A,[A])], [A]).

%% search1(+B:node, -P:path, +Q:queue, +Vs:list).
%
% Queue is a list of pairs (N, P) where N is a node and
% P is the path to reach N.

search1(B, P, [(B,P)|_], _):- !.
search1(B, P, [(B1,P1)|Q], Vs):-
	findall(
		(B2, [B2|P1]),
		(
			step(B1, B2),
			not(member(B2, Vs))
		),
		Es
	),
	append(Es, Q, Q1), % append(Q, Es, Q1) for depth-first
	search1(B, P, Q1, [B1|Vs]).