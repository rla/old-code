%% ?- [swi,paste,writing,parser,compile], compile_files(['core.pl','writing.pl','parser.pl','toplevel.pl']).
%% TODO newlines inside sexp symbols
%% TODO handle _ somehow

t([compound(true,[])]).
t([compound(flip,[compound(heads,[])]),
   compound(flip,[compound(tails,[])])]).
t([compound(append,[compound(nil,[]),variable('Y'),variable('Y')]),
   compound(':-',[compound(append,[compound(cons,[variable('X'),variable('XS')]),variable('Y'),compound(cons,[variable('X'),variable('ZS')])])
                 ,compound(append,[variable('XS'),variable('Y'),variable('ZS')])])]).
t([compound(ttt,[compound(this,[])]),
   compound(ttt,[compound(that,[])]),
   compound(ttt,[compound(other,[])])]).

%% Languages:
%%
%%   PL ~ Prolog terms
%%
%%   IR ~ Intermediate representation, ir has no variables, everything is ground
%%          <ir> ::= compound(<name>,[<ir> ...]) | variable(<name>)
%%
%%  IRS ~ A list of IR terms, all should have the same clause_functor
%%          an IRS term denotes an entire prolog relation
%%
%%  SCM ~ Schemeish syntax, represented as Prolog lists
%%          [define,[square,x],[*,x,x]]
%%
%% SEXP ~ A single atom representing an s-expression
%%         '(define (square x) (* x x))'
%%

namevars(Term,Ii,Io) :- variables(Term, Vars), namevars_in_list(Vars,Ii,Io).
namevars_in_list([],    E,E).
namevars_in_list([A|Vs],I,O) :- nonvar(A), namevars_in_list(Vs,I,O).
namevars_in_list([V|Vs],I,O) :- var(V), concat_atom(['V',I],V), succ(I,M), namevars_in_list(Vs,M,O).

clause_functor(H :- _, Name, Arity) :- !, functor(H, Name, Arity).
clause_functor(H, Name, Arity) :- functor(H, Name, Arity).

pl2ir(PL,IR) :- copy_term(PL,PLCopy), pl2ir_aux(PLCopy, IR), namevars(IR,0,_).
pl2ir_aux(Variable, variable(Variable)) :- var(Variable).
pl2ir_aux(Compound, compound(Name,Args)) :-
  nonvar(Compound), Compound =.. [Name|PLArgs], maplist(pl2ir_aux,PLArgs,Args).

ir2scm(variable(Name), Name). %% maybe nobody should call this, maybe they should go directly to sexp instead?
ir2scm(compound(Name,Args), [Name|SCMArgs]) :- maplist(ir2scm,Args,SCMArgs).

ir_clause(compound(':-',[H,B]),H,B) :- !.
ir_clause(H,H,compound(true,[])).

ir_clause_functor(Clause,Name,Arity) :- ir_clause(Clause,compound(Name,Args),_), length(Args,Arity).

irs2scm([IR|IRs],SCM) :- IRS = [IR|IRs],
  SCM = [define-relation,[[Name/Arity,Name,raw(Arity),raw(NumClauses)],term,query,stack,height,choice,cut-index],Body],
  ir_clause_functor(IR,Name,Arity),
  length(IRS,NumClauses),
  irs2scm_clauses((Name/Arity,NumClauses),IRS,Clauses,(UsedTermThawer)),
  ( UsedTermThawer == yes ->
    Body = [let,[[thaw,[term-thawer]]],InnerBody]
  ; Body = InnerBody ),
  ( Clauses = [[_,Choice]] ->
    InnerBody = Choice
  ; InnerBody = [clauses,choice|Clauses] ).

irs2scm_clauses(_,[],[],_).
irs2scm_clauses((Name/Arity,NumClauses),[IR|IRs],[Clause|Clauses],(UsedTermThawer)) :-
  ( ir_clause_functor(IR,_,0) ->
    Clause = [[raw(Choice),clause-Choice],Then],
    HasBindings = no
  ; Clause = [[raw(Choice),clause-Choice],
              [<-,bindings,[unify,[list,term],[list,[thaw,''''#SCMHead]]],Then,Else]],
    HasBindings = yes,
    UsedTermThawer = yes ),
  length([IR|IRs],Choice),
  ir_clause(IR,IRHead,IRBody),
  ir2scm(IRHead,SCMHead),
  ir2scm(IRBody,SCMBody),
  ( IRBody = compound(true,[]) ->
    Query1 = query,
    Query2 = query
  ; %% TODO: compile away conjunctions, do all possible lookups at compile time
    %%        that means passing around a db with known clauses
    %%       ! should also take the stack height into account
    UsedTermThawer = yes,
    Query1 = [cons,[term->conjunct,[thaw,''''#SCMBody],height],query],
    Query2 = [cons,[term->conjunct,[thaw,''''#SCMBody],[-,height,raw(1)]],query] ),
  ThenStart = [continue,Query1,
               [cons,
                [make-choicepoint,
                 [cons,
                  [make-conjunct,term,Name/Arity,raw(Choice),[+,raw(1),height]],query],
                 Bindings],stack],
               [+,raw(1),height]],
  ( HasBindings = yes ->
    Bindings = bindings,
    ThenEnd = [begin,
               [stack-add-bindings#'!',stack,bindings],
               [continue,Query1,stack,height]],
    ThenEnd2 = [begin,
                [stack-add-bindings#'!',stack,bindings],
                [continue,Query2,stack,height]]
  ; Bindings = ''''#[],
    ThenEnd = [continue,Query1,stack,height],
    ThenEnd2 = [continue,Query2,stack,height] ),
  ( Choice = 1 ->
    Then = ThenEnd
  ; NumClauses = Choice ->
    Then = ThenStart
  ; Then = [if,[=,choice,raw(NumClauses)],ThenStart,ThenEnd2] ),
  ( Choice = 1 ->
    Else = [failure,stack,height]
  ; Else = [clause-NextChoice], succ(NextChoice,Choice) ),
  %% & recursion
  irs2scm_clauses((Name/Arity,NumClauses),IRs,Clauses,(UsedTermThawer)).


scm2sexp(SCM, Sexp) :- scm2sexp(y, SCM, Sexp).

scm2sexp(_,raw(R),R) :- !.
scm2sexp(_,List, Sexp) :- List = [_|_], maplist(scm2sexp,List,SexpList), !, concat_atom(SexpList,' ',Body), concat_atom(['(',Body,')'],Sexp).
scm2sexp(y,Atom, Sexp) :- atomic(Atom), !, sexp_escape(Atom,Sexp).
scm2sexp(n,Atom, Sexp) :- atomic(Atom), !, Atom = Sexp.
scm2sexp(_,''''#L, Sexp) :- !, scm2sexp(y,L, SL), concat_atom(['''',SL],Sexp).
scm2sexp(E,P#Q, Sexp) :- !, paste(P,Ps), paste(Q,Qs), atom_concat(Ps,Qs,SexpU), scm2sexp(E,SexpU, Sexp).
scm2sexp(E,Fxy, Sexp) :- Fxy=..[F,X,Y], scm2sexp(n,X,Xs), scm2sexp(n,Y,Ys), concat_atom([Xs,F,Ys],SexpU), scm2sexp(E,SexpU, Sexp).

%%sexp_escape(X,X) :- number(X), !.
scm_readable(A) :-
  Special = [' ','(',')','|',',','[',']','{','}','''','"',';','\\','`',' '],
  A \= '.',
  A \= '#',
  atom_chars(A,C),
  C = [H|T],
  (\+ member(H, ['.','-','+','0','1','2','3','4','5','6','7','8','9'])),
  (\+ member(H, Special)),
  (\+ (member(Ch, T), member(Ch,Special))).
sexp_escape(X,Y) :- ( scm_readable(X) -> Y = X ; Xs = X, escape_atom(Xs,XsEsc), concat_atom(['|',XsEsc,'|'],Y) ).
escape_atom(A,Aesc) :-
  atom_chars(A,Aaaa),
  maplist(escape_char,Aaaa,Aescaa),
  concat_atom(Aescaa,Aesc).

escape_char('|','\\|') :- !.
escape_char('\\','\\\\') :- !.
escape_char('\n','\\\n') :- !.
escape_char(X,X).


% % Not implemented
%  get_file_terms(Filename, Terms) :-
%    open(Filename, read, Fd),
%    read_all_terms(Fd, Terms),
%    close(Fd).

%  %% Not implemented
%  read_all_terms(Fd, List) :-
%    read(Fd, Term),
%    ( Term = end_of_file, List = [], !
%    ; List = [Term|Rest], read_all_terms(Fd, Rest)
%    ).

group_terms(Clauses, Relations) :- reverse(Clauses,RClauses),group_terms(RClauses, [], RRelations), reverse(RRelations,Relations).
group_terms([], Relations, Relations).
group_terms([T|Ts], I, Relations) :- add_term(T, I, M), group_terms(Ts, M, Relations).

add_term(T, [], [[T]]).
add_term(T, [TG|Ts], [[T|TG]|Ts]) :- clause_functor(T, Name, Arity), [TGe|_] = TG, clause_functor(TGe, Name, Arity), !.
add_term(T, [YT|Ts], [YT|TTs]) :- add_term(T, Ts, TTs).

mapmaplist(_,[],[]).
mapmaplist(P,[I|Is],[O|Os]) :- maplist(P,I,O), mapmaplist(P,Is,Os).

write_nl(X,ok) :- write(X), nl, nl.

compile_file -->
%  { write(state-0),nl },
  get_file_terms,
%  { write(state-1),nl },
  maplist(expand_term), %% HOW 2 DO THIS!?!?!
%  { write(state-2),nl },
  group_terms,
%  { write(state-3),nl },
  mapmaplist(pl2ir),
%  { write(state-4),nl },
  maplist(irs2scm),
%  { write(state-5),nl },
  maplist(scm2sexp),
%  { write(state-6),nl },
  maplist(write_nl).

compile_files([]) :- !.
compile_files([F|Fs]) :- compile_file(F,_), compile_files(Fs).
