#include <stdlib.h>
#include <stdio.h>

#define CHUNKBASE struct t_chunkbase

CHUNKBASE {
	char *filename;
	FILE *file;
	int end_of_file;
};

CHUNKBASE *new_chunkbase(char *filename) {
	CHUNKBASE *base = malloc(sizeof(CHUNKBASE));
	base -> filename = filename;
	base -> file = fopen(filename, "w");
	base -> end_of_file = 0;
	return base;
}

void chunkbase_close(CHUNKBASE *base) {
	fclose(base -> file);
}

int chunkbase_write(CHUNKBASE *base, void *buffer, int size) {
	int position = base -> end_of_file + 1;
	fseek(base -> file, position, SEEK_SET);
	fwrite(buffer, size, 1, base -> file);
	base -> end_of_file = position + size;
	return position;
}

void *chunkbase_read(CHUNKBASE *base, int position, int size) {
	void *ptr = malloc(size);
	fseek(base -> file, position, SEEK_SET);
	fread(ptr, size, 1, base -> file);
	return ptr;
}
