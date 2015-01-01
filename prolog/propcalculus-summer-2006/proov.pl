% Proposal calculus
% Raivo Laanemets

% Valemite kirjeldus
% Aatomid
proposal_atom('A').
proposal_atom('B').
proposal_atom('C').
proposal_atom('D').

proposal_atom(- X):-
	proposal_atom(X).

% Tautoloogia
prove([X] |- [X]):-
	proposal_atom(X).
