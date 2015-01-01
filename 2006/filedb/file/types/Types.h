/*
 * Failide tüüpe tähistavate konstantide kirjeldused.
 * Raivo Laanemets 
 */

#define FILETYPE_TXT 1
#define FILETYPE_PDF 2
#define FILETYPE_HTML 3
#define FILETYPE_HTM 4

#define FILETYPE_MPG 10
#define FILETYPE_AVI 11
#define FILETYPE_WMV 12

#define FILETYPE_JPG 20
#define FILETYPE_PNG 21
#define FILETYPE_GIF 22
#define FILETYPE_BMP 23

#define FILETYPE_MP3 30
#define FILETYPE_OGG 31
#define FILETYPE_FLAC 32
#define FILETYPE_WAV 33

#define FILETYPE_DIR 100

int isDirectory(int type);
int isDocument(int type);
int isAudio(int type);
int isVideo(int type);
int isImage(int type);
