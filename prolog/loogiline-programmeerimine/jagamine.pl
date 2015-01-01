% Algne ülesanne:
%
% ........ (A) : ... (B) = ...... (C)
% ... (V1)
% ----
% .... (J1)
%  ... (V2)
%  ------
%    .... (J2)
%     ... (V3)
%     ----
%     .... (J3)
%     .... (V4)
%     ====
%
%

test(V1, V2, V3, V4, J1, J2, A, B):-
	between(100, 899, B),
	K1_3U is 999 // B,
	K4U is 9999 // B,
	K4L is 1000 // B + 1,
	between(K4L, K4U, K4),
	between(1, K1_3U, K2),
        between(1, K1_3U, K3),
	between(1, K1_3U, K1),
	V1 is K1 * B * 10^5,
	V2 is K2 * B * 10^4,
	V3 is K3 * B * 10,
	V4 is K4 * B,
	A is V1 + V2 + V3 + V4,
	A < 10^8,
	J1 is (A - V1) - A mod 10000,
	J1 >= 10^7,
	J2 is (J1 - V2) + A mod 10000 - A mod 10,
	J2 >= 10^4,
	J3 is (J2 - V3) + A mod 10,
	J3 =:= V4,
	J3 // 10 < B.
