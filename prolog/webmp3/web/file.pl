:-module(web_file, [
	show/1,
	show_lossless/1
]).


:-use_module(html).

show(Q):-
	show_data(file, [id, name, type], name, Q, 'Files').

show_lossless(Q):-
	show_data(file, show_lossless, [id, name], '`type`=''fla'' or `type`=''dts''', name, Q, 'Lossless files').
