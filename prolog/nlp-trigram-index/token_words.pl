:-module(token_words, [
	words/2,
	file_words/2
]).

:-index(separator(1)).

separator(10).
separator(32).
separator(44).
separator(13).
separator(33).
separator(34).
separator(35).
separator(36).
separator(37).
separator(38).
separator(39).
separator(40).
separator(41).
separator(42).
separator(43).
separator(44).
separator(45).
separator(46).
separator(47).
separator(58).
separator(59).
separator(60).
separator(61).
separator(62).
separator(63).
separator(64).
separator(91).
separator(92).
separator(93).
separator(94).
separator(95).
separator(96).
separator(123).
separator(124).
separator(125).
separator(126).
separator(127).

file_words(F, Ws):-
	read_file_to_codes(F, Cs, []),
	words(Cs, Ws).

words(Cs, Ws):-
	words(Cs, [], [], Ws).

words([], Cs1, Ws1, Ws):-
	length(Cs1, L),
	((L > 2) ->
		Ws = [Cs1|Ws1]
		;
		Ws = Ws1
	).

words([C|Cs], Cs1, Ws1, Ws):-
	(separator(C) ->
		length(Cs1, L),
		((L > 2) ->
			reverse(Cs1, Cs2),
			words(Cs, [], [Cs2|Ws1], Ws)
			;
			words(Cs, [], Ws1, Ws)
		)
		;
		words(Cs, [C|Cs1], Ws1, Ws)
	).