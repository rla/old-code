#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>

#define CHARMAP struct t_charmap

CHARMAP {
	wchar_t ch;
	char value;
	float prob;
	CHARMAP *next;
};

CHARMAP *charmap_read(char *filename) {
	CHARMAP *map = NULL;
	wchar_t ch;
	int value;
	float prob;

	FILE *file = fopen(filename, "r");
	
	fclose(file);

	return map;
}
