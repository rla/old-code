#include <stdlib.h>

/*
Jada suurusega n, minimaalse elemendiga min ja
maksimaalse elemendiga max loomine.
*/
int *loo_jada(int min, int max, int n) {
	int *jada=malloc(n*sizeof(int));
	int i;
	
	srand(time(0));
	
	for (i=0; i<n; i++) jada[i]=min+rand()/(RAND_MAX/(max-min+1));
	
	return jada;
}

/*
Jada vabastamine.
*/
void vabasta_jada(int *jada) {
	free(jada);
}
