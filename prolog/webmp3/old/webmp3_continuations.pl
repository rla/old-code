:-module(webmp3_continuations, [
	continue_implicit/3,
	continue_explicit/3
]).

:-use_module(library('http/http_session')).

head([X|_], X).

state(Ss, S):-
	http_session_data(state(S)),
	member(S, Ss), !.

state([S|_], S).

next(Ss, S, SN):-
	nth0(N, Ss, S),
	N1 is N + 1,
	nth0(N1, Ss, SN), !.

next([S|_], _, S). 

continue_implicit(M:ME, Ss, Q):-
	state(Ss, S),
	writeln(S),
	(call(M:ME, S, Q) ->
		http_session_retractall(state(_)),
		next(Ss, S, N),
		http_session_assert(state(N))
		;
		true
	).

continue_explicit(M:ME, S, Q):-
	(member(search(R), Q), member(state=N, R) ->
		call(M:ME, N, Q)
		;
		call(M:ME, S, Q)
	).