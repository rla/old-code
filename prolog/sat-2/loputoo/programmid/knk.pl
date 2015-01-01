%% <module> Prologi muutujatega antud valemi teisendamine listiesituses konjuktiivsele normaalkujule.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

% Lausearvutuse valemi teisendamine loogiliselt samaväärseks
% konjuktiivsel normaalkujul olevaks valemiks.
% Algoritmi üldine kirjeldus:
% "Logic for Computer Scientist" by Uwe Schöning

% Raivo Laanemets, 05.09.06
% 15.09.06 - listiesituse lisamine.
% 28.12.07 - kirjutatud ümber Prologi muutujate kasutamiseks.

:-module(knk, [
	knk/2,
	knk_list/2
]).

% Loogilised operaatorid ja nende prioriteedid.

:-op(100, fx, user:(-)).
:-op(200, xfy, user:(&)).
:-op(300, xfy, user:(v)).
:-op(400, xfy, user:(=>)).
:-op(500, xfy, user:(<=>)).

% Kõigepealt kirjutame lahti implikatsiooni
% ja ekvivalentsi.

yhtlusta(G, G):- var(G), !.
yhtlusta(-G, -G):- var(G), !.
yhtlusta(0, 0):- !.
yhtlusta(1, 1):- !.

yhtlusta(F, -F2):- compound(F), F = -F1, !, yhtlusta(F1, F2).
	

yhtlusta(G => H, -G1 v H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).
	
yhtlusta(G <=> H, (G1 & H1) v (-G1 & -H1)):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(G & H, G1 & H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(G v H, G1 v H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

% Kirjutame eitused atomaarsete
% valemite ette ja eemaldame neist
% mitmekordsed.

yhtlusta_eitus(G, G):- var(G), !.
yhtlusta_eitus(-G, -G):- var(G), !.
yhtlusta_eitus(0, 0):- !.
yhtlusta_eitus(1, 1):- !.

yhtlusta_eitus(-(G & H), G1 v H1):- !,
	yhtlusta_eitus(-G, G1),
	yhtlusta_eitus(-H, H1).

yhtlusta_eitus(-(G v H), G1 & H1):- !,
	yhtlusta_eitus(-G, G1),
	yhtlusta_eitus(-H, H1).

yhtlusta_eitus(G v H, G1 v H1):- !,
	yhtlusta_eitus(G, G1),
	yhtlusta_eitus(H, H1).

yhtlusta_eitus(G & H, G1 & H1):- !,
	yhtlusta_eitus(G, G1),
	yhtlusta_eitus(H, H1).
	
yhtlusta_eitus(-(-G), G1):- !, yhtlusta_eitus(G, G1).

% Teisendus konjuktiivsele normaakujule.

% Kirjutame lahti distributiivsuse juhud.
distr(F v F1, W):- compound(F1), F1 = (G & H), !, knk1((F v G) & (F v H), W).
distr(F1 v H, W):- compound(F1), F1 = (F & G), !, knk1((F v H) & (G v H), W).

knk1(G, G):- var(G), !.
knk1(-G, -G):- var(G), !.
knk1(0, 0):- !.
knk1(1, 1):- !.

% Disjunktsiooni juht 1: disjunktsioon
% tuleb läbi korrutada võimaliku
% kõrval oleva konjuktsiooniga.
% Kui sellist olukorda ei teki, rakendame juhtu 2.
% Lõige takistab mitte-knk (aga siiski loogiliselt samaväärse)
% valemi võimalikku genereerimist.

knk1(G v H, W):-
	knk1(G, G1),
	knk1(H, H1),
	distr((G1) v (H1), W), !.

% Disjunktsiooni juht 2: G või H konjuktsiooni ei sisalda.
knk1(G v H, G1 v H1):-
	knk1(G, G1),
	knk1(H, H1).

knk1(G & H, G1 & H1):-
	knk1(G, G1),
	knk1(H, H1).

%% knk(+F:valem, -G:valem).
%
% Lausearvutusvalemi F teisendamine konjuktiivsele
% normaalkujule G. Protseduur aksepteerib loogiliste
% operaatoritena \texttt{-} (eitus), \texttt{v} (disjunktsioon)
% \texttt{\&} (konjuktsioon), \texttt{=>} (implikatsioon),
% \texttt{<=>} (ekvivalents). Operaatorite prioriteedid kasvavalt:
% \texttt{-}, \texttt{\&}, \texttt{v}, \texttt{=>}, \texttt{<=>}.
% Protseduur ei eemalda valemist tautoloogiaid.
% Näide kasutamisest:
% ?>
% ?- knk((A v B) => C, W).
% W = (-A v C)& (-B v C)
% <?

knk(G, G3):-
	yhtlusta(G, G1),
	yhtlusta_eitus(G1, G2),
	knk1(G2, G3).

% KNK konjuktsiooni kirjutamine disjunktsioonide listiks.
% Sort aitab eemaldada korduvad elemendid.

konj_list(F, SKL):-
	compound(F),
	F = (G & H), !,
	konj_list(G, GL),
	konj_list(H, HL),
	append(GL, HL, KL),
	sort(KL, SKL), !.

konj_list(F, [DL]):- compound(F), F = (G v H), !, disj_list(G v H, DL).
konj_list(G, [DL]):- disj_list(G, DL).

% Disjunktsiooni kirjutamine literaalide listiks.

disj_list(G, [G]):- var(G), !.
disj_list(-G, [-G]):- var(G), !.

disj_list(G v H, SDL):-
	disj_list(G, GL),
	disj_list(H, HL),
	append(GL, HL, DL),
	sort(DL, SDL).

% Disjunktsiooni listiesitus on tautoloogia, kui ta sisaldab
% nii valemit A kui ka tema eitust.

tautoloogia(DL):- member(A, DL), member(-A1, DL), A == A1, !.

member_m(M, [M1|_]):- M == M1, !.
member_m(M, [_|Ms]):- member_m(M, Ms).

% Tautoloogiate eemaldamine listiesitusest.

eemalda_taut([DL|KL], TVKL):- tautoloogia(DL), eemalda_taut(KL, TVKL),!.
eemalda_taut([DL|KL], [DL|TVKL]):- eemalda_taut(KL, TVKL).
eemalda_taut([], []).

%% konj_list(+F:valem, -L:list).
%
% Valemi F teisendamine konjuktiivsele normaalkujule.
% Protseduur aksepteerib neidsamu operaatoreid, mida \texttt{knk/2}.

knk_list(G, L):-
	knk(G, KNK),
	konj_list(KNK, KL), !,
	eemalda_taut(KL, L).