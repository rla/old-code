% Defines all available colors

color(red).
color(green).
color(blue).
 
node(1).
node(2).
node(3).
node(4).
 
egde(1,2).
egde(1,3).
egde(2,3).
egde(2,4).
egde(3,4).

% mispell?
egde_s(X,Y) :- egde(X,Y); egde(Y,X).

% do coloring but start with no colorful subgraph
colors(Cs):-
	colors(Cs, []).

% do coloring by taken into account that some nodes are colored already
colors(Cs, Vs):-
	% pick a node
	(node(N), \+member((N, _), Vs) ->
		% color it
		color(C),
		% check if there is no edge between it and some other node
		% with same color
		% could be done otherway too (generate neighbours and test)
		% might be more efficent
		\+ (member((N1, C), Vs), egde_s(N, N1)),
		% do more coloring
		colors(Cs1, [(N, C)|Vs]),
		Cs = [(N, C)|Cs1]
		;
		% in case we have no more nodes we are ready
		Cs = []
	).