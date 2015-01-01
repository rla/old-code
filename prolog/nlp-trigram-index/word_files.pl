:-module(word_files, [
	index_file/1
]).

:-use_module(token_words).

% node(node_id, character, subnode_id, filelist_id)

:-dynamic(node/3).
:-index(node(1,1,0,0)).

:-dynamic(subnode_id/1).

index_file(F):-
	file_words(F, Ws),
	index_words(Ws, 1).

index_words([W|Ws], FLID):-
	length(W, L),
	((L > 2) ->
		index_word_top(W, FLID)
		;
		true
	),
	index_words(Ws, FLID).

index_words([], _).

index_word_top([C|Cs], FLID):-
	(node(0, C, S, _) ->
		index_word(Cs, SID, FLID)
		;
		new_subnode_id(SID),
		assert(node(0, C, SID, 0)),
		index_word()
	).

clean:-
	retractall