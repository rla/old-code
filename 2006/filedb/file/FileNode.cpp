#include <malloc.h>
#include "FileNode.h"
#include "File.h"

FileNode *newFileNode() {
	FileNode *fileNode = (FileNode *) malloc(sizeof(FileNode));
	for (int i = 0; i < NODE_SIZE; i++) {
		fileNode->files[i].directory = 0;
		fileNode->files[i].size = 0;
		assignName(&(fileNode->files[i]), "undefin");
		fileNode->pointers[i] = 0;
	}
	fileNode->pointers[NODE_SIZE] = 0;
	fileNode->count = 0;
	return fileNode;
}

FileNode *newEmptyFileNode() {
	return (FileNode *) malloc(sizeof(FileNode));
}
