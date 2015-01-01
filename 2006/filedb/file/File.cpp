#include <malloc.h>
#include <string.h>
#include "File.h"

void assignName(File *file, char *ch) {
	int current_length = strlen(ch);
	for (int i = 0; i < FILE_NAME_LENGTH; i++) {
		if (i < current_length) {
			file->name[i] = ch[i];
		} else {
			file->name[i] = '\0';
		}
	}
}

File *newFile() {
	File *file = (File *) malloc(sizeof(File));
	file->directory = 0;
	file->size = 0;
	assignName(file, "undefined");
	return file;
}
