% Posti vastavuse probleem
% Loogiline programmeerimine
% Raivo Laanemets, rlaanemt@ut.ee, 09.10.06

% Indeksite generaator

indeks(M, I):- between(1, M, I).

indekslist(0, _, []):- !.
indekslist(P, M, [I|Is]):- indeks(M, I), P1 is P-1, indekslist(P1, M, Is).

indeksid(M, Is):- between(1, 100, P), indekslist(P, M, Is).

% Lahendusalgoritm:
% genereeri indeksid ja vaata, kas need sobivad.

pvp(In, I, S):-
	length(In, M),
	indeksid(M, I),
	vali(I, In, S).

% Etteantud indeksite listi jaoks saadava konkatenatsiooni
% kontroll.

vali(I, In, S):- vali(I, In, '', '', S).

vali([], _, TF, TF, TF).
vali([I|Is], In, TFA, TFB, S):-
	nth1(I, In, (A, B)),
	concat(TFA, A, TA),
	concat(TFB, B, TB),
	vali(Is, In, TA, TB, S).

test:-
	pvp([('1','101'),('10','00'),('011','11')],X0, Y0), writeln(X0), writeln(Y0).