% RLa
:- module sokoban.

:- interface.
:- import_module io.
:- pred main(io.state::di, io.state::uo) is det.

:- implementation.
:- import_module list, int, char.

% Type definitions
:- type board_part ---> wall
                      ; floor
                      ; space
                      ; goldspace
                      ; gold.

:- type board_row == list(board_part).
:- type board     == list(board_row).

:- type point ---> point(x::int, y::int).

:- type game_state ---> state(point::point, board::board).

:- type direction ---> up
                     ; down
                     ; left
                     ; right
                     ; exit.

:- type pushing_pair ---> (board_part/board_part).

% Game logics and control
:- pred main_loop(io.state::di, io.state::uo, game_state::in, game_state::out) is det.
:- pred move(direction::in, game_state::in, game_state::out) is semidet.
:- pred win(game_state::in, game_state::out) is semidet.

% Board plumbing
:- pred soko_get(point::out, game_state::in, game_state::out) is det.
:- pred soko_set(point::in, game_state::in, game_state::out) is det.
:- pred tile_get(point::in, board_part::out, game_state::in, game_state::out) is semidet.
:- pred tile_set(point::in, board_part::in, game_state::in, game_state::out) is det.
:- pred push(pushing_pair::in, pushing_pair::out) is semidet.

% Helper predicates for board plumbing
:- func direction(direction::in) = (point::out).
:- func point_add(point::in, point::in) = (point::out).

% Input predicates
:- pred get_key(direction::out, io.state::di, io.state::uo) is det.
:- pred key(char::in, direction::out) is semidet.

% Output predicates
:- pred display(io.state::di, io.state::uo, game_state::in, game_state::out) is det.
:- pred write_row(point::in, point::in, board_row::in, io.state::di, io.state::uo) is det.
:- pred write_rows(point::in, point::in, board::in, io.state::di, io.state::uo) is det.
:- pred init_state(game_state::out) is det.
:- func cell(board_part::in) = (string::out).

main(!IO) :-
        init_state(S0),
        main_loop(!IO, S0, _).

% DCG for threading game state
main_loop(!IO) -->
        display(!IO),
        {get_key(Direction, !IO)},
        (if {Direction = exit}
        then {true}
        else
                (if move(Direction)
                then (if win then {io.write_string("You won!\n", !IO)} else main_loop(!IO))
                else main_loop(!IO)
                )
        ).

win(!State):-
        \+ (member(Row, !.State ^ board), member(gold, Row)).

point_add(point(X1, Y1), point(X2, Y2)) = point(X1 + X2, Y1 + Y2).

direction(up)    = point(0, -1).
direction(down)  = point(0, 1).
direction(left)  = point(-1, 0).
direction(right) = point(1, 0).

get_key(Direction) -->
        io.read_char(Result),
        (if
                {Result = ok(Char)},
                {key(Char, Direction1)}
        then
                {Direction = Direction1}
        else
                get_key(Direction)
        ).

move(Direction) -->
        soko_get(Current),
        {DirPoint = direction(Direction)},
        {Point1 = point_add(Current, DirPoint)},
        {Point2 = point_add(Point1, DirPoint)},
        tile_get(Point1, Tile1),
        tile_get(Point2, Tile2),
        {push(Tile1/Tile2, Result1/Result2)},
        tile_set(Point1, Result1),
        tile_set(Point2, Result2),
        soko_set(Point1).

soko_get(Point, !State):- Point = !.State ^ point.
soko_set(Point, !State):- !:State = !.State ^ point := Point.

tile_get(Point, Tile, !State):-
        list.index0(!.State ^ board, Point ^ y, Row),
        list.index0(Row, Point ^ x, Tile).

tile_set(Point, Tile, !State):-
        !:State = ((!.State) ^ board :=
                list.det_replace_nth(
                        !.State ^ board,
                        Point ^ y + 1,
                        list.det_replace_nth(
                                list.det_index0(
                                        !.State ^ board,
                                        Point ^ y
                                ),
                                Point ^ x + 1,
                                Tile
                        )
                )
        ).

push(floor/Any, floor/Any).
push(space/Any, space/Any).
push(gold/floor, floor/gold).
push(gold/space, floor/goldspace).
push(goldspace/floor, space/gold).
push(goldspace/space, space/goldspace).

key('w', up).
key('s', down).
key('a', left).
key('d', right).
key('e', exit).

display(!IO, state(Point, Board), state(Point, Board)):-
        write_rows(Point, point(0, 0), Board, !IO).

% DCG for threading IO
write_rows(P1, P2, Board) -->
        (
                {Board = []},
                io.nl
                ;
                {Board = [Row|Board1]},
                write_row(P1, P2, Row),
                write_rows(P1, point(P2 ^ x, P2 ^ y + 1), Board1)
        ).

write_row(P1, P2, Row) -->
        (
                {Row = []},
                io.nl
                ;
                {Row = [Cell|Row1]},
                (if
                        {P1 = P2}
                then
                        io.write_char('!'),
                        write_row(P1, point(P2 ^ x + 1, P2 ^ y), Row1)
                else
                        io.write_string(cell(Cell)),
                        write_row(P1, point(P2 ^ x + 1, P2 ^ y), Row1)
                )
        ).

init_state(state(StartPoint, StartBoard)):-
        StartPoint = point(1, 4),
        StartBoard = [
                [wall, wall,      wall,  wall],
                [wall, floor,     space, wall],
                [wall, floor,     floor, wall,  wall,  wall],
                [wall, goldspace, floor, floor, floor, wall],
                [wall, floor,     floor, gold,  floor, wall],
                [wall, floor,     floor, wall,  wall,  wall],
                [wall, wall,      wall,  wall]
        ].

cell(wall)      = "#".
cell(floor)     = " ".
cell(space)     = "_".
cell(goldspace) = "@".
cell(gold)      = "$".
