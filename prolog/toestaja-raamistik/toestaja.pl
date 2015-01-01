% 1. järku predikaatloogikas kirja
% pandud teoreemide tõestaja.
%
% Raivo Laanemets, rlaanemt@ut.ee, 17.11.06

:-module(toestaja, [
	toesta/2
]).

:-use_module(lause).
:-use_module(lause_parse).
:-use_module(lause_tex).
:-use_module(lause_res).

toesta(Axs, Th):-
	parsi_laused([Th|Axs], [Thp|Axsp]), !,
	alusta_protok,
	valjasta_algandmed([Thp|Axsp]),
	valemkuju([Thp|Axsp], V1),
	valjasta_valem(V1, 'Valemkuju'),
	V2 = '~'(V1),
	valjasta_valem(V2, 'Kummutatav valem'),
	eemalda_impl(V2, V3), !,
	valjasta_valem(V3, 'Eemaldades implikatsioonid'),
	teisenda_eitus(V3, V4), !,
	valjasta_valem(V4, 'Viies eitused aatomiteni'),
	(predarvutuse_valem(V4) ->
		toesta_pred(V4)
		;
		toesta_lause(V4)
	),
	lopeta_protok.

toesta_lause(V):-
	knk(V, V1), !,
	valjasta_valem(V1, 'Viies KNK-le'),
	teisenda_hulgaks(V1, V2), !,
	valjasta_hulk(V2, 'Viies hulga kujule'),
	res(V2, S),
	tex_subsection('Rakendame resolutsiooni'),
	valjasta_res_sammud(S).

toesta_pred(V):-
	nimeta_ymber(V, V1), !,
	valjasta_valem(V1, 'Nimetades muutujad "umber'),
	kvantorid_ette(V1, V2), !,
	valjasta_valem(V2, 'Viies kvantorid valemi ette'),
	skolemiseeri(V2, V3), !,
	valjasta_valem(V3, 'Skolemiseerides'),
	eemalda_kvantorid(V3, V4), !,
	valjasta_valem(V4, 'Eemaldades "uldsuskvantorid'),
	knk(V4, V5), !,
	valjasta_valem(V5, 'Viies KNK-le'),
	teisenda_hulgaks(V5, V6), !,
	valjasta_hulk(V6, 'Viies hulga kujule').
	

parsi_laused([], []).

parsi_laused([L|Ls], [P|Ps]):-
	parse(L, P),
	parsi_laused(Ls, Ps).

valemkuju([Th|Axs], 'v'('~'(K), Th)):-
	list_konj(Axs, K).

list_konj([A], A).

list_konj([A|As], '&'(A, K)):-
	list_konj(As, K).