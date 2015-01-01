/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include "laud.h"
#include "kaik.h"

#ifndef __PUU__
#define __PUU__

#define KAIGUINFO_LOEND struct t_kaiguinfo_loend

KAIGUINFO_LOEND {
	KAIGUINFO *pea;
	KAIGUINFO_LOEND *saba;
};

#define TIPP struct t_tipp

TIPP {
	LAUD *laud;
	KAIGUINFO_LOEND *kaikude_info;
};

#define PUU struct t_puu

PUU {
	PUU *vasak;
	PUU *parem;
	TIPP *tipp;
};

/*
Puusse käigu juurde panek.
*/
PUU *pane(PUU *puu, KAIK *kaik);

/*
Laua seisu järgi antud seisu järgi puu tipu leidmine.
*/
TIPP *leia(PUU *puu, LAUD *laud);

#endif
