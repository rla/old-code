/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#include "laud.h"

#ifndef __KAIK__
#define __KAIK__

#define KAIGUINFO struct t_kaiguinfo
#define KAIK struct t_kaik

KAIGUINFO {
	char mitmes;
	int heuristika;
	char kuhu; // {y, a, p, v, algseisul: s}
	KAIK *eelmine;
};

KAIK {
	LAUD *laud;
	KAIGUINFO *info;
};

#endif
