% Prolog module for binary trees.
% Raivo Laanemets, rlaanemt@ut.ee, 29.09.06
% Version 1.01

:-module(binary_tree, [
	empty/1,
	insert/4,
	min/3,
	max/3,
	remove/4,
	random_tree/2,
	member/3
]).

% Empty(?Tree).
% Unifies Tree with empty tree.

empty(void).

% Insert(+TreeIn, +Key, +Data, -TreeOut).
% Insert data Data with key Key into the TreeIn.

insert(void, K, D, (K, D, void, void)):- !.
insert((RK, RD, L, R), K, D, (RK, RD, TL, R)):- K @< RK, !, insert(L, K, D, TL).
insert((RK, RD, L, R), K, D, (RK, RD, L, TR)):- !, insert(R, K, D, TR).

% Max(+Tree, -Data, -Key).
% Find the maximum element (by key) of the tree.

max((K, D, void, void), K, D):- !.
max((K, D, _, void), K, D):- !.
max((_, _, _, R), K, D):- max(R, K, D).

% Min(+Tree, -Data, -Key).
% Find the minimum element (by key) of the tree.

min((K, D, void, void), K, D):- !.
min((K, D, void, _), K, D):- !.
min((_, _, L, _), K, D):- min(L, K, D).

% Remove(+Tree, +Key, +Data, -Tree).
% Remove element (by key and data) from the list.

remove(void, _, _, void).
remove((K, D, L, R), K, D, T):- !, combine(L, R, T).
remove((RK, RD, L, R), K, D, (RK, RD, RL, R)):- K @< RK, !, remove(L, K, D, RL).
remove((RK, RD, L, R), K, D, (RK, RD, L, RR)):- remove(R, K, D, RR).

% Member(+Tree, +Key, ?Data).
% Check if the tree contains key, data pair.

member((K, D, _, _), K, D).
member((RK, _, L, _), K, D):- K @< RK, !, member(L, K, D).
member((_, _, _, R), K, D):- member(R, K, D).
	

% Help to combine two subtrees T1 and T2 into one node.
% We assume that T1 and T2 are binary search trees
% and every element of T1 is smaller than every
% element of T2.
% Traverse down the right nodes of T1, reach void, replace
% with T2. In the worst case the tree heigh doubles - 2.

combine(void, T2, T2).
combine((K, D, L, R), T2, (K, D, L, T)):- combine(R, T2, T).

% Some test methods.

test:-
	insert(void, 2, a, A),
	insert(A, 1, b, B),
	insert(B, 3, c, C),
	select(C, 1, b).

random_tree(T, N):- random_insert(N, void, T).

random_insert(0, T, T).
random_insert(N, T, TF):- !,
	N1 is N-1,
	R is random(2000),
	insert(T, R, R, T1),
	random_insert(N1, T1, TF).

test_remove_max(0, _).
test_remove_max(N, T):-
	N1 is N-1,
	max(T, K, D),
	remove(T, K, D, T1),
	test_remove_max(N1, T1).

benchmark:- random_tree(RT, 1000), !, test_remove_max(100, RT).