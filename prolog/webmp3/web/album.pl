:-module(web_album, [
	show/1
]).


:-use_module(html).

show(Q):-
	show_data(album, [id, name, performer_id], name, Q, 'Albums').
