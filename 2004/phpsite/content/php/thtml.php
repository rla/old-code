<?php

/*
Templeiditud html'i redigeerimine,
andmete muutmine.

Raivo Laanemets 2004
*/

include('func/admin.php');

switch($_GET['act']) {

default:
	SetTitle('Objektid - thtml');

	$path=ReadSetting('admin_path');
    include($path .'/conf/system_mysql.php');
    /*Kuna incluudimine toimub funktsiooni sees, siis ei kirjutata üle
    põhisettinguid*/


    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!($db)) print mysql_error($db);
    if(!mysql_select_db($objects_base)) print mysql_error($db);

    print 'Saidi <b>' .GetSiteNameByPath($path) .'</b> templeiditud html objektid.<br><br>
    <table><tr><th>Nimi</th><th>Templeit</th></tr>';

    $sql="SELECT * FROM " .$objects_table ." WHERE type='thtml'";
    $res=mysql_query($sql, $db);
    while($result=mysql_fetch_row($res)) {
    	print '<tr><td>' .$result[1] .'</td>
        <td><a href="?id=temps&amp;act=muuda&amp;tmp=' .$result[2] .'.tpl" class="textlink">' .$result[2] .'</a></td></tr>';
    }
    print '</table>';
    mysql_close($db);
break;

}

?>