prime37(N):- member(N, [2,3,5,7,11,13,17,19,23,29,31,37]).

solve((M1, N1), (M2, N2), (M3, N3), (M4, N4)):-
	between(1, 10, Y3),
        between(1, 10, Y4),
        between(1, 10, Y2),
        Y1 is Y3 + Y4 - Y2,
        Y1 >= 1, Y1 =< 10,
	% Yi's will satisfy condition Y1 + Y2 = Y3 + Y4 here
	% Extra condition on Yi's:
        (Y1=:=Y3, Y2=:=Y4 -> fail; true),
        prime37(Q),
	% Compute radicals
        W1 is Q * Y1^4,
        W2 is Q * Y2^4,
        W3 is Q * Y3^4,
        W4 is Q * Y4^4,
	0.001 >= abs(W1^(1/4) + W2^(1/4) - W3^(1/4) - W4^(1/4)),
	% Check sum of-two-squares
        two_square_sum(W1, M1, N1),
        two_square_sum(W2, M2, N2),
        two_square_sum(W3, M3, N3),
        two_square_sum(W4, M4, N4),
	% Check linear conditions for M,N's
        M1 + M2 =:= M3 + M4,
        N1 + N2 =:= N3 + N4.

two_square_sum(W, M, N):-
        U is floor(sqrt(W)), between(0, U, M), N1 is sqrt(W-M^2), 0.001 >= N1 - floor(N1), N is round(N1).