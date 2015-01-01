#include <stdio.h>
#include "File.h"
#include "FileNode.h"
#include "search/Search.h"

#ifndef FILEDB_H_
#define FILEDB_H_

class FileDB {
private:
	char *filename;
	FILE *io;
	int size;
	FileNode *root;
	void writeNode(FileNode *fileNode);
	void updateNode(FileNode *fileNode, int position);
	void save(File *file, FileNode *root, int position);
	int compare(File *file1, File *file2);
	void shiftRight(FileNode *fileNode, int from);
	FileNode *readNode(int position);
	void print(FileNode *fileNode);
public:
	FileDB(char *filename);
	void close();
	void save(File *file);
	void print();
	SearchNode *search(char *filename);
};

#endif /*FILEDB_H_*/
