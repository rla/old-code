:-module(webmp3_templates, [
	use/3,
	template/2,
	load_template/1,
	output/2
]).

:-use_module(library('sgml')).
:-use_module(library('http/html_write')).

:-use_module(webmp3_list).

:-dynamic(template/2).

output(T, S):-
	use(T, S, R),
	html(R, X, []),
	print_html(X).

template_files(Fs):-
	working_directory(WD, WD),
	concat(WD, 'template_*.html', P),
	expand_file_name(P, Fs).

load_templates:-
	retractall(template(_, _)),
	template_files(Fs),
	applyl(Fs, webmp3_templates:load_template).

load_template(T):-
	working_directory(WD, WD),
	concat(WD, 'template_', P),
	concat(A, '.html', T),
	concat(P, N, A),
	load_xml_file(T, R),
	assert(template(N, R)).

:-load_templates.
	
% Use(+Template, +Substitutions, -HTML_tree)

use(T, S, HTML):-
	template(T, R),
	transform(R, S, HTML).

transform([], _, []).

transform([element(E, As, T)|Es], S, [element(E, As, T1)|E1s]):-
	transform(T, S, T1),
	transform(Es, S, E1s).

transform([E|Es], S, [N|E1s]):-
	member(E=N, S),
	transform(Es, S, E1s).

transform([E|Es], S, [E|E1s]):-
	transform(Es, S, E1s).