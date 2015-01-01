#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "tokenizer.c"
#include "chunkbase.c"
#include "charmap.c"

#define TRINODE struct t_trinode
#define TRILEAF struct t_trileaf
#define WORD_ID struct t_word_id
#define TRIAX struct t_triax
#define TRIROOT struct t_triroot
#define WORDIX struct t_wordix
#define ENTIX struct t_entix
#define INTLIST struct t_intlist
#define QUERY_MATRIX struct t_query_matrix

#define MAX_WORD_ID 2000000000

WORD_ID {
	int id;
	WORD_ID *next;
};

TRIROOT {
	TRINODE *nodes[255];
};

TRINODE {
	TRILEAF *leafs[255];
};

TRILEAF {
	WORD_ID *word_ids[255];
};

TRIAX {
	char letters[3];
	TRIAX *next;
};

WORDIX {
	int last_word_id;
	TRIROOT *triroot;
};

ENTIX {
	int last_entity_id;
	WORDIX *wordix;
};

INTLIST {
	int value;
	INTLIST *next;
};

QUERY_MATRIX {
	WORD_ID *word_id;
	QUERY_MATRIX *next;
};

WORD_ID *new_word_id() {
	WORD_ID *word_id = malloc(sizeof(WORD_ID));
	word_id -> next = NULL;
	return word_id;
}

TRIROOT *new_triroot() {
	TRIROOT *triroot = malloc(sizeof(TRIROOT));
	int i;
	for (i = 0; i < 255; i++) {
		triroot -> nodes[i] = NULL;
	}
	return triroot;
}

TRINODE *new_trinode() {
	TRINODE *trinode = malloc(sizeof(TRINODE));
	int i;
	for (i = 0; i < 255; i++) {
		trinode -> leafs[i] = NULL;
	}
	return trinode;
}

TRILEAF *new_trileaf() {
	TRILEAF *trileaf = malloc(sizeof(TRILEAF));
	int i;
	for (i = 0; i < 255; i++) {
		trileaf -> word_ids[i] = NULL;
	}
	return trileaf;
}

TRIAX *new_triax() {
	TRIAX *triax = malloc(sizeof(TRIAX));
	triax -> next = NULL;
	return triax;
}

WORDIX *new_wordix() {
	WORDIX *wordix = malloc(sizeof(WORDIX));
	wordix -> triroot = new_triroot();
	wordix -> last_word_id = 0;
	return wordix;
}

ENTIX *new_entix() {
	ENTIX *entix = malloc(sizeof(WORDIX));
	entix -> wordix = new_wordix();
	return entix;
}

INTLIST *new_intlist() {
	INTLIST *intlist = malloc(sizeof(INTLIST));
	intlist -> next = NULL;
	return intlist;
}

INTLIST *intlist_append(INTLIST *tail, int value) {
	INTLIST *head = new_intlist();
	head -> next = tail;
	head -> value = value;
	return head;
}

QUERY_MATRIX *new_query_matrix() {
	QUERY_MATRIX *matrix = malloc(sizeof(QUERY_MATRIX));
	matrix -> next = NULL;
	return matrix;
}

QUERY_MATRIX *query_matrix_append(QUERY_MATRIX *tail, WORD_ID *word_id) {
	QUERY_MATRIX *head = new_query_matrix();
	head -> next = tail;
	head -> word_id = word_id;
	return head;
}

TRIAX *triaxize(char *word) {
	int i;
	int l = strlen(word);
	TRIAX *start = new_triax();
	TRIAX *temp;
	for (i = 0; i <= l; i++) {
		if (i == 1) {
			start -> letters[0] = '$';
			start -> letters[1] = word[i-1];
			start -> letters[2] = word[i];
		} else if (i >= 1 && i < l) {
			temp = new_triax();
			temp -> next = start;
			temp -> letters[0] = word[i-2];
			temp -> letters[1] = word[i-1];
			temp -> letters[2] = word[i];
			start = temp;
		} else if (i > 0) { // i=l
			temp = new_triax();
			temp -> next = start;
			temp -> letters[0] = word[i-2];
			temp -> letters[1] = word[i-1];
			temp -> letters[2] = '$';
			start = temp;
		}
	}
	return start;
}

void insert_triax_leaf(TRILEAF *leaf, TRIAX *triax, int id) {
	int index = triax -> letters[2];
	WORD_ID *word_id = new_word_id();
	word_id -> id = id;
	if (leaf -> word_ids[index] == NULL) {
		leaf -> word_ids[index] = word_id;
	} else {
		word_id -> next = leaf -> word_ids[index];
		leaf -> word_ids[index] = word_id;
	}
}

void insert_triax_node(TRINODE *node, TRIAX *triax, int id) {
	int index = triax -> letters[1];
	if (node -> leafs[index] == NULL) {
		node -> leafs[index] = new_trileaf();
		insert_triax_leaf(node -> leafs[index], triax, id);
	} else {
		insert_triax_leaf(node -> leafs[index], triax, id);
	}
}

void insert_triax(TRIROOT *root, TRIAX *triax, int id) {
	int index;
	while (triax != NULL) {
		index = triax -> letters[0];
		if (root -> nodes[index] == NULL) {
			root -> nodes[index] = new_trinode();
			insert_triax_node(root -> nodes[index], triax, id);
		} else {
			insert_triax_node(root -> nodes[index], triax, id);
		}
		triax = triax -> next;
	}
}

void debug_enumerate_triples(TRIROOT *root) {
	int i;
	int j;
	int k;
	TRINODE *node;
	TRILEAF *leaf;
	WORD_ID *word_id;
	for (i = 0; i < 255; i++) {
		node = root -> nodes[i];
		if (node == NULL) {
			continue;
		}
		for (j = 0; j < 255; j++) {
			leaf = node -> leafs[j];
			if (leaf == NULL) {
				continue;
			}
			for (k = 0; k < 255; k++) {
				word_id = leaf -> word_ids[k];
				if (word_id == NULL) {
					continue;
				}
				printf("%c%c%c\n", i, j, k);
				while (word_id != NULL) {
					printf("  %i\n", word_id -> id);
					word_id = word_id -> next;
				}
			}
		}
	}
}

void debug_enumerate_triax(TRIAX *triax) {
	while (triax != NULL) {
		printf("%c%c%c\n", triax -> letters[0], triax -> letters[1], triax -> letters[2]);
		triax = triax -> next;
	}
}

int wordix_index(WORDIX *wordix, char *word) {
	int id = wordix -> last_word_id;
	id++;
	insert_triax(wordix -> triroot, triaxize(word), id);
	wordix -> last_word_id = id;
	return id;
}

int entix_index(ENTIX *entix, TOKEN *tokens) {
	int id = entix -> last_entity_id;
	int word_id;
	id++;
	while (tokens != NULL) {
		word_id = wordix_index(entix -> wordix, tokens -> word);
		tokens = tokens -> next;
	}
	entix -> last_entity_id = id;
	return id;
}

WORD_ID *wordix_find_exact(WORDIX *wordix, TRIAX *triax) {
	return wordix -> triroot -> nodes [(int)triax -> letters[0]] -> leafs[(int)triax -> letters[1]] -> word_ids[(int)triax -> letters[2]];
}

QUERY_MATRIX *wordix_find_exact_matrix(WORDIX *wordix, TRIAX *triax) {
	QUERY_MATRIX *matrix = NULL;
	while (triax != NULL) {
		matrix = query_matrix_append(matrix, wordix_find_exact(wordix, triax));
		triax = triax -> next;
	}
	return matrix;
}

WORD_ID *query_intersect(QUERY_MATRIX *original) {
	QUERY_MATRIX *matrix = original;
	// Find minimum
	int min = MAX_WORD_ID;
	int intersect = 1;
	int intersections = 0;
	while (matrix != NULL) {
		if (matrix -> word_id -> id < min) {
			min = matrix -> word_id -> id;
		}
		printf("min: %i\n", min);
		matrix = matrix -> next;
	}
        matrix = original;
	while (matrix != NULL && intersect == 1) {
		if (matrix -> word_id -> id != min) {
			matrix -> word_id = matrix -> word_id -> next;
			//if (intersections == 0 && matrix -> word_id == NULL) {
			//	return;
			//}
			intersect = 0;
		}
		matrix = matrix -> next;
	}
}

void debug_enumarate_query_matrix(QUERY_MATRIX *matrix) {
	WORD_ID *word_id;
	while (matrix != NULL) {
		word_id = matrix -> word_id;
		while (word_id != NULL) {
			printf("%i ", word_id -> id);
			word_id = word_id -> next;
		}
		printf("\n");
		matrix = matrix -> next;
	}
}

int main() {
	//TRIROOT *root = new_triroot();
	//insert_triax(root, triaxize("haha"), 1);
	//debug_enumerate_triples(root);
	ENTIX *entix = new_entix();
	TOKEN *tokens = tokenize_text("tere, mina olen arvuti, kes sina oled ja mis sinu nimi on");
	entix_index(entix, tokens);
	QUERY_MATRIX *matrix = wordix_find_exact_matrix(entix -> wordix, triaxize("sina"));
	debug_enumarate_query_matrix(matrix);
	//query_intersect(matrix);
	CHUNKBASE *base = new_chunkbase("/home/raivo/chunks.test2");
	int pos1 = chunkbase_write(base, "terevanakere\n11", 13);
	int pos2 = chunkbase_write(base, "arvuti\n11", 7);
	printf("%s\n", chunkbase_read(base, pos1, 12));
	printf("%s\n", chunkbase_read(base, pos2, 7));
	chunkbase_close(base);
	return 0;
}
