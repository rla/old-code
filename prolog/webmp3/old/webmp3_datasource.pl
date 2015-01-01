:-module(webmp3_datasource, [
	song/5,
	file/2
]).

:-use_module(library(odbc)).
:-odbc_connect(webmp3, _, [alias(webmp3), open(once)]).

% Song(Id, Name, Length, AlbumId, PerformerId).

song(ID, N, L, AID, PID):-
	odbc_query(webmp3, 'SELECT `id`, `name`, `length`, `album_id`, `performer_id` FROM `song`', row(ID, N, L, AID, PID)).

% File(Id, Name).

file(ID, N):-
	odbc_query(webmp3, 'SELECT `id`, `name` FROM `file`', row(ID, N)).