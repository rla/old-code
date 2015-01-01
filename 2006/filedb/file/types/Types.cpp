#include "Types.h"

int isDocument(int type) {
	return (type > 0 || type <= 10);
}

int isDirectory(int type) {
	return (type == FILETYPE_DIR);
}
