/*
upload - The Homepage Uploading Tool
Copyright (C) 2006 Raivo Laanemets

Contact: Raivo Laanemets, rlaanemt@ut.ee

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

/** <module> upload.

Homepage uploading tool. Uses wput as backend.

@author Raivo Laanemets, rlaanemt@ut.ee, 31.01.07
@version 1.01
@compatible SWI-Prolog 5.6.24
*/

load_conf:-
	expand_file_name('~', [H]),
	concat(H, '/.upload.pl', C),
	compile(C).

local(L):-
	\+ sub_string(L, 0, 4, _, http),
	\+ sub_string(L, 0, 6, _, mailto),
	\+ sub_string(L, 0, 1, _, '#'),
	\+ sub_string(L, 0, 2, _, '..').

dom2links([], []).

dom2links([element(E, A, S)|Es], [L|Ls]):-
	(E == a; E == link),
	member(href=L, A),
	local(L),
	dom2links(S, Ls1),
	dom2links(Es, Ls2),
	append(Ls1, Ls2, Ls).

dom2links([element(img, A, S)|Es], [L|Ls]):-
	member(src=L, A),
	local(L),
	dom2links(S, Ls1),
	dom2links(Es, Ls2),
	append(Ls1, Ls2, Ls).

dom2links([element(_, _, A)|Es], Ls):-
	dom2links(A, Ls1),
	dom2links(Es, Ls2),
	append(Ls1, Ls2, Ls).

dom2links([E|Es], Ls):-
	atomic(E),
	dom2links(Es, Ls).

process_links([], _, []).

process_links([DL|DLs], FD, [L|Ls]):-
	concat(FD, DL, L1),
	absolute_file_name(L1, L),
	process_links(DLs, FD, Ls).

links(F, Ls):-
	load_xml_file(F, D),
	dom2links(D, DLs),
	file_directory_name(F, FD),
	concat(FD, '/', FD1),
	process_links(DLs, FD1, Ls).

set_append([], Bs, Bs).
set_append(As, [], As).
set_append([A|As], Bs, Cs):- member(A, Bs), set_append(As, Bs, Cs).
set_append([A|As], Bs, Cs):- set_append(As, [A|Bs], Cs).

links_rec(F, Ls):- links_rec([F], [], Ls).

links_rec([], Os, Os).
links_rec([F|Fs], Os, Ls):-
	(member(F, Os) ->
		links_rec(Fs, Os, Ls)
		;
		(file_name_extension(_, html, F) ->
			links(F, Ls1), !,
			set_append(Fs, Ls1, Fs1),
			links_rec(Fs1, [F|Os], Ls)
			;
			links_rec(Fs, [F|Os], Ls)
		)
	).

copy(F, B, D):-
	links_rec(F, Ls),
	process(Ls, B, D, Lps),
	copy_files(Ls, Lps).

process([], _, _, []).
process([L|Ls], B, D, [Lp|Lps]):-
	concat(B, F, L),
	concat(D, F, Lp),
	process(Ls, B, D, Lps).

copy_files([], []).
copy_files([L|Ls], [Lp|Lps]):-
	copy(L, Lp),
	copy_files(Ls, Lps).

copy(S, D):-
	concat('wput -N -nc "', S, C1),
	concat(C1, '" "', C2),
	concat(C2, D, C3),
	concat(C3, '"', C),
	shell(C, _).

names(F):-
	links_rec(F, Ls),
	write_list(Ls).

names:-
	working_directory(WD, WD),
	concat(WD, 'index.html', IDX),
	names(IDX).

top(Argv):-
	(member('-names', Argv) ->
		names
		;
		copy_current
	).

/** top.

Top-level procedure wrapper. Reads command line
arguments and passes then to toplevel.
*/

top:-
	current_prolog_flag(argv, Argv),
	top(Argv).

copy_current:-
	load_conf,
	working_directory(WD, WD),
	remote_root(RR),
	local_root(LR),
	concat(WD, 'index.html', IDX),
	copy(IDX, LR, RR).

write_list([]).
write_list([X|Xs]):- writeln(X), write_list(Xs).