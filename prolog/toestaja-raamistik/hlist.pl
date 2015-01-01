/** <module> List processing and higher order predicates.
@author Raivo Laanemets, rlaanemt@ut.ee, 02.10.06
Tested on Swi-Prolog
*/

:-module(hlist, [
	map/3,
	fold/3,
	seq/3,
	seq_and_out/2,
	concatl/2,
	sublist/4,
	field/2,
	row/2,
	table/2,
	functorargs/2,
	functorname/2,
	applyl/2,
	split/3,
	concatwith/4,
	concatwithcommaspace/3,
	sharp_quote/2,
	single_quote/2
]).

% Map(+InputList, +Predicate/2, -ResultList).
%
% ?- map([1,2,3,4], square, X).
% X = [1, 4, 9, 16]
% Yes


map([], _, []).

map([I|Is], P, [IT|ITs]):-
	T =.. [P, I, IT],
	call(T),
	map(Is, P, ITs).

% Seq(+Input, +Predicate/2 list, -Result).
%
% ?- seq(3, [square], X).
% X = 9
% Yes
%
% ?- seq(3, [square, square], X).
% X = 81
% Yes
%
% ?- seq([1,2,3], [sum, square], X).
% X = 36
% Yes

seq(I, [], I).

seq(I, [P|Ps], R):-
	T =.. [P, I, I1],
	call(T),
	seq(I1, Ps, R).

seq_and_out(I, Ps):-
	append(Ps, [writeln2], Ps1),
	seq(I, Ps1, _).

writeln2(X, _):-
	writeln(X).

% Fold(+InputList, +Predicate/3, -ResultList).
%
% ?- fold([1,2,3], plus, X).
% X = 6
% Yes
%
% ?- fold([1,2,3], concat, X).
% X = '123'
% Yes

fold([], _, '').

fold([I], _, I).

fold([I|Is], P, R):-
	fold(Is, I, P, R).

fold([I], TF, P, R):-
	call(P, TF, I, R).

fold([I|Is], TF, P, R):-
	call(P, TF, I, TF1),
	fold(Is, TF1, P, R).

% Concatl(+List, -Result).

concatl(Xs, R):-
	fold(Xs, concat, R).

functorargs(T, As):-
	T =.. [_|As].

functorname(T, N):-
	T =.. [N|_].

sharp_quote(X, Y):-
	concatl(['`', X, '`'], Y).

single_quote(X, Y):-
	concatl(['''', X, ''''], Y).

field(F, td(F)).

row(Fs, tr(Fs1)):-
	map(Fs, field, Fs1).

table(Rs, table([id=data], Rs1)):-
	map(Rs, row, Rs1).

% Sublist(+List, +Start, +End, -ResultList).

sublist(Xs, S, E, Ys):-
	sublist(Xs, S, E, 0, Ys).

sublist([], _, _, _, []).

sublist([X|Xs], S, E, C, Ys):-
	(C >= S ->
		(C > E ->
			Ys = []
			;
			Ys = [X|Ys1],
			C1 is C + 1,
			sublist(Xs, S, E, C1, Ys1)
		)
		;
		C1 is C + 1,
		sublist(Xs, S, E, C1, Ys)
	).

applyl([], _).
applyl([I|Is], P):-
	call(P, I),
	applyl(Is, P).

% From Swi-Prolog mailing list.

split(A,B,C):-
	atom_chars(A,AC),
	atom_chars(B,BC),
	append(BC,AC,BAC),
	split3(AC,BAC,ABAC),
	split2(AC,ABAC,C).

split3(AC,BAC,NewABAC):-
	append(AC,ABAC,BAC),
	split3(AC,ABAC,NewABAC).
	split3(_,ABAC,ABAC).

split2(_,[],[]).
split2(X,Y,[A|O]):- 
	append(Z,X,ZX),append(ZX,R,Y),atom_chars(A,Z),
	split3(X,R,NewR),
	split2(X,NewR,O).

concatwith(A, B, C, D):-
	concat(A, C, A1),
	concat(A1, B, D).

concatwithcommaspace(A, B, C):-
	concatwith(A, B, ', ', C).