#include <fstream>
#include "FileSize.h"

int FileSize(const char* sFileName) {
	std::ifstream f;
	f.open(sFileName, std::ios_base::binary | std::ios_base::in);
	if (!f.good() || f.eof() || !f.is_open()) {
		return 0;
	}
	f.seekg(0, std::ios_base::beg);
	std::ifstream::pos_type begin_pos = f.tellg();
	f.seekg(0, std::ios_base::end);
	return static_cast<int>(f.tellg() - begin_pos);
}
