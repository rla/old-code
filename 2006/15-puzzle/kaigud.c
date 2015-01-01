/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "kaigud.h"

/*
Käikude ahela väljastamine nii, et näidatakse
kuhu tühikut tuleb liigutada.
*/
void kaigud_valjasta_kaigud(KAIK *kaik, int i) {
	if (kaik -> info -> eelmine) {
		kaigud_valjasta_kaigud(kaik -> info -> eelmine, i+1);
		switch(kaik -> info -> kuhu) {
			case 'y': printf("üles\n"); break;
			case 'a': printf("alla\n"); break;
			case 'p': printf("paremale\n"); break;
			case 'v': printf("vasakule\n"); break;
		}
	} else {
		printf("Käike kokku: %i\n", i);
	}
}

/*
Käikude ahela väljastamine nii, et näidatakse käigu
sooritamisel saadavaid laudu.
*/
void kaigud_valjasta_lauad(KAIK *kaik, int i) {
	if (kaik -> info -> eelmine) {
		kaigud_valjasta_lauad(kaik -> info -> eelmine, i+1);
		printf("--------------------------\n");
		valjasta_laud(kaik -> laud);
	}
}

/*
Käikude tabelisse käigu panek. Eeldame, et heuristika on
juba välja arvutatud.
*/
void tabelisse(KAIGUD *kaigud, KAIK *kaik) {
	KAIKUDE_LOEND *kaikude_loend;
	kaikude_loend = malloc(sizeof(KAIKUDE_LOEND));
	kaikude_loend -> kaik = kaik;
	kaikude_loend -> saba = kaigud -> tabel[kaik -> info -> heuristika];
	kaigud -> tabel[kaik -> info -> heuristika] = kaikude_loend;	
}

/*
Käikude hulga initsialiseerimine:
	1. nulli käikude tabel
	2. lisa algseis käikude hulka
	3. tagasta saadud käikude hulk
*/
KAIGUD *initsialiseeri_kaigud(LAUD *algseis) {
	KAIGUD *kaigud = malloc(sizeof(KAIGUD));
	KAIK *kaik = malloc(sizeof(KAIK));
	KAIGUINFO *info = malloc(sizeof(KAIGUINFO));
	int i;

	for (i = 0; i < MAX_TABELI_SUURUS; i++) kaigud -> tabel[i] = NULL;

	info -> mitmes = 0;
	info -> heuristika = 0 + leia_kaal(algseis);
	info -> kuhu = 'e';
	info -> eelmine = NULL;

	kaik -> info = info;
	kaik -> laud = algseis;

	tabelisse(kaigud, kaik);

	return kaigud;
}

/*
Mingist käigust saadud käigu lisamine:
	ette antud on kaikude hulk, eelmine käik,
	eelmise käigu tühiku asukoht, uue käigu tühiku asukoht
	
	uue laua saame eelmise laua kloonimisel ja vastavate
	positsioonide omavahel vahetamise abil

	siin arvutame ka heuristilise kaalu uuele käigule

	lõpuks lisame käigu käikude tabelisse
*/
void avarda_lisa(KAIGUD *kaigud, KAIK *kaik, int x, int y, int uus_x, int uus_y, char kuhu) {
	LAUD *uuslaud = malloc(sizeof(LAUD));
	KAIK *uuskaik = malloc(sizeof(KAIK));
	KAIGUINFO *uusinfo = malloc(sizeof(KAIGUINFO));

	memcpy(uuslaud, kaik -> laud, sizeof(LAUD));

	uuslaud -> koht[uus_y][uus_x] = 15;
	uuslaud -> koht[y][x] = kaik -> laud -> koht[uus_y][uus_x];

	uusinfo -> mitmes = kaik -> info -> mitmes + 1;
	uusinfo -> heuristika = (int)(uusinfo -> mitmes + 2.0 * (float)(leia_kaal(uuslaud)));

	uusinfo -> eelmine = kaik;
	uusinfo -> kuhu = kuhu;

	uuskaik -> laud = uuslaud;
	uuskaik -> info = uusinfo;
	
	uuslaud -> tyhik_x = uus_x;
	uuslaud -> tyhik_y = uus_y;

	tabelisse(kaigud, uuskaik);
}

/*
Käikude hulga avardamine:
	1. proovi tühikut nihutada üles, paremale, alla või vasakule
	2. kui antud käik on lubatud, tee antud väljaku põhjal
		uus käik ja lisa see käikude hulka, kui ta
		juba seal pole või on suurema kaaluga.
*/
void avarda(KAIGUD *kaigud, KAIK *kaik) {
	int x, y, xp1, xm1, yp1, ym1;

	x = kaik -> laud -> tyhik_x;
	y = kaik -> laud -> tyhik_y;

	xp1 = x+1;
	xm1 = x-1;
	yp1 = y+1;
	ym1 = y-1;

	if (xp1 <= 3) avarda_lisa(kaigud, kaik, x, y, xp1, y, 'p');
	if (xm1 >= 0) avarda_lisa(kaigud, kaik, x, y, xm1, y, 'v');
	if (yp1 <= 3) avarda_lisa(kaigud, kaik, x, y, x, yp1, 'a');
	if (ym1 >= 0) avarda_lisa(kaigud, kaik, x, y, x, ym1, 'y');
}

/*
Parima käigu leidmine:
	1. tsükkel üle indeksi i, i=0,..,tabeli_suurus-1
		kui tabel[i] on määratud, siis võta sellelt kohalt käik ära ja tagasta see
	2. kui tsükkel lõpetas, siis tagasta NULL
*/
KAIK *parim(KAIGUD *kaigud) {
	KAIKUDE_LOEND *pea;
	int i;

	for (i = 0; i < MAX_TABELI_SUURUS; i++) if (kaigud -> tabel[i]) {
		pea = kaigud -> tabel[i];
		kaigud -> tabel[i] = pea -> saba;
		return pea -> kaik;	
	}

	return NULL;
}
