<?php

/*
Lehtede muutumiseks vajalik script.
Raivo Laanemets 2004
*/

global $local_conf;
global $title;

$act=$_GET['act'];

switch($act) {
case 'uus':
    $title='Lehed - uus';
	Object('title', 'ee');
    print '<form method="post" action="func/pages.php">
    <input type="hidden" name="act" value="new">
    <input type="hidden" name="path">
    Lehekülje nimi:<br>
    <input type="text" name="nimi"><br>
    Pealkiri:<br>
    <input type="text" name="pealkiri"><br>
    Sisu:<br>
    <textarea rows="15" cols="70" wrap="off" name="sisu"></textarea>
    <input type="submit" value="Edasi->" class="button">
    </form>';
break;
case 'muuda':
    $title='Lehed - muutmine';
	Object('title', 'ee');
    print '<form method="post" action="func/pages.php">
    <input type="hidden" name="act" value="save">
    <input type="hidden" name="filename" value="' .$local_conf['main']['path'] .'/content/pages/' .$_GET['tmp'] .'">
    Lehe sisu (kasuta &lt;pre&gt;&lt/pre&gt; tääke formaaditud teksti puhul):<br>
    <textarea name="temp" rows="20" cols="80" wrap="off">';
    $fp=fopen($local_conf['main']['path'] .'/content/pages/' .$_GET['tmp'], 'r');
    while(!feof($fp)) {
    	$out=fgets($fp, 4096);
        print $out;
    }
    //print fread($fp, filesize($local_conf['main']['path'] .'/temps/' .$_GET['tmp']));
    fclose($fp);
    print '</textarea><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'del':
	//unlink($local_conf .'/temps/' .$_GET['tmp']);
    print '<script language="JavaScript">
	window.location="index.php?id=lehed";
	</script>';
break;
default:
	//$title peab olema seatud enne title Objekti kutsumist.
    $title='Lehed';
	Object('title', 'ee');
    $d=FiniGetValue($local_conf, 'main', 'path', '.') .'/content/pages';
    $temps=dir($d);
    while($entry=$temps->read()) {
    	if ((!is_dir($entry)) && ($entry!='.') && ($entry!='..')) print $entry .'
        	<a href="?id=lehed&amp;act=muuda&amp;tmp=' .$entry .'" class="textlink">Muuda</a>
            <a href="?id=lehed&amp;act=del&amp;tmp=' .$entry .'" class="textlink">Kustuta</a><br>';
    }
    $temps->close();
    print '<a href="?id=lehed&amp;act=uus" class="textlink">Lisa</a>';
}

?>