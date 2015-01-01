#include <sys/types.h>
#include <sys/dir.h>
#include <sys/param.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include "file/File.h"
#include "file/FileDB.h"

#define DIRNAME_BUFFER_SIZE 20000

extern  int alphasort();

void scan(char *directory, FileDB *fileDB) {
	struct direct **files;
	struct stat stat_p;
	char buffer[DIRNAME_BUFFER_SIZE];
	buffer[0] = '\0';
	File *file = new File();
	
	int count = scandir(directory, &files, 0, alphasort);
	for (int i = 0; i < count; i++) {
		if (strcmp(files[i]->d_name, ".") == 0 || strcmp(files[i]->d_name, "..") == 0) continue;
		
		
		buffer[0] = '\0';
		strncat(buffer, directory, strlen(directory));
		strncat(buffer, files[i]->d_name, strlen(files[i]->d_name));
		
		if (strlen(buffer) + strlen(files[i]->d_name) >= DIRNAME_BUFFER_SIZE - 40) {
			printf("BIG ERROR");
		}
			
		if (lstat(buffer, &stat_p) == -1) {
			continue;
		}
		
		if (S_ISDIR(stat_p.st_mode) && !S_ISLNK(stat_p.st_mode)) {
			strncat(buffer, "/", 1);
			scan(buffer, fileDB);
		}
		
		if (strlen(files[i]->d_name) >= FILE_NAME_LENGTH-2) {
			continue;
		}
		
		assignName(file, files[i]->d_name);
		file->size = files[i]->d_reclen;
		fileDB->save(file);
	}
}

int main() {
	
    FileDB *fileDB = new FileDB("/tmp/testscan.db");
	scan("/", fileDB);
	fileDB->print();
	
	fileDB->close();
	printf("Valmis!\n");
	return 0;
}
