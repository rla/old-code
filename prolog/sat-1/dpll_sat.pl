% DPLL SAT algoritm
% Hargnemine literaali väärtuse põhjal,
% mitte tõese literaali põhjal.

:-module(dpll_sat, [
	dpll/2
]).

:-use_module(library('lists')).

dpll(F, V):-
	dpll(F, [], V).

% Literaali L valimine valemist F.
% Esiteks püüame võtta ühikklauslist,
% kui sellist ei leidu, siis valime suvalise
% klausli ja sealt suvalise literaali.

vali_literaal(F, L):- member([L], F), !.
vali_literaal(F, L):- member(K, F), member(L, K), !.

% DPLL põhialgoritm.
%
% Näide käivitamisest:
% ?- dpll([[1,2],[-1]], V).
% V = [2, -1]
% Yes
%
% Näites: tõesed muutujad: 2, väärad: 1

% DPLL esimene reegel. Kui valem F on tühivalem,
% siis ei ole enam midagi teha ja sobivaks väärtustuseks
% tuleb võtta hetke väärtustus.

dpll([], V, V):- !.

% DPLL teine reegel. Kui valem F sisaldab
% tühiklauslit, siis tee tagasipöördumine.
% Muidu vali literaal L ja selle komplementaar Lc.
% Seejärel tee hargnemine:
% Esimeses harus võta L tõeseks ja eemalda valemist F
% need klauslid, kus esineb L ja klauslitest Lc esinemine.
% Teises harus võta Lc tõeseks ja eemalda valemist F
% need klauslid, kus esineb Lc ja klauslitest L esinemine.
% Kui esimene haru andis positiivse tulemuse, siis
% teist pole mõtet vaadata.

dpll(F, V1, V2):-
	\+ member([], F),
	vali_literaal(F, L),
	Lc is -L,
	hargne(F, V1, L, Lc, V2).

hargne(F, V1, L, Lc, V2):- eemalda(F, L, Lc, F1), dpll(F1, [L|V1], V2).
hargne(F, V1, L, Lc, V2):- eemalda(F, Lc, L, F1), dpll(F1, [Lc|V1], V2).

% Eemalda valemist F need klauslid, kus esineb
% literaal L ja klauslitest komplementaari Lc.

eemalda([K|F], L, Lc, F1):-
	(member(L, K) ->
		F1 = F2
		;
		delete(K, Lc, K1),
		F1 = [K1|F2]
	),
	eemalda(F, L, Lc, F2).
	
eemalda([], _, _, []).