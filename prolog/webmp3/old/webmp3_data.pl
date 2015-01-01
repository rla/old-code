:-module(webmp3_data, [
	song/5,
	file/2,
	pager/5
]).

:-use_module(library(odbc)).
:-use_module(webmp3_list).

:-odbc_connect(webmp3, _, [alias(webmp3), open(once)]).

% Song(Id, Name, Length, AlbumId, PerformerId).

song(ID, N, L, AID, PID):-
	odbc_query(webmp3, 'SELECT `id`, `name`, `length`, `album_id`, `performer_id` FROM `song`', row(ID, N, L, AID, PID)).

% File(Id, Name).

file(ID, N):-
	odbc_query(webmp3, 'SELECT `id`, `name` FROM `file`', row(ID, N)).

pager(N, L, D, S, E):-
	length(Vs, L),
	T =.. [N|Vs],
	findall(T, call(T), Ts),
	map(Ts, functorargs, D1),
	sublist(D1, S, E, D).

% time((pager(file, 2, Ts, 4000, 4002), seq(Ts, [table], HTML), html(div([HTML]), X, _), print_html(X))).