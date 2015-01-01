<?php

/*
Seaded!
Raivo Laanemets 2004
*/

include('func/admin.php');

$act=$_GET['act'];
$place=$_GET['place'];

switch($act) {
case 'change_path':
	SetTitle('Seadistused');
	if(WriteSetting('admin_path', $_GET['site_path'])): print 'Kausta muutmine õnnestus!';
    else: print 'Kausta muutmine ebaõnnestus';
    endif;

break;
default:
	SetTitle('Seadistused');

    $path=ReadSetting('admin_path');

	print 'Administreerimisliidese seadistused:<br>
	<form method="get" action="index.php">
    <input type="hidden" name="act" value="change_path">
    <input type="hidden" name="id" value="settings">
    Juurkaust:<br>
    <input type="text" name="path" value="' .$path . '" class="textbox"><br>
    Varem loodud leheküljed:<br>
    <select name="site_path">';
    //varemloodud lehekülgede loetelu
    $sites=array();
    GetSites($sites);
    foreach($sites as $key => $value) {
    	print '<option value="' .$value .'">' .$key .'</option>';
    }
    print '</select><br><input type="submit" value="Salvesta" class="button">
    </form>';
break;
}

?>