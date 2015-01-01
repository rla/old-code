%% <module> Module for reading wiki files.

:- module wiki_block_io.

:- interface.
:- import_module io, int, char, list.
:- pred read_blocks(list(block)::out, io::di, io::uo) is det.

:- type block ---> block(
	start :: int,
	lines :: list(list(char))
).

:- implementation.
:- import_module int, char, list, bool.

:- pred read_lines(list(list(char))::out, io::di, io::uo) is det.
:- pred find_blocks(list(list(char))::in, list(block)::out) is det.
:- pred find_blocks(list(list(char))::in, int::in, list(list(char))::in, list(block)::out) is det.
:- pred separator(list(char)::in) is semidet.

read_blocks(Bs, !IO):- read_lines(Ls, !IO), find_blocks(Ls, Bs).

read_lines(Ls, !IO):-
	io.read_line(R, !IO),
	(R = ok(L) ->
		Ls = [L|Ls1],
		read_lines(Ls1, !IO)
		;
		Ls = []
	).
	
separator([]).
separator([C|Cs]):-
	char.is_whitespace(C),
	separator(Cs).
	
find_blocks(Ls, Bs):- find_blocks(Ls, 1, [], Bs).

find_blocks([L|Ls], N, Acc, Bs):-
	N1 is N + 1,
	(separator(L) ->
		(Acc = [] ->
			find_blocks(Ls, N1, [], Bs)
			;
			list.reverse(Acc, Acc1),
			Bs = [block(N1,Acc1)|Bs1],
			find_blocks(Ls, N1, [], Bs1)
		)
		;
		find_blocks(Ls, N1, [L|Acc], Bs)
	).
find_blocks([], N, Acc, Bs):-
	(Acc = [] ->
		Bs = []
		;
		Bs = [block(N, Acc)]
	).