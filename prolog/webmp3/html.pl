/** <module> Module for HTML primitives of Prolog web server.
@author Raivo Laanemets, rlaanemt@ut.ee, 12.11.06
*/
:-module(html, [
	show_data/5,
	show_data/7,
	get_parameter/3,
	get_parameter/4,
	goto/1
]).

:-use_module(templates).
:-use_module(continuations).
:-use_module(hlist).
:-use_module(data).

get_parameter(Q, N, V):-
	member(search(R), Q),
	member(N=V, R).

get_parameter(Q, N, D, V):-
	(member(search(R), Q), member(N=V, R) -> true; V = D).

empty('').

to_int(X, I):-
	\+ empty(X),
	term_to_atom(I, X),
	integer(I).

show_data(E, Fs, O, Q, L):-
	get_parameter(Q, start, 0, S),
	to_int(S, Si),
	Sn is Si + 20,
	(Si - 20 > 0 -> Sp is Si - 20; Sp is 0),
	concatl(['requestContent(''http://localhost:8000/', E, '/show?start=', Sn, ''')'], Cn),
	concatl(['requestContent(''http://localhost:8000/', E, '/show?start=', Sp, ''')'], Cp),
	Next = a([onClick=Cn], ['Next ->']),
	Prev = a([onClick=Cp], ['<- Previous']),
	tuples_table(E, Fs, O, Si, 20, H),
	output(table, [
		entity=L,
		start=S,
		previous=Prev,
		next=Next,
		table=H
	]).

show_data(E, M, Fs, W, O, Q, L):-
	get_parameter(Q, start, 0, S),
	to_int(S, Si),
	Sn is Si + 20,
	(Si - 20 > 0 -> Sp is Si - 20; Sp is 0),
	concatl(['requestContent(''http://localhost:8000/', E, '/' ,M ,'?start=', Sn, ''')'], Cn),
	concatl(['requestContent(''http://localhost:8000/', E, '/' ,M, '?start=', Sp, ''')'], Cp),
	Next = a([onClick=Cn], ['Next ->']),
	Prev = a([onClick=Cp], ['<- Previous']),
	tuples_table(E, Fs, O, Si, 20, H, W),
	output(table, [
		entity=L,
		start=S,
		previous=Prev,
		next=Next,
		table=H
	]).

goto(U):-
	format('<script language="javascript">requestContent(''~a'')</a>', U).