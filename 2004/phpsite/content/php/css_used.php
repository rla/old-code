<?php

/*
CSS failid, mida kasutatakse leheküljel.
Raivo Laanemets 2004
*/

switch($_GET['act']) {
case 'lisa_2':
    SetTitle('Css');

	global $objects_db;
    global $objects_css_tbl;

    $sql="INSERT INTO " .$objects_css_tbl ." VALUES(0, '" .$_GET['file'] ."')";
    if(!mysql_query($sql, $objects_db)):
    	print 'EI ÕNNESTUNUD LISADA ANDMEBAASI!';
        mysql_error($objects_db);
    	break;
    else:
    	print 'Andmebaasi lisatud edukalt.';
    endif;
break;
case 'lisa':
	SetTitle('Lisa Css fail kasutatavate hulka');

	print 'Vali sobiv ja vajuta lisa.<br><br><table>';
    $d=dir(ReadSetting('admin_path') .'/content/css');

    while($entry=$d->read()) {
    	if ($entry!='.' && $entry!='..') print '<tr><td>' .$entry .'</td><td><a href="?id=css_used&amp;act=lisa_2&amp;file=' .$entry .'" class="textlink">Lisa</a></td></tr>';
    }

    $d->close();

    print '</table>';
break;
case 'remove':

    global $objects_db;
    global $objects_css_tbl;

	$sql="DELETE FROM " .$objects_css_tbl ." WHERE id=" .$_GET['fid'];
    if(!mysql_query($sql, $objects_db)):
    	print 'EI ÕNNESTUNUD KUSTUTADA ANDMEBAASIST!';
        mysql_error($objects_db);
    	break;
    else:
    	print 'Css fail eemaldatud kasutusest edukalt.';
    endif;
break;
default:
	SetTitle('Lehel kasutatavad CSS failid');

    print 'Sait kasutab järgmisi css faile:<br><br>
    <table>';

    global $objects_db;
    global $objects_css_tbl;

    $sql="SELECT * FROM " .$objects_css_tbl;
    $res=mysql_query($sql);

    while($result=mysql_fetch_row($res)) {
    	print '<tr><td>' .$result[1] .'</td>
        <td><a href="?id=css_used&amp;act=remove&amp;fid=' .$result[0] .'" class="textlink">Eemalda</a></td></tr>';
    }

    print '</table><br><a href="?id=css_used&amp;act=lisa" class="textlink">Lisa</a>';
break;
}

?>