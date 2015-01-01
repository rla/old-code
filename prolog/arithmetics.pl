next(X, s(X)).

add(X, 0, X).
add(X, Y, s(Z)):- next(Y1, Y), add(X, Y1, Z).

mult(_, 0, 0).
mult(X, s(0), X).
mult(X, Y, Z):- next(Y1, Y), mult(X, Y1, Z1), add(X, Z1, Z).

power(_, 0, s(0)).
power(X, s(0), X).
power(X, Y, Z):- next(Y1, Y), power(X, Y1, Z1), mult(X, Z1, Z).