:-op(500, xf, *).
:-op(600, xfy, -).

in(W, E) :- in(E, W, []).

in(E) --> {var(E), !}, prefix(E).
in(X) --> {atom(X)}, [X].
in([]) --> [].
in([X|L]) --> [X], in(L).
in(E1 - E2) --> in(E1), in(E2).
in(E1 + E2) --> in(E1).
in(E1 + E2) --> in(E2).
in(E *) --> in([]) ; in(E - E *).
in(E ^ 0) --> [].
in(E ^ N) --> {N > 0, M is N - 1}, in(E), in(E ^ M).
prefix([]) --> [].
prefix([X|W]) --> [X], prefix(W).

