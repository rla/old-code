#include <stdio.h>
#include "jada.c"
#include "unikaalsus.c"
#include "sort.c"

int main(void) {
	int n=10;
	int max=300;
	int min=1;
	int *jada=loo_jada(min, max, n);
	int i;
	
	printf("unikaalne: %i\n", onUnikaalne4(jada, n));
	for (i=0; i<n; i++) printf("%i\n", jada[i]);
	
	free(jada);
	
	return 0;
}
