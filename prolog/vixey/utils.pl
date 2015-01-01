get_file_contents(Filename, Text) :-
  open(Filename, read, Fd),
  get_contents(Fd, Text),
  close(Fd).
get_contents(Fd,[]) :- at_end_of_stream(Fd), !.
get_contents(Fd,[C|Cs]) :- get_code(Fd,C), get_contents(Fd,Cs).

down(variable(V),V).
down(compound(X,Args),D) :- maplist(down,Args,Dargs), D =.. [X|Dargs].


