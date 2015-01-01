% Otsinguprotseduuri realisatsioon keeles Prolog.

% Tühivalemi korral.

op([]).

% Tühiklausli korral.

op(F):- member([], F).

% Ühe literaaliga klausli korral.
% Muutuja esineb literaalina L.

op(F):-
        member([L], F),
        Lc is L,
        ((L > 0) ->
        	lihtsusta(F, L, Lc, Fl) % muutuja X positiivse esinemise korral
        	;
        	lihtsusta(F, Lc, L, Fl) % muutuja X negatiivse esinemise korral
        ), !,
        op(Fl).

% Lihtsusta valemit. L - muutuja esinemine positiivselt, Lc -
% muutuja esinemine negatiivselt.
% Vastab reeglitele (R1p ja R1n) - eemaldab tõese klausli
% valemist.

lihtsusta([C|F], L, Lc, Fl):-
        member(L, C), !,
        lihtsusta(F, L, Lc, Fl).

% Eemaldab väära literaali klauslist (R2p, R2n).

lihtsusta([C|F], L, Lc, [C1|Fl]):-
        eemalda_klauslist(C, Lc, C1),
        lihtsusta(F, L, Lc, Fl).

lihtsusta([], _, _, []).

% Protseduur etteantud klauslist muutuja esinemise
% literaalina L eemaldamiseks (vastab reeglitele R2p ja R2n).

eemalda_klauslist([L|C], L, C1):-
        eemalda_klauslist(C, L, C1).

eemalda_klauslist([L1|C], L, [L1|C1]):-
        eemalda_klauslist(C, L, C1).

eemalda_klauslist([], _, []).

