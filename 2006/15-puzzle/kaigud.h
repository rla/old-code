/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include "laud.h"
#include "kaik.h"
#include "puu.h"

#ifndef __KAIGUD__
#define __KAIGUD__

#define KAIKUDE_LOEND struct t_kaikude_loend

KAIKUDE_LOEND {
	KAIK *kaik;
	KAIKUDE_LOEND *saba;
};

#define KAIGUD struct t_kaigud
#define MAX_TABELI_SUURUS 1000

KAIGUD {
	KAIKUDE_LOEND *tabel[MAX_TABELI_SUURUS];
};

/*
Initsialiseeritakse käikude hulk ja tagastatakse see.
*/
KAIGUD *initsialiseeri_kaigud(LAUD *algseis);

/*
Leiab kõik seisud (käigud), kuhu antud seisust saab jõuda.
*/
void avarda(KAIGUD *kaigud, KAIK *kaik);

/*
Parima käigu võtmine.
*/
KAIK *parim(KAIGUD *kaigud);

/*
Käikude loendi väljastamine.
*/
void kaigud_valjasta_kaigud(KAIK *kaik, int i);

/*
Laudade loendi väljastamine.
*/
void kaigud_valjasta_lauad(KAIK *kaik, int i);

#endif
