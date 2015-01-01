% RLa
% Improved controls - less verbose input required
/*
 * ?- consult(sokoban).
 * % sokoban compiled 0.00 sec, 10,148 bytes
 * true.
 *
 * ?- sokoban.
 * ####
 * # _#
 * #  ###
 * #@   #
 * #! $ #
 * #  ###
 * ####
 *
 * |: right.
 * ####
 * # _#
 * #  ###
 * #@   #
 * # !$ #
 * #  ###
 * ####
 *
 * |: exit.
 *
 */



sokoban :- initial_state(State), game_loop(State,_).
game_loop --> display, {get_key(Direction)}, (move(Direction) ; {true}), (win -> {write('You have won!')} ; game_loop).

get_key(K) :- get_single_char(C), char_code(X, C), (X = e -> halt
                       ; (direction(X,_,_) -> K=X ; get_key(K))
                       ).

initial_state((1,4,
 [[wall, wall,      wall,  wall],
  [wall, floor,     space, wall],
  [wall, floor,     floor, wall,  wall,  wall],
  [wall, goldspace, floor, floor, floor, wall],
  [wall, floor,     floor, gold,  floor, wall],
  [wall, floor,     floor, wall,  wall,  wall],
  [wall, wall,      wall,  wall ]])).



win((X,Y,Board),(X,Y,Board)) :- \+ (member(Row,Board),member(gold,Row)).

move(Direction) -->
  {direction(Direction,Xd,Yd)},
  soko(get,X1,Y1),
  {X2 is X1+Xd},{Y2 is Y1+Yd},
  {X3 is X2+Xd},{Y3 is Y2+Yd},
  tile(get,T1,X2,Y2), tile(get,T2,X3,Y3),
  {push(T1/T2 --> R1/R2)},
  tile(set,R1,X2,Y2), tile(set,R2,X3,Y3),
  soko(set,X2,Y2).



cell(wall,'#').
cell(floor,' ').
cell(space,'_').
cell(goldspace,'@').
cell(gold,'$').

direction(u,0,-1).
direction(d,0,1).
direction(l,-1,0).
direction(r,1,0).

push(floor/Any --> floor/Any).
push(space/Any --> space/Any).
push(gold/floor --> floor/gold).
push(gold/space --> floor/goldspace).
push(goldspace/floor --> space/gold).
push(goldspace/space --> space/goldspace).



soko(get,X,Y,(X,Y,Board),(X,Y,Board)).
soko(set,X,Y,(_,_,Board),(X,Y,Board)).

tile(get,T,X,Y,(Xs,Ys,Board),(Xs,Ys,Board)) :- index(X,Y,Board,T).
tile(set,T,X,Y,(Xs,Ys,Board1),(Xs,Ys,Board2)) :- edit(X,Y,T,Board1 --> Board2).



index(0,[E|_],E) :- !.
index(N,[_|Es],E) :- M is N-1, index(M,Es,E).
index(X,0,[R|_],E) :- index(X,R,E).
index(X,N,[_|Rs],E) :- M is N-1, index(X,M,Rs,E).

edit(0,E,[_|Xs] --> [E|Xs]) :- !.
edit(N,E,[X|Xs] --> [X|Ys]) :- M is N-1, edit(M,E,Xs --> Ys).
edit(X,0,E,[R1|Xs] --> [R2|Xs]) :- edit(X,E,R1 --> R2).
edit(X,N,E,[R|RXs] --> [R|RYs]) :- M is N-1, edit(X,M,E,RXs --> RYs).

display((X,Y,Board),(X,Y,Board)) :- write_rows(X,Y,0,0,Board).
write_rows(_,_,_,_,[]) :- nl.
write_rows(Xs,Ys,X,Y,[R|Rs]) :- write_row(Xs,Ys,X,Y,R), succ(Y,Y2), write_rows(Xs,Ys,X,Y2,Rs).
write_row(_,_,_,_,[]) :- nl.
write_row(X,Y,X,Y,[_|Cs]) :- !, write('!'), succ(X,X2), write_row(X,Y,X2,Y,Cs).
write_row(Xs,Ys,X,Y,[C|Cs]) :- cell(C,Chr), write(Chr), succ(X,X2), write_row(Xs,Ys,X2,Y,Cs).
