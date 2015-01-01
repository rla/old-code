% Misjonäride ja inimsööjate probleem
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 29.10.06

:-module(misjonarid, [
	lahenda/4,
	lahenda/5
]).

:-encoding(utf8).

% Korduvate seisude tõttu tekkivate
% lõpmatute tsüklite vältimiseks.
:-dynamic(proovitud/5).

% Lõppseis - vasakule kaldale on jäänud 0 misjonäri ja inimsööjat ning paat on paremal kaldal.
loppseis(0, 0, _, _, p).

% Lahenduse leidmine, ette antakse
% M - misjonäride arv
% N - inimsööjate arv
% P - paadi mahutavus
% R - sõudjate arv
% lahendi leidumise korral saame käikude loendi Ks.
lahenda(M, N, P, R, Ks):-
	retractall(proovitud(_,_,_,_,_)),
	lahenda(M, N, 0, 0, P, R, Ks, v).

lahenda(M, N, P, R):-
	format('Misjonäride arv: ~a\n', M),
	format('Inimsööjate arv: ~a\n', N),
	format('Paadi mahutavus: ~a\n', P),
	format('Vajalik aerutajate arv: ~a\n', R),
	(lahenda(M, N, P, R, Ks) -> 
		format('Lahend:\n\n'),
		valjasta_lahend(Ks)
		;
		format('Lahendit ei leidu.\n')
	).

% Lahendamise põhiprotseduur
% Saame ette hetke seisu (Lm, Li, Rm, Ri), kus
% Lm - vasakul kaldal olevate misjonäride arv
% Li - vasakul kaldal olevate inimsööjate arv
% Rm - paremal kaldal olevate misjonäride arv
% Ri - paremal kaldal olevate inimsööjate arv
% Algoritm:
% 1. kui seis (Lm, Li, Rm, Ri) on lõppseis, siis lõpeta ja peatu
% 2. genereeri uus seis ja vastav käik (Lm1, Li1, Rm1, Ri1),
% 3. rekursiivselt proovi lahendada uus seis
% 4. uus seis viis lõppseisuni? jah -> lõpeta, ei -> mine tagasi punkti 2 
lahenda(Lm, Li, Rm, Ri, P, R, Ks, Pt):-
	assert(proovitud(Lm, Li, Rm, Ri, Pt)),
	(loppseis(Lm, Li, Rm, Ri, Pt) ->
		Ks = []
		;
		kaik(Lm, Li, Rm, Ri, P, R, Pt, Lm1, Li1, Rm1, Ri1, Pt1, Pm, Pi),
		lahenda(Lm1, Li1, Rm1, Ri1, P, R, Ks1, Pt1),
		Ks = [(Pm, Pi, Pt1, Lm1, Li1, Rm1, Ri1)|Ks1]
	).

% Kaigu genereerimine
kaik(Lm, Li, Rm, Ri, P, R, Pt, Lm1, Li1, Rm1, Ri1, Pt1, Pm, Pi):-
	paadi_suund(Pt, Pt1),
	uus_seis(Lm, Li, Rm, Ri, P, R, Pt1, Lm1, Li1, Rm1, Ri1, Pm, Pi),
	\+ proovitud(Lm1, Li1, Rm1, Ri1, Pt1).

% Uue seisu genereerimine
% Paat liigub vasakule (tagasi)
uus_seis(Lm, Li, Rm, Ri, P, R, v, Lm1, Li1, Rm1, Ri1, Pm, Pi):-
	between(0, Rm, Pm),          % paremalt Pm tükki misjonäre paati (alustame 0-st)
	between(0, Ri, Pi),          % paremalt Pi tükki inimsööjaid paati (alustame 0-st)
	(Pm == 0 -> true; Pm >= Pi), % paadis on misjonäre vähemalt sama palju kui inimsööjaid, kui seal on üldse misjonäre
	Pm + Pi =< P,                % paat kannatab kuni P inimest
	Pm + Pi >= R,                % paat nõuab vähemalt R sõudjat
	Lm1 is Lm + Pm,              % arvutame uue seisu vastavalt paadisõidule
	Li1 is Li + Pi,
	Rm1 is Rm - Pm,
	Ri1 is Ri - Pi,
	(Lm1 == 0 -> true; Lm1 >= Li1),  % vasakul pool on misjonäre vähemalt sama palju kui inimsööjaid, kui seal on üldse misjonäre
	(Rm1 == 0 -> true; Rm1 >= Ri1).  % paremal pool on misjonäre vähemalt sama palju kui inimsööjaid, kui seal on üldse misjonäre

% Paat liigub paremale
uus_seis(Lm, Li, Rm, Ri, P, R, p, Lm1, Li1, Rm1, Ri1, Pm, Pi):-
	between_rev(0, Lm, Pm),      % vasakult Pm tükki misjonäre paati (alustame Lm-st)
	between_rev(0, Li, Pi),      % vasakult Pi tükki misjonäre paati (alustame Pi-st)
	(Pm == 0 -> true; Pm >= Pi),
	Pm + Pi =< P,
	Pm + Pi >= R,
	Lm1 is Lm - Pm,
	Li1 is Li - Pi,
	Rm1 is Rm + Pm,
	Ri1 is Ri + Pi,
	(Lm1 == 0 -> true; Lm1 >= Li1),
	(Rm1 == 0 -> true; Rm1 >= Ri1).

% Tagurpidi genereeriv täisarvude generaator
between_rev(LB, UB, X):- between(LB, UB, X1), X is UB - X1.

% Paadi suuna muutmine
paadi_suund(v, p).
paadi_suund(p, v).

% Lahendi väljastamine
valjasta_lahend(Ks):- valjasta_lahend(Ks, 1).
valjasta_lahend([], _):- format('Lõpp\n').
valjasta_lahend([(Pm, Pi, Pt, Lm, Li, Rm, Ri)|Ks], C):-
	kuhu(Pt, K),
	format('~a. Paati võtame ~a misjonäri ja ~a inimsööjat, paadiga sõidame ~a\n', [C, Pm, Pi, K]),
	format('vasakul: ~a misjonäri ja ~a inimsööjat\n', [Lm, Li]),
	format('paremal: ~a misjonäri ja ~a inimsööjat\n\n', [Rm, Ri]),
	C1 is C + 1,
	valjasta_lahend(Ks, C1).

kuhu(v, 'vasakule').
kuhu(p, 'paremale').