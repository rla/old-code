<?php

/*
Lehe sisu objekt
16.05.04: lisatud uus tüüp js ehk javascript. Failid asuvad kaustas /content/js
Raivo Laanemets 2004
*/

include_once('func/admin.php');

$act=$_GET['act'];
$obj=$_GET['obj'];

switch($act) {
case 'new':
	$title='Objektid';
    Object('title', 'ee');
    //uue templeidi ja data lisamine
break;
case 'lisa':
    $title='Objektid - lisa';
    Object('title', 'ee');
    print '<form method="post" action="func/objects.php">
    <input type="hidden" name="act" value="save_new">
    <input type="hidden" name="path" value="' .$local_conf['main']['path'] .'">
    Nimi:<br>
    <input type="text" name="name"><br>
    Tüüp:<br>
    <select name="type">
    <option value="php">php</option>
    <option value="thtml">thtml</option>
    <option value="html">html</option>
    <option value="text">text</option>
    <option value="js">Javaskript</option>
    </select><br>
    Templeit:<br>
    <select name="temp">';
    $d=dir($local_conf['main']['path'] .'/temps');
    while($entry=$d->read()) {
    	if ($entry!='.' && $entry!='..') print '<option name="' .$entry .'">' .$entry .'</option>';
    }
    $d->close();
    print '</select><input type="checkbox" name="new_tpl">Uus templeit
    <input type="text" name="tpl_name"><br>
    Andmed:<br>
    <select name="data">';
    $d=dir($local_conf['main']['path'] .'/content/data');
    while($entry=$d->read()) {
    	if ($entry!='.' && $entry!='..') print '<option name="' .$entry .'">' .$entry .'</option>';
    }
    $d->close();
    print '</select><input type="checkbox" name="new_data">Uued andmed
    <input type="text" name="data_name"><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'text_edit':
	SetTitle('Objektid - Text - Muuda');

    $path=ReadSetting('admin_path');

    print 'Fail <b>' .$_GET['file'] .'</b>.<br><br>';

    print '<form action="func/objects.php" method="post">
    <input type="hidden" name="act" value="save_html">
    <input type="hidden" name="file" value="' .$path .'/content/text/' .$_GET['file'] .'">
    <textarea name="sisu" cols="70" rows="10">';
    include($path .'/content/text/' .$_GET['file']);
    print '</textarea><br>
    <input type="submit" value="salvesta" class="button">
    </form>';

break;
case 'text':
	SetTitle('Objektid - text');

    $path=ReadSetting('admin_path');
    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> text objektid.<br><br>
    <table><tr><th>Fail</th><th>Suurus (baitides)</th></tr>';

        $d=dir($path .'/content/text');
    while($entry=$d->read()) {
    	if($entry!='.' && $entry!='..') print '<tr><td>' .$entry .'</td>
        <td>' .filesize($path .'/content/text/' .$entry) .'</td>
        <td><a href="?id=obj&amp;act=text_edit&amp;file=' .$entry .'" class="textlink">redigeeri</a></td></tr>';
    }
    $d->close();
    print '</table>';
break;
case 'js_edit':
	SetTitle('Objektid - javascript - Muuda');

    $path=ReadSetting('admin_path');

    print 'Fail <b>' .$_GET['file'] .'</b>.<br><br>';

    print '<form action="func/objects.php" method="post">
    <input type="hidden" name="act" value="save_html">
    <input type="hidden" name="file" value="' .$path .'/content/js/' .$_GET['file'] .'">
    <textarea name="sisu" cols="70" rows="10">';
    include($path .'/content/js/' .$_GET['file']);
    print '</textarea><br>
    <input type="submit" value="salvesta" class="button">
    </form>';

break;
case 'js':
	SetTitle('Objektid - js');

    $path=ReadSetting('admin_path');
    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> js objektid.<br><br>
    <table><tr><th>Fail</th><th>Suurus (baitides)</th></tr>';

        $d=dir($path .'/content/js');
    while($entry=$d->read()) {
    	if($entry!='.' && $entry!='..') print '<tr><td>' .$entry .'</td><td>' .filesize($path .'/content/js/' .$entry) .'</td>
        <td><a href="?id=obj&amp;act=js_edit&amp;file=' .$entry .'" class="textlink">redigeeri</a></td></tr>';
    }
    $d->close();
    print '</table>';
break;

default:
	SetTitle('Objektid');

	$path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');
    /*Kuna incluudimine toimub funktsiooni sees, siis ei kirjutata üle
    põhisettinguid*/


    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);

    print 'Saidi <b>' .ReadSettingOutside('site_name', $objects_data_tbl, $db) .'</b> objektid<br><br>
    <table><tr><th>Nimi</th><th>Tüüp</th><th>Template</th></tr>';

    $sql="SELECT * FROM " .$objects_table;
    $res=mysql_query($sql, $db);
    while($result=mysql_fetch_row($res)) {
    	print '<tr><td>' .$result[1] .'</td>
        <td>' .$result[3] .'</td>
        <td>' .$result[2] .'</td></tr>';
    }
    print '</table>';
    mysql_close($db);
break;
}

?>