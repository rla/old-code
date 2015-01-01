:-module(web_song, [
	show/1
]).


:-use_module(html).

show(Q):-
	show_data(song, [id, name, performer_id, album_id], name, Q, 'Songs').
