<?php

/*
Lihtne MySql administreerimisliides.
Raivo Laanemets 2004
*/

switch($_GET['act']) {
case 'lisa_tbl_data':
	SetTitle('MySql admin - andmete lisamine');

    print 'Andmebaasi <b>' .$_GET['db'] .'</b> tabel <b>' .$_GET['tbl'] .'</b>.<br><br>';
    include('conf/system_mysql.php');
    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);

    if(!$db) Error(mysql_error($db));
    if(!mysql_select_db($_GET['db'])) Error(mysql_error($db));

    $sql='SHOW FIELDS FROM ' .$_GET['tbl'];
    if(!($res=mysql_query($sql))) Error(mysql_error($db));
    print '<table><form method="post" action="func/mysql.php">
    <input type="hidden" name="act" value="save_data">
    <input type="hidden" name="db" value="' .$_GET['db'] .'">
    <input type="hidden" name="tbl" value="' .$_GET['tbl'] .'"><tr>';

    while($result=mysql_fetch_row($res)) {
    	if ($result[5]!='auto_increment') print '<tr><td>' .$result[0] .'(' .$result[1] .')<br>
        <input type="text" name="' .$result[0] .'"></td></tr>';
    }

    mysql_close($db);
    print '</table><input type="submit" value="Salvesta" class="button"></form>';

break;
case 'vaata_tbl_data':
	SetTitle('MySql admin');

    print 'Andmebaasi <b>' .$_GET['db'] .'</b> tabeli <b>' .$_GET['tbl'] .'</b> andmed.<br><br>';

    include('conf/system_mysql.php');
    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));
    if(!mysql_select_db($_GET['db'])) Error(mysql_error($db));
    $sql='SHOW FIELDS FROM ' .$_GET['tbl'];
    if(!($res=mysql_query($sql, $db))) Error(mysql_error($db));
    print '<table><tr>';

    while($result=mysql_fetch_row($res)) {
    	print '<th>' .$result[0] .'</th>';
    }
    print '</tr>';

    $sql='SELECT * FROM ' .$_GET['tbl'] .' LIMIT 0, 30';
    if(!($res=mysql_query($sql))) Error(mysql_error($db));

    while($result=mysql_fetch_row($res)) {
        print '<tr>';
    	foreach($result as $value) print '<td>' .$value .'</td>';
        print '</tr>';
    }

    mysql_close($db);
    print '</table>';

break;
case 'tbl_succ':
	SetTitle('MySql admin');
    print 'Tabel loodud.';
break;
case 'tbl_succ':
	SetTitle('MySql admin');
    print 'Andmed lisatud';
break;
case 'lisa_tbl_2':
	SetTitle('MySql admin - tabel');

    $mysql_types=array('bigint', 'blob', 'char', 'date', 'datetime',
    'decimal', 'double', 'enum', 'float', 'int', 'longblob', 'longtext', 'mediumblob',
    'mediumint', 'mediumtext', 'numeric', 'real', 'set', 'smallint', 'text', 'time',
    'timestamp', 'tinyblob', 'tinyint', 'tinytext', 'varchar', 'year');

    print 'Andmebaasi <b>' .$_GET['db'] .'</b> tabel <b>' .$_GET['tbl'] .'</b>.<br><br>
    Esimene väli määratakse automaatselt võtmeks.<br><br>';

    print '<table>
    <tr><th>Välja nimi</th><th>Tüüp</th><th>Pikkus</th><th>Auto increcement</th></tr>
    <form method="post" action="func/mysql.php">
    <input type="hidden" name="act" value="tee_tabel">
    <input type="hidden" name="tbl" value="' .$_GET['tbl'] .'">
    <input type="hidden" name="db" value="' .$_GET['db'] .'">
    <input type="hidden" name="v_arv" value="' .$_GET['v_arv'] .'">';

    for($i=0; $i<$_GET['v_arv']; $i++) {
    	print '<tr><td><input type="text" name="nimi_' .$i .'"></td><td><select name="type_' .$i .'">';
        foreach($mysql_types as $value) print '<option value="' .$value .'">' .$value .'</option>';
        print '</select></td><td><input type="text" name="len_' .$i .'"></td>
        <td><input type="checkbox" name="inc_' .$i .'"></td></tr>';

    }
    print '</table><input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'lisa_tbl':
	SetTitle('MySql - tabeli lisamine');

    print 'Andmebaas <b>' .$_GET['db'] .'</b><br><br>
    <form method="get" action="index.php">
    <input type="hidden" name="id" value="mysql">
    <input type="hidden" name="act" value="lisa_tbl_2">
    <input type="hidden" name="db" value="' .$_GET['db'] .'">
    Tabeli nimi: <input type="text" name="tbl"><br>
    Väljade arv: <input type="text" name="v_arv"><br>
    <input type="submit" value="Lisa" class="button">
    </form>';

break;
case 'vaata_tbl_info':
	SetTitle('MySql admin');

    include('conf/system_mysql.php');
    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));
    if(!mysql_select_db($_GET['db'])) Error(mysql_error());

    print 'Andmebaasi <b>' .$_GET['db'] .'</b> tabel <b>' .$_GET['tbl'] .'</b>.<br><br>
    <table showempty="1"><tr>
    <th>Väli</th>
    <th>Tüüp</th>
    <th>Null</th>
    <th>Võti</th>
    <th>Vaikimisi</th>
    <th>Ekstra</th></tr>';

    $sql="SHOW FIELDS FROM " .$_GET['db'] ."." .$_GET['tbl'];
    if (!($res=mysql_query($sql, $db))): Error(mysql_error($db));
    else:
    	while($result=mysql_fetch_row($res)) {
        	print '<tr><td>' .$result[0] .'</td>
            <td>' .$result[1] .'</td>
            <td>' .$result[2] .'</td>
            <td>' .$result[3] .'</td>
            <td>' .$result[4] .'</td>
            <td>' .$result[5] .'</td></tr>';
    	}
    endif;

    mysql_close($db);
    print '</table>';

break;
case 'vaata_tbl':
    SetTitle('MySql admin');

    include('conf/system_mysql.php');
    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));

    print 'Andmebaasi <b>' .$_GET['db'] .'</b> tabelid.<br><br><table>';

    $sql="SHOW TABLE STATUS FROM " .$_GET['db'];
    if (!($res=mysql_query($sql, $db))): Error(mysql_error($db));
    else:
    	while($result=mysql_fetch_row($res)) {
        	print '<tr><td>' .$result[0] .'</td>
            <td><a href="?id=mysql&amp;act=vaata_tbl_info&amp;tbl=' .$result[0] .'&amp;db=' .$_GET['db'] .'" class="stext">Vaata</a></td>
            <td><a href="?id=mysql&amp;act=vaata_tbl_data&amp;tbl=' .$result[0] .'&amp;db=' .$_GET['db'] .'" class="stext">Andmed</a></td>
            <td><a href="?id=mysql&amp;act=lisa_tbl_data&amp;tbl=' .$result[0] .'&amp;db=' .$_GET['db'] .'" class="stext">Lisa andmeid</a></td>
            </td></tr>';
    	}
    endif;
    mysql_close($db);
    print '</table>';

break;
case 'vaata_db':
    SetTitle('MySql admin');

    print 'Saadaolevad andmebaasid.<br><br><table>';
    include('conf/system_mysql.php');
    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));
    $sql="SHOW DATABASES";
    if (!($res=mysql_query($sql, $db))): Error(mysql_error($db));
    else:
    	while($result=mysql_fetch_row($res)) {
        	print '<tr><td>' .$result[0] .'</td>
            <td><a href="?id=mysql&amp;act=vaata_tbl&amp;db=' .$result[0] .'" class="stext">Vaata</a>
            <td><a href="?id=mysql&amp;act=del_db&amp;db=' .$result[0] .'" class="stext">Kustuta</a>
            <td><a href="?id=mysql&amp;act=lisa_tbl&amp;db=' .$result[0] .'" class="stext">Lisa tabel</a>
            </td></tr>';
    	}
    endif;
    mysql_close($db);
    print '</table>';

break;
case 'uus_baas_2':
	SetTitle('MySql admin - uus andmebaas');

    include('conf/system_mysql.php');
	$db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));
    $sql="CREATE DATABASE " .$_GET['nimi'];
    if (!mysql_query($sql, $db)): Error(mysql_error($db));
    else: print 'Andmebaas <b>' .$_GET['nimi'] .'</b> edukalt loodud.';
    endif;
    mysql_close($db);

break;
case 'uus_baas':
	SetTitle('MySql admin - uus andmebaas');

    print '<form method="get" action="index.php">
    <input type="hidden" name="id" value="mysql">
    <input type="hidden" name="act" value="uus_baas_2">
    Andmebaasi nimi: <input type="text" name="nimi"><br>
    <input type="submit" value="Tekita" class="button">
    </form>';
break;
default:
	SetTitle('MySql admin');

    print '<a href="?id=mysql&amp;act=uus_baas" class="stext">Uus andmebaas</a><br>
    <a href="?id=mysql&amp;act=vaata_db" class="stext">Vaata andmebaase</a><br>';
break;
}

?>