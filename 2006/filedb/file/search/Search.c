#include <malloc.h>
#include "Search.h"

SearchNode *newSearch() {
	SearchNode *node = (SearchNode *) malloc(sizeof(SearchNode));
	node->file = NULL;
	node->next = NULL;
	return node;
}