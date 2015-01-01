#include <stdlib.h>
#include <string.h>

/*
õ=-11
Õ=-43
ä=-28
Ä=-60
ö=-10
Ö=-42
ü=-4
Ü=-36
*/

char eesticonvert(char ch) {
	if (ch==-11 || ch==-43) return 'o';
	else if (ch==-28 || ch==-60) return 'a';
	else if (ch==-10 || ch==-42) return 'o';
	else if (ch==-4 || ch==-36) return 'u';
	else return ch;
}

int iseesti(char ch) {
	if (ch==-11 || ch==-43 || ch==-28 || ch==-60 || ch==-10 || ch==-42 || ch==-4 || ch==-36) return 1;
	else return 0;
}

int is_numeric(char *str) {
	char *end_ptr;
	int length=strlen(str);
	
	strtol(str, &end_ptr, 10);
        if (end_ptr==str+length) return 1;

	strtod(str, &end_ptr);
	if (end_ptr == str+length) return 1;
	
	return 0;
}
