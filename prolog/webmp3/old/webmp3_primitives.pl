:-module(webmp3_primitives, [
	entity2form/3,
	form/3,
	entity2formc/4,
	formc/4,
	yesno/2
]).

:-use_module(web_data).
:-use_module(webmp3_continuations).
:-use_module(webmp3_list).

form(E, A, F):-
	entity(E, D),
	entity2form((E, D), A, F).

formc(E, A, F, S):-
	entity(E, D),
	entity2formc((E, D), A, F, S).

entity2formc((_, Fs), A, form([action=A, method=get], [input([type=hidden, name=state, value=S])|Is]), S):-
	inputs(Fs, Is).

entity2form((_, Fs), A, form([action=A, method=get], Is)):-
	inputs(Fs, Is).

inputs([], [br([]), input([type=submit, value='Save'])]).

inputs([(id, _)|Fs], Is):-
	inputs(Fs, Is).

inputs([(N, _)|Fs], [input([type=text, name=N]), br([])|Is]):-
	inputs(Fs, Is).

yesno([(yes, (M1:ME1, C1)), (no, (M2:ME2, C2))], p([a([href=Y], ['Yes']), br([]), a([href=N], ['No'])])):-
	concatl(['/', M1, '/', ME1, '?state=', C1], Y),
	concatl(['/', M2, '/', ME2, '?state=', C2], N).