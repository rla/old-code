DROP TABLE word;
DROP TABLE indexedfile;
DROP TABLE file_word;

CREATE TABLE word (
	id int,
	word char(22)
);

CREATE TABLE indexedfile (
	id int,
	name char(255)
);

CREATE TABLE file_word (
	file_id int,
	word_id int
);

CREATE TABLE word_count (
	word_id int,
	word_count int,
	CONSTRAINT pk_word_count PRIMARY KEY(word_id)
);