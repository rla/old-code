#include <stdlib.h>
#include <time.h>
#include <malloc.h>
#include "file/FileDB.h"
#include "file/File.h"

char *word(char *line) {
	char *buffer = (char *) malloc(100);
	bool ok = false;
	int c = 0;
	for (int i = 4; i < 100; i++) {
		if (line[i] == ' ' && !ok) {
			ok = true;
		} else if (line[i] == ' ' && ok && c > 0) {
			break;
		} else {
			buffer[c] = line[i];
			c++;
		}
	}
	buffer[c] = '\0';
	return buffer;
}

int main() {
	FileDB fileDB("/tmp/test.wr");
	

	FILE *input = fopen("/tmp/words.dump2", "r");
	while (!feof(input)) {
		
		char *line = (char *) malloc(100);
		fgets(line, 100, input);
		File *file = newFile();
		assignName(file, word(line));
		fileDB.save(file);	
	}
	fclose(input);
	
	fileDB.print();
	
	fileDB.close();
	printf("Valmis!\n");
	return 0;
}
