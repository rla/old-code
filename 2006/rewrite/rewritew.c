/*
Rewrite - simple text rewriting engine
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
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston
*/

/*
Usage:

:$ rewritew term substitution

Replaces all occurences of <%term%> in input text with the contents
of the file file.txt. 

Raivo Laanemets, 18.11.06
*/

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>

/*
States for the parser.
*/

#define STATE_TEXT 1
#define STATE_TERM 2
#define STATE_TERM_END 3

int main(int argc, char **argv) {
	int c = 0;
	int c1 = 0;
	int state = STATE_TEXT;
	int i = 0;	

	if (argc < 3) {
		printf("Usage: rewrite term substituition\n");
		return 1;
	}

	int t = strlen(argv[1]);
	char *buffer = malloc(100);

	while((c = getchar()) != EOF) {
		switch (state) {
			case STATE_TEXT: {
				if (c == '<') {
					c1 = getchar();
					if (c1 == EOF) { return 0; }
					if (c1 == '%') {
						i = 0;
						state = STATE_TERM;
					} else {
						putchar(c);
						putchar(c1);
					}
				} else {
					putchar(c);
				}
				continue;
			}
			case STATE_TERM: {
				if (c == '%') {
					state = STATE_TERM_END;
				} else {
					if (i > 98) { return 1; }
					buffer[i] = c;
					i++;
				}
				continue;
			}
			case STATE_TERM_END: {
				if (c == '>') {
					state = STATE_TEXT;
					buffer[i] = '\0';
					if (i == t && strcmp(buffer, argv[1]) == 0) {
						printf("%s", argv[2]);
					} else {
						printf("<%c%s%c>", '%', buffer, '%');
					}
				} else {
					return 1;
				}
				continue;
			}
		}
	}
	return 0;
}
