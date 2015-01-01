% Split codes to words.
% Each word is a list of codes.

:-module(words, [
	words/2,
	file_words/2
]).

:-encoding(utf8).

separators([
	10, 32, 44, 13, 33,
	34, 35, 36, 37, 38,
	39, 40, 41, 42, 43,
	44, 45, 46, 47, 58,
	59, 60, 61, 62, 63,
	64, 91, 92, 93, 94,
	95, 96, 123, 124, 125,
	126, 127
]).

file_words(F, Ws):-
	read_file_to_codes(F, Cs, []),
	words(Cs, Ws).

strip_leading_separators([C|Cs], Cs1):-
	separators(S),
	(member(C, S) ->
		!, strip_leading_separators(Cs, Cs1)
		;
		Cs1 = [C|Cs]
	).

words(Cs, Ws):-
	strip_leading_separators(Cs, Cs1), !,
	phrase(words(Ws), Cs1, []), !.

word(W) --> char_seq(W).

words([W|Ws]) --> word(W), separators, words(Ws).
words([W]) --> word(W), separators.
words([W]) --> word(W).

separators --> separator, separators.
separators --> !, separator.

separator --> [C], {separators(S), member(C, S)}, !.

char_seq([C|Cs]) -->
	char(C), char_seq(Cs), !.

char_seq([C]) --> !, char(C).

char(C) -->
	[C], {separators(S), \+ member(C, S)}, !.