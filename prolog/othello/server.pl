% Othello
% Veebipõhise suhtlusega seotud tegevused
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 19.11.06

:-module(server, [
	start_server/0
]).

:-encoding(utf8).

:-use_module(library('http/thread_httpd')).
:-use_module(library('http/http_session')).
:-use_module(library('http/http_error.pl')).
:-use_module(laud).
:-use_module(html).
:-use_module(othello).

% Serveri käivitus.

start_server:-
	http_server(serve, [port(4000), workers(10)]).
	%current_thread(X, _), concat('httpd@', _, X), thread_join(X, _).

% Päringule vastamine.

serve(Q):-
	write('Content-Type: text/html\n\n'),
	write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"'),
	write('"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'),
	write('<html><head><title>Lahend</title>'),
	write('<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />'),
	write('</head><body>'),
	%write('<h1>Soorita käik</h1>'),
	writeln(Q),
	(algus(Q) ->
		alusta_mangu(Q)
		;
		jatka_mangu(Q)
	),
	write('</body></html>').

% Mängu jätkamine (algus on ära tehtud).

jatka_mangu(Q):-
	vars(Q, X, Y),                   % loeme päringu muutujad
	writeln((X, Y)),
	http_session_data(laud(B))     % võtame eelmise laua seisu
	/*http_session_data(inimene(N)),
	http_session_retractall(laud(B)),
	writeln(B)*/
/*
	write('<h2>Eelmine seis</h2>'),
	valjasta(B, []),
	vastane(N, V),                  % leiame vastase
	(jai_vahele(X) ->                % kui inimene jäi eelmisel käigul vahele
		arvuti_kaik(B, V)        % siis soorita arvuti käik
		;
		inimese_kaik(B, N, X, Y) % vastasel juhul jätka inimese käigu täitmist
	)*/.

% Inimene jäi vahele, päringust
% saadud X < 0.

jai_vahele(X):-
	X < 0.

% Inimese poolt käigu sooritamine
% B - laua seis
% N - inimese nuppude värv

inimese_kaik(B, N, X, Y):-
	paiguta(B, X, Y, N, B1),              % sooritame inimese käigu
	write('<h2>Pärast inimese käiku</h2>'),
	valjasta(B1, []),
	poorab(B1, X, Y, N, XYPs),            % pöörame vastase nupud ringi
	paiguta_koik(B1, XYPs, N, B2),
	write('<h2>Pärast arvuti nuppude ümber pööramist</h2>'),
	valjasta(B2, []),
	vastane(N, V),                        % leia vastane
	arvuti_kaik(B2, V).                   % soorita arvuti käik


% Arvuti poolt käigu sooritamine.
% B - laua seis
% N - arvuti nuppude värv

arvuti_kaik(B, N):-
	leia_kaidavad(B, XYk, N),
	length(XYk, L1),
	vastane(N, V),                             % leiame vastase
	((L1 > 0) ->
		kaik(B, N, X, Y),                  % leiame arvuti poolt sooritatava käigu
		paiguta(B, X, Y, N, B1),           % paigutame käigu tulemuse lauale
		write('<h2>Pärast arvuti käigu sooritamist</h2>'),
		valjasta(B1, []),
		poorab(B1, X, Y, N, XYPs),         % pöörame ringi inimese nupud
		paiguta_koik(B1, XYPs, N, B2),
		write('<h2>Pärast sinu nuppude ümber keeramist</h2>'),
		valjasta(B2, []),
		leia_kaidavad(B2, XYs, V),         % leiame inimese poolt käidavad nupud
		length(XYs, L2),
		((L2 > 0) ->
			valjasta(B2, XYs)          % väljastame laua koos inimese poolt käidavate käikudega
			;
			write('<h2>Sina ei saa käiku teha, jääd vahele</h2>'),
			write('<h2>Vajuta edasi</h2>'),
			write('<a href="http://localhost:4000?x=-1&y=-1">Edasi</a>')
		),
		http_session_assert(laud(B2))      % salvestame laua seisu sessiooni
		;
		write('<h2>Jään vahele</h2>'),
		leia_kaidavad(B, XY1s, V),         % leiame inimese poolt käidavad nupud
		length(XY1s, L3),
		((L3 > 0) ->
			valjasta(B, XY1s)
			;
			tasakaal(B, S),            % ka inimese jaoks ei leidunud käiku
			((S > 0) ->
				((N =:= 1) ->
					write('<h2 style="color: red">Mina võitsin</h2>')
					;
					write('<h2 style="color: red">Sina võitsid</h2>')
				)
				;
				((N =:= 1) ->
					write('<h2 style="color: red">Sina võitsid</h2>')
					;
					write('<h2 style="color: red">Mina võitsin</h2>')
				)
			)
		),
		http_session_assert(laud(B))       % salvestame laua seisu sessiooni   
	).	

% Algusprotseduur.

alusta_mangu(Q):-
	http_session_retractall(laud(_)),           % tühjendame eelmise mängu seisu
	http_session_retractall(inimene(_)),
	algseis(B),                                 % leiame algseisu
	(alustaja(Q, inimene) ->
		leia_kaidavad(B, XYs, -1),          % leiame inimese poolt käidavad ruudud
		valjasta(B, XYs),                   % väljastame laua koos käidavate ruutudega
		http_session_assert(laud(B)),
		http_session_assert(inimene(-1))
		;          
                arvuti_kaik(B, -1),
		http_session_assert(inimene(1))
	).	

% Alustaja leidmine.

alustaja(Q, inimene):-
	member(search(Ps), Q),
	member(alustaja=inimene, Ps).

alustaja(_, arvuti).

% Kas tegemist algusega?

algus(Q):-
	member(search(Ps), Q),
	member(algus='1', Ps).

% Päringust muutujate välja lugemine

vars(Q, X, Y):-
	member(search(Ps), Q),
	member(x=X1, Ps),
	member(y=Y1, Ps),
	to_int(X1, X),
	to_int(Y1, Y).

to_int(X, I):-
	\+ empty(X),
	term_to_atom(I, X),
	integer(I).

empty('').