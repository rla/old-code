% Lause algab kvantoriga. R1 on ülejäänud lause osa,
% kust on kvantor koos tema mõjupiirkonnas oleva alamlausega
% välja võetud.

lause(R, C):-
	kvantor(R, C, R1, C1),
	lause(R1, C1).

lause(R, C):-
	suluavaldis(R, C, R1, C1),
	lause(R1, C1).

lause(R, C):-
	predikaat(R, C, R1, C1),
	lause(R1, C1).

lause(_, C):-
	syntaksiviga(C).

kvantor(['V'|R], C, R1, C2):-
	C1 is C + 1,
	muutuja(R, C1, R1, C2),
	lause()



syntaksiviga(C):-
	format('Süntaksiviga kohal ~a!\n', C).