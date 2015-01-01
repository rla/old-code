:-module(web_performer, [
	show/1
]).


:-use_module(html).

show(Q):-
	show_data(performer, [id, name], name, Q, 'Performers').
