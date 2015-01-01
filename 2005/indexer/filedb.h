#include "worddb.h"

#define TFILEWORD struct t_file_word

struct t_file_word {
	struct t_word *word;
	struct t_file_word *next;
}

#define TFILE struct t_file

struct t_file {
	char *name;
	struct t_file *next;
	struct t_word *words;
}