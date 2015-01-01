% Fast priority queue. Limited for
% special cases of priority value.
% The priority value can only be an
% integer between 2 and 10025.
% The queue itself is non-logical
% and does not allow backtracking.
%
% Raivo Laanemets, rlaanemt@ut.ee, 06.12.2006

:-module(priority_queue_fast, [
	fast_queue/1,
	push/3,
	pop/2
]).

% Pop element off the queue.
%
% Q - queue
% E - element

pop(Q, E):-
	(arg(1, Q, 10025) ->
		fail
		;
		arg(1, Q, M), !,
		arg(M, Q, [E|Es]), !,
		nb_setarg(M, Q, Es),
		((Es = []) ->
			setmin(Q)
			;
			true
		)
	).

% Find lowest element and reorganise
% queue.

setmin(Q):-
	between(2, 10024, I),
	arg(I, Q, [_|_]), !,
	nb_setarg(1, Q, I).

setmin(Q):-
	nb_setarg(1, Q, 10025).

% Push element into the queue.
%
% Q - queue
% P - priority
% E - element

push(Q, P, E):-
	((P > 10024) ->
		format('Queue out of upper bound! (~a)', P),
		fail
		;
		true
	),
	((P < 2) ->
		format('Queue out of lower bound! (~a)', P),
		fail
		;
		true
	),
	arg(P, Q, A), !,
	nb_setarg(P, Q, [E|A]),
	arg(1, Q, M), !,
	((P < M)->
		nb_setarg(1, Q, P)
		;
		true
	).

% Create new queue.
%
% Q - queue

fast_queue(Q):-
	length(L, 10024),
	Q =.. [q|L],
	nb_setarg(1, Q, 10025),
	prepare(Q).

prepare(Q):-
	findall(I, between(2, 10024, I), Is),
	prepare(Is, Q).

prepare([], _).

prepare([I|Is], Q):-
	nb_setarg(I, Q, []),
	prepare(Is, Q).