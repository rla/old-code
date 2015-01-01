% Author:
% Date: 11/1/2007

%my_save:-
 %   pce_autoload_all,
 %   qsave_program('sabo.exe', [goal(solve_main('data.out')), stand_alone(true)]).

% query solve_main('C:/Documents and Settings/bdundua/Desktop/lena/test.txt').

% y1=y3 & y2=y4
prime37(N):- member(N, [2,3,5,7,11,13,17,19,23,29,31,37]).

solve_main(F):-open(F, write, S), solve_and_write_stream(S), close( S).


 solve_and_write_stream(S) :-

        findall(
                _,
                (
                        solve((M1, N1), (M2, N2), (M3, N3), (M4, N4)),
                        format(S, '~a ~a\n ~a ~a\n ~a ~a\n ~a ~a\n', [M1, N1, M2, N2, M3, N3, M4, N4])
                ),
                _
        )
        .



solve((M1, N1), (M2, N2), (M3, N3), (M4, N4)):-
        between(1, 5, Y2),
        between(1, 5, Y3),
        between(1, 5, Y4),
        Y1 is Y3 + Y4 - Y2,
        Y1 >= 1, Y1 =< 5,
        Y1 =:= Y3 , Y2 =:= Y4,
        prime37(Q),
        W1 is Q * Y1,
        W2 is Q * Y2,
        W3 is Q * Y3,
        W4 is Q * Y4,
        two_square_sum(W1, M1, N1),
        two_square_sum(W2, M2, N2),
        two_square_sum(W3, M3, N3),
        two_square_sum(W4, M4, N4),
        M1 + M2 = M3 + M4,
        N1 + N2 = N3 + N4,
        0.0001 >= abs((M1 * M1 + N1 * N1)^(1/4) + (M2 * M2 + N2 * N2)^(1/4) - (M3 * M3 + N3 * N3)^(1/4) - (M4 * M4 + N4 * N4)^(1/4)).

two_square_sum(W, M, N):-
        U is floor(sqrt(W)), between(0, U, M), N1 is sqrt(W-M^2), 0.0001 >= N1 - floor(N1), N is round(N1).