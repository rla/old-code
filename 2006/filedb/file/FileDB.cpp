#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "FileDB.h"
#include "FileSize.h"
#include "File.h"

FileDB::FileDB(char *filename) {
	this->filename = filename;
	io = fopen(filename, "r+b");
	
	if (!io) {
		printf("The file did not exist, creating a new one");
		io = fopen(filename, "w+b");
	}
	
	if (!io) {
		printf("Some other error occured at opening");
	}
	
	size = FileSize(filename);
	printf("Opened %s - size: %i bytes\n", filename, size);
	
	if (size == 0) {
		printf("Since the file was empty, will create new root node\n");
		root = newFileNode();
		rewind(io);
		writeNode(root);
	} else {
		rewind(io);
		root = newEmptyFileNode();
		fread(root, sizeof(FileNode), 1, io);
		printf("Read root node, here is the first file name: %s\n", root->files[0].name);
	}
	
}

void FileDB::close() {
	fclose(io);
}

void FileDB::writeNode(FileNode *fileNode) {
	fwrite(fileNode, sizeof(FileNode), 1, io);
	size += sizeof(FileNode);
	fseek(io, size, SEEK_SET);
}

void FileDB::updateNode(FileNode *fileNode, int position) {
	if (position > 1000000000) {
		printf("update error");
	}
	fseek(io, position, SEEK_SET);
	fwrite(fileNode, sizeof(FileNode), 1, io);
}

FileNode *FileDB::readNode(int position) {
	if (position > 1000000000) {
		printf("read error");
	}
	FileNode *node = newEmptyFileNode();
	fseek(io, position, SEEK_SET);
	fread(node, sizeof(FileNode), 1, io);
	return node;
}

// Recursive save function. Tries to
// find suitable position and then updates
// the node.
void FileDB::save(File *file, FileNode *root, int position) {
	int i = 0;
	for (i = 0; i < root->count; i++) {
		File *temp = &(root->files[i]);
		int compval = compare(file, temp);
		if (compval >= 0) {
			if (root->count < NODE_SIZE) {
				shiftRight(root, i);
				root->files[i].directory = file->directory;
				memcpy(root->files[i].name, file->name, FILE_NAME_LENGTH);
				root->files[i].size = file->size;
				root->count++;
				updateNode(root, position);
			} else {
				int sub = root->pointers[i];
				if (sub == 0) {
					root->pointers[i] = size;
					updateNode(root, position);
					FileNode *newNode = newFileNode();
					save(file, newNode, size);
					free(newNode);
					size += sizeof(FileNode);
				} else {
					FileNode *node = readNode(root->pointers[i]);
					save(file, node, root->pointers[i]);
					free(node);
				}
			}
			return;
		}
	}
	
	if (i < NODE_SIZE) {
		root->files[i].directory = file->directory;
		memcpy(root->files[i].name, file->name, FILE_NAME_LENGTH);
		root->files[i].size = file->size;
		root->count++;
		updateNode(root, position);
	} else {
		int sub = root->pointers[NODE_SIZE];
		if (sub == 0) {
			root->pointers[NODE_SIZE] = size;
			updateNode(root, position);
			FileNode *newNode = newFileNode();
			save(file, newNode, size);
			free(newNode);
			size += sizeof(FileNode);
		} else {
			FileNode *node = readNode(root->pointers[NODE_SIZE]);
			save(file, node, root->pointers[NODE_SIZE]);
			free(node);
		}
	}
}

void FileDB::save(File *file) {
	// Try to put into root first,
	// then look elsewhere.
	save(file, root, 0);
}

// Compare two files.
int FileDB::compare(File *file1, File *file2) {
	return strcoll(file1->name, file2->name);
}

// Shift files to right from position 'from'.
void FileDB::shiftRight(FileNode *node, int from) {
	for (int i = NODE_SIZE-1; i > from; i--) {
		node->files[i] = node->files[i-1];
		node->pointers[i] = node->pointers[i-1];
	}
}

// Will print out the contents (for debuging purpose).
void FileDB::print() {
	print(root);
}

// Helping procedure for print(), uses recursion.
void FileDB::print(FileNode *root) {
	for (int i = 0; i < root->count; i++) {
		if (root->pointers[i] > 0) {
			FileNode *node = readNode(root->pointers[i]);
			print(node);
			free(node);
		}
		printf("%s\n", root->files[i].name);
	}
	if (root->pointers[NODE_SIZE] > 0) {
			FileNode *node = readNode(root->pointers[NODE_SIZE]);
			print(node);
			free(node);
	}
}

// Search for matching filename
SearchNode *FileDB::search(char *filename) {
	
}
