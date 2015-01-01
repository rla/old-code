%% <module> Moodul DPLL algoritmi kasutamiseks läbi Prolog muutujate.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(dpllp, [
	dpllp/1,
	dpllk/1
]).

:-use_module(dpll).
:-use_module(knk).
:-use_module(abi).

%% dpllp(+F).
%
% Kehtestatavuse lahendaja, mille sisendiks
% on konjuktiivsel normaalkujul listiesituses
% antud valem. Valemi muutujad, mis on vajalikud
% valemi tõesuseks, väärtustatakse väärtusega 1 (tõene)
% või 0 (väär).
%
% Näide kasutamisest:
% ?>
% ?- dpllp((A v B) => C).
% C = 1 ;
% A = 0,
% B = 0,
% C = 0
% ?-   
% <?

dpllp(F):- knk_list(F, F1), dpllk(F1).

dpllk(F):-
	transleeri(F, F1, T),
	dpll(F1, S),
	vaartustus_list(S, L),
	seo(L, T).

vaartustus_list(S, L):-
	S =.. [_|As],
	vaartustus_list(As, L, 1).

vaartustus_list([V|As], L, N):- var(V), !, N1 is N + 1, vaartustus_list(As, L, N1).
vaartustus_list([V|As], [(N-V)|L], N):- N1 is N + 1, vaartustus_list(As, L, N1).
vaartustus_list([], [], _).

% Seo muutuja väärtus tema indeksi järgi.

seo([(M-V)|Ms], T):-
	member((M-L), T), !,
	L = V,
	seo(Ms, T).
seo([], _).

% Muutujate indekseerimistabel.

tabel(F, Is):-
	term_variables(F, Vs),
	indekslist(Vs, Is).
	
transleeri(F, F1, T):-
	tabel(F, T),
	transleeri1(F, T, F1).
	
transleeri1([C|F], T, [C1|F1]):-
	transleeri_klausel(C, T, C1),
	transleeri1(F, T, F1).
transleeri1([], _, []).

transleeri_klausel([L|C], T, [L1|C1]):-
	(compound(L) ->
		L =.. [-, M],
		member_m(T, (N-M)),
		L1 is -N
		;
		member_m(T, (N-L)),
		L1 is N
	),
	transleeri_klausel(C, T, C1).
transleeri_klausel([], _, []).


member_m([(N-M)|_], (N-M1)):- M == M1, !.
member_m([_|Ms], M):- member_m(Ms, M).