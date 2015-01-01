% Wang'i algoritmi realiseering
% Raivo Laanemets, suvi 2006

% Wang'i algoritm,
% kontrollime, kas valemi(te)st Xs järeldu(b)vad
% valem(id) Ys.

wang(Xs, Ys):-
  (
    wang_axiom(Xs, Ys);
    wang_left_negation(Xs, Ys);
    wang_right_negation(Xs, Ys);
    wang_left_conjuction(Xs, Ys);
    wang_left_disjunction(Xs, Ys);
    wang_right_disjunction(Xs, Ys);
    wang_right_conjuction(Xs, Ys);
    wang_left_implication(Xs, Ys);
    wang_right_implication(Xs, Ys);
    wang_left_equivalence(Xs, Ys);
    wang_right_equivalence(Xs, Ys);
    wang_reduce(Xs, Ys)
  ),
  write(Xs), write(' |- '), write(Ys), nl.
  
  
% Järeldumist loeme tõeseks,
% kui Xs ja Ys on tühjad.

% Aksioomid
% a) Kustutamisreegli lõpp

wang_axiom([], []).

% b) Lausearvutuse aksioom, kus
% vasak pool sisaldab parempoolset lauset.

wang_axiom(Xs, [X]):-
  member(X, Xs).
wang_axiom(Xs, [X,X]):-
  member(X, Xs).
wang_axiom(Xs, [X,X,X]):-
  member(X, Xs).

% c) Aksioom, kus järelduse parem pool on
% alati tõene.
  
wang_axiom(_, Xs):-
  member(A, Xs),
  member(-A, Xs).
  
% d) Aksioom, kus vasak pool sisaldab vastuolu.  
  
wang_axiom(Xs, _):-
  member(A, Xs),
  member(-A, Xs).

% Vasakul asuva negatiivse termi
% viime paremale positiivseks termiks.

wang_left_negation(Xs, Ys):-
  wang_left_negation(Xs, Ys, []).
wang_left_negation([X|Xs], Ys, Zs):-
  negation(X),
  denegate(X, Xn),
  append(Xs, Zs, Xs1),
  wang(Xs1, [Xn|Ys]).
wang_left_negation([X|Xs], Ys, Zs):-
  \+ negation(X),
  wang_left_negation(Xs, Ys, [X|Zs]).

% Paremal asuva negatiivse termi viime
% vasakul positiivseks termiks.  

wang_right_negation(Xs, Ys):-
  wang_right_negation(Xs, Ys, []).
wang_right_negation(Xs, [Y|Ys], Zs):-
  negation(Y),
  denegate(Y, Yn),
  append(Ys, Zs, Ys1),
  wang([Yn|Xs], Ys1).
wang_right_negation(Xs, [Y|Ys], Zs):-
  \+ negation(Y),
  wang_right_negation(Xs, Ys, [Y|Zs]).
  
% Konjuktsioon vasakul

wang_left_conjuction(Xs, Ys):-
  wang_left_conjuction(Xs, Ys, []).
wang_left_conjuction([(X & Y)|Xs], Ys, Zs):-
  append(Xs, Zs, Xs1),
  wang([X,Y|Xs1], Ys).
wang_left_conjuction([X|Xs], Ys, Zs):-
  wang_left_conjuction(Xs, Ys, [X|Zs]).
  
% Konjuktsioon paremal

wang_right_conjuction(Xs, Ys):-
  partition_conjuct(Ys, Ys1, Ys2),
  wang(Xs, Ys1),
  wang(Xs, Ys2).
  
% Disjunktsioon paremal
% Disjunkt. -ni kirjutame lahti
% kaheks valemiks, millest kumbki sisaldab
% ühte disjunkti osa. Tõestamiseks on kolm
% järgmist juhtu:
% 1) vasak disjunktsiooni pool on tõestatav
% 2) parem disjunktsiooni pool on tõestatav
% 3) tõestamiseks on vajalikud mõlemad pooled (|- a v -a).

wang_right_disjunction(Xs, Ys):-
  wang_right_disjunction(Xs, Ys, []).
wang_right_disjunction(Xs, [(X v Y)|Ys], Zs):-
  append(Ys, Zs, Ys1),
  (
    wang(Xs, [X,Y|Ys1]);
    wang(Xs, [X|Ys1]);
    wang(Xs, [Y|Ys1])
  ).
wang_right_disjunction(Xs, [Y|Ys], Zs):-
  wang_right_disjunction(Xs, Ys, [Y|Zs]).
  
% Disjunktsioon vasakul

wang_left_disjunction(Xs, Ys):-
  partition_disjunct(Xs, Xs1, Xs2),
  wang(Xs1, Ys),
  wang(Xs2, Ys).
  
% Implikatsioon vasakul (a > b),
% kirjutame lahti kui -a v b

wang_left_implication(Xs, Ys):-
  wang_left_implication(Xs, Ys, []).
wang_left_implication([(X > Y)|Xs], Ys, Zs):-
  append(Xs, Zs, Xs1),
  wang([(-X v Y)|Xs1], Ys).
wang_left_implication([X|Xs], Ys, Zs):-
  wang_left_implication(Xs, Ys, [X|Zs]).
  
% Implikatsioon paremal,
% vt. 'Implikatsioon vasakul', rakendame
% paremale poolele.

wang_right_implication(Xs, Ys):-
  wang_right_implication(Xs, Ys, []).
wang_right_implication(Xs, [(X > Y)|Ys], Zs):-
  append(Ys, Zs, Ys1),
  wang(Xs, [(-X v Y)|Ys1]).
wang_right_implication(Xs, [Y|Ys], Zs):-
  wang_right_implication(Xs, Ys, [Y|Zs]).
  
% Ekvivalents vasakul

wang_left_equivalence(Xs, Ys):-
  wang_left_equivalence(Xs, Ys, []).
wang_left_equivalence([(X <> Y)|Xs], Ys, Zs):-
  append(Xs, Zs, Xs1),
  wang([(X > Y), (Y > X)|Xs1], Ys).
wang_left_equivalence([X|Xs], Ys, Zs):-
  wang_left_equivalence(Xs, Ys, [X|Zs]).
  
% Ekvivalents paremal

wang_right_equivalence(Xs, Ys):-
  wang_right_equivalence(Xs, Ys, []).
wang_right_equivalence(Xs, [(X <> Y)|Ys], Zs):-
  append(Ys, Zs, Ys1),
  wang(Xs, [(X > Y) & (Y > X)|Ys1]).
wang_right_equivalence(Xs, [Y|Ys], Zs):-
  wang_right_equivalence(Xs, Ys, [Y|Zs]).
  
% Ühesuguste termide redutseerimine

wang_reduce(Xs, Ys):-
  member(A, Xs),
  member(A, Ys),
  delete(Ys, A, Ys1),
  delete(Xs, A, Xs1),
  wang(Xs1, Ys1).
  
% Konjuktsiooni järgi lausete hulga jaotamine

partition_conjuct(Xs, Xs1, Xs2):-
  partition_conjuct(Xs, Xs1, Xs2, []).
partition_conjuct([(X & Y)|Xs], [X|Xs2], [Y|Xs2], Xs1):-
  append(Xs, Xs1, Xs2).
partition_conjuct([X|Xs], Xs1, Xs2, Xs3):-
  partition_conjuct(Xs, Xs1, Xs2, [X|Xs3]).
  
% Disjunktsiooni järgi lausete hulga jaotamine

partition_disjunct(Xs, Xs1, Xs2):-
  partition_disjunct(Xs, Xs1, Xs2, []).
partition_disjunct([(X v Y)|Xs], [X|Xs2], [Y|Xs2], Xs1):-
  append(Xs, Xs1, Xs2).
partition_disjunct([X|Xs], Xs1, Xs2, Xs3):-
  partition_disjunct(Xs, Xs1, Xs2, [X|Xs3]).
  
  
negation(-_).
denegate(-X, X).