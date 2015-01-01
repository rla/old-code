% Prolog module for priority queue.
% Uses binary tree as the storage element.
% See www.rl.pri.ee/programming/prolog/modules/binary_tree.pl
% Raivo Laanemets, rlaanemt@ut.ee, 29.09.06

:-module(priority_queue, [
	empty/1,
	push/4,
	popmin/3,
	popmax/3
]).

:-use_module('binary_tree').

% Push(+Queue1, +Priority, +Data, -Queue2).
% Push some data with some priority into the Queue.

push(Q1, P, D, Q2):- insert(Q1, P, D, Q2).

% Popmax(+Queue1, +Data, +Queue2).
% Pop the top priority data off the queue.

popmax(Q1, D, Q2):- max(Q1, P, D),! , remove(Q1, P, D, Q2).

% Popmin(+Queue1, +Data, +Queue2).
% Pop the lowest priority data off the queue.

popmin(Q1, D, Q2):- min(Q1, P, D),! ,remove(Q1, P, D, Q2).

test:-
	empty(Q),
	push(Q, 4, a, Q1),
	push(Q1, 2, b, Q2),
	push(Q2, 5, c, Q3),
	popmin(Q3, b, _).