:-module(web_playlists, [
	show/1,
	new/1,
	new/2
]).

:-use_module(webmp3_templates).
:-use_module(webmp3_data).
:-use_module(webmp3_list).
:-use_module(webmp3_continuations).
:-use_module(webmp3_primitives).

show(_):-
	output(data, [title='Playlists', data='Test']).

new(Q):-
	continue_explicit(web_playlists:new, form, Q).

new(form, _):-
	formc(playlist, new, F, selectsongs),
	output(data, [title='Insert data for a new playlist', data=F]).

new(selectsongs, _):-
	formc(playlist, new, F, decision),
	output(data, [title='Select songs for a new playlist', data=F]).

new(decision, _):-
	Ds = [
		(yes, (playlists:new, selectsongs)),
		(no, (playlists:new, save))
	],
	yesno(Ds, H),
	output(yesno, [title='Would you like to select more songs?', yesno=H]).

new(save, _):-
	output(data, [title='Saved the new playlist!']).