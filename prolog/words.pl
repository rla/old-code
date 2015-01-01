word(W) --> char_seq(W).

words([W]) --> word(W).
words([W]) --> word(W), whitespace.
words([W|Ws]) --> word(W), whitespace, words(Ws).

whitespace --> [' '].
whitespace --> [' '], whitespace.

char_seq([C]) --> char(C).

char_seq([C|Cs]) -->
	char(C), char_seq(Cs).

char(C) -->
	[C], {\+ C = ' '}.