nthq(0,Ea,[Eb|_]) :- Ea == Eb.
nthq(S,Ea,[_|Es]) :- nthq(Z,Ea,Es), succ(Z,S).


%% Extracting all the variables from a term
variables(Term, Variables) :- variables(Term, Variables, []).
variables(V) --> { var(V),      ! }, [V].
variables(C) --> { C =.. [_|Args] }, list_variables(Args).
list_variables([])     --> {}.
list_variables([T|Ts]) --> variables(T), list_variables(Ts).

%% Low level writing
write_chars([]).
write_chars([C|Cs]) :- write_char(C), write_chars(Cs).
write_atom(Atom) :- atom_codes(Atom,Chars), write_chars(Chars).              %% TODO: escaping
write_term(Term) :- flatten(Term,Flat,[]), write_term_list(Flat,[]).

%% Helpers for write_term/1
flatten(V) --> { var(V),          ! }, [V].
flatten(L) --> { list(L),         ! }, ['['], flatten_list(L), [']'].
flatten(C) --> { C =.. [Name],    ! }, [Name].
flatten(C) --> { C =.. [Name|Args]  }, [Name], ['('], flatten_args(Args), [')'].

flatten_list([])    --> [].
flatten_list([E])   --> { ! }, flatten(E).
flatten_list([P|Q]) --> { list(Q) , ! }, flatten(P), [','], flatten_list(Q).
flatten_list([P|Q]) --> flatten(P), ['|'], flatten(Q).

flatten_args([])       --> { }.
flatten_args([T])      --> {!}, flatten(T).
flatten_args([T,S|Ts]) --> { }, flatten(T), [', '], flatten_args([S|Ts]).

write_term_list([],    _).
write_term_list([V|Ts],S) :- var(V), nthq(N,V,S), !, write_atom('V'), write_atom(N), write_term_list(Ts,S).
write_term_list([V|Ts],S) :- var(V), !, append(S,[V],SV), write_term_list([V|Ts],SV).
write_term_list([A|Ts],S) :- atomic(A), write_atom(A), write_term_list(Ts,S).

nl :- write_atom('\n').
