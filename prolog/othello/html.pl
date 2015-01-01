% Othello
% Veebipõhise kasutajaliidesega seotud tegevused
% Tehisintellekt I
% Raivo Laanemets, rlaanemt@ut.ee, 19.11.06

:-module(html, [
	valjasta/2
]).

:-use_module(laud).

% Laua väljastamine, XYs - hetkel käidavad ruudud.

valjasta(B, XYs):-
	write('<table border="1" cellspacing="0" cellpadding="4">'),
	valjasta_read(B, XYs, 0),
	tasakaal(B, S),
	format('</table><br />Tasakaal:~a<br />', S).

valjasta_read([], _, _).

valjasta_read([R|Rs], XYs, X):-
	write('<tr>'),
	valjasta_rida(R, XYs, X, 0),
	write('</tr>'),
	X1 is X + 1,
	valjasta_read(Rs, XYs, X1).

valjasta_rida([], _, _ ,_).

valjasta_rida([E|Es], XYs, X, Y):-
	write('<td>'),
	(member((X, Y), XYs) ->
		symbol(X, Y, S)
		;
		symbol(E, S)
	),
	write(S),
	write('</td>'),
	Y1 is Y + 1,
	valjasta_rida(Es, XYs, X, Y1).

symbol(0, '<img src="http://www.rl.pri.ee/programming/prolog/othello/tyhi.png" alt="tyhi" />').
symbol(1, '<img src="http://www.rl.pri.ee/programming/prolog/othello/valge.png" alt="valge" />').
symbol(-1, '<img src="http://www.rl.pri.ee/programming/prolog/othello/must.png" alt="must" />').
symbol(X, Y, S):-
	format(atom(S), '<a href="http://localhost:4000?x=~a&y=~a">K</a>', [X, Y]).