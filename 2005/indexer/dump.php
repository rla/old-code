<?php

mysql_connect('localhost', 'raivo', '');
mysql_select_db('indexer');

$word_files=file('word_files.txt');
$words=file('words.txt');
$files=file('files.txt');

echo "Sõnade salvestamine\n";
mysql_query("TRUNCATE `words`");
foreach ($words as $value) {
	list($id, $word)=explode(',', $value);
	mysql_query("INSERT INTO `words` (`id`, `word`) VALUES (" .$id .", '" .trim($word) ."')");
}

echo "Failide salvestamine\n";
mysql_query("TRUNCATE `files`");
foreach ($files as $value) {
	list($id, $file)=explode(',', $value);
	mysql_query("INSERT INTO `files` (`id`, `name`) VALUES (" .$id .", '" .trim($file) ."')");
}

echo "Faili->sõna seose salvestamine\n";
mysql_query("TRUNCATE word_files");
foreach ($word_files as $value) {
	list($word, $file)=explode(' ', $value);
	mysql_query("INSERT INTO `word_files` (`word`, `file`) VALUES (" .$word .", " .$file .")");

}

mysql_close();

?>