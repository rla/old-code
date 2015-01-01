:-module(testid, [
	genereeri_nmk/3,
	testi_sat/6,
	genereeri_nm/4,
	testi_sat_nm/6
]).

:-use_module('../genereeri').
:-use_module('../kirjuta_cnf').
:-use_module('../read_cnf').

% Genereerib N muutujaga ja M klausliga
% juhuslikke valemeid K tükki.
% Salvestab failidesse.

genereeri_nmk(N, M, K):-
	K > 0,
	K1 is K - 1,
	format(atom(FN), 'juhuslik/test_~a_~a_~a.cnf', [N, M, K]),
	genereeri(N, M, F),
	kirjuta_cnf(F, FN),
	genereeri_nmk(N, M, K1).

genereeri_nmk(_, _, 0).

% Võtab muutujate arvu N vahemikust N_LB..N_UB,
% võtab klauslite arvu M vahemikust M_LB..M_UB.
% Genereerib vastavad testfailid, iga N-M paari
% jaoks 10 tk.

genereeri_nm(N_LB, N_UB, M_LB, M_UB):-
	genereeri_nm_n(N_LB, N_UB, M_LB, M_UB).

genereeri_nm_n(N, N_UB, M, M_UB):-
	genereeri_nm_m(N, M, M_UB),
	((N =< N_UB) ->
		N1 is N + 5,
		genereeri_nm_n(N1, N_UB, M, M_UB)
		;
		true
	).

genereeri_nm_m(N, M, M_UB):-
	((M =< M_UB) ->
		genereeri_nmk(N, M, 10),
		M1 is M + 5,
		genereeri_nm_m(N, M1, M_UB)
		;
		true
	).

% Rakendab protseduuriga genereeri_nm/4 loodud
% testfaile etteantud SAT protseduurile SP.
% Tulemused salvestatakse faili DF.

testi_sat_nm(N_LB, N_UB, M_LB, M_UB, SP, DF):-
	open(DF, write, S, []),
	testi_sat_nm_n(N_LB, N_UB, M_LB, M_UB, SP, S),
	close(S),
	nl.

testi_sat_nm_n(N, N_UB, M, M_UB, SP, S):-
	testi_sat_nm_m(N, M, M_UB, SP, S),
	((N =< N_UB) ->
		N1 is N + 5,
		testi_sat_nm_n(N1, N_UB, M, M_UB, SP, S)
		;
		true
	).

testi_sat_nm_m(N, M, M_UB, SP, S):-
	((M =< M_UB) ->
		testi_sat(juhuslik, N, M, SP, AVG, _),
		format(S, '~a ~a ~a\n', [N, M, AVG]),
		write(-), flush,
		M1 is M + 5,
		testi_sat_nm_m(N, M1, M_UB, SP, S)
		;
		true
	).

% Etteantud SAT protseduuri SP rakendamine N-M
% testide komplektile. AVG - keskmine tuletuste arv.
% STDDEV - tuletuste keskmise standardhälve.

testi_sat(juhuslik, N, M, SP, AVG, STDDEV):-
	format(atom(FP), 'juhuslik/test_~a_~a_*.cnf', [N, M]),
	expand_file_name(FP, FNs),
	test_sat_failidest(FNs, SP, AVG, STDDEV).

test_sat_failidest(FNs, SP, AVG, STDDEV):-
	test_sat_failidest(FNs, SP, [], AVG, STDDEV).

test_sat_failidest([FN|FNs], SP, Rs, AVG, STDDEV):-
	read_cnf(FN, F),
	statistics(inferences, I1),
	(call(SP, F, _) -> true; true),
	statistics(inferences, I2),
	R is I2 - I1,
	test_sat_failidest(FNs, SP, [R|Rs], AVG, STDDEV).

test_sat_failidest([], _, Rs, AVG, STDDEV):-
	arvuta_avg(Rs, AVG),
	arvuta_stddev(Rs, AVG, STDDEV).

% Keskmise arvutamine.

arvuta_avg(Rs, AVG):-
	arvuta_avg(Rs, 0, 0, AVG).

arvuta_avg([R|Rs], C, S, AVG):-
	S1 is S + R,
	C1 is C + 1,
	arvuta_avg(Rs, C1, S1, AVG).

arvuta_avg([], C, S, AVG):-
	AVG is S / C.

% Standardhälbe arvutamine.

arvuta_stddev(Rs, AVG, STDDEV):-
	arvuta_stddev(Rs, AVG, 0, 0, STDDEV).

arvuta_stddev([R|Rs], AVG, C, S, STDDEV):-
	S1 is abs(AVG - S) + R,
	C1 is C + 1,
	arvuta_stddev(Rs, AVG, C1, S1, STDDEV).

arvuta_stddev([], _, C, S, STDDEV):-
	STDDEV is S / C.
	