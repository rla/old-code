% Lausearvutuse valemi teisendamine loogiliselt samaväärseks
% konjuktiivsel normaalkujul olevaks valemiks.
% Algoritmi üldine kirjeldus:
% "Logic for Computer Scientist" by Uwe Schöning

% Raivo Laanemets, 05.09.06
% 15.09.06 - listiesituse lisamine.

% Loogilised operaatorid
% ja nende prioriteedid.

:-op(100, fx, ~).
:-op(200, xfy, &).
:-op(300, xfy, v).
:-op(400, xfy, =>).
:-op(500, xfy, <=>).

% Atomaarsed valemid
% Siia tuleb tähti juurde lisada, kui neid rohkem vaja läheb.

aatom(a).
aatom(b).
aatom(c).
aatom(d).
aatom(e).

% Kõigepealt kirjutame lahti implikatsiooni
% ja ekvivalentsi.

yhtlusta(G => H, ~G1 v H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(G <=> H, (G1 & H1) v (~G1 & ~H1)):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(G & H, G1 & H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(G v H, G1 v H1):-
	yhtlusta(G, G1),
	yhtlusta(H, H1).

yhtlusta(~G, ~G1):- yhtlusta(G, G1).
yhtlusta(G, G):- aatom(G).

% Kirjutame eitused atomaarsete
% valemite ette ja eemaldame neist
% mitmekordsed.

yhtlusta_eitus(~(~G), G1):- yhtlusta_eitus(G, G1).

yhtlusta_eitus(~(G & H), G1 v H1):-
	yhtlusta_eitus(~G, G1),
	yhtlusta_eitus(~H, H1).

yhtlusta_eitus(~(G v H), G1 & H1):-
	yhtlusta_eitus(~G, G1),
	yhtlusta_eitus(~H, H1).

yhtlusta_eitus(G v H, G1 v H1):-
	yhtlusta_eitus(G, G1),
	yhtlusta_eitus(H, H1).

yhtlusta_eitus(G & H, G1 & H1):-
	yhtlusta_eitus(G, G1),
	yhtlusta_eitus(H, H1).

yhtlusta_eitus(G, G):- aatom(G).
yhtlusta_eitus(~G, ~G):- aatom(G).

% Teisendus konjuktiivsele normaakujule.

% Kirjutame lahti distributiivsuse juhud.
distr(F v (G & H), W):- !, knk1((F v G) & (F v H), W).
distr((F & G) v H, W):- !, knk1((F v H) & (G v H), W).

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

knk1(~G, ~G):- aatom(G).
knk1(G, G):- aatom(G).

% KNK-le teisendus suvalise lausearvutuse valemi jaoks.

knk(G, G3):-
	yhtlusta(G, G1),
	yhtlusta_eitus(G1, G2),
	knk1(G2, G3).

test:-
	knk(a => b, G1), write(G1), nl,
	knk(a v ~a, G2), write(G2), nl,
	knk((~a => b) v (a & ~c <=> b), G3), write(G3), nl.

% Listiesituse saamine

% KNK konjuktsiooni kirjutamine disjunktsioonide listiks.
% Sort aitab eemaldada korduvad elemendid.

konj_list(G & H, SKL):-
	konj_list(G, GL),
	konj_list(H, HL),
	append(GL, HL, KL),
	sort(KL, SKL).

konj_list(G v H, [DL]):- disj_list(G v H, DL).
konj_list(G, [DL]):- disj_list(G, DL).

% Disjunktsiooni kirjutamine literaalide listiks.

disj_list(G v H, SDL):-
	disj_list(G, GL),
	disj_list(H, HL),
	append(GL, HL, DL),
	sort(DL, SDL).

disj_list(G, [G]):- aatom(G).
disj_list(~G, [~G]):- aatom(G).

% Disjunktsiooni listiesitus on tautoloogia, kui ta sisaldab
% nii valemit A kui ka tema eitust.

tautoloogia(DL):- member(A, DL), member(~A, DL).

% Tautoloogiate eemaldamine listiesitusest.

eemalda_taut([DL|KL], TVKL):- tautoloogia(DL), eemalda_taut(KL, TVKL),!.
eemalda_taut([DL|KL], [DL|TVKL]):- eemalda_taut(KL, TVKL).
eemalda_taut([], []).

% Suvalise lausearvutuse valemi KNK listiesituse saamine.

knk_list(G, L):-
	knk(G, KNK),
	konj_list(KNK, KL),!,
	eemalda_taut(KL, L).

test_list:-
	knk_list((~a => b) v (a & ~c <=> b), G), write(G), nl,
	knk_list(a => (b => a), G1), write(G1), nl,
	knk_list(a & (b v (d & e)), G2), write(G2), nl,
	knk_list(a & b v c & d, G3), write(G3), nl.
