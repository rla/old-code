#include <stdio.h>
#include "jada.c"
#include "unikaalsus.c"
#include "sort.c"


/*
Jada unikaalsuse kontrollimise algoritmide
töökiiruse võrdlemine.

Raivo Laanemets
*/

int main(int argc, char *argv[]) {

	char *pEnd;
	int n=strtol(argv[1], &pEnd, 10);
	int m=strtol(argv[2], &pEnd, 10);
	int min=strtol(argv[3], &pEnd, 10);
	int max=strtol(argv[4], &pEnd, 10);
	
	if (min>=max) {
		printf("min>=max\n");
		return 1;
	}
	
	//Loome jada
	int *jada=loo_jada(min, max, n);
	
	/*printf("Jada suurus: %s\n", n);
	
	switch (m) {
		case 0:
			printf("Vahetu meetod\n");

		break;
		default:
			printf("Tundmatu meetod\n");
			//Käsurealt määrati tundmatu meetod, väljume
			return 1;
		break;
	}*/
	
	//Vabastame jada
	//free(jada);
	
	//Kõik läks hästi, tagastame 0
	return 0;
	
}
