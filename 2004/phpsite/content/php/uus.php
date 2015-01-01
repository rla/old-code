<?php

/*
Uue saidi loomine.
Raivo Laanemets 2004
*/

include_once('func/admin.php');

switch($_GET['act']) {
case 'step_3':

	SetTitle('Uue lehekülje loomine');
    $path=$_GET['path'];
    $name=$_GET['name'];

    print 'Struktuuri salvestamine ja põhimuutujate seadmine.<br><br>';

    if(@copy('install/struct/' .$_GET['structure'], $path .'/content/temps/struct.tpl')):
    	TaskOk('Struktuur salvestatud');
    else: TaskFailed('Struktuuri salvestamine ebaõnnestus');
    endif;

    include($path .'/conf/system_mysql.php');

    $db=@mysql_connect($objects_host, $objects_user, $objects_pass, true)
    	or die('Ei õnnestunud ühendada mysql baasiga.');
    if(!mysql_select_db($objects_base)) print mysql_error($db);

    $sql="INSERT INTO " .$name ."_content VALUES(0, 9999, 'cache_timeout', '" .$_GET['cache_timeout'] ."', '')";
    $failed=false;
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_content VALUES(0, 9999, 'def_lang', '" .$_GET['def_lang'] ."', '')";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_objects VALUES(0, 'struct', 'struct', 'thtml', '', 1)";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_objects VALUES(0, 'header', 'header', 'thtml', '', 2)";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_objects VALUES(0, 'menuu', '', 'php', '', 0)";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_objects VALUES(0, 'index', '', 'html', '', 0)";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;
    $sql="INSERT INTO " .$name ."_objects VALUES(0, 'footer', '', 'html', '', 0)";
    if(!mysql_query($sql, $db)): $failed=true; print mysql_error($db); endif;

    if($failed): TaskFailed('Vaikimisi väärtuste lisamine baasi ebaõnnestus');
    else: TaskOk('Vaikimisi väärtused seatud');
    endif;

    mysql_close($db);

break;
case 'step_2':
	SetTitle('Uue lehekülje loomine');
    print 'Vali sobiv struktuur<br><br><table>
    <form method="get" action="index.php">
    <input type="hidden" name="id" value="uus">
    <input type="hidden" name="act" value="step_3">
    <input type="hidden" name="path" value="' .$_GET['path'] .'">
    <input type="hidden" name="name" value="' .$_GET['name'] .'">';

    $d=dir('install/struct');
    while($entry=$d->read()) {
    	if($entry!='.' && $entry!='..') print '<tr><td>
        <input type="radio" name="structure" value="' .$entry . '"></td><td>' .$entry .'</td>
        <td><a href="install/struct/' .$entry .'" target="struct" class="textlink">Vaata</a></td></tr>';
    }
    $d->close();

    print '</table>
    Vaikimisi keel:<br>
    <input type="text" name="def_lang" value="ee"><br>
    Vahefailide eluaeg:<br>
    <input type="text" name="cache_timeout" value="600"><br>
    <input type="submit" value="Edasi->" class="button"></form>';
break;
case 'step_1':
	$uued_kaustad=array('func', 'cache', 'content', 'content/html', 'content/js',
    'content/php', 'content/text', 'content/temps', 'content/pics','content/css' ,
    'logs', 'conf');

	SetTitle('Uue lehekülje loomine');
    $root=$_GET['root_path'];
    $name=$_GET['site_name'];

    print 'Kaustade ja andmebaasi tabelite loomine.<br><br>';

    //kaustade loomine
    //kõigepealt uus juurkaust
    $failed=false;
	$ok=@mkdir($_GET['root_path']);
    if($ok): TaskOk('Kaust ' .$root .' edukalt loodud.');
    else:
    	TaskFailed('Kausta ' .$root .' loomine ebaõnnestus.');
        $failed=true;
    endif;
    foreach($uued_kaustad as $value) {
    	$ok=@mkdir($root .'/' .$value);
        if($ok): TaskOk('Kaust ' .$root .'/' .$value .' edukalt loodud.');
    	else:
    		TaskFailed('Kausta ' .$root .'/' .$value .' loomine ebaõnnestus.');
        	$failed=true;
    	endif;
    }
    print '-----<br>';

    //failide kopeerimine
    $uued_failid=array('index.php', 'func/print_msg.php', 'func/errors.php',
    'func/main.php', 'func/menu_tree.php', 'content/css/default.css',
    'content/html/index.html', 'content/temps/header.tpl',
    'content/php/menuu.php', 'conf/menu.cde');

    foreach($uued_failid as $value) {
    	$ok=@copy('install/' .$value , $root .'/' .$value);
        if($ok): TaskOk('Fail ' .$root .'/' .$value .' edukalt kopeeritud.');
    	else:
    		TaskFailed('Faili ' .$root .'/' .$value .' kopeerimine ebaõnnestus.');
        	$failed=true;
    	endif;
    }

    print '-----<br>';

    //tabelite loomine
    $db=mysql_connect($_GET['db_host'], $_GET['db_user'], $_GET['db_pass'], true);
    mysql_select_db($_GET['db'], $db);
    $sql="CREATE TABLE " .$name ."_objects (
  	id bigint(20) NOT NULL auto_increment,
  	name char(20) default NULL,
  	template char(20) default NULL,
  	type char(5) default NULL,
  	title char(50) default NULL,
  	object_id int(11) default NULL,
  	PRIMARY KEY  (id),
  	UNIQUE KEY name (name)
	) TYPE=MyISAM";
    if(mysql_query($sql, $db)): TaskOk('Tabel ' .$name .'_objects loodud.');
    else:
    	TaskFailed('Tabeli ' .$name .'_objects loomine ebaõnnestus.');
    	$failed=true;
    endif;
    $sql="CREATE TABLE " .$name ."_content(
  	id bigint(20) NOT NULL auto_increment,
  	object_id int(11) default NULL,
  	varname varchar(20) default NULL,
  	value tinytext,
  	lang char(2) default NULL,
  	PRIMARY KEY  (id),
  	KEY object_id (object_id)
	) TYPE=MyISAM";
    if(mysql_query($sql, $db)): TaskOk('Tabel ' .$name .'_content loodud.');
    else:
    	TaskFailed('Tabeli ' .$name .'_content loomine ebaõnnestus.');
    	$failed=true;
    endif;
    $sql="CREATE TABLE " .$name ."_cache(
    id bigint(20) NOT NULL auto_increment,
  	object_name char(20) default NULL,
  	last_mod int(11) default NULL,
  	ex int(1) default NULL,
  	PRIMARY KEY (id),
  	UNIQUE KEY object_name (object_name)
	) TYPE=MyISAM ROW_FORMAT=FIXED";
      if(mysql_query($sql, $db)): TaskOk('Tabel ' .$name .'_cache loodud.');
    else:
    	TaskFailed('Tabeli ' .$name .'_cache loomine ebaõnnestus.');
    	$failed=true;
    endif;
    mysql_close($db);

    print '-----<br>';

    //confi salvestamine
    if($fp=fopen($root .'/conf/system_mysql.php', 'w')):
    	TaskOk('MySql konfiguratsiooni salvestamine õnnestus.');
    	fwrite($fp, '<?php' ."\n");
    	fwrite($fp, chr(36) .'objects_host="' .$_GET['db_host'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_user="' .$_GET['db_user'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_pass="' .$_GET['db_pass'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_base="' .$_GET['db'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_table="' .$name .'_objects";' ."\n");
        fwrite($fp, chr(36) .'objects_data_tbl="' .$name .'_content";' ."\n");
        fwrite($fp, '?>');
        fclose($fp);
    else:
    	TaskFailed('Ei õnnestunud salvestada MySql konfiguratsiooni.');
        $failed=true;
    endif;

    if(!$failed): print 'Esimene samm õnnestus!<br><br>';
    else: print 'Uue saidi loomine ebaõnnestus.';
    endif;

    print '<br><form method="get" action="index.php">
    <input type="hidden" name="id" value="uus">
    <input type="hidden" name="act" value="step_2">
    <input type="hidden" name="path" value="' .$root .'">
    <input type="hidden" name="name" value="' .$name .'">
    <input type="submit" value="Edasi->" class="button">
    </form>';

break;
default:
	SetTitle('Uue lehekülje loomine');
    print 'Sisesta kõik vajalikud andmed!
    <form method="get" action="index.php">
    <input type="hidden" name="id" value="uus">
    <input type="hidden" name="act" value="step_1">
    Saidi nimi (ära kasuta tühikut ja erimärke!):<br>
    <input type="text" name="site_name"><br>
    Juurkaust:<br>
    <input type="text" name="root_path"><br>
    Andmebaasi aadress:<br>
    <input type="text" name="db_host" value="localhost"><br>
    Andmebaasi nimi:<br>
    <input type="text" name="db"><br>
    Andmebaasi kasutajanimi:<br>
    <input type="text" name="db_user" value="root"><br>
    Andmebaasi parool:<br>
    <input type="password" name="db_pass"><br>
	<input type="submit" value="Edasi->" class="button">
    </form>';
break;
}

?>