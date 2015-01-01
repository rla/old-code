% Loendamisprotseduuri realisatsioon keeles Prolog
%
% Kasutatud Prolog implementatsioon: SWI-Prolog, versioon 5.6.34
% Siin kujutame muutujaid aatomitena a,b,c,...
% Klauslit kujutame litraalide listina, valemit kujutame
% klauslite listina.
%
% Näide kasutamisest:
% ?- lp([[a,b,-c], [-a,-b], [c,-b]], 3, C).
% C = 4
% Yes

% Failis op.pl on defineeritud lihtsusta/4 ja
% komplementaar/2 ning vali_muutuja/2

:-ensure_loaded(op).

% Tühivalemi korral on meil kehtestatav valem.
% N muutujat on vaja veel värtustada. Neile saab
% väärtusi anda 2^N erineval viisil.

lp([], N, C):- C is 2^N.

% Valemil, mis sisaldab tühiklauslit, on 0 lahendit.

lp(F, _, 0):- member([], F).

% Kui valemis esineb mingi muutuja ühikliteraalina,
% siis kasuta väärtustusreeglit selle muutuja järgi.
% Vastab reeglitele R4p ja R4n.

lp(F, N, C):-
	member([L], F),
	komplementaar(L, Lc),
	lihtsusta(F, L, Lc, F1), !,
	N1 is N - 1,
	lp(F1, N1, C).

% Kui eelmised juhud polnud rakendatavad, peame kasutama
% üldist väärtustusreeglit.

lp(F, N, C):-
	vali_muutuja(F, L),
	komplementaar(L, Lc),
	lihtsusta(F, L, Lc, F1),
	lihtsusta(F, Lc, L, F2), !,
	N1 is N - 1,
	lp(F1, N1, C1),
	lp(F2, N1, C2),
	C is C1 + C2.