even(N):- 0 is N mod 2.

b2n(_, 0, 1).
b2n(X, N, R):- even(N), !, N1 is N // 2, b2n(X, N1, R1), R is R1 * R1.
b2n(X, N, R):- N1 is N - 1, b2n(X, N1, R1), R is X * R1.