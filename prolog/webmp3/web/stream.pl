:-module(web_stream, [
	new/1,
	show/1
]).

:-use_module(html).
:-use_module(continuations).
:-use_module(templates).
:-use_module(data).

new(Q):-
	continue_explicit(web_stream:new, show_form, Q).

new(show_form, _):-
	output(new_stream, []).

new(save, Q):-
	get_parameter(Q, name, N),
	get_parameter(Q, url, U),
	save_tuple(stream, [name, url], [N, U]),
	output(notice, [
		module='Streams',
		notice='New stream saved!'
	]).

show(Q):-
	show_data(stream, [id, name, url], name, Q, 'Streams').

