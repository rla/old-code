clauses(F/N,Clauses):-
  length(Parameters,N),
  Term=..[F|Parameters],
  findall((Term:-Body),clause(Term,Body),Clauses).


member(X,[X|_]).
member(X,[_|XS]):-member(X,XS).

flip(heads).
flip(tails).

unify(X,X).

try(X,y):-X.
try(_,n).
negation(X):-once(try(X,N)),unify(N,n).


prove(true):-!.
prove((X,Y)):-!,prove(X),prove(Y).
prove(Query):-!,
  functor(Query,F,N),
  clauses(F/N,Clauses),
  prove_clauses(Query,Clauses).

prove_clauses(Query,[(Head:-Body)|Clauses]):-
  ( Query=Head,prove(Body)
  ; prove_clauses(Query,Clauses)
  ).


or(y,y,y):-!.
or(y,n,y):-!.
or(n,y,y):-!.
or(n,n,n):-!.


prove(true):-!.
prove(once(X)):-!,prove(X),!.
prove((X,Y)):-!,prove(X),prove(Y).
prove(Query):-!,
  functor(Query,F,N),
  clauses(F/N,Clauses),
  prove_clauses(Query,Clauses).

prove_clauses(Query,[(Head:-Body)|Clauses]):-
  ( Query=Head,prove(Body)
  ; prove_clauses(Query,Clauses)
  ).

