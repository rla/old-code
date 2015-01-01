% Hanoi tornide lahendus
% "The Art of Prolog" järgi
% Raivo Laanemets, suvi 2006

:-op(1200, xfy, to).

% Tornide lahendusalgoritm.

% Rekursiooni baasjuhtum, 1 ketta korral
% liigutame kohe selle ketta teisele pulgale,
% kasutamata vahepulka.

hanoi(1, A, B, _, [A to B]).

% Rekursiooni samm. N ketta liigutamiseks
% liigutame kõigepealt N-1 alumist ketast
% ja seejärel tõstame ümber viimase ketta.

% A - lähtepulk
% B - lõpp-pulk
% C - abipulk.

hanoi(N, A, B, C, Moves):-
  N1 is N-1,
  hanoi(N1, A, C, B, Ms1), % Tõstame esimeselt pulgalt abipulgale.
  hanoi(N1, C, B, A, Ms2), % Tõstame abipulgalt teisele pulgale.
  append(Ms1, [A to B|Ms2], Moves).

hanoi(N):-
  hanoi(N, a, c, b, Moves),
  write_moves(Moves, 0).

% Käikude väljakirjutamine.
  
write_moves([M|Moves], N):-
  write(M), nl,
  N1 is N+1,
  ((N1 > 20) -> (wait, write_moves(Moves, 0)); write_moves(Moves, N1)).
  
write_moves([], _).

% Ootab kasutajalt klahvivajutust
% "paged" väljundi saamiseks.

wait:- get_char(_).