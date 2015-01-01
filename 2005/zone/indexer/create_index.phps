<?php

$files=array('.txt', '.log', '.html', '.htm', '.bas', '.cpp', '.c','.h', '.java', '.pas', '.xml', '.php', '.xsl', '.asm', '.s', '.doc', '.rtf');
//$files=array('.pdf');
$special=array('makefile', 'readme', 'todo', 'install', 'notice', 'license', );
$valid=array('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'š', 'z', 'ž', 't', 'u', 'v', 'w', 'õ', 'ä', 'ö', 'ü', 'x', 'y', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

mysql_connect('localhost', 'raivo', '');
mysql_select_db('indexer');

function getword($fp) {
	global $valid;
	$buffer='';
	while (!feof($fp)) {
		$ch=fgetc($fp);
		$ch=strtolower($ch);
		if (in_array($ch, $valid)) $buffer.=$ch;
		else if (strlen($buffer)>1) break;
	}
	return trim($buffer);
}

$c=0;

function process_directory($dir, $parentid) {
	global $files;
	global $special;
	global $c;
	try {
	$di=new DirectoryIterator($dir);
	} catch (Exception $e) { return; }
	while ($di->valid()) {
		echo "Nodes: " .$c++ ."\n";
		if ($di->isDir() && !$di->isDot() && !$di->isLink()) {
			mysql_query("INSERT into nodes (type, path, mtime, atime, size, parent) VALUES ('directory', '" .$di->getPathname() ."', " .$di->getMTime() .", " .$di->getATime() .", " .$di->getSize() .", " .$parentid .")");
			process_directory($di->getPathname(), mysql_insert_id());
		} else if ($di->isFile()) {
			mysql_query("INSERT into nodes (type, path, mtime, atime, size, hash, parent) VALUES ('file', '" .$di->getPathname() ."', " .$di->getMTime() .", " .$di->getATime() .", " .$di->getSize() .", " .md5_file($di->getPathname()) .", " .$parentid .")");

			$id=mysql_insert_id();
			if (in_array(strrchr($di->getFilename(), '.'), $files) or in_array(strtolower($di->getFilename()), $special)) {
		
				$fp=fopen($di->getPathname(), 'rb');
				echo "Indexing " .$di->getPathname() ."\n";
				while (!feof($fp)) {
					if ($word=getword($fp)) {
						$res=mysql_query("SELECT id FROM words WHERE word='" .$word ."'");
						if ($result=mysql_fetch_row($res)) {
							$wid=$result[0];
						} else {
							mysql_query("INSERT INTO words (word) VALUES ('" .$word ."')");
							$wid=mysql_insert_id();
						}
						mysql_query("INSERT INTO node_words (node, word) VALUES (" .$id .", " .$wid .")");
					}
				}
				fclose($fp);
			}

		}
		$di->next();
	}
}

process_directory('/home/raivo', 0);


?>