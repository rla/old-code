oe_list_insert(L, Key, Value):-
	(var(L) ->
		L = [Key-Value|_]
		;
		L = [_|Tail],
		oe_list_insert(Tail, Key, Value)
	).