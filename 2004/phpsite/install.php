<html>

<head>
  <title>PhpSait installeerimine</title>
</head>

<body>
<h1>PhpSait installeerimine</h1>


<?php

/*
Administreerimisliidese installeerimine.
Raivo Laanemets 2004

Kaasas liidesega alates versioonist 0.06
*/

switch($_GET['act']) {
default:
	print '<form action="install.php" method="get">
	<input type="hidden" name="act" value="step_1">
	Mysql kasutajanimi:<br>
	<input type="text" name="user"><br>
	Parool:<br>
	<input type="password" name="pass"><br>
	Aadress:<br>
	<input type="text" name="host" value="localhost"><br>
    Andmebaasi nimi:<br>
    <input type="text" name="db"><br>
    Liidese nimi:<br>
    <input type="text" name="name" value="admin"><br><br>
    <input type="submit" value="Edasi">
	</form>';
break;

case 'step_1':
    $db=mysql_connect($_GET['host'], $_GET['user'], $_GET['pass'], true) or die('Ei saanud ühendust andmebaasiga.');
    if(!mysql_select_db($_GET['db'], $db)) die('Puudub soovitud andmebaas.');

    $sql="CREATE TABLE " .$_GET['name'] ."_objects (
  	id bigint(20) NOT NULL auto_increment,
  	name char(20) default NULL,
  	template char(20) default NULL,
  	type char(5) default NULL,
  	title char(50) default NULL,
  	object_id int(11) default NULL,
  	PRIMARY KEY  (id),
  	UNIQUE KEY name (name)
	) TYPE=MyISAM";

    if(!mysql_query($sql, $db)) print 'Objektide tabeli loomine ebaõnnestus.<br>';

    $sql="CREATE TABLE " .$_GET['name'] ."_content(
  	id bigint(20) NOT NULL auto_increment,
  	object_id int(11) default NULL,
  	varname varchar(20) default NULL,
  	value char(255) default NULL,
  	lang char(2) default NULL,
  	PRIMARY KEY  (id),
  	KEY object_id (object_id)
	) TYPE=MyISAM ROW_FORMAT=FIXED";

    if(!mysql_query($sql, $db)) print 'Sisu tabeli loomine ebaõnnestus.<br>';

    $sql="CREATE TABLE " .$_GET['name'] ."_cache(
    id bigint(20) NOT NULL auto_increment,
  	object_name char(20) default NULL,
  	last_mod int(11) default NULL,
  	ex int(1) default NULL,
  	PRIMARY KEY (id),
  	UNIQUE KEY object_name (object_name)
	) TYPE=MyISAM ROW_FORMAT=FIXED";

    if(!mysql_query($sql, $db)) print 'Vahekausta tabeli loomine ebaõnnestus.<br>';

    $sql="CREATE TABLE " .$_GET['name'] ."_css(
    id int(11) NOT NULL auto_increment,
  	css_file char(20) default NULL,
  	PRIMARY KEY  (id)
	) TYPE=MyISAM ROW_FORMAT=FIXED";

    if(!mysql_query($sql, $db)) print 'CSS tabeli loomine ebaõnnestus.<br>';

    $sql="CREATE TABLE " .$_GET['name'] ."_sites(
  	id bigint(20) NOT NULL auto_increment,
  	name char(20) default NULL,
  	path char(75) default NULL,
  	PRIMARY KEY  (id)
	) TYPE=MyISAM";

    if(!mysql_query($sql, $db)) print 'Saitide tabeli loomine ebaõnnestus.<br>';

    mysql_close($db);

    if(is_writeable('conf/system_mysql.php')):
    	$fp=fopen('conf/system_mysql.php', 'w');
        fwrite($fp, '<?php' ."\n");
        fwrite($fp, chr(36) .'objects_host="' .$_GET['host'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_user="' .$_GET['user'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_pass="' .$_GET['pass'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_base="' .$_GET['db'] .'";' ."\n");
        fwrite($fp, chr(36) .'objects_table="' .$_GET['name'] .'_objects";' ."\n");
        fwrite($fp, chr(36) .'objects_data_tbl="' .$_GET['name'] .'_content";' ."\n");
        fwrite($fp, chr(36) .'objects_css_tbl="' .$_GET['name'] .'_css";' ."\n");
        fwrite($fp, '?>');
        fclose($fp);
    else:
    	print 'Ei õnnestunud kirjutada konfiguratsioonifaili.<br>';
    endif;

    print 'Esimene samm lõpetatud.<br>
    Kui veateateid ei esinenud, võid jätkata.<br><br>
    <a href="?act=step_2">Edasi</a>';

break;

case 'step_2':

	include('conf/system_mysql.php');
    $db=@mysql_connect($objects_host, $objects_user, $objects_pass, true)
    	or die('Ei õnnestunud ühendada mysql baasiga.');
    if(!mysql_select_db($objects_base, $db)) print 'Puudub soovitud andmebaas.';

    $sql="INSERT INTO " .$objects_table ." VALUES (1,'struct','struct','thtml','',1) ,
    (2,'menu',NULL,'php','',NULL) , (3,'header','header','thtml','',2) ,
    (4,'footer',NULL,'html','',NULL) , (5,'index',NULL,'html','Index',NULL) ,
    (6,'obj',NULL,'php','',NULL) , (7,'date','date','thtml','',3) ,
    (8,'menuu',NULL,'php','',NULL) , (9,'temps',NULL,'php','',NULL) ,
    (10,'title','title','thtml','',4) , (11,'settings',NULL,'php','',NULL) ,
    (12,'abi',NULL,'php','',NULL) , (13,'cache',NULL,'php','',NULL) ,
    (14,'css',NULL,'php','',NULL) , (15,'data',NULL,'php','',NULL) ,
    (16,'error','error','thtml','',5) , (17,'link_show',NULL,'js','',NULL) ,
    (18,'link_show_bar',NULL,'html','',NULL) , (19,'navbar',NULL,'html','',NULL) ,
    (20,'print','print','thtml','',6) , (21,'header_print','header','thtml','',7) ,
    (22,'mysql',NULL,'php','',0) , (23,'uus','','php','Uue lehekülje loomine',0) ,
    (24,'abi_obj','','html','Abi',0) , (25,'php','','php','Objektid - php',0) ,
    (26,'thtml','','php','Objektid - thtml',0) , (27,'include_css','','php','',0) ,
    (28,'css_used','','php','',0)";

    if(!mysql_query($sql, $db)) print 'Objektide info salvestamine ebaõnnestus.';

    $sql="INSERT INTO " .$objects_data_tbl ." VALUES (1,1,'copyright','(C) Raivo Laanemets 2004 rl@starline.ee','ee') ,
    (16,9999,'admin_path','.','') , (3,3,'date','%echo date(\"Y-m-d\");','ee') ,
    (4,4,'title','%global $title; print $title;','ee') ,
    (5,5,'title','\'VIGA!\'','ee') ,
    (6,5,'msg','%global $LAST_ERROR; print $LAST_ERROR;','ee') ,
    (7,2,'doctype','<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">','ee') ,
    (8,2,'title','PhpSait admin','ee') , (9,2,'charset','iso-8859-1','ee') ,
    (10,2,'author','Raivo Laanemets','ee') , (11,2,'description','Administreerimisliides','ee') ,
    (12,2,'robots','FOLLOW','ee') , (13,2,'copyright','(c) 2004 Raivo Laanemets','ee') ,
    (14,2,'head_code','','ee') , (15,2,'favicon','favicon.ico','ee') ,
    (17,9999,'site_name','Administreerimisliides','ee') ,
    (18,9999,'cache_timeout','10','') , (19,9999,'def_lang','ee','') ,
    (20,2,'test','see on proov','ee') , (21,2,'test','kak','ee') ,
    (22,2,'author','Raivo Laanemets','ee') , (23,2,'test3','proov33','ee')";

    if(!mysql_query($sql, $db)) print 'Objektide andmete salvestamine ebaõnnestus.';

    mysql_close($db);

    print 'Kui veateateid ei esinenud, siis
    on administreerimisliides edukalt installeeritud<br>
    <a href="index.php">Index</a>';

break;
}


?>

</body>

</html>