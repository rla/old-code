<?php

/*
Templeitide modimiseks mõeldud script.
Raivo Laanemets 2004
*/

include_once('func/admin.php');

switch($_GET['act']) {
case 'muutujad':
	SetTitle('Templeidid - muutujad ja objektid');

    $vars=array();
    $path=ReadSetting('admin_path');

    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> templeidi <b>' .$_GET['tmp'] .'</b> muutujad
     ja objektid.<br><br>';

    ReadTemplateVars($path .'/content/temps/' .$_GET['tmp'], $vars);
    foreach($vars as $value) {
    	if($value{0}==':'): print '<b>objekt</b> ' .substr($value, 1);
        else: print '<b>muutuja</b> ' .$value;
        endif;
        print '<br>';
    }
break;
case 'lisa':
	SetTitle('Templeidid - uue lisamine');

    print '<form method="post" action="func/temps.php">
    <input type="hidden" name="act" value="save_new">
    <input type="hidden" name="path" value="' .ReadSetting('admin_path') .'">
    Nimi:<br>
    <input type="text" name="name"><br>
    <textarea name="temp" rows="20" cols="80" wrap="off"></textarea><br>
    <input type="submit" value="Salvesta" class="button">
    </form>
    ';
break;
case 'muuda':
    SetTitle('Templeidid - muutmine');
    print '<form method="post" action="func/temps.php">
    <input type="hidden" name="act" value="save_temp">
    <input type="hidden" name="path" value="' .$_GET['tmp'] .'">
    <input type="hidden" name="filename" value="' .ReadSetting('admin_path') .'/content/temps/' .$_GET['tmp'] .'">
    Templeidi kood:<br>
    <textarea name="temp" rows="20" cols="80" wrap="off">';
    $fp=fopen(ReadSetting('admin_path') .'/content/temps/' .$_GET['tmp'], 'r');
    while(!feof($fp)) {
    	$out=fgets($fp, 4096);
        if ($out!="\r") print $out;
    }
    //print fread($fp, filesize($local_conf['main']['path'] .'/temps/' .$_GET['tmp']));
    fclose($fp);
    print '</textarea><br>
    <input type="checkbox" name="strip_rn" checked>Eemalda reavahed<br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'del':
	//unlink($local_conf .'/temps/' .$_GET['tmp']);
    print '<script language="JavaScript">
	window.location="index.php?id=temps";
	</script>';
break;
default:
    SetTitle('Templeidid');

    $d=ReadSetting('admin_path');

    print 'Saidi <b>' .GetSiteNameByPath($d) .'</b> templeidid.<br><br>
    <table>';

    $d.='/content/temps';

    $temps=dir($d);
    while($entry=$temps->read()) {
    	if ((!is_dir($entry)) && ($entry!='.') && ($entry!='..')) print '<tr><td>' .$entry .'</td>
        	<td><a href="?id=temps&amp;act=muuda&amp;tmp=' .$entry .'" class="textlink">Muuda</a></td>
            <td><a href="?id=temps&amp;act=del&amp;tmp=' .$entry .'" class="textlink">Kustuta</a></td>
            <td><a href="?id=temps&amp;act=muutujad&amp;tmp=' .$entry .'" class="textlink">Muutujad ja objektid</a></td>
            </tr>';
    }
    $temps->close();

    print '</table>
    <a href="?id=temps&amp;act=lisa" class="textlink">Lisa</a>';
}

?>