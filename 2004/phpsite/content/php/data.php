<?php

/*
Templeitide modimiseks mõeldud script.
Raivo Laanemets 2004
*/

include_once('func/admin.php');

switch($_GET['act']) {

case 'kustuta':
	SetTitle('Andmete Kustutamine');

    $path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);
    $sql="DELETE FROM " .$objects_data_tbl ." WHERE id=" .$_GET['var_id'];

    if(mysql_query($sql)):
    	print 'Muutuja kustutatud.';
    else:
    	print 'Muutuja kustutamine ebaõnnestus.';
    endif;

    print '<br><a href="?id=data" class="textlink">Algus</a>';

    mysql_close($db);
break;

case 'add_2':
	SetTitle('Andmete lisamine');

    $path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);
    $sql="INSERT INTO " .$objects_data_tbl ." VALUES (0, " .$_GET['obj_id'] .", '" .$_GET['varname'] ."', '" .$_GET['value'] ."', '" .$_GET['language'] ."')";

    if(mysql_query($sql)):
    	print 'Muutuja väärtus salvestatud.';
    else:
    	print 'Muutuja väärtuse salvestamine ebaõnnestus.';
    endif;

    print '<br><a href="?id=data" class="textlink">Algus</a>';

    mysql_close($db);
break;

case 'add':
	SetTitle('Andmete lisamine');

    print '<form method="get" action="index.php">
    <input type="hidden" name="id" value="data">
    <input type="hidden" name="act" value="add_2">
    <input type="hidden" name="obj_id" value="' .$_GET['obj_id'] .'">
    Muutuja nimi:<br>
    <input type="text" name="varname"><br>
    Keel:<br>
    <input type="text" name="language"><br>
    Väärtus:<br>
    <input type="text" name="value" style="width: 300px"><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;

case 'muuda_2':
	SetTitle('Andmed - muutmine');

    $path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);
	$sql="UPDATE " .$objects_data_tbl ." SET value='" .$_GET['value'] ."' WHERE id='" .$_GET['var_id'] ."'";

    if(mysql_query($sql)):
    	print 'Muutuja väärtus salvestatud.';
    else:
    	print 'Muutuja väärtuse salvestamine ebaõnnestus.';
    endif;

    print '<br><a href="?id=data" class="textlink">Algus</a>';

    mysql_close($db);
break;

case 'muuda':
	SetTitle('Andmed - muutmine');

	print '<form method="get" action="index.php">
    <input type="hidden" name="id" value="data">
    <input type="hidden" name="act" value="muuda_2">
    <input type="hidden" name="var_id" value="' .$_GET['var_id'] .'">
    Muutuja (' .$_GET['varname'] .'):<br>
    <input type="text" name="value" value="' .stripslashes(htmlentities($_GET['value'])) .'" style="width: 300px"><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;

case 'show':
    SetTitle('Andmed');

	$path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);

    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> templeiditud html objektide andmekogud.<br><br>
    <table><tr><th>Muutuja</th><th>Keel</th><th>Väärtus</th><th>&nbsp;</th></tr>';

    $sql="SELECT * FROM " .$objects_data_tbl ." WHERE object_id=" .$_GET['obj_id'] ." ORDER BY varname";
    if(!$res=mysql_query($sql, $db)) print mysql_error($db);
    while($result=mysql_fetch_row($res)) {
    	print '<tr><td>' .$result[2] .'</td>
        <td>' .$result[4] .'</td>
        <td>' .htmlentities($result[3]) .'</td>
        <td><a href="?id=data&amp;act=muuda&amp;varname=' .$result[2] .' &amp;var_id=' .$result[0] .'&amp;value=' .htmlentities($result[3]) .'" class="textlink">Muuda</a></td>
        <td><a href="?id=data&amp;act=kustuta&amp;var_id=' .$result[0] .'" class="textlink">Kustuta</a></td>
        </tr>';
    }
    print '</table>
    <a href="?id=data&amp;act=add&amp;obj_id=' .$_GET['obj_id'] .'" class="textlink">Lisa</a>';
    mysql_close($db);
break;

default:
    SetTitle('Andmed');

	$path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);

    print 'Saidi&nbsp;<b>' .GetSiteNameByPath($path) .'&nbsp;</b>templeiditud html objektide andmekogud.<br><br>
    <table><tr><th>Nimi</th><th>&nbsp;</th></tr>';

    $sql="SELECT * FROM " .$objects_table ." WHERE type='thtml'";
    $res=mysql_query($sql, $db);
    while($result=mysql_fetch_row($res)) {
    	print '<tr><td>' .$result[1] .'</td>
        <td><a href="?id=data&amp;act=show&amp;obj_id=' .$result[5] .'" class="textlink">Andmed</a></td></tr>';
    }
    print '</table>';
    mysql_close($db);
}

?>