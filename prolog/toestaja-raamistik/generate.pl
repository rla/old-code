% Herbrandi universumi genereerimine.
% Raivo Laanemets

:-module(herbrand_univ, [
	universe/3
]).

% ?- genereeri(4, [a, f(a)], [f/1], X).
% X = [a, f(a), f(f(a)), f(f(f(a))), f(f(f(f(a)))), f(f(f(f(...))))]

genereeri(0, H, _, H):- !.
genereeri(N, H, Fs, H1):-
	N1 is N - 1,
	genereeri(H, Fs, H2),
	genereeri(N1, H2, Fs, H1).

% ?- genereeri([a, f(a)], [f/1], X).
% X = [a, f(a), f(f(a))] 

genereeri(H, Fs, H2):-
	findall(T, funktsionaal(Fs, H, T), Ts),
	append(H, Ts, H1),
	sort(H1, H2).

% ?- funktsionaal([f/1], [a], T).
% T = f(a) ;

funktsionaal(Fs, H, T):-
	member(F/A, Fs),
	vota(A, H, As),
	T =.. [F|As].

% N elemendi võtmine elementide listist.

vota(0, _, []):- !.
vota(N, Es, [E|Ss]):-
	member(E, Es),
	N1 is N - 1,
	vota(N1, Es, Ss).