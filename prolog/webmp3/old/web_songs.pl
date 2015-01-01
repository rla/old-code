:-module(web_songs, [
	show/1
]).

:-use_module(webmp3_templates).
:-use_module(webmp3_data).
:-use_module(webmp3_list).
:-use_module(library('http/html_write')).

show(_):-
	pager(file, 2, Ts, 0, 70), seq(Ts, [table], D),
	output(data, [title='Songs', data=D]).