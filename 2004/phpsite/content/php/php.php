<?php

/*
Php objektide muutmiseks mõeldud skript.
Raivo Laanemets 2004

Lisatud põhikoosseisu alates versioonist 0.06
*/

include_once('func/admin.php');

switch($_GET['act']) {

case 'php_sisu':
	SetTitle('Objektid - php');
    $path=ReadSetting('admin_path');
    print 'Fail <b>' .$_GET['file'] .'</b>.<br><br>';
    highlight_file($path .'/content/php/' .$_GET['file']);
break;

case 'php_edit':
	SetTitle('Objektid - php');

    $path=ReadSetting('admin_path');

    print 'Fail <b>' .$_GET['file'] .'</b>.<br><br>';

    print '<form action="func/objects.php" method="post">
    <input type="hidden" name="act" value="save_html">
    <input type="hidden" name="file" value="' .$path .'/content/js/' .$_GET['file'] .'">
    <textarea name="sisu" cols="70" rows="15" wrap="off">';
    $fname=$path .'/content/php/' .$_GET['file'];
    $fp=fopen($fname, 'r');
    $content=fread($fp, filesize($fname));
    print htmlentities($content);
    fclose($fp);
    print '</textarea><br>
    <input type="submit" value="salvesta" class="button">
    </form>';
break;

default:
	SetTitle('Objektid - php');

	$path=ReadSetting('admin_path');
    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> php objektid.<br><br>
    <table><tr><th>Fail</th><th>Suurus (baitides)</th></tr>';

    $d=dir($path .'/content/php');
    while($entry=$d->read()) {
    	if($entry!='.' && $entry!='..') print '<tr><td>' .$entry .'</td><td>' .filesize($path .'/content/php/' .$entry) .'</td>
        <td><a href="?id=php&amp;act=php_sisu&amp;file=' .$entry .'" class="textlink">näita sisu</a></td>
        <td><a href="?id=php&amp;act=php_edit&amp;file=' .$entry .'" class="textlink">redigeeri</a></td></tr>';
    }
    $d->close();
    print '</table>';
break;

}

?>