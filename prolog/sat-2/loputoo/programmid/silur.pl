%% <module> Programmi silumist abistavad protseduurid.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(silur, [
	silur_literaal/2,
	silur_yhikliteraal/2,
	write_konflikt/1,
	silur_valem/3,
	silur_oota/0,
	sisse/0,
	valja/0
]).

:-use_module(library(lists)).

:-use_module(abi).
:-use_module(vaartustus).
:-use_module(valem).

:-dynamic(silur_keela/0).

%% sisse.
%
% Siluri väljundi näitamise lubamine. Kui siluri väljundi näitamine
% on lubatud, kirjutatakse standardväljundisse infot algoritmi sammude
% kohta.

sisse:- (silur_keela -> retract(silur_keela); true).

%% valja.
%
% Siluri väljundi näitamise keelamine. Kui siluri väljundi näitamine
% on lubatud, kirjutatakse standardväljundisse infot algoritmi sammude
% kohta.

valja:- (silur_keela -> true; assert(silur_keela)).

silur_oota:- silur_keela, !.
silur_oota:- get_char(_).

silur_valem(_, _, _):- silur_keela, !.
silur_valem(F, S, D):-
	write(D), write(' - Valem: ['),
	valem_leia_vt_klauslid(F, S, Is),
	silur_valem_klauslid(Is, F, S),
	write(']'), nl.
	
silur_valem_klauslid([], _, _):- !.
silur_valem_klauslid([I|Is], F, S):-
	(klausel_vaartuseta(S, I) ->
		kl_vaartuseta_muutujad(F, I, S, Ps, Ns),
		write('['),
		silur_klausli_muutujad1(Ps, 1),
		length(Ps, Lp),
		length(Ns, Ln),
		((Lp > 0 , Ln > 0) -> write(', ') ; true),
		silur_klausli_muutujad1(Ns, -1),
		write(']'),
		(Is \== [] -> write(', ') ; true)
		;
		true
	),
	silur_valem_klauslid(Is, F, S).
	
valem_leia_vt_klauslid(F, S, Is):-
	klauslite_arv(F, M),
	findall(
		I,
		(
			between(1, M, I),
			klausel_vaartuseta(S, I)
		),
		Is
	).
	
silur_klausli_muutujad1([], _).
silur_klausli_muutujad1([M], K):- !, L is K * M, write(L).
silur_klausli_muutujad1([M|Ms], K):- L is K * M, format('~a, ', L), silur_klausli_muutujad1(Ms, K).

write_konflikt(_):- silur_keela, !.
write_konflikt(SC):- write(SC), write(' < Konflikt'), nl.

write_otsus(_):- silur_keela, !.
write_otsus(O):- write('Otsus: '), writeln(O).

silur_yhikliteraal(_, _):- silur_keela, !.
silur_yhikliteraal(L, D):- write(D), write(' > T"oeseks valitud "uhikliteraal '), write(L), nl.

silur_literaal(_, _):- silur_keela, !.
silur_literaal(L, D):- write(D), write(' > T"oeseks valitud literaal '), write(L), nl.

% Initsialiseerimiskood, siluri väljalülitamine.

:-initialization(valja).