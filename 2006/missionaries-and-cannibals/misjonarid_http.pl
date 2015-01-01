% Misjonäride ja inimsööjate probleem
% Tehisintellekt I
% Veebipõhine kasutajaliides
% Raivo Laanemets, rlaanemt@ut.ee, 29.10.06

:-encoding(utf8).

:-use_module(library('http/thread_httpd')).
:-use_module(misjonarid).

% Serveri käivitus (user-lõimes)
start_server:-
	http_server(serve, [port(8888), workers(10)]),
	current_thread(X, _), concat('httpd@', _, X), thread_join(X, _).

% Vastamine päringule,
% saadame http ja html päised. body osas
% väljastame lahenduse
serve(Q):-
	format('Content-Type: text/html\n\n'),
	format('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'),
	format('<html><head><title>Lahend</title><meta http-equiv="Content-Type" content="text/html;charset=utf-8" /></head><body><pre>'),
	(vars(Q, M, N, P, R), ok(M, N, P, R) ->
		lahenda(M, N, P, R)
		;
		format('Parameetrid peavad olema vahemikus 0..50 (R ja P vahemikus 1..50)\n')
	),
	format('</pre></body></html>').

% Päringust muutujate välja lugemine
vars(Q, M, N, P, R):-
	member(search(Ps), Q),
	member(m=M1, Ps),
	member(n=N1, Ps),
	member(p=P1, Ps),
	member(r=R1, Ps),
	to_int(M1, M),
	to_int(N1, N),
	to_int(P1, P),
	to_int(R1, R).

to_int(X, I):-
	\+ empty(X),
	term_to_atom(I, X),
	integer(I).

empty('').

% Muutujatele seatud kitsendused
ok(M, N, P, R):-
	in(0, 50, M),
	in(0, 50, N),
	in(1, 50, P),
	in(1, 50, R).

in(A, B, X):- X >= A, X =< B.