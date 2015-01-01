:-module(webmp3_server, [
	web_query/3,
	start_server/0
]).

:-use_module(library('http/thread_httpd')).
:-use_module(library('http/http_session')).
:-use_module(library('http/html_write')).

:-use_module(webmp3_list).

web_module_files(Ms):-
	working_directory(WD, WD),
	concat(WD, 'web_*.pl', P),
	expand_file_name(P, Ms).

load_web_modules:-
	web_module_files(Ms),
	applyl(Ms, use_module).

:-load_web_modules.

start_server:-
	http_set_session_options([timeout(0)]),
	http_server(dispatch, [port(8000), workers(10)]),
	current_thread(X, _), concat('httpd@', _, X), thread_join(X, _).

dispatch(Q):-
	write('Content-type: text/html\n\n'),
	member(path(P), Q),
	split('/', P, [M, ME]),
	web_query(M, ME, Q).

web_module(M, N):-
	current_module(M),
	concat('web_', N, M).

methods(M, Ms):-
	export_list(M, Ms1),
	map(Ms1, functorname, Ms).

web_query(N, ME, Q):-
	(web_module(M, N), methods(M, Ms), member(ME, Ms) ->
		call(M:ME, Q)
		;
		web_error('Cannot dispatch!')
	).

web_error(M):-
	html(html([
		head([title(M)]),
		body([h1([M])])
	]), HTML, []), print_html(HTML).