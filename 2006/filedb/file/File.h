#ifndef FILE_H_
#define FILE_H_

#define FILE_NAME_LENGTH 50
#define File struct t_file

File {
	char name[FILE_NAME_LENGTH];
	long size;
	long directory;
	short type;
};

void assignName(File *file, char *ch);
File *newFile();

#endif /*FILE_H_*/
