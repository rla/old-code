% Ligikaudse loendamise algoritm.
%
% W.Wei, B.Selman
% A New Approach to Model Counting (2005)
%

:-module(approxcount, [
	approxcount/2
]).

:-use_module(library('random')).
:-use_module(library('lists')).
:-use_module('valem').
:-use_module('samplesat').

approxcount(F, N):-
	iteratsioon(F, 1, N).

iteratsioon([], N, N):- !.

% 1. Võta 10 lahendit Ss F lahendite hulgast.
% 2. Vali juhuslikult valemist F muutuja L.
% .. vaata kirjeldust artiklist.

iteratsioon(F, Acc, N):-
	vota_samplid(F, 5, Ss),
	writeln((f, F)),
	writeln('Sämplid: '),
	writeln_list(Ss),
	member(K, F),
	member(L, K),
	writeln(('L', L)),
	Lc is -L,
	mitu_tk(Ss, L, C1),
	mitu_tk(Ss, Lc, C2),
	writeln(('C1', C1)),
	writeln(('C2', C2)),
	((C1 > C2) ->
		propageeri(F, L, F1),
		M is 5/C1
		;
		propageeri(F, Lc, F1),
		M is 5/C2
	),
	writeln((m, M)),
	Acc1 is Acc * M,
	iteratsioon(F1, Acc1, N).

writeln_list([]):- nl.

writeln_list([S|Ss]):-
	writeln(S),
	writeln_list(Ss).
	

% K mudeli leidmine valemile F.
% Kasutab SampleSAT algoritmi.

vota_samplid(_, 0, []):- !.

vota_samplid(F, K, [S|Ss]):-
	K > 0,
	samplesat(F, S),
	K1 is K - 1,
	vota_samplid(F, K1, Ss).

% Leiab, mitu korda esineb L
% väärtustuste hulgas.

mitu_tk(Ss, L, C):-
	mitu_tk(Ss, L, 0, C).

mitu_tk([S|Ss], L, Acc, C):-
	(member(L, S) ->
		Acc1 is Acc + 1,
		mitu_tk(Ss, L, Acc1, C)
		;
		mitu_tk(Ss, L, Acc, C)
	).

mitu_tk([], _, C, C).