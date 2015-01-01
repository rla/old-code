:-module(web_playlist, [
	show/1
]).


:-use_module(html).

show(Q):-
	show_data(playlist, [id, name], name, Q, 'Playlists').
