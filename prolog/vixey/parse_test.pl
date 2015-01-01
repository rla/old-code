test("X.", variable('X')).
test("Xs.", variable('Xs')).
test("ABC.", variable('ABC')).
test("at.", compound('at',[])).
test("qqq(x,y,z).", compound('qqq',[compound('x',[]),compound('y',[]),compound('z',[])])).
test("[x,y,z].", compound('.',[compound('x',[]),compound('.',[compound('y',[]),compound('.',[compound('z',[]),compound('[]',[])])])])).
test("[p,q,X|Y].",compound('.',[compound('p',[]),compound('.',[compound('q',[]),compound('.',[variable('X'),variable('Y')])])])).
test("'Atomic'' term'.", compound('Atomic'' term',[])).
test("\"string\".",compound('.',[compound(0's,[]),compound('.',[compound(0't,[]),compound('.',[compound(0'r,[]),compound('.',[compound(0'i,[]),compound('.',[compound(0'n,[]),compound('.',[compound(0'g,[]),compound('[]',[])])])])])])])).
test("0'X.", compound(0'X,[])).

run_tests :- test(String, Result), nl, nl, atom_codes(At,String),
 write(At), nl,
 tokenize(Tokens, String, "."),
 write('tokenized..'), nl,
 term(top,AST, Tokens, []),
 write('parsed..'), nl,
 AST = Result, write('Success!!!!'), nl,
 fail.

parse_string(String,Parse) :- tokenize(Tokens,String,"."), term(top,Parse,Tokens,[]).


parse_self :-
 get_file_contents('parse.pl',Contents),
 debug_lex(Tokens, Contents, []),
 parse_loop(Tokens).

parse_loop([]).
parse_loop([Tokens|Tokenss]) :-
 write(Tokens),nl,
 term(top,Term,Tokens,[]),
 write(Term),nl,
 down(Term,DTerm),
 write(DTerm),nl,
 nl,
 !,
 parse_loop(Tokenss).

