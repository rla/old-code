add(X, Y, Z):- var(Z), Z is X + Y.
add(X, Y, Z):- var(X), X is Z - Y.
add(X, Y, Z):- var(Y), Y is Z - X.

mult(X, Y, Z):- var(Z), Z is X * Y.
mult(X, Y, Z):- var(X), X is Z / Y.
mult(X, Y, Z):- var(Y), Y is Z / X.