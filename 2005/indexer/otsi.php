<?php

require('microtime.php');

mysql_connect('localhost', 'raivo', '');
mysql_select_db('indexer');

$start=microtime_float();

/*
Leiame sõnadele vastavad indeksid.
*/
$words_in=array();

$res=mysql_query("select id from words where word='raivo' or word='laanemets'");
while ($result=mysql_fetch_row($res)) $words_in[]=$result[0];

echo "Sõnade indeksid: \n";
print_r($words_in);

mysql_query("create temporary table temp1 (`file` int, primary key(`file`))");
mysql_query("insert into temp1 (`file`) select `file` from `word_files` where word=" .$words_in[1]);

$res=mysql_query("select count(*) from temp1");
$result=mysql_fetch_row($res);

echo "Esimese sõna otsing andis tulemusi: " .$result[0] ."\n";

mysql_query("create temporary table temp2 (`file` int, primary key(`file`))");
mysql_query("insert into temp2 (`file`) select `file` from word_files where word=" .$words_in[0]);

$res=mysql_query("select count(*) from temp2");
$result=mysql_fetch_row($res);
echo "Teise sõna otsing andis tulemusi: " .$result[0] ."\n";

mysql_query("create temporary table temp3 (`file` int, primary key(`file`))");
mysql_query("insert into temp3 (`file`) select temp1.file from temp1, temp2 where temp1.file=temp2.file");

$res=mysql_query("select count(*) from temp3");
$result=mysql_fetch_row($res);
echo "Kahe otsingu ühisosa suurus on: " .$result[0] ."\n";

$res=mysql_query("select files.name from files, temp3 where temp3.file=files.id");
while ($result=mysql_fetch_row($res)) echo $result[0] ."\n";

echo "Aega läks: " .(microtime_float()-$start) ."\nVigu: " .mysql_error() ."\n";

mysql_close();

?>