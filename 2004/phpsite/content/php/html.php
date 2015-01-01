<?php

/*
Html objektide muutmise skript
Raivo Laanemets 2004
*/

include_once('func/admin.php');

switch($_GET['act']){
case 'html_edit':
	SetTitle('Objektid - Html - Muuda');

    $path=ReadSetting('admin_path');

    print 'Fail <b>' .$_GET['file'] .'</b>.<br>
    <a href="index.php?id=validate&amp;struct=simple&amp;file=' .$path .'/content/html/' .$_GET['file'] .'" class="textlink" target="validate">Valideeri</a><br>';

    print '<form action="func/objects.php" method="post">
    <input type="hidden" name="act" value="html_save">
    <input type="hidden" name="file" value="' .$path .'/content/html/' .$_GET['file'] .'">
    <textarea name="sisu" cols="70" rows="10" wrap="off">';
    ShowFile($path .'/content/html/' .$_GET['file']);
    print '</textarea><br>
    <input type="submit" value="salvesta" class="button">
    </form>';

break;

default:
	SetTitle('Objektid - html');

    $path=ReadSetting('admin_path');
    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> html objektid.<br><br>
    <table><tr><th>Fail</th><th>Suurus (baitides)</th></tr>';

        $d=dir($path .'/content/html');
    while($entry=$d->read()) {
    	if($entry!='.' && $entry!='..') print '<tr><td>' .$entry .'</td>
        <td>' .filesize($path .'/content/html/' .$entry) .'</td>
        <td><a href="?id=html&amp;act=html_edit&amp;file=' .$entry .'" class="textlink">redigeeri</a></td></tr>';
    }
    $d->close();
    print '</table>';
break;
}

?>