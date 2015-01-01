% DPLL #SAT algoritm kaalutud loendamiseks (WDPLL).
% Põhineb DPLL #SAT algoritmil (vt. dpll_loenda.pl).
%
% T.Sang, P.Beame, H.Kautz
% Solving Bayesian Networks by Weighted Model Counting (2005)

:-module(dpll_loenda_kaalutud, [
	dpll/3
]).

:-use_module(library('lists')).

% WDPLL.
% Valemi F
% mudelite kaalutud loendamine. Mudeleid on C tükki.
% Muutujate kaalud on ette antud listis Ws (M=W).

% dpll(F, C, Ws)

% Literaali L valimine valemist F.
% Esiteks püüame võtta ühikklauslist,
% kui sellist ei leidu, siis valime suvalise
% klausli ja sealt suvalise literaali.

vali_literaal(F, L):- member([L], F), !.
vali_literaal(F, L):- member(K, F), member(L, K), !.

% WDPLL esimene reegel.
% Valem tühi - tagasta 1.

dpll([], 1, _):- !.

% #DPLL teine reegel.
% Kui valem F sisaldab tühiklauslit, siis
% on tegemist vastuoluga. Valemil ei leidu
% siis mudelit. Mudeleid 0.

dpll(F, 0, _):- member([], F), !.

% WDPLL kolmas reegel.
% Vali valemist F literaal L ja tema
% komplementaar Lc. Siis arvuta, kui palju (C1)
% on mudeleid kui võtta L tõeseks, ja kui
% palju (C2) on neid siis, kui võtta Lc tõeseks.
% Kokku on kaalutud mudeleid selles sammus C = W(L) * C1 + W(Lc) * C2 tükki,
% kus W(x) on literaali x kaal.
		
dpll(F, C, Ws):-
	vali_literaal(F, L),
	Lc is -L,
	eemalda(F, L, Lc, F1),
	eemalda(F, Lc, L, F2), !,                      
	dpll(F1, C1, Ws),
	dpll(F2, C2, Ws),
	kaal(Ws, L, W1),
	kaal(Ws, Lc, W2),
	C is W1 * C1 + W2 * C2.

kaal(Ws, L, W):- member(L=W, Ws).

eemalda([K|F], L, Lc, F1):-
	(member(L, K) ->
		F1 = F2
		;
		delete(K, Lc, K1),
		F1 = [K1|F2]
	),
	eemalda(F, L, Lc, F2).

eemalda([], _, _, []).