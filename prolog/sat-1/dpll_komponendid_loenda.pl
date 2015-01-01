% DPLL #SAT algoritm.

module(dpll_loenda, [
	dpll/3
]).

:-use_module(library('lists')).
:-use_module('komponendid').

% DPLL.
% N muutujaga valemi F
% mudelite loendamine. Mudeleid on C tükki.
%
% Näide kasutamisest:
%
% ?- dpll([[1,2], [-1,-2]], 2, C).
% C = 2
% Yes

dpll(F, N, C):- dpll(F, 0, N, C).

% Literaali L valimine valemist F.
% Esiteks püüame võtta ühikklauslist,
% kui sellist ei leidu, siis valime suvalise
% klausli ja sealt suvalise literaali.

vali_literaal(F, L):- member([L], F), !.
vali_literaal(F, L):- member(K, F), member(L, K), !.

% #DPLL esimene reegel.
% Kui valemiks F on tühivalem, siis mudelite
% arvuks on 2^(n-m), kus n on valemi F
% muutujate koguarv ja m on hetkel väärtustatud muutujate
% arv. Täpselt n-m tükki on neid muutujaid,
% millele saab suvalise väärtustuse anda.

dpll([], M, N, C):- !, C is 2^(N-M).

% #DPLL teine reegel.
% Kui valem F sisaldab tühiklauslit, siis
% on tegemist vastuoluga. Valemil ei leidu
% siis mudelit.

dpll(F, _, _, 0):- member([], F), !.

% #DPLL kolmas reegel.
% Vali valemist F literaal L ja tema
% komplementaar Lc. Siis arvuta, kui palju (C1)
% on mudeleid kui võtta L tõeseks, ja kui
% palju (C2) on neid siis, kui võtta Lc tõeseks.
% Kokku on mudeleid selles sammus C = C1 + C2 tükki.
		
dpll(F, M, N, C):-
	komponendid_uuri(F),
	vali_literaal(F, L),
	Lc is -L,
	eemalda(F, L, Lc, F1),
	eemalda(F, Lc, L, F2), !,
	M1 is M + 1,                        
	dpll(F1, M1, N, C1),
	dpll(F2, M1, N, C2),
	C is C1 + C2.

eemalda([K|F], L, Lc, F1):-
	(member(L, K) ->
		F1 = F2
		;
		delete(K, Lc, K1),
		F1 = [K1|F2]
	),
	eemalda(F, L, Lc, F2).

eemalda([], _, _, []).


komponendid_uuri(F):- !,
	komponendid(F, Ks),
	length(Ks, L),
	((L > 1) ->
		writeln(L),
		writeln(F)
		;
		true
	).