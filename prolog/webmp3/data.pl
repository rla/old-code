:-module(data, [
	sharp_quote/2,
	single_quote/2,
	save_tuple/3,
	tuples_with_limit/6,
	tuples_table/6,
	tuples_with_limit/7,
	tuples_table/7
]).

:-use_module(library(odbc)).
:-use_module(hlist).
:-use_module(domain).

:-odbc_connect(webmp3, _, [alias(webmp3), open(once)]).

save_tuple(E, Fs, Vs):-
	map(Fs, sharp_quote, Fqs),
	fold(Fqs, concatwithcommaspace, F),
	map(Vs, single_quote, Vqs),
	fold(Vqs, concatwithcommaspace, V),
	concatl(['INSERT INTO `', E, '` (', F, ') VALUES (', V, ')'], Q),
	odbc_query(webmp3, Q, _).
	
/** tuples_with_limit(+Entity, +Fields:list, +Order, +Start, +Count, -Tuples:list)
*/
tuples_with_limit(E, Fs, O, S, C, Ts):-
	map(Fs, sharp_quote, Fqs),
	fold(Fqs, concatwithcommaspace, F),
	concatl(['SELECT ', F, ' FROM `', E, '` ORDER BY `', O, '` LIMIT ', S, ', ', C], Q),
	length(Fs, N),
	length(L, N),
	T =.. [row|L],
	findall(T, odbc_query(webmp3, Q, T), Ts1),
	map(Ts1, functorargs, Ts).

/** tuples_with_limit(+Entity, +Fields:list, +Order, +Start, +Count, -Tuples:list, +Where)
*/
tuples_with_limit(E, Fs, O, S, C, Ts, W):-
	map(Fs, sharp_quote, Fqs),
	fold(Fqs, concatwithcommaspace, F),
	concatl(['SELECT ', F, ' FROM `', E, '` WHERE ', W, ' ORDER BY `', O, '` LIMIT ', S, ', ', C], Q),
	length(Fs, N),
	length(L, N),
	T =.. [row|L],
	findall(T, odbc_query(webmp3, Q, T), Ts1),
	map(Ts1, functorargs, Ts).

tuples_table(E, Fs, O, S, C, H):-
	tuples_with_limit(E, Fs, O, S, C, Ts),
	table(Ts, H).

tuples_table(E, Fs, O, S, C, H, W):-
	tuples_with_limit(E, Fs, O, S, C, Ts, W),
	table(Ts, H).