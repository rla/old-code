%% <module> Module for types of abstract syntax tree.

:- module wiki_ast.

:- interface.
:- import_module io.
:- import_module int, char, list, bool.

:- type decorator ---> emphasis ; bold ; striked ; underlined.

:- type 
:- type text_node ---> list(char).