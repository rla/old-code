#include "../File.h"

#ifndef SEARCH_H_
#define SEARCH_H_

#define SearchNode struct t_searchnode

SearchNode {
	File *file;
	SearchNode *next;
};

SearchNode *newSearch();

#endif /*SEARCH_H_*/
