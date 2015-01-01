:- op(1025,xfx,=>).

write_char(C) :- put_code(C).

read_line(L) :- current_input(S), read_line_to_codes(S,L).

This => That :- \+ (call(This), \+ call(That)).
