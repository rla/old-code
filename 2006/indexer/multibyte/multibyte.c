/*
RL Multibyte Library
Copyright (C) 2006 Raivo Laanemets

Contact: Raivo Laanemets, rlaanemt@ut.ee

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <stdio.h>
#include <stdlib.h>
#include "multibyte.h"

MULTIBYTE *new_multibyte() {
	MULTIBYTE *mbyte = malloc(sizeof(MULTIBYTE));
	int i;
	for (i = 0; i < MULTIBYTE_SIZE; i++) {
		mbyte -> chars[i] = 0;
	}
	return mbyte;
}

MULTIBYTE_SEQ *new_multibyte_seq() {
	MULTIBYTE_SEQ *seq = malloc(sizeof(MULTIBYTE_SEQ));
	seq -> mbyte = NULL;
	seq -> next = NULL;
	return seq;
}

MULTIBYTE_SEQ *multibyte_append(MULTIBYTE_SEQ *tail, MULTIBYTE *mbyte) {
	MULTIBYTE_SEQ *head = new_multibyte_seq();
	head -> next = tail;
	head -> mbyte = mbyte;
	return head;
}

MULTIBYTE_SEQ *multibyte_file(char *filename) {
	MULTIBYTE_SEQ *seq = NULL;
	MULTIBYTE *mbyte = NULL;
	FILE *file = fopen(filename, "rb");
	int a;
	int b;
	if (!file) {
		return NULL;
	}
	while ((a = fgetc(file)) != EOF) {
		mbyte = new_multibyte();
		if (a > 127) {
			b = fgetc(file);
			if (b == EOF) {
				return seq;
			}
			mbyte -> chars[0] = a;
			mbyte -> chars[1] = b;
			seq = multibyte_append(seq, mbyte);
		} else {
			mbyte -> chars[0] = a;
			seq = multibyte_append(seq, mbyte);
		}
	}
	fclose(file);
	return seq;
}

int multibyte_isnum(MULTIBYTE *mbyte) {
	return ((mbyte -> chars[1]) == 0 && (mbyte -> chars[0] >= 48) && (mbyte -> chars[0] <= 57));
}

int multibyte_isspace(MULTIBYTE *mbyte) {
	return ((mbyte -> chars[1] == 0) && (mbyte -> chars[0] == 32));
}

int multibyte_isdot(MULTIBYTE *mbyte) {
	return ((mbyte -> chars[1] == 0) && (mbyte -> chars[0] == 46));
}

int multibyte_isle(MULTIBYTE *mbyte) {
	return ((mbyte -> chars[1] == 0) && (mbyte -> chars[0] == 10));
}

#ifdef DEBUG

void debug_seq(MULTIBYTE_SEQ *seq) {
	unsigned char a;
	unsigned char b;
	while (seq != NULL) {
		a = seq -> mbyte -> chars[0];
		b = seq -> mbyte -> chars[1];
		printf("a = %i\n", a);
		printf("b = %i\n", b);
		seq = seq -> next;
	}
}

int main() {
	MULTIBYTE_SEQ *file = multibyte_file("proov.utf8");
	debug_seq(file);
	return 0;
}

#endif
