%% <module> Protseduur muutuja väärtustuse valimise propageerimiseks.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis

:-module(propageeri, [
	propageeri/5
]).

:-use_module(library(lists)).

:-use_module(valem).
:-use_module(vaartustus).

%% propageeri(+L:int, +F:valem, +V:olek, -Cf:int, -Ct:int).
%
% Etteantud tõese literaali L väärtuse propageerimine
% (valemi F vastava muutuja/klauslite väärtustamine).
% Väljundparameetrid: Cf - saadud väärade klauslite arv;
% Ct - saadud tõeste klauslite arv.

propageeri(L, F, S, Cf, Ct):-
	(L > 0 ->
		propageeri_pos(L, F, S, Cf, Ct)
		;
		L1 is -L,
		propageeri_neg(L1, F, S, Cf, Ct)
	).

% Negatiivse tõese literaali väärtustuse
% propageerimine.

propageeri_neg(M, F, S, Cf, Ct):-
	vaartusta_muutuja(S, M, 0),
	muutuja_klauslid(F, M, Ps, Ns),
	vaartusta_klauslid(Ns, S, 1, Ct),
	kontrolli_ja_vaartusta_neg(Ps, F, S, Cf).

% Tõese positiivse literaali (muutuja indeksiga I)
% väärtuse propageerimine.

propageeri_pos(M, F, S, Cf, Ct):-
	vaartusta_muutuja(S, M, 1),
	muutuja_klauslid(F, M, Ps, Ns),
	vaartusta_klauslid(Ps, S, 1, Ct),
	kontrolli_ja_vaartusta_neg(Ns, F, S, Cf).
	
% Kontrolli etteantud klauslite väärtusi literaalide pealt ja
% väärtusta need klauslid.

kontrolli_ja_vaartusta_neg([], _, _, 0):- !.
kontrolli_ja_vaartusta_neg([C|Cs], F, S, N):- klausel_vaartuseta(S, C), !,
	(leidub_vaartuseta_muutuja(F, S, C) ->
		kontrolli_ja_vaartusta_neg(Cs, F, S, N)
		;
		vaartusta_klausel(S, C, 0),
		N = 1,
		kontrolli_ja_vaartusta_neg(Cs, F, S, _)
	).
kontrolli_ja_vaartusta_neg([_|Cs], F, S, N):- kontrolli_ja_vaartusta_neg(Cs, F, S, N).
	
% Tõene, kui klauslis leidub väärtuseta muutuja. 

leidub_vaartuseta_muutuja(F, S, C):-
	klausli_muutujad(F, C, Ps, Ns),
	(
		(member(V, Ps), muutuja_vaartuseta(S, V))
		;
		(member(V, Ns), muutuja_vaartuseta(S, V))
	).

% Väärtusta väärtusega V kõik etteantud indeksiga klauslid.
% W - väärtustatud klauslite arv.

vaartusta_klauslid(Cs, S, V, W):-
	vaartusta_klauslid(Cs, S, V, 0, W).

vaartusta_klauslid([C|Cs], S, V, W1, W2):-
	(klausel_vaartuseta(S, C) ->
		vaartusta_klausel(S, C, V),
		W3 is W1 + 1,
		vaartusta_klauslid(Cs, S, V, W3, W2)
		;
		vaartusta_klauslid(Cs, S, V, W1, W2)
	).
vaartusta_klauslid([], _, _, W, W).