#include <string.h>
#include "filedb.h"

/*
Uue failide andmebaasi loomine.
*/
TFILE *fileDB() {
	TFILE *root;
	root=malloc(sizeof(TFILE));
	root->next=NULL;
	root->words=NULL;
	root->name=NULL;
	return root;
}