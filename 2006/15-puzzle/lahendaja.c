/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include <stdio.h>
#include <stdlib.h>
#include "lahendaja.h"
#include "puu.h"

/*
Käikude väljastamine:
	kui programmi sisendargumentide arv oli 18, siis
	näitame kasutajale laudu, mitte käike.
*/
void lahendaja_valjasta(KAIK *kaik, int argc) {
	if (argc == 18) {
		kaigud_valjasta_lauad(kaik, 0);
	} else {
		kaigud_valjasta_kaigud(kaik, 0);
	}
}

/*
Otsingualgoritm (A*):
	1. võta parim käik A
	2. kui seisus A on käidud, mine sammu (1)
	3. kui A on lõppseis, siis lõpeta
	4. laienda otsingugraafi A-st saadavate seisude arvel
	5. mine tagasi punkti (1)
*/
int lahenda(KAIGUD *kaigud, int argc) {
	KAIK *parim_kaik;
	LAUD *loppseis = tee_loppseis();
	PUU *suletud = NULL;

	while(1) {
		parim_kaik = parim(kaigud);
		if (leia(suletud, parim_kaik -> laud)) {
			continue;
		}
		if (!parim_kaik) {
			printf("Käigud said otsa!\n");
			return 1;
		}
		if (on_loppseis(parim_kaik -> laud, loppseis)) {
			lahendaja_valjasta(parim_kaik, argc);
			return 0;
		}
		suletud = pane(suletud, parim_kaik);
		avarda(kaigud, parim_kaik);
	}
}
