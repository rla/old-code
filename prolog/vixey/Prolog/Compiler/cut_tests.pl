flip(heads).
flip(tails).

t1(X,Y) :- flip(X), flip(Y).

t2(X,Y) :- (flip(X), !), flip(Y).

t3(X,Y) :- flip(X), (!, flip(Y)).

t4(X,Y) :- X = a, !, flip(Y).
t4(X,Y) :- X = b, flip(Y).

t5(X,Y) :- fail.
t5(X,Y) :- X = a, !, flip(Y).
t5(X,Y) :- X = b, flip(Y).
