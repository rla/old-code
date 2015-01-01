% Resolutsioon lausearvutuse jaoks.

:-module(lause_res, [
	res/2
]).

res(Ds, S):-
	findall((D1, D2, R), resolveeri(Ds, D1, D2, R), Rs),
	findall(R, member((_, _, R), Rs), Ds1),
	append(Ds, Ds1, Ds2),
	(member((D1, D2, []), Rs) ->
		S = [Ds2]
		;
		S = [Ds|S1],
		res(Ds2, S1)
	).

resolveeri(Ds, D1, D2, R):-
	member(D1, Ds),
	member(D2, Ds),
	D1 \= D2,
	select(F, D1, R1),
	select('~'(F), D2, R2),
	append(R1, R2, R).