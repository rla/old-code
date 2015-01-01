:-module(trigram, [
	save_word/1,
	save_file/1,
	succest/2
]).

:-use_module(token_words).

:-dynamic(word/2).
:-index(word(1,0)).

:-dynamic(word_id/2).
:-index(word_id(1,0)).

:-dynamic(trigram/4).
:-index(trigram(1,1,1,0)).

:-dynamic(trigram_id/1).
:-index(trigram_id(1)).

:-dynamic(trigram_word_id/2).
:-index(trigram_word_id(1,0)).

% ID's

:-dynamic(last_word_id/1).
:-dynamic(last_trigram_id/1).

save_file(F):-
	file_words(F, Ws),
	findall(A, (member(W, Ws), atom_codes(A, W)), As),
	save_words(As).

save_words([]).

save_words([A|As]):-
	save_word(A),
	save_words(As).

% Sisendi teisendamine kolmikuteks.
% Minimaalne sisendsõna pikkus on 3.

trigrams([_, _], []).

trigrams([_], []).

trigrams([], []).

trigrams([X,Y,Z], []):-
	member(42, [X,Y,Z]).

trigrams([X,Y,Z], [[X,Y,Z]]).

trigrams([42,Y,Z|I], Ts):- !,
	trigrams([Y,Z|I], Ts).

trigrams([_,42,Z|I], Ts):- !,
	trigrams([Z|I], Ts).

trigrams([_,_,42|I], Ts):- !,
	trigrams(I, Ts).

trigrams([X,Y,Z|I], [[X,Y,Z]|Ts]):-
	trigrams([Y,Z|I], Ts).

% Aatomina antud sõna salvestamine
% trigram-dena.

save_word(W):-
	writeln(W),
	(word(W, _) ->
		true
		;
		atom_codes(W, Cs),
		trigrams(Cs, Ts),
		choose_new_word_id(WId),
		assert(word(W, WId)),
		assert(word_id(WId, W)),
		save_trigrams(Ts, WId)
	).

% Sõnale identifikaatori valimine.

choose_new_word_id(WId):-
	last_word_id(LWId),
	retractall(last_word_id(_)),
	WId is LWId + 1,
	assert(last_word_id(WId)).

% Mingi sõna kolmikute salvestamine.

save_trigrams([], _).

save_trigrams([[X,Y,Z]|Ts], WId):-
	(trigram(X,Y,Z,TId) ->
		assert(trigram_word_id(TId, WId))
		;
		choose_new_trigram_id(TId),
		assert(trigram_id(TId)),
		assert(trigram(X,Y,Z,TId)),
		assert(trigram_word_id(TId, WId))
	),
	save_trigrams(Ts, WId).

% Kolmikule identifikaatori valimine.

choose_new_trigram_id(TId):-
	last_trigram_id(LTId),
	retractall(last_trigram_id(_)),
	TId is LTId + 1,
	assert(last_trigram_id(TId)).

clean:-
	retractall(word(_, _)),
	retractall(word_id(_, _)),
	retractall(trigram(_, _, _, _)),
	retractall(trigram_id(_)),
	retractall(trigram_word_id(_, _)),
	retractall(last_word_id(_)),
	retractall(last_trigram_id(_)),
	assert(last_word_id(0)),
	assert(last_trigram_id(0)).

% Ühe trigrammi sõna saamine.

trigram_word(X, Y, Z, W):-
	trigram(X, Y, Z, TId), !,
	trigram_word_id(TId, WId),
	word_id(WId, W).

% Succest possible words against current query.

succest(Q, Ws):-
	atom_codes(Q, Cs),
	trigrams(Cs, QTs),
	find_trigrams_words(QTs, Wss),
	intersection(Wss, Ws), !.

% For every trigram, find set of words.

find_trigrams_words([], []).

find_trigrams_words([[X,Y,Z]|Ts], [Ws|Wss]):-
	findall(W, trigram_word(X, Y, Z, W), Ws),
	find_trigrams_words(Ts, Wss).

% Find intersection of list of lists.

intersection([], []).

intersection([L], L).

intersection([L1,L2|Ls], L):-
	intersection1([L2|Ls], L1, L).

intersection1([], L, L).

intersection1([L1|Ls], L2, L):-
	intersection(L1, L2, L3),
	intersection1(Ls, L3, L).