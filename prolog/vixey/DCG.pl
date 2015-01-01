:- op(1200,xfx,-->>).

term_expansion((Head -->> Body), (Head2 :- ExpandedBody)) :-
 Head =.. [Name|Args],
 append(Args,[I,O],Args2),
 Head2 =.. [Name|Args2],
 thread(I --> O, Body, ExpandedBody).

thread(I --> O, Variable, append(Variable,O,I)) :- var(Variable).
thread(I --> O, (A,B), (XA,XB)) :- thread(I --> M, A, XA), thread(M --> O, B, XB).
thread(I --> O, (If->Then;Else), (XIf->XThen;XElse)) :- %% TODO,
 thread(I --> M, If, XIf),                              %% This might unify something CAUSING ->
 thread(M --> O, Then, XThen),
 thread(I --> O, Else, XElse).
thread(I --> O, (If->Then), (XIf->XThen)) :-            %% ditto
 thread(I --> M, If, XIf),
 thread(M --> O, Then, XThen).
thread(I --> O, (P;Q), (XP;XQ)) :- thread(I --> O, P, XP), thread(I --> O, Q, XQ).
thread(I --> O, [], I=O).
thread(I --> O, [X|Xs], I = Thread) :- append([X|Xs],O,Thread).
thread(I --> O, {Raw}, (I=O,Raw)).
thread(I --> O, !, (I=O,!)).
thread(I --> O, Call, XCall) :-
 Call =.. [Name|Args],
 append(Args,[I,O],Args2),
 XCall =.. [Name|Args2].
