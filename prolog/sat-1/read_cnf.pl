% Standardsete .cnf failide sisselugeja

:-module(read_cnf, [
	read_cnf/2
]).

:-use_module(library('lists')).

% Faili lugemine koodide listiks.

read_file_to_codes(F, Cs):-
	open(F, read, S),
	read_codes(S, Cs),
	close(S).

read_codes(S, Cs):-
	(at_end_of_stream(S) ->
		Cs = []
		;
		get_code(S, C),
		Cs = [C|Cs1],
		read_codes(S, Cs1)
	).

% .cnf faili lugemine valemiks.

read_cnf(F, Ds):-
	read_file_to_codes(F, Cs),
	phrase(cnf(Ds), Cs, []), !.

cnf([D|Ds]) -->
	disjunction(D), cnf(Ds).

cnf([D]) -->
	disjunction(D).

cnf(Ds) -->
	comment, cnf(Ds).

cnf([]) -->
	comment.

comment -->
	"c", not_nl_seq, "\n".

comment -->
	"p", not_nl_seq, "\n".

disjunction([X]) -->
	signed_int_wrapper(X), disjunction_end.

disjunction([X|Xs]) -->
	signed_int_wrapper(X), " ", disjunction(Xs).

disjunction_end -->
	" 0\n".

disjunction_end -->
	" 0 \n".

signed_int_wrapper(N) -->
	signed_int_number(Xs),
	{
		number_codes(N, Xs)
	}.

signed_int_number([45|Xs]) -->
	"-", int_number(Xs).

signed_int_number(Xs) -->
	int_number(Xs).

int_number([X|Xs]) -->
	int_digit(X), int_number(Xs).

int_number([X]) -->
	int_digit(X).

int_digit(X) -->
	[X], {
		memberchk(X, "0123456789")
	}.

not_nl -->
	[X], {X =\= 10}.

not_nl_seq -->
	not_nl, not_nl_seq.

not_nl_seq -->
	not_nl.