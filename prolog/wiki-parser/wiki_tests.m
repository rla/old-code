%% <module> Module for testing other modules of wiki parser.

:- module wiki_tests.

:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int, char, list, bool, wiki_block_io, wiki_ast.

main(!IO):- read_blocks(Bs, !IO).