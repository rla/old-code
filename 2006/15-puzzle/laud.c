/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "laud.h"

/*
Mängulaua väljastamine:
	tsükkel üle laua koordinaatide,
	väärtuse 15 asemele väljastame tühiku,
	väljad on eraldatud tabulaatoriga
*/
void valjasta_laud(LAUD *laud) {
	int i, j, v;
	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			v = laud -> koht[i][j];
			if (v == 15) {
				printf(" \t");
			} else {
				printf("%i\t", v+1);
			}
		}
		printf("\n");
	}
}

/*
Algseisu sisselugemine:
	algseisu saame käsurea argumentidest,
	teisendame need ja lõpuks kontrollime,
	kas etteantud seis on sobiv

	ette antakse argumentidena arvud 1..16,
	programselt kasutame väärtusi 0..15
*/
LAUD *loe_algseis(char **argv) {
	int i, j, v;
	char arv[16];
	LAUD *laud = malloc(sizeof(LAUD));
	for (i = 0; i < 16; i++) arv[i] = 0;
	for (i = 0; i < 4; i++) for (j = 0; j < 4; j++) {
		v = strtol(argv[i*4+j+1], NULL, 0)-1;
		if (v > 15) {
			free(laud);
			return NULL;
		}
		if (v == 15) {
			laud -> tyhik_x = j;
			laud -> tyhik_y = i;
		}
		laud -> koht[i][j] = v;
		arv[v] = 1;
	}
	for (i = 0; i < 16; i++) if (arv[i] == 0) {
		printf("Puudub arv %i!\n", i+1);
		free(laud);
		return NULL;
	}
	return laud;
}

/*
Lõppseisu tegemine:
	paigutame arvud väljakul nende õigetesse kohtadesse
*/
LAUD *tee_loppseis() {
	int i, j;
	LAUD *laud = malloc(sizeof(LAUD));
	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			laud -> koht[i][j] = i*4+j;
		}
	}
	laud -> tyhik_x = 3;
	laud -> tyhik_y = 3;
	return laud;
}

/*
Laua kaalu (headuse leidmine). Arvutame
summa üle Manhattani kauguste igast arvust
tema õige kohani. Mida väiksema saame tulemuse,
seda parem antud seis on.
*/
int leia_kaal(LAUD *laud) {
	int i, j, s, x, y, v;
	s = 0;
	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			v = laud -> koht[i][j];
			y = v/4;
			x = v%4;
			s += abs(i - y)+abs(j - x);
		}
	}
	return s;
}

/*
Leiame, kas antud seis on lõppseis. Kasutame
madala taseme baidimassiivide võrdlemist.
*/
int on_loppseis(LAUD *seis, LAUD *loppseis) {
	return (memcmp(loppseis, seis, sizeof(LAUD)) == 0);
}

/*
Kontroll, kas etteantud lauaseis on lahenduv.
Kõigepealt teeme massiivi ruutudest, mis on
saadud lauast tühikuga ruudu eemaldamise teel.
Seejärel kontrollime vastavalt teoreemile, mille
leiab aadressilt
http://www.cut-the-knot.org/pythagoras/fifteen.shtml
*/
int on_lahenduv(LAUD *laud) {
	char r[15];
	int i, j, c, v, a, sum, rn;
	c = 0;
	rn = 0;
	for (i = 0; i < 4; i++) {
		for (j = 0; j < 4; j++) {
			v = laud -> koht[i][j];
			if (v != 15) {
				r[c] = v;
				c++;
			} else {
				rn = i;
			}
		}
	}
	sum = 0;
	for (i = 0; i < 14; i++) {
		a = r[i];
		for (j = i+1; j < 15; j++) {
			if (r[j] > a) sum++;
		}
	}
	return (((sum + rn) % 2) == 0);
}
