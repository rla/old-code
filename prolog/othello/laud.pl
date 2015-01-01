% Othello
% Mängulauaga seotud tegevused
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 19.11.06

% Lauda kujutame reavektorite listina.
% Nupu kordinaadid on määratud kui nupu
% geomeetrilised kordinaadid nii, et
% ülemine vasak nurk on (0,0) ja alumine
% parem nurk on (7,7) ning esimese koordinaadi
% moodustab rea valik ning teise koordinaadi
% moodustab reas elemendi valik.

% Nuppudeks on täisarvud -1,0,1, kus
% -1 tähistab musta, 0 tühja ja
% 1 valget ruutu.

:-module(laud, [
	algseis/1,
	korval/4,
	nupp/4,
	tasakaal/2,
	leia_kaidavad/3,
	paiguta/5,
	paiguta_koik/4,
	vastane/2,
	diagonaal_alla/4,
	diagonaal_yles/4,
	rida/4,
	veerg/4,
	laual/2,
	kaugus/5,
	poorab/5,
	nurk/2,
	aar/2
]).

% Antud koordinaat (X, Y) asub ääres.

aar(0, Y):-
	between(0, 7, Y).

aar(X, 0):-
	between(0, 7, X).

% Antud koordinaat (X, Y) asub nurgas.

nurk(0, 0).
nurk(7, 0).
nurk(0, 7).
nurk(7, 7).

% kahe nupu vahelise kauguse leidmine.

kaugus(X, Y, X1, Y1, D):-
	D is abs(X - X1) + abs(Y - Y1).


% Must sooritas oma käigu ja nüüd tuleb mõned
% valged nupud ümber pöörata.

poorab(B, X, Y, N, XYs):-
	poorab_paremal(B, X, Y, N, [], XY1s),
	poorab_vasakul(B, X, Y, N, [], XY2s),
	poorab_yleval(B, X, Y, N, [], XY3s),
	poorab_all(B, X, Y, N, [], XY4s),
	poorab_yleval_paremal(B, X, Y, N, [], XY5s),
	poorab_yleval_vasakul(B, X, Y, N, [], XY6s),
	poorab_all_paremal(B, X, Y, N, [], XY7s),
	poorab_all_vasakul(B, X, Y, N, [], XY8s),
	flatten([XY1s, XY2s, XY3s, XY4s, XY5s, XY6s, XY7s, XY8s], XYs).

poorab_paremal(B, X, Y, N, XYs, XYFs):-
	Y1 is Y + 1,
	(laual(X, Y1) ->
		(nupp(B, X, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X, Y1, N) ->
				XYFs = XYs
				;
				poorab_paremal(B, X, Y1, N, [(X, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_vasakul(B, X, Y, N, XYs, XYFs):-
	Y1 is Y - 1,
	(laual(X, Y1) ->
		(nupp(B, X, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X, Y1, N) ->
				XYFs = XYs
				;
				poorab_vasakul(B, X, Y1, N, [(X, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_yleval(B, X, Y, N, XYs, XYFs):-
	X1 is X - 1,
	(laual(X1, Y) ->
		(nupp(B, X1, Y, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y, N) ->
				XYFs = XYs
				;
				poorab_yleval(B, X1, Y, N, [(X1, Y)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_all(B, X, Y, N, XYs, XYFs):-
	X1 is X + 1,
	(laual(X1, Y) ->
		(nupp(B, X1, Y, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y, N) ->
				XYFs = XYs
				;
				poorab_all(B, X1, Y, N, [(X1, Y)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_yleval_paremal(B, X, Y, N, XYs, XYFs):-
	X1 is X - 1,
	Y1 is Y + 1,
	(laual(X1, Y1) ->
		(nupp(B, X1, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y1, N) ->
				XYFs = XYs
				;
				poorab_yleval_paremal(B, X1, Y1, N, [(X1, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_yleval_vasakul(B, X, Y, N, XYs, XYFs):-
	X1 is X - 1,
	Y1 is Y - 1,
	(laual(X1, Y1) ->
		(nupp(B, X1, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y1, N) ->
				XYFs = XYs
				;
				poorab_yleval_vasakul(B, X1, Y1, N, [(X1, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_all_paremal(B, X, Y, N, XYs, XYFs):-
	X1 is X + 1,
	Y1 is Y + 1,
	(laual(X1, Y1) ->
		(nupp(B, X1, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y1, N) ->
				XYFs = XYs
				;
				poorab_all_paremal(B, X1, Y1, N, [(X1, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).

poorab_all_vasakul(B, X, Y, N, XYs, XYFs):-
	X1 is X + 1,
	Y1 is Y - 1,
	(laual(X1, Y1) ->
		(nupp(B, X1, Y1, 0) ->
			XYFs = []
			;
			(nupp(B, X1, Y1, N) ->
				XYFs = XYs
				;
				poorab_all_vasakul(B, X1, Y1, N, [(X1, Y1)|XYs], XYFs)
			)
		)
		;
		XYFs = []
	).
	
% Antud punkti läbiv veerg.

veerg(_, Y, X1, Y):-
	between(0, 7, X1).

% Antud punkti läbiv rida.

rida(X, _, X, Y1):-
	between(0, 7, Y1).

% Antud punkti läbiv diagonaal, suunaga "üles".

diagonaal_yles(X, Y, X1, Y1):-
	between(-7, 7, N),
	X1 is X - N,
	Y1 is Y + N,
	laual(X1, Y1).

% Antud punkti läbiv diagonaal, suunaga "alla".

diagonaal_alla(X, Y, X1, Y1):-
	between(-7, 7, N),
	X1 is X + N,
	Y1 is Y + N,
	laual(X1, Y1).
	

vastane(1, -1).
vastane(-1, 1).

% Lauale B kohale (X, Y) nupu N paigutamine.

paiguta(B, X, Y, N, B1):-
	paiguta_rida(B, X, Y, N, B1, 0).

paiguta_rida([], _, _, _, [], _).

paiguta_rida([R|Rs], X, Y, N, [R1|R1s], RN):-
	((X =:= RN) ->
		paiguta_veerg(R, Y, N, R1, 0)
		;
		R1 = R
	),
	RN1 is RN + 1,
	paiguta_rida(Rs, X, Y, N, R1s, RN1).

paiguta_veerg([], _, _, [], _).

paiguta_veerg([E|Es], Y, N, [E1|E1s], VN):-
	((Y =:= VN) ->
		E1 = N
		;
		E1 = E
	),
	VN1 is VN + 1,
	paiguta_veerg(Es, Y, N, E1s, VN1).

paiguta_koik(B, [], _, B).

paiguta_koik(B, [(X, Y)|XYs], N, B2):-
	paiguta(B, X, Y, N, B1),
	paiguta_koik(B1, XYs, N, B2).

% Leiame, kas koordinaat (X, Y) asub laual.

laual(X, Y):-
	between(0, 7, X),
	between(0, 7, Y).

% Lauaseisu tasakaalu arvutamine.
% Tasakaaluks
% nimetame summat S üle nuppude väärtuste.
% Ilmselt
%   * kui S = 0, siis valgeid ja musti on laual ühepalju;
%   * kui S > 0, siis valgeid on laual rohkem;
%   * kui S < 0, siis valgeid on laual vähem kui musti.

tasakaal(B, S):-
	findall(N, nupp(B, _, _, N), Ns), % loeme kõik nuppude väärtused listi
	sumlist(Ns, S).                   % leiame summa üle listi elementide

% Leiame laual kohad, kuhu saab N käia.

leia_kaidavad(B, XYs, N):-
	findall((X, Y), leia_kaidav(B, X, Y, N), XYs).

leia_kaidav(B, X, Y, N):-
	laual(X, Y),
	nupp(B, X, Y, 0),
	poorab(B, X, Y, N, XYs),
	length(XYs, L),
	L > 0.  

% Nupu vaatamine laual.

nupp(B, X, Y, N):-
	nth0(X, B, R),
	nth0(Y, R, N).

% Mängulaua algseis.

algseis([
	[0,0,0, 0, 0,0,0,0],
	[0,0,0, 0, 0,0,0,0],
	[0,0,0, 0, 0,0,0,0],
	[0,0,0, 1,-1,0,0,0],
	[0,0,0,-1, 1,0,0,0],
	[0,0,0, 0, 0,0,0,0],
	[0,0,0, 0, 0,0,0,0],
	[0,0,0, 0, 0,0,0,0]
]).

% Ruudu (X, Y) kõrval oleva ruudu (X', Y') leidmine.

korval(X, Y, X1, Y1):-
	X =\= 7,
	Y =\= 7,
	X1 is X + 1,
	Y1 is Y + 1.

korval(X, Y, X1, Y1):-
	X =\= 7,
	Y =\= 0,
	X1 is X + 1,
	Y1 is Y - 1.

korval(X, Y, X1, Y1):-
	X =\= 0,
	Y =\= 7,
	X1 is X - 1,
	Y1 is Y + 1.

korval(X, Y, X1, Y1):-
	X =\= 0,
	Y =\= 0,
	X1 is X - 1,
	Y1 is Y - 1.

korval(X, Y, X, Y1):-
	Y =\= 7,
	Y1 is Y + 1.

korval(X, Y, X, Y1):-
	Y =\= 0,
	Y1 is Y - 1.

korval(X, Y, X1, Y):-
	X =\= 7,
	X1 is X + 1.

korval(X, Y, X1, Y):-
	X =\= 0,
	X1 is X - 1.