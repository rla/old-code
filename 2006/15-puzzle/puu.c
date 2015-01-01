/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "puu.h"

/*
Puusse käigu panek:
	1. kui puu on tühipuu, tee uus puu ja tipp ning tagasta need
	2. kui ei ole tühipuu, otsi koht kuni leiad tühipuu (a) või saad
		tipu, mille laud = käigu laud (b)
		a) mine punkti 1
		b) lisa tipust lähtuvasse listi käigu info
*/
PUU *pane(PUU *puu, KAIK *kaik) {
	TIPP *tipp;
	KAIGUINFO_LOEND *loend;
	int c;

	if (!puu) {
		puu = malloc(sizeof(PUU));
		puu -> vasak = NULL;
		puu -> parem = NULL;
		
		tipp = malloc(sizeof(TIPP));
		tipp -> laud = kaik -> laud;

		puu -> tipp = tipp;

		loend = malloc(sizeof(KAIGUINFO_LOEND));
		loend -> saba = NULL;
		loend -> pea = kaik -> info;

		tipp -> kaikude_info = loend;

		return puu;
	} else {
		c = memcmp(kaik -> laud, puu -> tipp -> laud, sizeof(LAUD));
		if (c > 0) {
			puu -> parem = pane(puu -> parem, kaik);
		} else if (c < 0) {
			puu -> vasak = pane(puu -> vasak, kaik);
		} else {
			printf("olemas\n");
			loend = malloc(sizeof(KAIGUINFO_LOEND));
			loend -> saba = puu -> tipp -> kaikude_info;
			loend -> pea = kaik -> info;
			puu -> tipp -> kaikude_info = loend;
		}
		return puu;
	}
}

/*
Puust lauale vastava tipu leidmine:
	tavaline puu läbimise algoritm.
	Kui sobivat tippu ei leitud, tagastab NULL
*/
TIPP *leia(PUU *puu, LAUD *laud) {
	int c;

	if (!puu) {
		return NULL;
	} else {
		c = memcmp(laud, puu -> tipp -> laud, sizeof(LAUD));
		if (c > 0) {
			return leia(puu -> parem, laud);
		} else if (c < 0) {
			return leia(puu -> vasak, laud);
		} else {
			return puu -> tipp;
		}
	}
}

