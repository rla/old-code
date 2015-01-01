#include <stdlib.h>

#define BITSEQ struct t_bitseq
#define HUFFTREE struct t_hufftree
#define HUFFCONFIG struct t_huffconfig

BITSEQ {
	char bit;
	BITSEQ *next;
};

HUFFTREE {
};

HUFFCONFIG {
	char ch;
	float prob;
	HUFFCONFIG *next;
};
