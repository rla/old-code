% Posti vastavuse probleem
% Loogiline programmeerimine
% Raivo Laanemets, rlaanemt@ut.ee, 14.10.06

% Ümbertöötatud paaride hoidmine globaalsel tasemel,
% ei pea argumentidena kaasas vedama.

:-dynamic(paar/3).

% Lahendi leidmine: tühjendame eelmise arvutuse
% jäägid ning salvestame uuesti paaride hulga,
% seejärel leiame lahendi.

pvp(Ps, Ist, S):-
	retractall(paar(_, _, _)),
	salvesta(Ps, 1),
	piire(M),
	kombineeri([], [], 0, Is, M), !,
	taasta(Is, S, Ist).

% Paaride ('110', '101') salvestamine predikaadi
% paar/3 abil. Sõned '110' teeme listiks [1,1,0].

salvesta([], _).
salvesta([(A, B)|Ps], I):-
	atom_chars(A, Acs),
	atom_chars(B, Bcs),
	assert(paar(Acs, Bcs, I)),
	I1 is I+1,
	salvesta(Ps, I1).

% Lahenduse ühe sammu leidmine.
% Ja - eelmise sammu vasakpoolse osa jääk,
% Jb - eelmise sammu parempoolse osa jääk,
% C - sammude loendur,
% Is - lahendusse võetud indeksite list.
% Igal sammul Ja = [] või Jb = [].
% Lahendini oleme jõudnud, kui Ja = [] ja Jb = [] ning C > 0.
% Et vältida Ja või Jb piiramatut kasvamist, on sisse toodud piire M märki.
% Kiiruse nimel jäetakse meelde ainult indeksite list.

kombineeri(Ja, Jb, C, [I|Is], M):-
	((lahend(Ja, Jb), C > 0) ->
		Is = []
		;
		paar(A, B, I),
		append(Ja, A, Au),
		append(Jb, B, Bu),
		ok(Au, Bu, Auj, Buj),
		length(Auj, N1),
		length(Buj, N2),
		N1 =< M, N2 =< M,
		C1 is C+1,
		kombineeri(Auj, Buj, C1, Is, M)
	).

% Piirde arvutus ülemise algoritmi jaoks.
% Piirdeks võtame maksimaalse pikkuse järjest
% kasvatatud vasakute või paremate elementide jadadest.
% (Ei ole täpne valem, mõne ülesande korral tuleb seda suurendada)

piire(M):- piire([], [], M1, 1), M is M1 + 10. 
piire(As, Bs, M, C):-
	(paar(A, B, C) ->
		append(As, A, As1),
		append(Bs, B, Bs1),
		C1 is C+1,
		piire(As1, Bs1, M, C1)
		;
		length(As, N1),
		length(Bs, N2),
		max(N1, N2, M)
	).

% Maksimumi võtmine kahest elemendist.

max(X, Y, X):- X > Y, !.
max(_, Y, Y). 

% Kontrollimine, kas üks listidest on
% teise prefiks ja ülejääva osa ära lõikamine.

ok([], Bs, [], Bs).
ok(As, [], As, []).
ok([A|As], [A|Bs], Ay, By):- ok(As, Bs, Ay, By).

lahend([], []).

% Lahendi taastamine indeksite
% järgi.

taasta(Is, S, Ist):- taasta(Is, '', S, Ist).
taasta([_], S, S, []).
taasta([I|Is], TF, S, [I|Ist]):-
	paar(Acs, _, I),
	atom_chars(A, Acs),
	concat(TF, A, TF1),
	taasta(Is, TF1, S, Ist).

% Mõne lahenduva juhu läbi vaatamine.

test:-
	pvp([('1','101'),('10','00'),('011','11')],X0, Y0), writeln(X0), writeln(Y0),
	pvp([('1', '111'), ('10111', '10'), ('10', '0')], X1, Y1), writeln(X1), writeln(Y1),
	pvp([('001','0'),('01','011'),('01','101'),('10','001')], X3, Y3), writeln(X3), writeln(Y3).