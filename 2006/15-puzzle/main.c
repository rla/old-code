/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include <stdio.h>
#include "lahendaja.h"
#include "laud.h"

/*
Põhiprogramm:
	1. kontrollime sisendi korrektsust
	2. loome käikude hulga
	3. käivitame lahendusprotseduuri
*/
int main(int argc, char **argv) {
	KAIGUD *kaigud;
	LAUD *algseis;

	if (argc < 17) {
		printf("Sisend on poolik!\n");
		return 1;
	}
	algseis = loe_algseis(argv);
	if (!algseis) {
		printf("Sisend on vigane!\n");
	}
	kaigud = initsialiseeri_kaigud(algseis);
	if (argc == 18) {
		valjasta_laud(algseis);
	}
	if (on_lahenduv(algseis)) {
		return lahenda(kaigud, argc);
	} else {
		printf("Algseis on mittelahenduv!\n");
		return 1;
	}
}
