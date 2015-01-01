/*
Directory cleaner from backup files 
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

#include <dirent.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

#define DIRENT struct dirent
#define STAT struct stat

void loop(char *dir) {

	DIR *dirp;
	DIRENT *entry;
	STAT st;
	char *buffer;
	int len_dir;
	int len;

	if ((dirp = opendir(dir)) == NULL) return;

	len_dir = strlen(dir);
	
	do {
		if ((entry = readdir(dirp)) != NULL) {
			if (strcmp(entry -> d_name, ".") == 0) continue;
			if (strcmp(entry -> d_name, "..") == 0) continue;

			len = strlen(entry -> d_name) + len_dir + 2;

			buffer = malloc(len);
			buffer[0] = '\0';

			strcat(buffer, dir);
			strcat(buffer, "/");
			strcat(buffer, entry -> d_name);

			lstat(buffer, &st);

			if (S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode)) loop(buffer);
			
			if (buffer[len-2] == '~') {
				printf("%s\n", buffer);
				unlink(buffer);
			}

			free(buffer);
		}
	} while (entry != NULL);

	closedir(dirp);
}

int main(int argc, char **argv) {
	if (argc == 1) {
		printf("usage: cleaner directory\n");
		return 1;
	}
	loop(argv[1]);
	return 0;
}
