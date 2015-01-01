#include <stdio.h>
#include "node.c"
#include "network.c"

int main() {
	Network *network = new_network();
	int i = 0;
	int c_relations = 0;
	for (i = 0; i < 8; i++) {
		grow(network);
		c_relations = count_relations(network -> nodes);
		printf("Tippude arv: %i\n", count_nodes(network -> nodes));
		printf("Sisendite arv: %i\n", count_nodes(network -> inputs));
		printf("Seoste arv: %i, võetud mälu: %i\n,", c_relations, c_relations*sizeof(Subnode));
	}
	return 0;
}
