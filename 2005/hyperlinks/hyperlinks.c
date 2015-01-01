/*
Hyperlinks
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
Separates links from the stream of HTML code.
No error checking but the code works well
on correct HTML markup.

Raivo Laanemets, summer 2006
*/

#include <stdio.h>

/*
States for the parser.
*/

#define STATE_A 1
#define STATE_TAG_START 3
#define STATE_TEXT 4
#define STATE_HREF 5
#define STATE_URL 6
#define STATE_HREF1 7
#define STATE_ENC 8
#define STATE_ENC1 9

/*
Finds code for numerical character. Used for
URL decoding.
*/

int code(c) {
	if (c >= '0' && c <= '9') {
		return (c-48);
	} else if (c >= 'a' && c <= 'f') {
		return (c-97+10);
	} else if (c >= 'A' && c <= 'F') {
		return c-'A'+10;
	} else {
		return 0;
	}
}

/*
The parser. Reads the stream from the standard input and writes
URL's to the standard output, appends line end to each URL.
*/

int main() {
	int c = 0;
	int state = STATE_TEXT;
	int enc_x = 0;
	int enc_y = 0;
	int enc = 0;
	while((c = getchar()) != EOF) {
		switch (state) {
		case STATE_TEXT: {
			if (c == '<') {
				state = STATE_TAG_START;
			}
			continue;
		}
		case STATE_TAG_START: {
			if (c == 'a' || c == 'A') {
				state = STATE_A;
			} else if (c == '>') {
				state = STATE_TEXT;
			}
			continue;
		}
		case STATE_A: {
			if (c == '>') {
				state = STATE_TEXT;
			} else if (c == 'h' || c == 'H') {
				state = STATE_HREF1;
			}
			continue;
		}
		case STATE_HREF1: {
			if (c == 'r' || c == 'R') {
				state = STATE_HREF;
			} else {
				state = STATE_A;
			}
			continue;
		}
		case STATE_HREF: {
			if ( c == '=') {
				state = STATE_URL;
			}
			continue;
		}
		case STATE_URL: {
			if (c == ' ') {
				state = STATE_A;
				printf("\n");
			} else if (c == '>') {
				state = STATE_TEXT;
				printf("\n");
			} else if (c == '%') {
				state = STATE_ENC;
			} else if (c != '"') {
				printf("%c", c);
			}
			continue;
		}
		case STATE_ENC: {
			enc_x = code(c);
			state = STATE_ENC1;
			continue;
		}
		case STATE_ENC1: {
			enc_y = code(c);
			enc = enc_x * 16 + enc_y;
			printf("%c", enc);
			state = STATE_URL;
			continue;
		}
		}
	}
	return 0;
}
