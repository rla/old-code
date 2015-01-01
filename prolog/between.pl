bw(L, U, L):- L =< U.
bw(L, U, N):- L =< U, L1 is L + 1, bw(L1, U, N).