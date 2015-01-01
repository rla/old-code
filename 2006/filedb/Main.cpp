#include <stdio.h>
#include "file/File.h"
#include "file/FileDB.h"

int main() {
	FileDB fileDB("/tmp/test.wr");
	
	File *file = newFile();
	assignName(file, "b");
	fileDB.save(file);
	fileDB.print();
	
	fileDB.close();
	printf("Valmis!\n");
	return 0;
}
