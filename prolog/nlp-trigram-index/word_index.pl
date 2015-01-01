:-module(word_index, [
	index_word/2
]).

% node(node_id, character, subnode_id, word_id)

:-dynamic(node/4).
:-index(node(1,1,0,0)).

:-dynamic(last_word_id/1).
:-dynamic(last_subnode_id/1).

index_word(W, WID):-
	index_word_head(W, WID).

index_word_head([C|Cs], WID):-
	(node(0, C, SID, _) ->
		index_word_tail(Cs, SID, WID)
		;
		new_subnode_id(SID),
		assert(node(0, C, SID, 0)),
		index_word_tail(Cs, SID, WID)
	).

index_word_tail([C,C1|Cs], SID, WID):-
	(node(SID, C, SID1, _) ->
		index_word_tail([C1|Cs], SID1, WID)
		;
		new_subnode_id(SID1),
		assert(node(SID, C, SID1, 0)),
		index_word_tail([C1|Cs], SID1, WID)
	).

index_word_tail([C], SID, WID2):-
	(node(SID, C, SID1, WID)->
		((WID > 0) ->
			WID2 is WID
			;
			retract(node(SID, C, SID1, WID)),
			new_word_id(WID1),
			assert(node(SID, C, SID1, WID1)),
			WID2 is WID1
		)
		;
		new_word_id(WID),
		new_subnode_id(SID1),
		assert(node(SID, C, SID1, WID)),
		WID2 is WID
	).

new_word_id(WID):-
	last_word_id(LWID),
	WID is LWID + 1,
	retract(last_word_id(LWID)),
	assert(last_word_id(WID)).

new_subnode_id(SID):-
	last_subnode_id(LSID),
	SID is LSID + 1,
	retract(last_subnode_id(LSID)),
	assert(last_subnode_id(SID)).

clean:-
	retractall(node(_,_,_,_)),
	retractall(last_word_id(_)),
	retractall(last_subnode_id(_)),
	assert(last_word_id(1)),
	assert(last_subnode_id(1)).