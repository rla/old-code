% Indeksile i vastava Dedekindi valemi genereerimine.

:-module(dedekind, [
	dedekind/2,
	dedekind_arv/2
]).

:-use_module(library('lists')).
:-use_module('dpll_loenda').

% Indeksile vastava arvu saamine.
% N - indeks
% A - Dedekindi arv
% Kõigepealt leitakse vastav valem
% ja seejärel loetakse kokku selle
% lahendite arv.

dedekind_arv(N, A):-
	dedekind(N, F), V is 2^N, dpll(F, V, A).

% Indeksile vastava valemi saamine.
% N - indeks (n-th)
% F - valem
% Algoritm vaatab järjest läbi kõik vastava kuupgraafi
% tipud ja paigutab valemisse tipule ja tema järglastele
% vastavad klauslid.

dedekind(N, F):-
	dedekind(0, N, [], F).

dedekind(I, N, F, F):-
	I =:= 2^N, !.

dedekind(I, N, Acc, F):-
	findall(K, klausel(I, N, K), Ks),
	append(Acc, Ks, Acc1),
	I1 is I + 1,
	dedekind(I1, N, Acc1, F).

% Tipu I klausli saamine.
% Kõigepealt leitakse tipule vastav bitijada,
% seejärel genereeritakse järglane,
% muutes bitijadas ühe nullbiti üheks.
% Saadud bitijada teisendakse täisarvuks.
% Et vältida täisarvu 0, liidetakse igale
% positiivsele täisarvule üks ja negatiivsetest
% lahutatakse üks.

klausel(I, N, [A, B]):-
	bit_str(I, N, Bs),
	between(0, N, I1),
	muuda_1(Bs, I1, Bs1),
	bit_str_int(Bs1, I2),
	A is -(I + 1),
	B is I2 + 1.

% Täisarvust bitijada saamine.
% Bitijada antakse listina, kus
% madalama kaaluga bitt on eespool kui
% kõrgema kaaluga bitt.

bit_str(_, 0, []):- !.

bit_str(I, N, [B|Bs]):-
	B is I mod 2,
	I1 is I // 2,
	N1 is N - 1,
	bit_str(I1, N1, Bs).

% Bitijada teisendamine täisarvuks.
% Eeldab, et kasutatakse bitijada,
% mis saadakse protseduurist bit_str.

bit_str_int(Bs, I):-
	bit_str_int(Bs, 0, 0, I).

bit_str_int([B|Bs], E, Acc, I):-
	Acc1 is Acc + B * 2 ^ E,
	E1 is E + 1,
	bit_str_int(Bs, E1, Acc1, I).

bit_str_int([], _, I, I).

% Bitijadas I-nda biti muutmine
% üheks. Eeldab, et esialgses jadas
% oli I-s bitt 0.
% Indeks algab 0-st.
	
muuda_1([0|Bs], 0, [1|Bs]).

muuda_1([B|Bs], I, [B|Bs1]):-
	I > 0,
	I1 is I - 1,
	muuda_1(Bs, I1, Bs1).