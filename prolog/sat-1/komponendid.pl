% Sidususkomponentidide leidmine


:-module(komponendid, [
	komponendid/2
]).

:-use_module(library('lists')).

komponendid([K|F], KOs):-
	komponendid(F, K, [], [K], [], KOs).


% Valemi klauslite järgi läbi vaatamine.
% [K|F] on etteantud valem.
% Ls on hetkel vaadeldava komponendi literaalid (akumulaator).
% Ys on klauslid, mis seni komponenti HKO ei sobinud.
% HKO on hetkel vaadeldavas komponendis olevad
% klauslid (akumulaator).
% KOs1 on seni leitud komponendid (akumulaator).
% KOs2 on lõpuks leitud komponendid.


% Esimene reegel: kui leidub hetkel vaadeldava
% komponendi literaalide hulgas literaal L ja
% L või tema komplementaar Lc esineb vaadeldavas
% klauslis K (1), siis võta klausel K hetkel vaadeldavasse
% komponenti ja lisa K-s sisalduvad literaalid
% hetkel vaadeldava komponendi literaalide hulka Ls.
% Seejärel võta varasemast üle jäänud klauslid
% Ys ja lisa nad valemisse F. Saadud valemi F1 peal jätka
% hetke komponenti kuuluvate klauslite otsimist.

komponendid([K|F], Ls, Ys, HKO, KOs1, KOs2):-
	member(L, Ls),
	Lc is -L,
	(member(L, K); member(Lc, K)), !,
	append(K, Ls, Ls1),
	append(Ys, F, F1),
	komponendid(F1, Ls1, [], [K|HKO], KOs1, KOs2).

% Teine reegel: kui tingimus (1) polnud täidetud, siis
% pane vaadeldud klausel K listi Ys ja jätka valemi
% läbivaatamist.

komponendid([K|F], Ls, Ys, HKO, KOs1, KOs2):- !,
	komponendid(F, Ls, [K|Ys], HKO, KOs1, KOs2).

% Kolmas reegel: kui ühtegi klauslit vaadeldavast komponendist üle
% ei jäänud ja esialgne valem on lõpuni läbi vaadatud, siis võta
% hetke komponent HKO komponentide hulka ja lõpeta.

komponendid([], _, [], HKO, KOs1, [HKO|KOs1]):- !.


% Kui valem on läbi vaadatud, siis pole sealt rohkem
% hektke komponenti HKO kuuluvaid klausleid leida.
% Tee uus komponent [K], paiguta HKO seni leitud
% komponentide hulka ja jätka otsingut.

komponendid([], _, [K|Ys], HKO, KOs1, KOs2):-
	komponendid(Ys, K, [], [K], [HKO|KOs1], KOs2).
	
	