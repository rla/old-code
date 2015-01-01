%% these should be built in and mutable
lowercase(C) :- member(C,"_").
lowercase(C) :- member(C,"abcdefghijklmnopqrstuvwxyz").
lowercase(C) :- member(C,"0123456789").
uppercase(C) :- member(C,"ABCDEFGHIJKLMNOPQRSTUVWXYZ").
whitespace(C) :- member(C," \n").

%% core
lowercase(C) --> [C], { lowercase(C) }.
uppercase(C) --> [C], { uppercase(C) }.
anything(C) --> lowercase(C).
anything(C) --> uppercase(C).
%% ws           --> "%", ...
ws           --> [C], { whitespace(C) }, ws.
ws           --> {!}.
ws1 --> [C], { whitespace(C) }.

identifier_string([C|Cs])    --> lowercase(C), rest(Cs).
variable_name_string([C|Cs]) --> uppercase(C), rest(Cs).
rest([C|Cs]) --> anything(C), rest(Cs).
rest([]) --> [].


identifier(C)    --> identifier_string(S),    { atom_codes(C,S) }.
variable_name(C) --> variable_name_string(S), { atom_codes(C,S) }.



ops([(xfx,[('-->',"-->"),((':-'),":-")]),
     (xfy,[(';',";")]),
     (xfy,[('->',"->")]),
     (xfx,[('=>',"=>")]),
     (xfy,[(',',",")]),
     ( fy,[('\\+',"\\+")]),
     (xfx,[('==',"=="),('=',"="), %% NOTE: must go longest first
           ('\\=',"\\="),
           ('<',"<"),('>',">")]),
     (yfx,[('+',"+"),('-',"-")]),
     ( fx,[('-',"-")]),
     ( fy,[('s',"s")]),
     (yfx,[('*',"*")])]).

ops_below_comma([
                 ( fy,[('\\+',"\\+")]),
                 (xfx,[('==',"=="),('=',"="), %% NOTE: must go longest first
                       ('\\=',"\\="),
                       ('<',"<"),('>',">")]),
                 (yfx,[('+',"+"),('-',"-")]),
                 ( fx,[('-',"-")]),
                 ( fy,[('s',"s")]),
                 (yfx,[('*',"*")])]).


% Just plain variables and compound, no infix
plain(variable(Variable)) --> ws, variable_name(Variable).
plain(compound(Name,Args)) --> ws, identifier(Name), ( ws, "(" -> { ops_below_comma(Ops) }, args(Ops, Args), ")" ; { Args = [] } ).
plain(compound('!',[])) --> ws, "!".
plain(compound('[]',[])) --> ws, "[]".
plain(List) --> { ops_below_comma(Ops) }, ws, "[", args(Ops,Args), ws,
  ( "|", term(Ops,Nil), "]", { listify_list(Nil,List,Args) }
  ; "]", { listify_list(List,Args) } ).
args(Ops,[T|Ts]) --> term(Ops,T), ws, ( ",", ws, args(Ops,Ts) -> [] ; { Ts = [] } ).
listify_list(compound('[]',[]), []).
listify_list(compound('.',[A,ListfiedRgs]), [A|Rgs]) :- listify_list(ListfiedRgs, Rgs).
listify_list(Nil, Nil, []).
listify_list(Nil, compound('.',[A,ListfiedRgs]), [A|Rgs]) :- listify_list(Nil, ListfiedRgs, Rgs).


% terms with possible use of infix operators
term([(xfx,Os)|Ops],T) --> term(Ops,L), ( oper(O,Os), term(Ops,R), { T = compound(O,[L,R]) }
                                        ; { T = L } ).
term([(xfy,Os)|Ops],T) --> term(Ops,L), ( oper(O,Os), term([(xfy,Os)|Ops],R), { T = compound(O,[L,R]) }
                                        ; { T = L } ).
term([(yfx,Os)|Ops],T) --> seperated(Os,Ops,Ts), { rollup(Ts,T) }.
term([( fx,Os)|Ops],T) --> ( oper(O,Os), ws1, term(Ops,E),            { T = compound(O,[E]) }
                           ; term(Ops,T) ).
term([( fy,Os)|Ops],T) --> ( oper(O,Os), ws1, term([( fy,Os)|Ops],E), { T = compound(O,[E]) }
                           ; term(Ops,T) ).
term([],T) --> ws, "(", { ops(Ops) }, term(Ops,T), ws, ")".
term([],compound('{}',T)) --> ws, "{", { ops(Ops) }, term(Ops,T), ws, "}".
term([],T) --> plain(T).

term(T) --> { ops(Ops) }, term(Ops,T), ".".

% Helpers
oper(O,Os, StreamI,StreamO) :- ws(StreamI,StreamM), member((O,S),Os), append(S,StreamO,StreamM).
% seperated(Os,Ops,Ts) --> term(Ops,A), ( oper(O,Os) -> seperated(Os,Ops,Tss), { Ts = [A,O|Tss] }
%                                       ; { Ts = [A] } ).
seperated(Os,Ops,Ts) --> term(Ops,A), ( oper(O,Os), seperated(Os,Ops,Tss), { Ts = [A,O|Tss] }
                                      ; { Ts = [A] } ).
rollup([A],A).
rollup([A,O,B|Cs],F) :- rollup([compound(O,[A,B])|Cs],F).


%% not implemented
get_file_contents(Filename, Text) :-
  open(Filename, read, Fd),
  get_contents(Fd, Text),
  close(Fd).
get_contents(Fd,[]) :- at_end_of_stream(Fd), !.
get_contents(Fd,[C|Cs]) :- get_code(Fd,C), get_contents(Fd,Cs).


ir2pl(variable(Name),     Variable,Store) :- member(Name --> Variable,Store), !.
ir2pl(compound(Name,Args),Compound,Store) :- ir2pls(Args,ArgsPL,Store), Compound =.. [Name|ArgsPL].
ir2pls([],[],_).
ir2pls([I|Is],[P|Ps],Store) :- ir2pl(I,P,Store), ir2pls(Is,Ps,Store).

parse_terms(Result) --> ( term(T) -> parse_terms(Ts), { ir2pl(T,Tp,_), Result = [Tp|Ts] }
                        ; { Result = [] } ).

get_file_terms(File,Terms) :- get_file_contents(File,Text), parse_terms(Terms,Text,Rem), ws(Rem,"").
