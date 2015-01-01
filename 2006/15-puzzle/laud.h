/*
Tehisintellekt I: 15-mängu lahendamine
Raivo Laanemets, rlaanemt@ut.ee, 05.10.06
*/

#ifndef __LAUD__
#define __LAUD__

#define LAUD struct t_laud

/*
Lauda kujutame kui kahemõõtmelist
baidimassiivi. Eraldi on välja toodud
tühiku asukoht antud laual, et
ei peaks seda pidevalt uuesti leidma.
*/
LAUD {
	char tyhik_x;
	char tyhik_y;
	char koht[4][4];
};

/*
Laua väljastamine.
*/
void valjasta_laud(LAUD *laud);

/*
Algseisu lugemine programmi argumentidest.
*/
LAUD *loe_algseis(char **argv);

/*
Lõppseisule vastava laua tegemine.
*/
LAUD *tee_loppseis();

/*
Antud lauale vastava kaalu leidmine.
*/
int leia_kaal(LAUD *laud);

/*
Leiame, kas antud seis on lõppseis või mitte.
*/
int on_loppseis(LAUD *seis, LAUD *loppseis);

/*
Kontroll, kas lauaseis on lahenduv.
*/
int on_lahenduv(LAUD *seis);

#endif
