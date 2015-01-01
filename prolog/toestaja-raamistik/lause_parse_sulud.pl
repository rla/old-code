% Suluavaldiste puu moodustamine.

:-module(lause_parse_sulud, [
	parse_sulud/2
]).

parse_sulud(I, F):-
	phrase(sulud(F), I, []), !.

% Olgu sisend [a,(,b,+,c,),d], siis saame [a,[b,+,c],d].

sulud([R1|R2]) -->
	"(", sulud(R1), ")", sulud(R2).

sulud([]) -->
	"".

sulud([T|R]) -->
	taht(T), sulud(R).

taht(T) -->
	[T],
	{\+ sulg(T)}.

sulg(T):-
	avav_sulg(T).

sulg(T):-
	sulgev_sulg(T).

avav_sulg(40).
sulgev_sulg(41).