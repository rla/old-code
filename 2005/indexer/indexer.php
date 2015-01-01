Indekseerija
<?php

$valid=array('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'š', 'z', 'ž', 't', 'u', 'v', 'w', 'õ', 'ä', 'ö', 'ü', 'x', 'y', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
$files=array('.txt', '.log', '.html', '.htm', '.bas', '.cpp', '.c','.h', '.java', '.pas', '.xml', '.php', '.xsl', '.asm', '.s', '.rtf');

$count=0; $size=0; $validfiles=0; $validsize=0;
$fp=fopen('valid.txt', 'w');
$all=false;

function validfile($filename) {
	global $files;
	return in_array(strrchr($filename, '.'), $files);
}

function directory($directory) {
	global $count;
	global $size;
	global $validfiles;
	global $validsize;
	global $words;
	global $fp;
	global $all;
	
	$d=@dir($directory);
	if (!$d) return;
	while ($entry=$d->read())
		if ($entry!='.' and $entry!='..') {
			$direntry=$directory .'/' .$entry;
			if (is_dir($direntry)) directory($direntry);
			else {
				$fsize=filesize($direntry);
				$count++;
				$size+=$fsize;
				if (validfile($direntry) || $all) {
					$validfiles++;
					$validsize+=$fsize;
					fputs($fp, $direntry ."\n");
				}
			}
		}
	$d->close();
}

mysql_connect('localhost', 'raivo', '');
mysql_select_db('indexer');

//Saame juurte nimekirja
$res=mysql_query("SELECT `dir`, `what` FROM `roots` ORDER BY `dir`") or die(mysql_error());
while ($result=mysql_fetch_array($res)) {
	if ($result['what']=='all') $all=true; else $all=false;
	directory('/home/raivo/' .$result['dir']);
}

fclose($fp);

echo "Failide arv on: " .$count ."\n" .
	"Failide suurus on kokku: " .$size ." baiti\n" .
	"Indekseeritavate failide arv on: " .$validfiles ."\n" .
	"Indekseeritavate failide suurus on kokku: " .$validsize ." baiti\n" .
	"Indekseeritavate failide nimistu on kirjutatud faili valid.txt\n";

mysql_close();	
	
?>