<html><head>
<title>Objektid</title>
</head>
<body>
<?php

/*
Raivo Laanemets 2004
Objektide muutmiseks vajalikud funktsioonid.
*/

//kõik väljaspoolt tulevad muutujad
//saame post meetodiga
$act=$_POST['act'];
$path=$_POST['path'];
$name=$_POST['name'];

global $objects;

switch($_POST['act']) {
case 'html_save':
	$path=$_POST['file'];

    $fp=fopen('../'.$path, 'w');
    fwrite($fp, str_replace("\r", '', stripslashes($_POST['sisu'])));
    fclose($fp);

    $link='?id=obj&amp;act=html';
break;
case 'save_new':
    include('inifiles.php');

    //objektide confi lugemine
    $ob_fp=FIniFile('..' .$path .'/conf/objects.ini');
    $objects=array();
    FIniReadFile($ob_fp, $objects);


    if ($_POST['new_tpl']=='on'): $temp=$_POST['tpl_name'];
    else: $temp=$_POST['temp'];
    endif;

    if ($_POST['new_data']=='on'): $data=$_POST['data_name'];
    else: $data=$_POST['data'];
    endif;

    if ($_POST['type']=='thtml') {
	    $objects[$name]['temp']=$temp;
    	$objects[$name]['data']=$data;
    }


    $objects[$name]['type']=$_POST['type'];


    $link='../index.php?id=obj&amp;act=new&amp;temp=' .$temp .'&amp;data=' .$data .'&amp;new_tpl=' .$new_tpl .'&amp;new_data=' .$new_data .'';

    //objektide confi kirjutamine
    FIniWriteFile($ob_fp, $objects);
break;
case 'save_temp':
	$fp=fopen('../' .$_POST['filename'], 'w');
    fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    fclose($fp);
    $link='../index.php?id=temps';
break;
default:
	print 'Vigased sisendandmed!';
break;
}
?>
<?php echo '<a href="../index.php' .$link .'">Jätka</a>'; ?>
</body>
</html>