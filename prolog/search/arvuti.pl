% Loogiline programmeerimine
% Üheregistrilise arvuti simuleerimine
% Raivo Laanemets, rlaanemt@ut.ee, 29.11.06

:-use_module(otsing).

:-dynamic(arvuta/1).

% Register arvuga X olgu tähistatud reg(X)

% Kontroll, kas arv X jagub kolmega.

jagub_3ga(X):-
	0 is X mod 3.

% Operaatorid
%   üldkuju oper(op_nimi, vana_register, uus_register)

% ONE - väärtustab registri sisu 1-ga.
% Saab kasutada vaid siis, kui registri sisu
% ei jagu kolmega.

oper(one, reg(X), reg(1)):-
	\+ jagub_3ga(X).

% ADD - liida registri sisule 1.
% Saab kasutada vaid siis, kui registri sisu
% ei jagu kolmega.

oper(add, reg(X), reg(Y)):-
	\+ jagub_3ga(X),
	Y is X + 1.

% DOUBLE - kahekordistab registri sisu.
% Saab kasutada vaid siis, kui registri sisu
% ei jagu kolmega.

oper(double, reg(X), reg(Y)):-
	\+ jagub_3ga(X),
	Y is 2 * X.

% SUB - lahuta registri sisust 1.
% Saab kasutada vaid siis, kui registri sisu
% ei jagu kolmega.

oper(sub, reg(X), reg(Y)):-
	\+ jagub_3ga(X),
	Y is X - 1.

% DIVIDE - jaga registri sisu kolmega.
% Saab kasutada vaid siis, kui registri sisu
% jagub kolmega.

oper(divide, reg(X), reg(Y)):-
	jagub_3ga(X),
	Y is X // 3.

% Otsingugraafi laiendav predikaat
% leiab kõik paarid (P, reg(X)), milles P on tee ja
% reg(X) seis, kuhu on võimalik antud teega jõuda.

laienda(P, R, Rs):-
	findall(([O|P], R1), oper(O, R, R1), Rs).

% Hindame hetkeseisu

% reg(S) - seis
% H - hind

hinda_seis(reg(S), H):-
	arvuta(X),
	H is abs(X - S).

% Hindame käiku

% N - mitmes käik
% H - käigu hind

% DIVIDE hinnaks on (2n)/3

hinda_kaik(divide, N, H):- !,
	H is 2 * N / 3.

% Ülejäänud käikude hinnaks on 1

hinda_kaik(_, _, 1).

interpreteeri(arvuta(X), a-tarn-q, T):-
	retractall(arvuta(_)),
	assert(arvuta(X)),
	otsing(a-tarn-q, reg(1), reg(X), laienda, hinda_seis, hinda_kaik, T1),
	reverse(T1, T).

interpreteeri(arvuta(X), a-tarn, T):-
	retractall(arvuta(_)),
	assert(arvuta(X)),
	otsing(a-tarn, reg(1), reg(X), laienda, hinda_seis, hinda_kaik, T1),
	reverse(T1, T).

interpreteeri(arvuta(X), M, T):-
	otsing(M, reg(1), reg(X), laienda, T1),
	reverse(T1, T).

% Kontrolli, kas 27 ja 1 korral töötab enam-vähem õigesti

kontrolli:-
	interpreteeri(arvuta(1), a-tarn-q, T1),
	interpreteeri(arvuta(1), a-tarn, T2),
	interpreteeri(arvuta(1), laiuti, T3),
	interpreteeri(arvuta(1), iteratiivne-suvitsi, T4), !,
	writeln(T4),
	T1 = T2,
	T2 = T3,
	T3 = T4,
	interpreteeri(arvuta(27), a-tarn-q, T5),
	interpreteeri(arvuta(27), a-tarn, T6),
	interpreteeri(arvuta(27), laiuti, T7),
	interpreteeri(arvuta(27), iteratiivne-suvitsi, T8), !,
	writeln(T8),
	T5 = T6,
	T6 = T7,
	T7 = T8,
	writeln('korras').

% Erinevate interpreteerimisstrateegiate test.
% Genereerib graafikud gnuplot abiga. Ei pruugi
% igal pool töötada (Windows).

test:-
	test_f(a-tarn, 'a-tarn.dat'),
	test_f(iteratiivne-suvitsi, 'iter-suv.dat'),
	test_f(laiuti, 'laiuti.dat'),
	test_f(a-tarn-q, 'a-tarn-q.dat'),
	test_f_s(a-tarn, 'a-tarn-s.dat'),
	test_f_s(iteratiivne-suvitsi, 'iter-suv-s.dat'),
	test_f_s(laiuti, 'laiuti-s.dat'),
	test_f_s(a-tarn-q, 'a-tarn-q-s.dat'),
	shell('./plot.gnuplot'),
	shell('ps2pdf tulemus.ps tulemus.pdf').

writetest([], FD):-
	nl(FD).

writetest([(X, Y)|Ts], FD):-
	format(FD, '~a ~a\n', [X, Y]),
	writetest(Ts, FD).

test_f(M, F):-
	open(F, write, FD, []),
	test(M, Ts),
	writetest(Ts, FD),
	close(FD).

test_f_s(M, F):-
	open(F, write, FD, []),
	test_s(M, Ts),
	writetest(Ts, FD),
	close(FD).

test(M, Ts):-
	test([5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200], M, Ts).

test_s(M, Ts):-
	test([2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 18, 21, 24, 27, 30, 33], M, Ts).

test([], _, []).

test([X|Xs], M, [(X,L)|Ts]):-
	statistics(inferences, V1),
	interpreteeri(arvuta(X), M, _),
	statistics(inferences, V2),
	L is V2 - V1,
	test(Xs, M, Ts).
	