:-module(web_status, [
	show/1
]).


:-use_module(html).

show(_):-
	writeln('status..').
