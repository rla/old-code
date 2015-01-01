/** <module> T~oestaja faili lugeja

@author Raivo Laanemets, rlaanemt@ut.ee, 17.11.06
@version 1.0
@license GPL
*/

:-module(lugeja, [
	loe/2,
	tee_ridadeks/2,
	loe_ridadeks/2
]).

loe_ridadeks(F, Rs):-
	loe(F, Ks),
	tee_ridadeks(Ks, Rs), !.

/** tee\_ridadeks($+Ks$:list, $-Rs$:list)

Teeb koodide listi $Ks$ ridade listiks $Rs$.
*/

tee_ridadeks(Ks, Rs):-
	phrase(read(Rs), Ks, []).


/** loe\_koodid($+S$:stream, $-Ks$:list)

Loeb striimist $S$ k~oik koodid listi $Ks$.
*/

loe_koodid(S, Ks):-
	loe_koodid(S, [], Ks).

loe_koodid(S, Acc, Ks):-
	get_code(S, K),
	((K =:= -1) ->
		reverse(Acc, Ks)
		;
		loe_koodid(S, [K|Acc], Ks)
	).

/** loe($+F$:string, $-Ks$:list)

Loeb failist $F$ k~oik koodid listi $Ks$.
*/

loe(F, Ks):-
	open(F, read, S, []),
	loe_koodid(S, Ks),
	close(S).

/*
Grammatika koodide listi teisendamiseks ridade listiks.
*/

read([R|Rs]) --> rida(R), read(Rs).

read([R]) --> rida(R).

read([R]) --> tahed(R).

rida(kommentaar(K)) --> "#", tahed(T), {atom_codes(K, T)}, rea_lopud.
rida(rida(R)) --> tahed(R), rea_lopud.

rea_lopud --> [10], rea_lopud.
rea_lopud --> [10].

tahed([T|Ts]) -->
	taht(T), tahed(Ts).

tahed([T]) -->
	taht(T).

taht(T) --> [T], {\+ T = 35, \+ code_type(T, newline)}.