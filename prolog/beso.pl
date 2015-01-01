% Author:
% Date: 15.01.2008
:-op(800, xfy, 'u').
:-op(100, xf, '#').
:-op(400, xfy, 'c').
:-op(1000, xfy, '<=0').
:-op(1000, xfy, '<=').
:-op(1000, xfy, '<-').
:-op(850, xfy, '&').

der(_, [], []).
der( _, lambda, []).
der( X, A + B, D1 u D2):- der( X, A, D1), der( X, B, D2).
der( X, A u S, D1 u D2):- der( X, A, D1), der( X, S, D2).
der(X,A#, D) :- der2(X ,A,A#,D).
der(X, A0 c B, D) :-  \+ nullable(A0), der2(X,A0,B,D).
der(X, A1 c B, D1 u D2) :- nullable(A1), der2(X,A1,B,D1), der(X,B,D2).
der(X,Y,Z):- atom(Y), (X=Y -> Z=lambda ; Z=[]).
der2(_, [], c, []).
der2( _, lambda, _, []).
der2( X, A + B, C, D1 u D2):- der2( X, A, C, D1), der2( X, B, C, D2).
der2(X,A#, C, D) :- der2(X ,A,A# c C,D).
der2(X, A0 c B, C, D) :- \+ nullable(A0), der2(X,A0,B c C,D).
der2(X, A1 c B, C, D1 u D2) :- nullable(A1), der2(X,A1,B c C,D1), der2(X,B,C,D2).
der2(X,Y,C,Z):- atom(Y),(X=Y -> Z=C ; Z=[]).

nullable(lambda):-true.
nullable(_#):-true.
nullable(A + B):- nullable(A);nullable(B).
nullable(A c B):- nullable(A),nullable(B).

unf([],_,true).
unf(lambda,_,1):-!.
unf(A#,S,U):-unf2(A,A#,S,U).
unf(A + B,S,U1 & U2):-unf(A,S,U1),unf(B,S,U2).
unf(A0 c B,S,U):- \+ nullable(A0),unf2(A0,B,S,U).
unf(A1 c B,S,U1 & U2):- nullable(A1),unf2(A1,B,S,U1), unf(B,S,U2).
unf( X, S, R):- der( X, S, D),prove(lambda <= D,R).
%unf( X, S, lambda <= D):- der( X, S, D).
unf2([],_,_,1).
unf2(lambda,_,_,1).
unf2(A#,C,S,U):-unf2(A,A# c C,S,U).
unf2(A + B,C,S,U1 & U2):-unf2(A,C,S,U1),unf2(B,C,S,U2).
unf2(A0 c B,C,S,U):- \+ nullable(A0), unf2(A0,B c C,S,U).
unf2(A1 c B,C,S,U1 & U2):- nullable(A1), unf2(A1,B c C,S,U1),unf2(B,C,S,U2).
unf2( X, C, S, C <= D):- der( X, S, D).



%Module Main

prove(A <= S & A <- S & C ,R):- prove(A <- S & C,R).
prove(A <= S & A <- S,R):- prove(A <- S ,R).
prove(A1 <= S0 ,0):- nullable(A1), \+ nullable(S0).
prove(A0 <= S ,R1 & A0 <- S):-  \+ nullable(A0), unf(A0,S,R1).
prove(A1 <= S1 ,R1 & A1 <- S1):-  nullable(A1),nullable(S1), unf(A1,S1,R1).

%trivial case

prove([] <= _, 1).
prove(lambda <= _, 1).
prove(A <= A, 1).
prove(A <= B1 c A, 1):-nullable(B1).

%comutativity and asociativity of u

commute_for_u( C1 u C2, C1 u C2).
commute_for_u( C1 u C2, C2 u C1).
asociative_for_u( C1 u C2 u C3, (C1 u C2) u C3).
asociative_for_u( C1 u C2 u C3, C1 u (C2 u C3)).

%axioms for u

rule_for_u([] u S,S).
rule_for_u(S u S,S).

%comutativity and asociativity of &


commute_for_and( C1 & C2, C1 & C2).
commute_for_and( C1 & C2, C2 & C1).
asociative_for_and( C1 & C2 & C3, (C1 & C2) & C3).
asociative_for_and( C1 & C2 & C3, C1 & (C2 & C3)).

%axioms for &

rule_for_and(1 & S,S).
rule_for_and(0 & _,0).
rule_for_and(S & S,S).

% simplify
simplify(A <= S u _ & A <- S , A <- S).
simplify(A <= S u _ & A <= S, A <= S).
simplify(A <= S u _ & A <- S & C, A <- S & C).
simplify(A <= S u _ & A <= S & C, A <= S & C).