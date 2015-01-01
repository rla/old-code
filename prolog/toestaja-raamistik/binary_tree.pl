/** <module> Prolog module for binary trees

@author Raivo Laanemets, rlaanemt@ut.ee, 29.09.06
@license GPL
@version 1.01
@compability SWI-Prolog 5.6.24
@filename binary-tree.pl
*/

:-module(binary_tree, [
	empty/1,
	insert/4,
	min/3,
	max/3,
	remove/4,
	random_tree/2,
	member/3
]).

/** empty($?T$:tree).

Unifies the variable $T$ vith the empty tree. Can also be
used to check whether the $T$ is an empty tree.
*/

empty(void).

/** insert($+T_1$:tree, $+K$, $+D$, $-T_2$:tree).

Insert the data $D$ with the key $K$ into the tree $T_1$.
The resulting tree is $T_2$.
*/

insert(void, K, D, (K, D, void, void)):- !.
insert((RK, RD, L, R), K, D, (RK, RD, TL, R)):- K @< RK, !, insert(L, K, D, TL).
insert((RK, RD, L, R), K, D, (RK, RD, L, TR)):- !, insert(R, K, D, TR).

/** max($+T$:tree, $-D$, $-K$).

Find the maximum element $D$ (by key $K$) of the tree $T$.
*/

max((K, D, void, void), K, D):- !.
max((K, D, _, void), K, D):- !.
max((_, _, _, R), K, D):- max(R, K, D).

/** min($+T$:tree, $-D$, $-K$).

Find the minimum element $D$ (by key $K$) of the tree $T$.
*/

min((K, D, void, void), K, D):- !.
min((K, D, void, _), K, D):- !.
min((_, _, L, _), K, D):- min(L, K, D).

/** remove($+T_1$, $+K$, $?D$, $-T_2$).

Remove the element by key $K$ and data $D$ from the tree $T_1$.
The resulting tree is $T_2$.
*/

remove(void, _, _, void).
remove((K, D, L, R), K, D, T):- !, combine(L, R, T).
remove((RK, RD, L, R), K, D, (RK, RD, RL, R)):- K @< RK, !, remove(L, K, D, RL).
remove((RK, RD, L, R), K, D, (RK, RD, L, RR)):- remove(R, K, D, RR).

/** member($+T$, $+K$, $?D$).

Check if the tree $T$ contains key $K$ with data $D$.
*/

member((K, D, _, _), K, D).
member((RK, _, L, _), K, D):- K @< RK, !, member(L, K, D).
member((_, _, _, R), K, D):- member(R, K, D).
	

/** combine($+T_1$:tree, $+T_2$:tree, $-T_3$:tree).

Help to combine two subtrees $T_1$ and $T_2$ into one tree $T_3$.
We assume that every element of $T_1$ is smaller than every
element of $T_2$.
*/

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