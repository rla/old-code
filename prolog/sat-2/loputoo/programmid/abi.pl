%% <module> Üldiste abimeetodite moodul.
%
% @author Raivo Laanemets, rlaanemt@ut.ee, 2007 sügis.

:-module(abi, [
	indekslist/2,
	algvaartustus/4,
	kl_vaartuseta_muutujad/5,
	m_filtreeri_vaartuseta/3,
	algseadista_loendur/1,
	poora_literaalid/2,
	leia_alg_yhik/2
]).

:-use_module(library(lists)).

:-use_module(vaartustus).
:-use_module(valem).

leia_alg_yhik(F, Ls):-
	klauslite_arv(F, M),
	findall(
		L,
		(
			between(1, M, I),
			klausli_muutujad(F, I, Ps, Ns),
			(
				(Ps = [L], Ns = [])
				;
				(Ps = [], Ns = [L1], L is -L1)
			)
		),
		Ls
	).

poora_literaalid([L|Ls], [L1|Ls1]):- L1 is -L, poora_literaalid(Ls, Ls1).
poora_literaalid([], []).

%% algseadista_loendur(-Lo).
%
% Uue loenduri Lo algseadistamine väärtusele 0.

algseadista_loendur(Lo):-
	gensym(dpll, Lo),
	nb_setval(Lo, 0).

%% kl_vaartuseta_muutujad(+F:valem, Ci:int, +S:olek, -Ps:list, -Ns:list).
%
% Valemist F klausli Ci väärtustamata positiivsena esinevate muutujate Ps
% ja negatiivsena esinevate muutujate Ns leidmine.

kl_vaartuseta_muutujad(F, Ci, S, Ps, Ns):-
	klausli_muutujad(F, Ci, Ps1, Ns1),
	m_filtreeri_vaartuseta(Ps1, S, Ps),
	m_filtreeri_vaartuseta(Ns1, S, Ns).
	
%% m_filtreeri_vaartuseta(+Ms:list, +S:olek, -Ms1:list).
%
% Muutujate listist Ms väärtustamata muutujate väljafiltreerimine
% listi Ms1.
	
m_filtreeri_vaartuseta([M|Ms], S, [M|Ms1]):-
	muutuja_vaartuseta(S, M), !,
	m_filtreeri_vaartuseta(Ms, S, Ms1).
m_filtreeri_vaartuseta([_|Ms], S, Ms1):-
	m_filtreeri_vaartuseta(Ms, S, Ms1).
m_filtreeri_vaartuseta([], _, []).

%% algvaartustus(+Fin:list, -F:valem, -S:olek, -V:term).
%
% DPLL algoritmides algandmestruktuuride koostamine.
% Fin - sisendvalem, F - valem sisekujul, S - tühi väärtustus,
% V - väärtustuse muutujate osa.

algvaartustus(Fin, F, S, V):-
	teisenda(Fin, F),
	tyhi_vaartustus(F, S),
	S = olek(V, _).

%% indekslist(+Xs:list, -Ps:list).
%
% Listi Xs konverteerimine listiks Ps, mille elementideks
% on paarid {\it I-E}, kus {\it I} on elemendi täisarvuline indeks
% ja {\it E} on element ise. Indeksid algavad väärtusega 1 ja väljendavad
% elemendi esinemispositsiooni listi algusosast alates.

indekslist(Xs, Ps):- indekslist(Xs, 1, Ps).
indekslist([], _, []).
indekslist([V|Vs], I, [(I-V)|Ps]):- I1 is I + 1, indekslist(Vs, I1, Ps).
