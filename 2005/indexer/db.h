#define TFILE struct t_file

TFILE {
	char *name;
	TFILE *next;
};

#define TWORDFILE struct t_word_file

TWORDFILE {
	TFILE *file;
	TWORDFILE *left;
	TWORDFILE *right;
};

#define TWORD struct t_word

TWORD {
	TWORD *left;
	TWORD *right;
	char *word;
	TWORDFILE *files;
};



/*
Andmebaasi struktuur.
*/
