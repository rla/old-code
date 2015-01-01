#include <string.h>
#include <stdio.h>
#include "db.h"

/*
Teeb stringist uue koopia.
*/
char *strcopy(char *string) {
	char *ret=malloc(strlen(string)+1);
	strcpy(ret, string);	
	return ret;
}

/*
Uue failide struktuuri tipu loomine.
*/

TFILE *newFile() {
	TFILE *f=malloc(sizeof(TFILE));
	f->name=NULL;
	f->next=NULL;
	return f;
}

/*
Uue sõna failide puu tipu loomine.
*/

TWORDFILE *newWordFile() {
	TWORDFILE *wf=malloc(sizeof(TWORDFILE));
	wf->left=NULL;
	wf->right=NULL;
	wf->file=NULL;
	return wf;
}

/*
Uue sõnade puu tipu loomine.
*/

TWORD *newWord() {
	TWORD *t=malloc(sizeof(TWORD));
	t->left=NULL;
	t->right=NULL;
	t->word=NULL;
	t->files=NULL;
	return t;
}

/*
Uue faili lisamine, tagastab viida loodud struktuurile.
Sisendparameetriks on viit eelmise faili struktuurile.
*/
TFILE *addFile(TFILE *lastone, char *file) {
	TFILE *ffile;
	if (lastone->name==NULL) {
		lastone->name=strcopy(file);
		return lastone;
	} else {
		ffile=newFile();
		ffile->name=strcopy(file);
		lastone->next=ffile;
		return ffile;
	}
}

/*
Uue faili lisamine sõna failide kahendpuus.
*/
void addWordFile(TWORDFILE *root, TFILE *file) {
	TWORDFILE *current;
	TWORDFILE *parent;
	int flag;
	
	if (root->file==NULL) {
		root->file=file;
		return;
	}
		
	flag=1;
	current=parent=root;
	while (current!=NULL) {
		parent=current;
		if (current->file>file) { current=current->left; flag=1; }
		else if (current->file<file) { current=current->right; flag=2; }
		else return;
	}
	current=newWordFile();
	current->file=file;
	if (flag==1) parent->left=current;
	else parent->right=current;
}

/*
Otsib andmebaasist sõna, mis sobib ja tagastab
selle id, muidu lisab uue sõna ja loob uue id
(tagastab ka selle).
*/
void addWord(TWORD *root, char *word, TFILE *file) {
	TWORD *current;
	TWORD *parent;

	int flag=1;
	int cmp;
	
	if (root->word==NULL) {
		root->word=strcopy(word);
		root->files=newWordFile();
		addWordFile(root->files, file);
		return;
	} else {
		current=root;
		parent=root;
		while (current!=NULL) {
			parent=current;
			cmp=strcmp(current->word, word);
			if (cmp>0) {
				current=current->left;
				flag=1;
			} else if (cmp<0) {
				current=current->right;
				flag=2;
			} else {
				if (current->files==NULL) current->files=newWordFile();
				addWordFile(current->files, file);		
				return;
			}
		}
		current=newWord();
		current->word=strcopy(word);
		if (current->files==NULL) current->files=newWordFile();
		addWordFile(current->files, file);
		if (flag==1) parent->left=current; else parent->right=current;
	}
}

/*
Sõnade andmebaasi kirjete
salvestamine faili.
*/
void dumpWordDBRecord(TWORD *word, FILE *fp) {
	if (word==NULL) return;
	dumpWordDBRecord(word->left, fp);
	fprintf(fp, "%i,%s\n", (int)word, word->word);
	dumpWordDBRecord(word->right, fp);
}

/*
Failide andmebaasi väljaprintimine.
*/
void printFileDB(TFILE *file) {
	if (file==NULL) return;
	printf("%s\n", file->name);
	printFileDB(file->next);
}

/*
Failide andmebaasi faili kirjutamine.
*/
void dumpFileDB(TFILE *file, char *filename) {
	FILE *fp;
	TFILE *lfile=file;
	fp=fopen(filename, "w");
	while (lfile!=NULL) {
		fprintf(fp, "%i,%s\n", (int)lfile, lfile->name);
		lfile=lfile->next;
	}
	fclose(fp);
}

void dumpFileRecord(TWORDFILE *wf, TWORD *word, FILE *fp) {
	if (wf==NULL) return;
	dumpFileRecord(wf->left, word, fp);
	fprintf(fp, "%i %i\n", (int)word, (int)wf->file);
	dumpFileRecord(wf->right, word, fp);
}

void dumpWordFileRecord(TWORD *word, FILE *fp) {
	if (word==NULL) return;
	dumpWordFileRecord(word->left, fp);
	dumpFileRecord(word->files, word, fp);
	dumpWordFileRecord(word->right, fp);
}

/*
Sõna->faili andmebaasi faili kirjutamine.
*/
void dumpWordFileDB(TWORD *word, char *filename) {
	FILE *fp;
	fp=fopen(filename, "w");
	dumpWordFileRecord(word, fp);
	fclose(fp);
}

/*
Sõnade andmebaasi faili kirjutamine.
*/
void dumpWordDB(TWORD *word, char *filename) {
	FILE *fp;
	fp=fopen(filename, "w");
	if (!fp) {
		printf("Ei saa avada faili %s\n!", filename);
		return;
	}
	dumpWordDBRecord(word, fp);
	fclose(fp);
}
