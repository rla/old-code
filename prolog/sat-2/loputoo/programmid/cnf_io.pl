%% <module> cnf formaadis failide lugemise moodul.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(cnf_io, [
	loe_cnf/2
]).

:-use_module(library(lists)).

% fail_loe_koodid(+F:sisendfail, -Cs:list).
%
% Faili F lugemine koodide listiks Cs.

fail_loe_koodid(F, Cs):-
	open(F, read, S),
	loe_koodid(S, Cs),
	close(S).

loe_koodid(S, Cs):-
	(at_end_of_stream(S) ->
		Cs = []
		;
		get_code(S, C),
		Cs = [C|Cs1],
		loe_koodid(S, Cs1)
	).

%% loe_cnf(+F:sisendfail, -Ds:valem).
%
% .cnf faili F lugemine konjuktiivsel normaalkujul listiesituses valemiks Ds.

loe_cnf(F, Ds):-
	fail_loe_koodid(F, Cs),
	phrase(cnf(Ds), Cs, []), !.

cnf([D|Ds]) --> disj_algus, disj(D), cnf(Ds).
cnf([D])    --> disj_algus, disj(D).
cnf(Ds)     --> kommentaar, cnf(Ds).
cnf([])     --> kommentaar.

disj_algus  --> tyhikud.
disj_algus  --> "".

kommentaar     --> "c\n".
kommentaar     --> "c", mitte_nl_seq, "\n".
kommentaar     --> "c", mitte_nl_seq, "\r\n".
kommentaar     --> "p", mitte_nl_seq, "\n".
kommentaar     --> "p", mitte_nl_seq, "\r\n".

disj([X])    --> literaal(X), disj_lopp.
disj([X|Xs]) --> literaal(X), tyhikud, disj(Xs).

tyhikud --> " ".
tyhikud --> " ", tyhikud.

disj_lopp --> tyhikud, "0\n".
disj_lopp --> tyhikud, "0\r\n".
disj_lopp --> tyhikud, "0 \n".
disj_lopp --> tyhikud, "0 \r\n".
disj_lopp --> tyhikud, "0", !.

literaal(N) --> taisarv(Xs), {number_codes(N, Xs)}.

taisarv([45|Xs]) --> "-", naturaalarv(Xs).
taisarv(Xs)      --> naturaalarv(Xs).

naturaalarv([X|Xs]) --> numbrike(X), naturaalarv(Xs).
naturaalarv([X])    --> numbrike(X).

numbrike(X)       --> [X], {memberchk(X, "0123456789")}.

mitte_nl --> [X], {X =\= 10}.

mitte_nl_seq --> mitte_nl, mitte_nl_seq.
mitte_nl_seq --> mitte_nl.