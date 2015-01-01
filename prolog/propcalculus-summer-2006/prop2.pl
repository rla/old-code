% Lausearvutuste valemite tõestamine sekventside abil
% Raivo Laanemets, suvi 2006

% Valemite kirjeldused
% Aatomite kirjeldused

prop_atom('A').
prop_atom('B').
prop_atom('C').

% Loogikatehete jaoks operaatorite kirjeldamine

:-op(1000, xfy, v).
:-op(800, xfy, &).

% Aatomitest ja loogikatehetest koostatavate
% valemite kirjeldused

prop_formula(X):- prop_atom(X).
prop_formula(- X):- prop_formula(X).
prop_formula(X v Y):- prop_formula(X), prop_formula(Y).
prop_formula(X & Y):- prop_formula(X), prop_formula(Y).

% Aksioomide kirjeldused
% Aksioomiks loetakse sekventsi, mille
% vasak pool sisaldab parempoolset valemit.

prop_axiom([X|_], X):-
  prop_formula(X).
prop_axiom([X|Xs], Y):- X \== Y, prop_axiom(Xs, Y).

% Tuletusreeglid
% Eituse paremale sissetoomine


% Tõestuspuu konstrueerimine
% Tõestamine käib puus juurest (väitest) ülespoole
% (aksioomideni) liikudes, kasutades korrektseid
% tuletusreegleid.

prove(Xs, X, N, Pt):-
  N1 is N+1,
  ((N1 > 8) -> fail, !; true),
  (
    prove_axiom(Xs, X, N1, Pt);
    prove_conjuct_left(Xs, X, N1, Pt);
    prove_disjunct_right1(Xs, X, N1, Pt);
    prove_disjunct_right2(Xs, X, N1, Pt);
    prove_disjunct_left(Xs, X, N1, Pt);
    prove_conjuct_right(Xs, X, N1, Pt);
    prove_negation_add1(Xs, X, N1, Pt);
    prove_negation_add2(Xs, X, N1, Pt);
    prove_negation_remove(Xs, X, N1, Pt)
  ).
  
% Tegemist on juba aksioomiga.
prove_axiom(Xs, X, N, [['Aksioom', Xs, X], []]):-
  ((N > 8) -> fail; prop_axiom(Xs, X)).
   
% Konjuktsiooni vasakule sissetoomine
prove_conjuct_left(Xs, X, N, [['& |-', Xs, X], Pt]):- cut_conjuction(Xs, Xs1), prove(Xs1, X, N, Pt).
  
% Disjunktsiooni paremale sissetoomine
prove_disjunct_right1(Xs, X v _, N, [['|- v', Xs, X], Pt]):- prove(Xs, X, N, Pt).
  
prove_disjunct_right2(Xs, _ v Y, N, [['|- v', Xs, X], Pt]):- prove(Xs, Y, N, Pt).
  
% Disjunktsiooni vasakule sissetoomine
prove_disjunct_left(Xs, X, N, [['v |-', Xs, X], Pt1, Pt2]):- partition_disjunct(Xs, Xs1, Xs2), prove(Xs1, X, N, Pt1), prove(Xs2, X, N, Pt2).

% Konjuktsiooni paremale sissetoomine
prove_conjuct_right(Xs, X & Y, N, [['|- &', Xs, X], Pt1, Pt2]):- prove(Xs, X, N, Pt1), prove(Xs, Y, N, Pt2).

% Eituse paremale sissetoomine
prove_negation_add1(Xs, - X, N, [['|- -', Xs, X], Pt1, Pt2]):- includes(Xs, Y), prove([X|Xs], Y, N, Pt1), prove([X|Xs], -Y, N, Pt2).
prove_negation_add2(Xs, - ( - X), N, [['|- -', Xs, X], Pt1, Pt2]):- prove([-X|Xs], X, N, Pt1), prove([-X|Xs], -X, N, Pt2).

% Eituse paremalt eemaldamise reegel
prove_negation_remove(Xs, X, N, [['|- /-', Xs, X], Pt]):- prove(Xs, -(-X), N, Pt).
  
% Abi
% Sekventsi väljastamine

write_prop_seq(Xs, X):-
  write_prop_list(Xs),
  write(' |- '),
  write_prop_form(X).
  
% Valemite listi väljastamine

write_prop_list([X|[]]):- write_prop_form(X).
write_prop_list([X|Xs]):- write_prop_form(X), write(', '), write_prop_list(Xs).

% Valemi väljastamine

write_prop_form(X):- write(X).

% Kas valemite list sisaldab antud valemit?
includes([X|_], X).
includes([X|Xs], Y):- X \== Y, includes(Xs, Y).

% Konjuktsioonide lahtilõikamine

cut_conjuction([(X & Y)|Xs], [X,Y|Xs1]):- cut_conjuction(Xs, Xs1).
cut_conjuction([X|Xs], [X|Xs1]):- atom(X), cut_conjuction(Xs, Xs1).
cut_conjuction([], []).

% Disjunktsiooni järgi lahtilõikamine
  
partition_disjunct(Xs, Xs1, Xs2):-
  partition_disjunct(Xs, Xs1, Xs2, []).
partition_disjunct([(X v Y)|Xs], [X|Xs2], [Y|Xs2], Xs1):-
  append(Xs1, Xs, Xs2).
partition_disjunct([X|Xs], Xs1, Xs2, Xs3):-
%!!! Viga?
  atom(X),
  partition_disjunct(Xs, Xs1, Xs2, [X|Xs3]).
  
equal(X, X).
negation(-X, X):- prop_atom(X).
negation(X, -X):- prop_atom(X).
negation([], []).
negation([X|Xs], [Y|Ys]):- negation(X, Y), negation(Xs, Ys).
  
% Wang'i algoritm

% Teisendamine algvalemiteks
% Wang'i valemite aatomid

wang_form([X], [X]):- prop_atom(X).
wang_form([-X], Xs):- negative_wang_form(X, Xs).
wang_form([X|Xs], [X|Ys]) :- prop_atom(X), wang_form(Xs, Ys).
wang_form([(X v Y)|Xs]).

negative_wang_form(X, [-X]):- prop_atom(X).

wang([], _).
wang([X|Xs], Ys):- prop_atom(X), wang_match(X, Ys), wang(Xs, Ys).
wang([-X|Xs], Ys):- prop_atom(X), wang(Xs, [X|Ys]).

% Leitakse, kas aatomile vasakul leitakse
% vastav paremal.

wang_match(X, [X|Ys]).
wang_match(X, [Y|Ys]):- prop_atom(Y), X \==Y, wang_match(X, Ys).

% Tõestuspuu väljastamine

write_proof(Xs):- write_proof(Xs, 1).
write_proof([], _).
write_proof([[Rule, Xs, X], Pt], L):-
  S is 4*L,
  space(S),
  write('sekvents: '), write_prop_seq(Xs, X), write(', reegel: '), write(Rule), nl,
  L1 is L+1,
  write_proof(Pt, L1).
  
write_proof([[Rule, Xs, X], Pt1, Pt2], L):-
  S is 4*L,
  space(S),
  write('sekvents: '), write_prop_seq(Xs, X), write(', reegel: '), write(Rule), nl,
  L1 is L+1,
  write_proof(Pt1, L1),
  write_proof(Pt2, L1).
  
space(S):-
  S1 is S-1,
  write(' '),
  ((S1 >= 0) -> space(S1); true).