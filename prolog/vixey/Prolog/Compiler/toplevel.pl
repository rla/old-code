% ['parser.pl', 'compile.pl', 'core.pl', 'toplevel.pl'].

ir2pl(variable(Name),     Variable,Store) :- member(Name --> Variable,Store), !.
ir2pl(compound(Name,Args),Compound,Store) :- ir2pls(Args,ArgsPL,Store), Compound =.. [Name|ArgsPL].
ir2pls([],[],_).
ir2pls([I|Is],[P|Ps],Store) :- ir2pl(I,P,Store), ir2pls(Is,Ps,Store).

parse_string(String, Term) :- term(IRTerm, String, _), ir2pl(IRTerm, Term, _).

main :-
  write_atom('?- '), read_line(Line),
  parse_string(Line, Term),
  ( execute_term(Term), !, main
  ; write_atom('no.'), nl, main
  ).
execute_term(Term) :-
  call(Term),
  write_term(Term),
  read_line(More),
  More \= ";",
  !.

% ?- main.
% !- true.
% true %% more? [y/n] y
% no.
% !- true.
% true %% more? [y/n] n
% !- true.
% true %% more? [y/n] n
% !- append(P,Q,[1,2,3,4,5])
% append([], .(1, .(2, .(3, .(4, .(5, []))))), .(1, .(2, .(3, .(4, .(5, [])))))) %% more? [y/n] y
% append(.(1, []), .(2, .(3, .(4, .(5, [])))), .(1, .(2, .(3, .(4, .(5, [])))))) %% more? [y/n] y
% append(.(1, .(2, [])), .(3, .(4, .(5, []))), .(1, .(2, .(3, .(4, .(5, [])))))) %% more? [y/n] y
% append(.(1, .(2, .(3, []))), .(4, .(5, [])), .(1, .(2, .(3, .(4, .(5, [])))))) %% more? [y/n] n
