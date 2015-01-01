/** <module> T~oestaja p~ohifail.

@author Raivo Laanemets, rlaanemt@ut.ee, 17.11.06
@version 1.0
@license GPL
@filename toestaja2.pl
*/

:-module(toestaja2, [
	toesta2/3
]).

:-use_module('lause').
:-use_module('lause_parse').
:-use_module('lause_tex').
:-use_module('lause_res').

/** toesta2($+Axs$:list, $+Th$:koodide\_list, $+K$:string).

T~oestaja k"aivitamine. List $Axs$ koosneb aksioomidest.
Teoreem antakse ette muutujas $Th$. Kommentaari $K$
kasutatakse t~oestaja protokolli v"aljastamisel.
*/

toesta2(Axs, Th, K):-
	writeln(hehe),
	parsi_laused([Th|Axs], [Thp|Axsp]),
	writeln(haha1),
	alusta_protok,
	valjasta(K),
	writeln(haha),
	valjasta_algandmed([Thp|Axsp]),
	hulk('~'(Thp), Ds),
	valjasta_hulk(Ds, 'Teoreemi eitus hulgana'),
	writeln(haaa),
	teisenda_hulkadeks(Axsp, Dss),
	valjasta_aks_hulgad(Dss, 1),
	lopeta_protok.

valjasta_aks_hulgad([], _).

valjasta_aks_hulgad([H|Hs], C):-
	format(atom(A), 'Aksioom ~a hulgana', C),
	C1 is C + 1,
	valjasta_hulk(H, A),
	valjasta_aks_hulgad(Hs, C1).

teisenda_hulkadeks([], []).

teisenda_hulkadeks([F|Fs], [Ds|Dss]):-
	hulk(F, Ds),
	teisenda_hulkadeks(Fs, Dss).

hulk(F, Ds):-
	eemalda_impl(F, F1),
	teisenda_eitus(F1, F2),
	nimeta_ymber(F2, F3),
	kvantorid_ette(F3, F4),
	skolemiseeri(F4, F5),
	eemalda_kvantorid(F5, F6),
	knk(F6, F7),
	teisenda_hulgaks(F7, Ds1),
	sort(Ds1, Ds).