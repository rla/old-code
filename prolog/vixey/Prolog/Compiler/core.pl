true.

X = X.

\+ X :- call(X), !, fail.
\+ X.

X \= Y :- \+ X = Y.

If -> Then ; Else :- !, (call(If), !, call(Then) ; call(Else)).
Left ; Right :- or(Left,Right).

This => That :- \+ (call(This), \+ call(That)).

V1 == V2 :-
  var(V1), var(V2).
  \+ (V1 = chalk, V2 = cheese).
C1 == C2 :-
  functor(C1, C, N), functor(C2, C, N),
  ( arg(I,C1,A1),arg(I,C2,A2) => A1 == A2 ).


list([]).
list([_|_]).

member(X,[X|_]).
member(X,[_|XS]) :- member(X,XS).

append([],YS,YS).
append([X|XS],YS,[X|ZS]) :- append(XS,YS,ZS).

select(E,[E|ES],ES).
select(E,[X|ES],[X|XS]) :- select(E,ES,XS).

maplist(P,[],[]).
maplist(P,[X|Xs],[Y|Ys]) :- call(P,X,Y), maplist(P,Xs,Ys).
