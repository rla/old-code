% Lausete väljastamine tex'i kujul.
%
% Raivo Laanemets, rlaanemt@ut.ee, 17.11.06

:-module(lause_tex, [
	tex/2,
	alusta_protok/1,
	alusta_protok/0,
	lopeta_protok/0,
	valjasta_algandmed/1,
	valjasta_valem/2,
	valjasta_hulk/2,
	valjasta/1,
	valjasta_res_sammud/1,
	tex_subsection/1,
	tex_subsubsection/1,
	tex_subsubsection_/1,
	vaata/1,
	vaata/0
]).

valjasta_res_sammud(Ss):-
	valjasta_res_sammud(Ss, 1).

valjasta_res_sammud([], C):-
	samm(C),
	write(pr, '$$\\square$$').

valjasta_res_sammud([S|Ss], C):-
	samm(C),
	C1 is C + 1,
	%write(pr, '$$'),
	konj_hulk(S),
	%write(pr, '$$'),
	valjasta_res_sammud(Ss, C1).

samm(C):-
	format(pr, '\\subsubsection*{Samm ~a}\n', C).

tex_subsubsection(T):-
	format(pr, '\\subsubsection*{~a}\n', T).

tex_subsubsection_(T):-
	format(pr, '\\subsubsection{~a}\n', T).

tex_subsection(T):-
	format(pr, '\\subsection*{~a}\n', T).

valjasta(T):-
	format(pr, '~a\n', T).

valjasta_hulk(V, L):-
	format(pr, '\\subsection*{~a}\n', L),
	konj_hulk(V),
	write(pr, '\n').

konj_hulk([]).

konj_hulk([K]):-
	write(pr, '$$\\{'),
	disj_hulk(K),
	write(pr, '\\}$$\n'), !.

konj_hulk([K|Ks]):-
	write(pr, '$$\\{'),
	disj_hulk(K),
	write(pr, '\\}$$\n'),
	konj_hulk(Ks).

disj_hulk([]).

disj_hulk([D]):-
	tex(pr, D).

disj_hulk([D|Ds]):-
	tex(pr, D),
	write(pr, ','),
	disj_hulk(Ds).

valjasta_valem(V, L):-
	format(pr, '\\subsection*{~a}\n$$', L),
	tex(pr, V),
	write(pr, '$$\n').

vaata:-
	vaata('protokoll.tex').

vaata(F):-
	concat(D, '.tex', F),
	format(atom(C), 'latex ~a && kdvi ~a.dvi', [F, D]),
	shell(C, _).

valjasta_algandmed([Th|Axs]):-
	write(pr, '\\subsection*{Teoreem}\n$$'),
	tex(pr, Th),
	write(pr, '$$\n'),
	write(pr, '\\subsection*{Aksioomid}\n'),
	write(pr, '\\begin{enumerate}\n'),
	valjasta_aksioomid(Axs),
	write(pr, '\\end{enumerate}\n').

valjasta_aksioomid([Ax]):-
	write(pr, '\\item $'),
	tex(pr, Ax),
	write(pr, '$').

valjasta_aksioomid([Ax|Axs]):-
	write(pr, '\\item $'),
	tex(pr, Ax),
	write(pr, '$\n'),
	valjasta_aksioomid(Axs).

alusta_protok:-
	alusta_protok('protokoll.tex').

alusta_protok(F):-
	open(F, write, _, [alias(pr)]),
	write(pr, '\\documentclass[estonian]{article}\n'),
	write(pr, '\\usepackage[T1]{fontenc}\n'),
	write(pr, '\\usepackage[estonian]{babel}\n'),
	write(pr, '\\usepackage{ae}\n'),
	write(pr, '\\usepackage{amsmath}\n'),
	write(pr, '\\usepackage{amssymb}\n'),
	write(pr, '\\begin{document}\n').

lopeta_protok:-
	write(pr, '\\end{document}'),
	close(pr).

tex(S, '=>'(F, G)):-
	(vajab_sulgi(F) ->
		write(S, '('), tex(S, F), write(S, ')')
		;
		tex(S, F)
	),
	write(S, '\\to '),
	(vajab_sulgi(G) ->
		write(S, '('), tex(S, G), write(S, ')')
		;
		tex(S, G)
	).

tex(S, 'v'(F, G)):-
	(vajab_sulgi(F) ->
		write(S, '('), tex(S, F), write(S, ')')
		;
		tex(S, F)
	),
	write(S, '\\vee '),
	(vajab_sulgi(G) ->
		write(S, '('), tex(S, G), write(S, ')')
		;
		tex(S, G)
	).

tex(S, '&'(F, G)):-
	(vajab_sulgi(F) ->
		write(S, '('), tex(S, F), write(S, ')')
		;
		tex(S, F)
	),
	write(S, '\\wedge '),
	(vajab_sulgi(G) ->
		write(S, '('), tex(S, G), write(S, ')')
		;
		tex(S, G)
	).

tex(S, '~'(F)):-
	(vajab_sulgi(F) ->
		write(S, '\\neg ('),
		tex(S, F),
		write(S, ')')
		;
		write(S, '\\neg '),
		tex(S, F)
	).

tex(S, 'V'(X, F)):-
	format(S, '\\forall ~a(', X),
	tex(S, F),
	write(S, ')').

tex(S, 'E'(X, F)):-
	format(S, '\\exists ~a(', X),
	tex(S, F),
	write(S, ')').

tex(S, 't'(F/_, As)):-
	format(S, '~a(', F),
	argumendid(As, S),
	write(S, ')').

tex(S, 't'(F/0)):-
	write(S, F).

tex(S, A):-
	write(S, A).

vajab_sulgi(X):-
	\+ term(X),
	\+ eitus(X),
	\+ kvantor(X).

kvantor('V'(_, _)).
kvantor('E'(_, _)).
term('t'(_, _)).
term('t'(_)).
eitus('~'(_)).

argumendid([A], S):-
	tex(S, A).

argumendid([A|As], S):-
	tex(S, A),
	write(S, ', '),
	argumendid(As, S). 