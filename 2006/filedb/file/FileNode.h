#include "File.h"

#ifndef FILENODE_H_
#define FILENODE_H_

#define NODE_SIZE 200
#define FileNode struct t_filenode

FileNode {
	int count;
	File files[NODE_SIZE];
	int pointers[NODE_SIZE+1];
};

FileNode *newFileNode();
FileNode *newEmptyFileNode();

#endif /*FILENODE_H_*/
