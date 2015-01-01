#include <string.h>
#include "worddb.h"

/*
Teeb stringist uue koopia.
*/
char *strcopy(char *string) {
	char *ret=malloc(strlen(string)+1);
	strcpy(ret, string);	
	return ret;
}

struct t_word * wordDB() {
	struct t_word *root;
	root=malloc(sizeof(struct t_word));
	
	root->left=NULL;
	root->right=NULL;
	root->word=NULL;
	
	return root;
}

/*
Otsib andmebaasist sõna, mis sobib ja tagastab
selle id, muidu lisab uue sõna ja loob uue id
(tagastab ka selle).
*/
struct t_word *addWord(struct t_word *root, char *word) {
	struct t_word *current;
	struct t_word *parent;
	int flag=1;
	int cmp;

	if (root->word==NULL) {
		root->word=strcopy(word);
		return root;
	} else {
		current=root;
		parent=root;
		while (current!=NULL) {
			parent=current;
			cmp=strcmp(current->word, word);
			if (cmp>0) {
				current=current->left;
				flag=1;
			} else if (cmp<0) {
				current=current->right;
				flag=2;
			} else return current;
		}
		current=malloc(sizeof(struct t_word));
		if (current==NULL) return NULL;
		current->left=NULL;
		current->right=NULL;
		current->word=strcopy(word);
		if (flag==1) parent->left=current; else parent->right=current;
		return current;
	}
}

/*
Andmebaasi väljaprintimine.
*/
void printdb(struct t_word *word) {
	if (word==NULL) return;
	printdb(word->left);
	printf("%s\n", word->word);
	printdb(word->right);
}
