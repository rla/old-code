/** <module> Lausetega tehtavad teisendused.

@author Raivo Laanemets, rlaanemt@ut.ee, 17.11.06
@version 1.0
@license GPL
@filename lause.pl
*/

:-module(lause, [
	skolemiseeri/2,
	eemalda_impl/2,
	teisenda_eitus/2,
	nimeta_ymber/2,
	kvantorid_ette/2,
	eemalda_kvantorid/2,
	knk/2,
	teisenda_hulgaks/2,
	predarvutuse_valem/1
]).

/** predarvutuse\_valem($+V$:valem).

Kontrollib, kas valem $V$ on predikaatarvutuse valem.
Sisuliselt kontrollitakse kvantorite olemasolu.
*/

predarvutuse_valem('V'(_, _)).

predarvutuse_valem('E'(_, _)).

predarvutuse_valem('&'(F, _)):-
	predarvutuse_valem(F).

predarvutuse_valem('&'(_, F)):-
	predarvutuse_valem(F).

predarvutuse_valem('v'(F, _)):-
	predarvutuse_valem(F).

predarvutuse_valem('v'(_, F)):-
	predarvutuse_valem(F).

predarvutuse_valem('~'(F)):-
	predarvutuse_valem(F).

/** teisenda\_hulgaks($+V$:valem, $-S$:list).

Teisendab valemi disjunktide listiks $S$.
Disjunktid ise teisendatakse ka listideks.
*/

teisenda_hulgaks('&'(F, G), S):-
	teisenda_hulgaks1(F, F1),
	teisenda_hulgaks1(G, G1),
	append(F1, G1, S).

teisenda_hulgaks('v'(F, G), S):-
	teisenda_hulgaks1('v'(F, G), S).

teisenda_hulgaks(T, S):-
	teisenda_hulgaks1(T, S).

teisenda_hulgaks1('&'(F, G), S):-
	teisenda_hulgaks('&'(F, G), S).

teisenda_hulgaks1(T, [[T]]):-
	literaal(T).

teisenda_hulgaks1('v'(F, G), [S]):-
	teisenda_hulgaks2(F, F1),
	teisenda_hulgaks2(G, G1),
	append(F1, G1, S).

teisenda_hulgaks2('v'(F, G), S):-
	teisenda_hulgaks2(F, F1),
	teisenda_hulgaks2(G, G1),
	append(F1, G1, S).

teisenda_hulgaks2(T, [T]):-
	literaal(T).
/*
teisenda_hulgaks('&'('&'(F, G), '&'(H, W)), S):-
	teisenda_hulgaks('&'(F, G), S1),
	teisenda_hulgaks('&'(H, W), S2),
	append(S1, S2, S).

teisenda_hulgaks('&'('v'(F, G), '&'(H, W)), [S1|S]):-
	teisenda_hulgaks('v'(F, G), S1),
	teisenda_hulgaks('&'(H, W), S).

teisenda_hulgaks('&'('&'(F, G), 'v'(H, W)), [S1|S]):-
	teisenda_hulgaks('&'(F, G), S),
	teisenda_hulgaks('v'(H, W), S1).

teisenda_hulgaks('&'('v'(F, G), 'v'(H, W)), [S1,S2]):-
	teisenda_hulgaks('v'(F, G), S1),
	teisenda_hulgaks('v'(H, W), S2).

teisenda_hulgaks('&'('&'(F, G), T), [[T]|S]):-
	literaal(T),
	teisenda_hulgaks('&'(F, G), [S]).

teisenda_hulgaks('&'(T, '&'(F, G)), [[T]|S]):-
	literaal(T),
	teisenda_hulgaks('&'(F, G), [S]).

teisenda_hulgaks('&'('v'(F, G), T), [[T]|S]):-
	literaal(T),
	teisenda_hulgaks('v'(F, G), S).

teisenda_hulgaks('&'(T, 'v'(F, G)), [[T],S]):-
	literaal(T),
	teisenda_hulgaks('v'(F, G), S).

teisenda_hulgaks('&'(T1, T2), [[T1],[T2]]):-
	literaal(T1),
	literaal(T2).

teisenda_hulgaks('v'('v'(F, G), 'v'(H, W)), S):-
	teisenda_hulgaks('v'(F, G), S1),
	teisenda_hulgaks('v'(H, W), S2),
	append(S1, S2, S).

teisenda_hulgaks('v'('v'(F, G), T), [[T|S]]):-
	literaal(T),
	teisenda_hulgaks('v'(F, G), [S]).

teisenda_hulgaks('v'(T, 'v'(F, G)), [[T|S]]):-
	literaal(T),
	teisenda_hulgaks('v'(F, G), [S]).

teisenda_hulgaks('v'(T1, T2), [[T1,T2]]):-
	literaal(T1),
	literaal(T2).

teisenda_hulgaks(L, [[L]]):-
	literaal(L).*/

literaal(X):-
	term(X).

literaal('~'(X)):-
	term(X).

term('t'(_)).

term('t'(_, _)).

/** knk($+V_1$:valem, $-V_2$:valem).

Valemi $V_1$ viimine konjuktiivsele normaalkujule.
Saadud valem on muutujas $V_2$.
*/

distr('v'(F, '&'(G, H)), W):- !,
	knk('&'('v'(F, G), 'v'(F, H)), W).

distr('v'('&'(G, H), F), W):- !,
	knk('&'('v'(G, F), 'v'(H, F)), W).

knk('v'(F, G), H):-
	knk(F, F1),
	knk(G, G1),
	distr('v'(F1, G1), H), !.

knk('v'(F, G), 'v'(F1, G1)):-
	knk(F, F1),
	knk(G, G1).

knk('&'(F, G), '&'(F1, G1)):-
	knk(F, F1),
	knk(G, G1).

knk('~'(P), '~'(P)).

knk('t'(F, A), 't'(F, A)).

knk('t'(F), 't'(F)).

/** eemalda\_kvantorid($+V_1$:valem, $-V_2$:valem).

Valemist $V_1$ kvantorite eemaldamine. Resultaat
on muutujas $V_2$. Protseduur eeldab, et valem
$V_1$ on prefikskujul.
*/

eemalda_kvantorid('V'(_, F), F1):-
	eemalda_kvantorid(F, F1).

eemalda_kvantorid('E'(_, F), F1):-
	eemalda_kvantorid(F, F1).

eemalda_kvantorid('v'(F, G), 'v'(F, G)).

eemalda_kvantorid('&'(F, G), '&'(F, G)).

eemalda_kvantorid('~'(F), '~'(F)).

eemalda_kvantorid('t'(F, A), 't'(F, A)).

eemalda_kvantorid('t'(F), 't'(F)).

/** funktsionaalid($+V$:valem, $-Fs$:list).

Funktsionaalide leidmine valemist $V$.
Leitud funktsionaalid asuvad listis $Fs$.
Funktsionaalideks loetakse k~oik termid,
sealhulgas predikaats"umbolid.
*/

funktsionaalid('V'(_, F), Fs):-
	funktsionaalid(F, Fs).

funktsionaalid('E'(_, F), Fs):-
	funktsionaalid(F, Fs).

funktsionaalid('&'(F, G), Fs):-
	funktsionaalid(F, Fs1),
	funktsionaalid(G, Gs1),
	append(Fs1, Gs1, Fs).

funktsionaalid('v'(F, G), Fs):-
	funktsionaalid(F, Fs1),
	funktsionaalid(G, Gs1),
	append(Fs1, Gs1, Fs).

funktsionaalid('~'(F), Fs):-
	funktsionaalid(F, Fs).

funktsionaalid('t'(F/_, As), [F|Fs]):-
	funktsionaalid(As, Fs).

funktsionaalid('t'(F/_), [F]).

funktsionaalid(['t'(F/_, As)|Ts], [F|Fs]):-
	funktsionaalid(As, Fs1),
	funktsionaalid(Ts, Fs2),
	append(Fs1, Fs2, Fs).

funktsionaalid(['t'(F/_)|Ts], [F|Fs]):-
	funktsionaalid(Ts, Fs).

funktsionaalid([A|Ts], Fs):-
	muutuja(A),
	funktsionaalid(Ts, Fs).

funktsionaalid([], []).

/** skolemiseeri($+V_1$:valem, $-V_2$:valem).

Valemi $V_1$ skolemiseerimine. Resultaadiks
saadakse valem $V_2$. Eeldab, et valem $V_1$
on prefikskujul.
*/

skolemiseeri(F, F1):-
	funktsionaalid(F, Fs),
	skolemiseeri(F, [], [], Fs, F1).

% Ms - seni leitud üldsuskvantoriga seotud muutujad.

skolemiseeri('V'(X, F), Ns, Ms, Fs, 'V'(X, F1)):-
	skolemiseeri(F, [X|Ns], Ms, Fs, F1).

skolemiseeri('E'(X, F), Ns, Ms, Fs, F1):-
	length(Ns, N),
	(N =:= 0 ->
		konstant(Ff),
		\+ member(Ff, Fs),
		skolemiseeri(F, Ns, [X='t'(Ff/0)|Ms], [Ff|Fs], F1)
		;
		funktsionaal(Ff),
		\+ member(Ff, Fs),
		skolemiseeri(F, Ns, [X='t'(Ff/N, Ns)|Ms], [Ff|Fs], F1)
	).

skolemiseeri('v'(F, G), Ns, Ms, Fs, 'v'(F1, G1)):-
	skolemiseeri(F, Ns, Ms, Fs, F1),
	skolemiseeri(G, Ns, Ms, Fs, G1).

skolemiseeri('&'(F, G), Ns, Ms, Fs, '&'(F1, G1)):-
	skolemiseeri(F, Ns, Ms, Fs, F1),
	skolemiseeri(G, Ns, Ms, Fs, G1).

skolemiseeri('~'(P), Ns, Ms, Fs, '~'(P1)):-
	skolemiseeri(P, Ns, Ms, Fs, P1).

skolemiseeri('t'(F, As), Ns, Ms, Fs, 't'(F, As1)):-
	skolemiseeri(As, Ns, Ms, Fs, As1).

skolemiseeri('t'(F), _, _, _, 't'(F)).

skolemiseeri(['t'(F, A)|As], Ns, Ms, Fs, ['t'(F, A1)|As1]):-
	skolemiseeri(A, Ns, Ms, Fs, A1),
	skolemiseeri(As, Ns, Ms, Fs, As1).

skolemiseeri(['t'(F)|As], Ns, Ms, Fs, ['t'(F)|As1]):-
	skolemiseeri(As, Ns, Ms, Fs, As1).

skolemiseeri([A|As], Ns, Ms, Fs, [Ff|As1]):-
	(member(A=Ff, Ms) ->
		true
		;
		Ff = A
	),
	skolemiseeri(As, Ns, Ms, Fs, As1).

skolemiseeri([], _, _, _, []).

konstant(a).
konstant(b).
konstant(c).
konstant(d).
konstant(e).
konstant(f).

funktsionaal(f).
funktsionaal(g).
funktsionaal(h).
funktsionaal(i).
funktsionaal(j).
funktsionaal('f''').
funktsionaal('g''').
funktsionaal('h''').
funktsionaal('i''').
funktsionaal('j''').

/** kvantorid\_ette($+V_1$:valem, $-V_2$:valem).

Valemis $V_1$ kvantorite viimine k~oige ette.
Saame prefikskuju. Resultaat on muutujas $V_2$.
Eeldame, et valemis on implikatsioonid "umber
kirjutatud, muutujad "umber nimetatud ja
eitused viidud atomaarsete valemiteni.
*/

kvantorid_ette('V'(X, F), 'V'(X, F1)):-
	kvantorid_ette(F, F1), !.

kvantorid_ette('E'(X, F), 'E'(X, F1)):-
	kvantorid_ette(F, F1), !.

kvantorid_ette('~'(P), '~'(P)):- !.

kvantorid_ette('t'(F, A), 't'(F, A)):- !.

kvantorid_ette('t'(F), 't'(F)):- !.

kvantorid_ette('v'(F, G), W):-
	kvantorid_ette(F, F1),
	kvantorid_ette(G, G1),
	kvantorid_ette1('v'(F1, G1), W), !.

kvantorid_ette('v'(F, G), 'v'(F, G)).

kvantorid_ette('&'(F, G), W):-
	kvantorid_ette(F, F1),
	kvantorid_ette(G, G1),
	kvantorid_ette1('&'(F1, G1), W), !.

kvantorid_ette('&'(F, G), '&'(F, G)).

kvantorid_ette1('v'('V'(X, F), G), 'V'(X, F1)):-
	kvantorid_ette('v'(F, G), F1), !.

kvantorid_ette1('v'('E'(X, F), G), 'E'(X, F1)):-
	kvantorid_ette('v'(F, G), F1), !.

kvantorid_ette1('v'(F, 'E'(X, G)), 'E'(X, F1)):-
	kvantorid_ette('v'(F, G), F1), !.

kvantorid_ette1('v'(F, 'V'(X, G)), 'V'(X, F1)):-
	kvantorid_ette('v'(F, G), F1), !.

kvantorid_ette1('&'('V'(X, F), G), 'V'(X, F1)):-
	kvantorid_ette('&'(F, G), F1), !.

kvantorid_ette1('&'('E'(X, F), G), 'E'(X, F1)):-
	kvantorid_ette('&'(F, G), F1), !.

kvantorid_ette1('&'(F, 'V'(X, G)), 'V'(X, F1)):-
	kvantorid_ette('&'(F, G), F1), !.

kvantorid_ette1('&'(F, 'E'(X, G)), 'E'(X, F1)):-
	kvantorid_ette('&'(F, G), F1), !.

/** nimeta\_ymber($+V_1$:valem, $-V_2$:valem).

Muutujate "umbernimetamine. Eeldame, et eitused on
viidud atomaarsete valemite juurde ja implikatsioonid
on eemaldatud.
*/

nimeta_ymber(F, F1):-
	nimeta_ymber(F, [], [], F1, _, _).

% Ns - varem kasutatud muutujanimed.
% Ms - ülemise kvantoriga seotud muutujad paaridena (x=u),
% kus x on asendatud u-ga.

nimeta_ymber('V'(X, F), Ns, Ms, 'V'(Xu, F1), [Xu|UNs], [X=Xu|UMs]):-
	(member(X, Ns) ->
		muutuja(Xu),
		\+ member(Xu, Ns),
		nimeta_ymber(F, [Xu|Ns], [X=Xu|Ms], F1, UNs, UMs)
		;
		Xu = X,
		nimeta_ymber(F, [X|Ns], Ms, F1, UNs, UMs)
	).

nimeta_ymber('E'(X, F), Ns, Ms, 'E'(Xu, F1), [Xu|UNs], [X=Xu|UMs]):-
	(member(X, Ns) ->
		muutuja(Xu),
		\+ member(Xu, Ns),
		nimeta_ymber(F, [Xu|Ns], [X=Xu|Ms], F1, UNs, UMs)
		;
		Xu = X,
		nimeta_ymber(F, [X|Ns], Ms, F1, UNs, UMs)
	).

nimeta_ymber('v'(F, G), Ns, Ms, 'v'(F1, G1), UNs, UMs):-
	nimeta_ymber(F, Ns, Ms, F1, UNs1, UMs1),
	nimeta_ymber(G, UNs1, UMs1, G1, UNs, UMs).

nimeta_ymber('&'(F, G), Ns, Ms, '&'(F1, G1), UNs, UMs):-
	nimeta_ymber(F, Ns, Ms, F1, UNs1, UMs1),
	nimeta_ymber(G, UNs1, UMs1, G1, UNs, UMs).

nimeta_ymber('~'(F), Ns, Ms, '~'(F1), UNs, UMs):-
	nimeta_ymber(F, Ns, Ms, F1, UNs, UMs).

nimeta_ymber('t'(F, A), Ns, Ms, 't'(F, A1), Ns, Ms):-
	nimeta_ymber(A, Ns, Ms, A1, _, _).

nimeta_ymber('t'(F), Ns, Ms, 't'(F), Ns, Ms).

nimeta_ymber([], Ns, Ms, [], Ns, Ms).

nimeta_ymber(['t'(F, A)|Ts], Ns, Ms, ['t'(F, A1)|Tns], Ns, Ms):-
	nimeta_ymber(A, Ns, Ms, A1, _, _),
	nimeta_ymber(Ts, Ns, Ms, Tns, _, _).

nimeta_ymber(['t'(F)|Ts], Ns, Ms, ['t'(F)|Tns], Ns, Ms):-
	nimeta_ymber(Ts, Ns, Ms, Tns, _, _).

nimeta_ymber([A|Ts], Ns, Ms, [A1|Tns], Ns, Ms):-
	atomic(A),
	(member(A=X, Ms) ->
		A1 = X
		;
		A1 = A
	),
	nimeta_ymber(Ts, Ns, Ms, Tns, _, _).

muutuja(x).
muutuja(y).
muutuja(z).
muutuja(u).
muutuja(v).
muutuja(w).
muutuja(s).
muutuja(k).
muutuja(l).
muutuja(o).
muutuja(e).

muutuja('x''').
muutuja('y''').
muutuja('z''').
muutuja('u''').
muutuja('v''').
muutuja('w''').
muutuja('s''').
muutuja('k''').
muutuja('l''').
muutuja('o''').

/** teisenda\_eitus($+V_1$:valem, $-V_2$:valem).

Valemist $V_1$ eituste eemaldamine. Resultaadiks
on valem $V_2$. Eeldab, et valem ei sisalda
implikatsioone.
*/

teisenda_eitus('~'('v'(F, G)), '&'(F1, G1)):-
	teisenda_eitus('~'(F), F1),
	teisenda_eitus('~'(G), G1).

teisenda_eitus('~'('&'(F, G)), 'v'(F1, G1)):-
	teisenda_eitus('~'(F), F1),
	teisenda_eitus('~'(G), G1).

teisenda_eitus('~'('V'(X, F)), 'E'(X, F1)):-
	teisenda_eitus('~'(F), F1).

teisenda_eitus('~'('E'(X, F)), 'V'(X, F1)):-
	teisenda_eitus('~'(F), F1).

teisenda_eitus('~'('~'(F)), F1):-
	teisenda_eitus(F, F1).

teisenda_eitus('~'('t'(F, A)), '~'('t'(F, A))).
teisenda_eitus('~'('t'(F)), '~'('t'(F))).

teisenda_eitus('v'(F, G), 'v'(F1, G1)):-
	teisenda_eitus(F, F1),
	teisenda_eitus(G, G1).

teisenda_eitus('&'(F, G), '&'(F1, G1)):-
	teisenda_eitus(F, F1),
	teisenda_eitus(G, G1).

teisenda_eitus('V'(X, F), 'V'(X, F1)):-
	teisenda_eitus(F, F1).

teisenda_eitus('E'(X, F), 'E'(X, F1)):-
	teisenda_eitus(F, F1).

teisenda_eitus('t'(F, A), 't'(F, A)).

teisenda_eitus('t'(F), 't'(F)).

/** eemalda\_impl($+V_1$:valem, $-V_2$:valem).

Valemis $V_1$ implikatsiooni "umberkirjutamine.
Resultaadiks on valem $V_2$.
*/

eemalda_impl('=>'(F, G), 'v'('~'(F1), G1)):-
	eemalda_impl(F, F1),
	eemalda_impl(G, G1).

eemalda_impl('V'(X, F), 'V'(X, F1)):-
	eemalda_impl(F, F1).

eemalda_impl('E'(X, F), 'E'(X, F1)):-
	eemalda_impl(F, F1).

eemalda_impl('v'(F, G), 'v'(F1, G1)):-
	eemalda_impl(F, F1),
	eemalda_impl(G, G1).

eemalda_impl('&'(F, G), '&'(F1, G1)):-
	eemalda_impl(F, F1),
	eemalda_impl(G, G1).

eemalda_impl('~'(F), '~'(F1)):-
	eemalda_impl(F, F1).

eemalda_impl('t'(F, A), 't'(F, A)).

eemalda_impl('t'(F), 't'(F)).