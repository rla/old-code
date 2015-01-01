%% Parser for (roughly) Prolog syntax.

% Variables                  X Xs ABC
% Compounds                  at, qqq(x,y,z)
% Lists                      [x,y,z] [p,q,X|Y]
% Single quotes              'Atomic'' term'
% Double quotes              "string"
% Characters                 0'X
% Pre/Post/Infix operators   1+1 is 2
% Comments                   /* /* laaa */ */ %% lalala
% Brackets                   (1 + 2) * 3
% Cut                        !

uppercase(0'A).
uppercase(0'B).
uppercase(0'C).
uppercase(0'D).
uppercase(0'E).
uppercase(0'F).
uppercase(0'G).
uppercase(0'H).
uppercase(0'I).
uppercase(0'J).
uppercase(0'K).
uppercase(0'L).
uppercase(0'M).
uppercase(0'N).
uppercase(0'O).
uppercase(0'P).
uppercase(0'Q).
uppercase(0'R).
uppercase(0'S).
uppercase(0'T).
uppercase(0'U).
uppercase(0'V).
uppercase(0'W).
uppercase(0'X).
uppercase(0'Y).
uppercase(0'Z).

lowercase(0'a).
lowercase(0'b).
lowercase(0'c).
lowercase(0'd).
lowercase(0'e).
lowercase(0'f).
lowercase(0'g).
lowercase(0'h).
lowercase(0'i).
lowercase(0'j).
lowercase(0'k).
lowercase(0'l).
lowercase(0'm).
lowercase(0'n).
lowercase(0'o).
lowercase(0'p).
lowercase(0'q).
lowercase(0'r).
lowercase(0's).
lowercase(0't).
lowercase(0'u).
lowercase(0'v).
lowercase(0'w).
lowercase(0'x).
lowercase(0'y).
lowercase(0'z).

alphabetic(C) :- uppercase(C).
alphabetic(C) :- lowercase(C).

digit(0'0).
digit(0'1).
digit(0'2).
digit(0'3).
digit(0'4).
digit(0'5).
digit(0'6).
digit(0'7).
digit(0'8).
digit(0'9).

%%

lex([Tok|Toks]) --> tokenize(Tok), [0'.], lex(Toks).
lex([]) --> ws.

debug_lex([Tok|Toks]) --> tokenize(Tok), {write('%% '), write(Tok), nl}, [0'.], debug_lex(Toks).
debug_lex([]) --> ws.

tokenize([T|Ts]) --> ws, token(T), !, tokenize(Ts). %% should this cut be here? (token is not deterministic)
tokenize([]) --> ws.                                %% can you support -o and o- by removing it?

ws --> [0' ],  !, ws.
ws --> [0'\n], !, ws.
ws --> [0'\t], !, ws.
ws --> [0'%],  !, skip_past(0'\n),          ws.
ws --> "/*",   !, finish_multiline_comment, ws.
ws --> [].

skip_past(Character) --> [Character], !.
skip_past(Character) --> [_], skip_past(Character).

finish_multiline_comment --> "*/", !.
finish_multiline_comment --> "/*", !, finish_multiline_comment, finish_multiline_comment.
finish_multiline_comment --> [_],  finish_multiline_comment.

token('(') --> [0'(].
token(')') --> [0')].
token('[') --> [0'[].
token(']') --> [0']].
token('{') --> [0'{].
token('}') --> [0'}].
token(',') --> [0',].
token('|') --> [0'|].
token('!') --> [0'!].
token(opr(Textual)) --> {operator(Textual)}, Textual.
token(var([N|Ame])) --> [N], {uppercase(N); N = 0'_}, finish_symbol(Ame), !.
token(idt([N|Ame])) --> [N], {lowercase(N)},          finish_symbol(Ame), !.
token(idt(Name))    --> [0''], finish_single_quoted(Name),   !.
token(str(String))  --> [0'"], finish_double_quoted(String), !.
token(chr(Char))    --> "0'", ( [0'\\] -> ( [0'n]  -> {Char = 0'\n}
                                          ; [0't]  -> {Char = 0'\t}
                                          ; [0'\\] -> {Char = 0'\\} )
                              ; [Char] ).
token(num([N|Umber])) --> [N], {digit(N)}, finish_number(Umber), !.

finish_symbol([C|Cs]) --> [C], {alphabetic(C); C = 0'_}, finish_symbol(Cs).
finish_symbol([])     --> [].

finish_number([D|Ds]) --> [D], {digit(D)},               finish_number(Ds).
finish_number([])     --> [].

finish_single_quoted([0''|Cs]) --> "''",            finish_single_quoted(Cs).
finish_single_quoted([C|Cs])   --> [C], {C \= 0''}, finish_single_quoted(Cs).
finish_single_quoted([])       --> "'".

finish_double_quoted([0'\\|Ss]) --> "\\\\",          finish_double_quoted(Ss).
finish_double_quoted([0'"|Ss])  --> "\\\"",          finish_double_quoted(Ss).
finish_double_quoted([S|Ss])    --> [S], {S \= 0'"}, finish_double_quoted(Ss).
finish_double_quoted([])        --> "\"".

%%

optable(
 [(1200,xfx,"-->"),(1200,xfx,":-"),
  (1200,fx,":-"),
  (1100,xfy,";"),
  (1050,xfy,"->"),
  (1000,xfy,","),
  (700,xfx,"="),(700,xfx,"\\="),(700,xfx,"=<"),(700,xfx,">="),
  (500,yfx,"-"),
  (400,yfx,"/")]).
optable(Level,Table) :-
 optable(OpTable), findall((L,F,O),(member((L,F,O),OpTable),L=<Level),Table).

assert_operator(Op) :- assertz(operator(Op)).
define_operator :-
 retractall(operator(_)),
 optable(Table),findall(Op,member((_,_,Op),Table),Ops),
 sort(length,Ops,SortedOps),!,
 maplist(assert_operator,SortedOps).

:- dynamic(operator/1).
:- define_operator.

%%

term(top,Term)         --> !, term(1200,Term).
term(below_comma,Term) --> !, term(1000,Term).
term(Level,Term)       --> glom(Vine), {optable(Level,Table), tangle(Vine, Table, Term)}.


glom([])                 --> [].
glom([operator(",")|Ts]) --> [','], glom(Ts).
glom([operator(O)|Ts])   --> [opr(O)], glom(Ts).
glom([term(T)|Ts])       --> one_term(T), !, glom(Ts).
glom([term(T)|Ts])       --> ['('], term(top,T), [')'], glom(Ts).


tangle([term(T)],_,T).
tangle(List,[(_,xfx,O)|Os],compound(Oa,[X,Y])):-
	split(List,operator(O),LHS-RHS),
 	tangle(LHS,Os,X),
	tangle(RHS,Os,Y),
	atom_codes(Oa,O).
tangle(List,[(L,xfy,O)|Os],compound(Oa,[X,Y])):-
	split(List,operator(O),LHS-RHS),
 	tangle(LHS,Os,X),
	tangle(RHS,[(L,xfy,O)|Os],Y),
	atom_codes(Oa,O).
tangle(List,[(L,yfx,O)|Os],compound(Oa,[X,Y])):-
	split(List,operator(O),LHS-RHS),
 	tangle(LHS,[(L,yfx,O)|Os],X),
	tangle(RHS,Os,Y),
	atom_codes(Oa,O).
tangle([operator(O)|Tail],[(_,fx,O)|Os],compound(Oa,[T])):-
	tangle(Tail,Os,T),
	atom_codes(Oa,O).
tangle(List,[_|Os],T):-
	List \= [term(_)],
	tangle(List,Os,T).


one_term(variable(AtName)) --> [var(Name)], {atom_codes(AtName,Name)}, !.
one_term(compound(AtName,Args)) --> [idt(Name)], ['('], tuple_body(Args), [')'], {atom_codes(AtName,Name)}.
one_term(compound(AtName,[]))   --> [idt(Name)], {atom_codes(AtName,Name)}.
one_term(compound(',', [])) --> [','].
one_term(compound('|', [])) --> ['|'].
one_term(compound('!', [])) --> ['!'].
one_term(compound('[]',[])) --> ['['],[']'].
one_term(compound(Char,[])) --> [chr(Char)].
one_term(compound(Numb,[])) --> [num(Name)], {atom_codes(Numb,Name)}. %% maybe this will change?
one_term(compound('{}',[Body])) --> ['{'],term(top,Body),['}'].
one_term(ListAST)   --> ['['], list_body(List), [']'], {list_ast(List,ListAST)}, !.
one_term(StringAST) --> [str(String)], {string_ast(String,StringAST)}, !.


tuple_body([T|Ts]) --> term(below_comma,T), ( [','], tuple_body(Ts)
                                            ; {Ts = []} ).

list_body(Res) --> term(below_comma,T), ( [','], list_body(Ts), {Res = [T|Ts]}
                                        ; ['|'], term(below_comma,S), {Res = [T|S]}
                                        ; {Res = [T]} ).

list_ast([],     compound('[]',[])).
list_ast([X|Xs], compound('.',[X,Ys])) :- list_ast(Xs,Ys).
list_ast([X|Y],  compound('.',[X,Y])).

string_ast([],     compound('[]',[])).
string_ast([X|Xs], compound('.',[compound(X,[]),Ys])) :- string_ast(Xs,Ys).

