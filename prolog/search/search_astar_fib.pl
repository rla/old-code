% Module for general A* search (uses Fibonacci heap).
%
% Raivo Laanemets, rlaanemt@ut.ee, 06.12.2006

:-module(search_astar_fib, [
	astar_fib/6
]).

:-use_module(fib_heap).

:-dynamic(visited/1).
:-index(visited(1)).

:-dynamic(step/2).
:-index(step(1, 0)).

% Genereal A* search method.
%
% S - start node
% E - end node
% EP - search graph extension predicate
% SV - state value
% MV - move value
% SH - state hasher

astar_fib(S, E, EP, SV, MV, T):-
	% Clean up
	retractall(visited(_)),
	retractall(step(_, _)),
	% Extend the start state
	call(EP, [], S, Ss),
	% Evaluate and save new states
	evaluate(Ss, 0, Q, SV, MV),
	% Compute hash of current state
	hash_term(S, SH),
	% Store hash
	assert(visited(SH)),
	astar_r(E, EP, SV, MV, Q, T).

% A* recursive call.
%
% E - end node
% EP - search graph extension predicate
% SV - state value
% MV - move value
% Q - queue
% T - path

astar_r(E, EP, SV, MV, Q, T):-
	% Take best move
	extract_min(SH0, H0),
	step(SH0, (T1, S)),
	% Are we in the end
	((E = S) ->
		T = T1
		;
		% Extend search graph
		call(EP, T1, S, Ss),
		% Evaluate new states
		evaluate(Ss, H0, Q, SV, MV),
		% Compute the has of current state
		hash_term(S, SH),
		% Store hash
		assert(visited(SH)),
		% Search on
		astar_r(E, EP, SV, MV, Q, T)
	).

% Evaluate and store given steps.
% Ss - list of (moves, state)
% H0 - cost of current path
% Q - fast queue
% SV - state value
% MV - move value 

evaluate([([M|Ms], S)|Ss], H0, Q, SV, MV):-
	hash_term(S, SH),
	(visited(SH) ->
		evaluate(Ss, H0, Q, SV, MV)
		;
		% Path length
		length([M|Ms], L),
		% State value
		call(SV, S, H1),
		% Move value
		call(MV, M, L, H2),
		% Overall value
		H is H0 + H1 + H2,
		% Save
		assert(step(SH, ([M|Ms], S))),
		insert(SH, H),
		evaluate(Ss, H0, Q, SV, MV)
	).

evaluate([], _, _, _, _).