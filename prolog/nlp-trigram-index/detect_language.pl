% Detect language of given text.
% The text is given as a list of words.

:-module(detect_language, [
	scores/2
]).

language_words(estonian, [
	"ja", "mis", "see",
	"on", "ka", "ei", "ole",
	"et", "ma", "ta", "siia",
	"siis", "pole", "kas", "mina",
	"teie", "nad", "kui", "kunagi",
	"ega", "ehk", "olema", "mille",
	"seda", "olla", "viis", "kes",
	"oli", "kõik"
]).

language_words(english, [
	"the", "is", "about",
	"new", "are", "what",
	"that", "which", "in",
	"a", "if", "you", "and",
	"to", "our", "set", "or",
	"can", "with", "only",
	"at", "all", "my"
]).

scores(Ws, Ss):-
	findall(L, language_words(L, _), Ls),
	score_languages(Ls, Ws, Ss).

score_languages([], _, []).

score_languages([L|Ls], Ws, [S-L|Ss]):-
	score_language(L, Ws, S),
	score_languages(Ls, Ws, Ss).

score_language(L, Ws, S):-
	count_matches(Ws, L, S).

count_matches(Ws, L, S):-
	count_matches(Ws, L, 0, S).

count_matches([], _, S, S).

count_matches([W|Ws], L, S1, S):-
	language_words(L, Ws1),
	(member(W, Ws1) ->
		S2 is S1 + 1,
		count_matches(Ws, L, S2, S)
		;
		count_matches(Ws, L, S1, S)
	).