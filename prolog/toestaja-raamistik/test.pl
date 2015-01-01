/** <module> T~oestaja testija.

@author Raivo Laanemets, rlaanemt@ut.ee, 17.11.06
@version 1.0
@license GPL
@filename test.pl
*/

:-module(test, [
	test/1,
	concatwithn/3
]).

:-use_module('lugeja').
:-use_module('toestaja2').
:-use_module('hlist').

/** test($+F$:string).

Loeb faili $F$ ja k"aivitab selle p~ohjal t~oestaja.
*/

test(F):-
	loe_ridadeks(F, Rs),
	eralda_kommentaarid(Rs, Ks, Fs),
	reverse(Fs, [Th|Ax]),
	reverse(Ks, Ks1),
	fold(Ks1, test:concatwithn, K),
	toesta2(Ax, Th, K).

concatwithn(X, Y, Z):-
	char_code(C, 10),
	concatwith(X, Y, C, Z).

eralda_kommentaarid(Rs, Ks, Fs):-
	eralda_kommentaarid(Rs, [], [], Ks, Fs).

eralda_kommentaarid([], Ks, Fs, Ks, Fs).

eralda_kommentaarid([rida(R)|Rs], Ks1, Fs1, Ks, Fs):-
	eralda_kommentaarid(Rs, Ks1, [R|Fs1], Ks, Fs).

eralda_kommentaarid([kommentaar(K)|Rs], Ks1, Fs1, Ks, Fs):-
	eralda_kommentaarid(Rs, [K|Ks1], Fs1, Ks, Fs).
	