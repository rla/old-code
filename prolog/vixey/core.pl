%% Things which may be useful/reusable go in here

split([Pivot|Rest],Pivot,[]-Rest).
split([L|Rest],Pivot,[L|Ls]-Rs) :- L \= Pivot, split(Rest,Pivot,Ls-Rs).

%sort(Key,List,Sorted) :- permutation(List,Sorted), sorted(Key,Sorted).
%% too damn slow!
%sorted(_,[]).
%sorted(_,[_]).
%sorted(Key,[A,B|Xs]) :- apply(Key,[A,AK]), apply(Key,[B,BK]), AK >= BK, sorted(Key,[B|Xs]).


sort(Key,List,Sorted) :- qsort(Key,List,Sorted,[]).

%% Thank you David H. D. Warren!

qsort(Key,[X|L],R,R0) :-
	partition(Key,L,X,L1,L2),
	qsort(Key,L2,R1,R0),
	qsort(Key,L1,R,[X|R1]).
qsort(_,[],R,R).

partition(Key,[X|L],Y,[X|L1],L2) :-
	apply(Key,[X,Xk]), apply(Key,[Y,Yk]), Xk >= Yk, !,
	partition(Key,L,Y,L1,L2).
partition(Key,[X|L],Y,L1,[X|L2]) :-
	partition(Key,L,Y,L1,L2).
partition(_,[],_,[],[]).
