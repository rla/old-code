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

#ifndef __MULTIBYTE__
#define __MULTIBYTE__

#define MULTIBYTE struct t_multibyte
#define MULTIBYTE_SEQ struct t_multibyte_seq
#define MULTIBYTE_SIZE 2

/**
 * Structure to save characters that contain multiple characters.
 */
MULTIBYTE {
	unsigned char chars[MULTIBYTE_SIZE];
};

/**
 * Structure to save the sequence of multibyte characters.
 */
MULTIBYTE_SEQ {
	MULTIBYTE *mbyte;
	MULTIBYTE_SEQ *next;
};

/**
 * Function to read utf8 file into multibyte sequence.
 */
MULTIBYTE_SEQ *multibyte_file(char *filename);

/**
 * Helping function to detect if the multibyte is numeric (0..9).
 */
int multibyte_isnum(MULTIBYTE *mbyte);

/**
 * Helping function to detect if the multibyte is space.
 */
int multibyte_isspace(MULTIBYTE *mbyte);

/**
 * Helping function to detect if the multibyte is dot.
 */
int multibyte_isdot(MULTIBYTE *mbyte);

/**
 * Helping function to detect if the multibyte is line end.
 */
int multibyte_isle(MULTIBYTE *mbyte);

#endif
