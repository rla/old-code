:- module wiki_parser.

:- interface.
:- import_module io, int, char, list.

% Wiki types

:- type wiki_line  ---> wiki_line(
	line_number :: int,
	content     :: list(char)
).
:- type wiki_block ---> wiki_block(
	lines :: list(wiki_line)
).

:- type wiki_block_type --->
	heading(int) ;
	paragraph ;
	item_list ;
	num_list ;
	hor_line.

:- pred main(io::di, io::uo) is det.

% Implementation of wiki parser-

:- implementation.
:- import_module int, char, list, bool.




:- pred detect_block_type(wiki_block::in, wiki_block_type::out) is det.
:- pred write_block_types(list(wiki_block)::in, io::di, io::uo) is det.
:- pred first_line(wiki_block::in, list(char)::out) is semidet.
:- pred prefix_ignore_whitespace(list(char)::in, list(char)::in) is semidet.
:- pred list_prefix(list(T)::in, list(T)::in) is semidet.
:- pred all_have_prefix_ignore_whitespace(list(list(char))::in, list(char)::in) is semidet.
:- pred extract_lines(list(wiki_line)::in, list(list(char))::out) is det.
:- pred is_item_list(wiki_block::in) is semidet.
:- pred is_heading(wiki_block::in, int::out) is semidet.
:- pred is_hor_line(wiki_block::in) is semidet.

% Block type detection.

is_item_list(B):- first_line(B, L), list_prefix(['*',' '], L).
is_heading(B, Le):-
	first_line(B, L),
	(
		if list_prefix(['=','=','=','='], L) then Le = 4
		else if list_prefix(['=','=','='], L) then Le = 3
		else if list_prefix(['=','='], L) then Le = 2
		else if list_prefix(['='], L) then Le = 1
		else fail
	).
is_hor_line(B):- first_line(B, L), list_prefix(['-','-','-','-'], L).

% Helping predicates for char list processing.

extract_lines([wiki_line(_, L)|In], [L|Ls]):-
	extract_lines(In, Ls).
extract_lines([], []).

first_line(wiki_block([wiki_line(_, Cs)|_]), Cs).

all_have_prefix_ignore_whitespace([L|Ls], P):-
	prefix_ignore_whitespace(L, P),
	all_have_prefix_ignore_whitespace(Ls, P).
all_have_prefix_ignore_whitespace([], _).

prefix_ignore_whitespace([C|Cs], P):-
	(char.is_whitespace(C) ->
		prefix_ignore_whitespace(Cs, P)
		;
		list_prefix(P, Cs)
	).

list_prefix([X|P], [X|Xs]):- list_prefix(P, Xs).
list_prefix([], _).

detect_block_type(B, T):-
	(
		if is_item_list(B) then T = item_list
		else if is_heading(B, L) then T = heading(L)
		else if is_hor_line(B) then T = hor_line
		else T = paragraph
	).

read_lines(Ls, !IO):-
	io.read_line(R, !IO),
	(R = ok(L) ->
		Ls = [L|Ls1],
		read_lines(Ls1, !IO)
		;
		Ls = []
	).


write_block_types(Bs, !IO):-
	(Bs = [B|Bs1] ->
		detect_block_type(B, T),
		io.write(T, !IO),
		io.nl(!IO),
		write_block_types(Bs1, !IO)
		;
		true
	).

main(!IO):-
	read_lines(Ls, !IO),
	find_blocks(Ls, Bs),
	write_block_types(Bs, !IO).