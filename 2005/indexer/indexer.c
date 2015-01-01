#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "db.c"
#include "format.c"

/*
42 - *
44 - ,
48 - 0
57 - 9
64 - @
65 - a
94 - ~
95 - _
97 - A
*/
int isvalid(ch) {
	if (ch>=65 && ch<=90) return 1;
	else if (ch>=97 && ch<=122) return 1;
	else if (ch>=48 && ch <=57) return 1;
	else if (ch==95) return 1;
	return iseesti(ch);
}

int main() {
	FILE *fp;
	FILE *input;
	int size;
	char *buffer;
	char *word;
	char *file;
	int i;
	char ch;
	int r;
	TWORD *words;
	TFILE *files;
	TFILE *lastfile;
	
	words=newWord();
	files=newFile();
	lastfile=files;	
	
	input=fopen("valid.txt", "r");
	
	file=malloc(1024);
	word=malloc(51);
	while (!feof(input)) {
	
		i=0;
		do {
			ch=fgetc(input);
			if (ch!='\n') file[i]=ch;
			i++;
		} while (ch!=EOF && ch!='\n');
		
		file[i]='\0';
		
		//Avame faili
		fp=fopen(file, "r");
		if (fp==NULL) continue;
		
		//Lisame faili andmebaasi
		lastfile=addFile(lastfile, file);

		//Loeme faili sisu puhvrisse
		fseek(fp, 0, SEEK_END);
		size=ftell(fp);
		rewind(fp);
	
		buffer=malloc(size);
		fread(buffer, 1, size, fp);
		
		i=0;
		r=0;
		
		//Jagame faili sõnadeks ja salvestame need andmebaasi
		while (i<size) {
			ch=buffer[i];
			if (isvalid(ch)) {
				if (ch>=65 && ch<=90) ch=ch+32;
				word[r]=ch;
				r++;
				if (r>50) r=0;
			} else if (r>1) {
				word[r]=0;
				//Numbreid ei lisata ja numbriga algavaid sõnu ei lisa.
				if (!is_numeric(word) && (word[0]<48 || word[0]>57)) {
					addWord(words, word, lastfile);
				}
				r=0;
			} else {
				r=0;
			}
			i++;
		}
		
		fclose(fp);
		free(buffer);
	}
	
	fclose(input);
	
	printf("Failide indeksi salvestamine\n");
	dumpFileDB(files, "files.txt");
	printf("Sõnade indeksi salvestamine\n");
	dumpWordDB(words, "words.txt");
	printf("Sõna->Faili seose salvestamine\n");
	dumpWordFileDB(words, "word_files.txt");
	
	return 0;
}
