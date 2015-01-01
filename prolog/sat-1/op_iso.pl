% Otsinguprotseduuri realisatsioon keeles Prolog
%
% Kasutatud Prolog implementatsioon: SWI-Prolog, versioon 5.6.34
% Siin kujutame muutujaid aatomitena a,b,c,...
% Klauslit kujutame litraalide listina, valemit kujutame
% klauslite listina.
% op on reserveeritud nimi, kasutame nime otp
%
% Näide kasutamisest (eespool vaadeldud näide):
% ?- otp([[a,b,-c], [-a,-b], [c,-b]], V).
% V = [-b, a]
% Yes

otp(F, V):-
	otp(F, [], V).

% Tühivalemi korral on meil kehtestatav valem.
% Sellisel juhul pole midagi enam edasi teha.

otp([], V, V).

% Kui valemis esineb mingi muutuja ühikliteraalina,
% siis kasuta väärtustusreeglit selle muutuja järgi.
% Vastab reeglitele R4p ja R4n.

otp(F, V1, V2):-
	member([L], F),
	komplementaar(L, Lc),
	lihtsusta(F, L, Lc, F1), !,
	otp(F1, [L|V1], V2).

% Kui eelmised juhud polnud rakendatavad, peame kasutama
% üldist väärtustusreeglit.

otp(F, V1, V2):-
	vali_muutuja(F, L),
	komplementaar(L, Lc),
	lihtsusta(F, L, Lc, F1),
	lihtsusta(F, Lc, L, F2), !,
	(otp(F1, [L|V1], V2) ; otp(F2, [Lc|V1], V2)).

% Muutuja valik. Võtame kõige vasakpoolsemast
% klauslist kõige vasakpoolsema muutuja esinemise.

vali_muutuja([[L|_]|_], L).

% Literaali L komplementaar (kui muutuja X esineb positiivselt
% literaalina L, siis L komplementaar on muutuja X esinemine
% negatiivselt ja vastupidi).

komplementaar(-L, L):- !.
komplementaar(L, -L).

% Lihtsusta valemit, eemalda valemist
% F need klauslid, kus esineb
% literaal L ja F klauslitest L komplementaar Lc.

lihtsusta([K|F], L, Lc, F1):-
	(member(L, K) ->
		F1 = F2
		;
		delete(K, Lc, K1),
		F1 = [K1|F2]
	),
	lihtsusta(F, L, Lc, F2).
	
lihtsusta([], _, _, []).

