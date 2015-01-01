<html><head>
<title>Templeidid</title>
</head>
<body>
<?php

/*
Raivo Laanemets 2004
Templeitide muutmiseks vajalikud funktsioonid.
*/

//kõik väljaspoolt tulevad muutujad
//saame post meetodiga
$act=$_POST['act'];
$path=$_POST['tmp'];

switch($act) {
case 'save_new':
	$fp=fopen('../' .$_POST['path'] .'/content/temps/' .$_POST['name'] .'.tpl', 'w');
    fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    fclose($fp);
    $link='../index.php?id=temps';
break;
case 'save_temp':
	if($fp=fopen('../' .$_POST['filename'], 'w')):
    	fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    	fclose($fp);
    	$link='../index.php?id=temps';
    else: $failed=true;
    endif;
break;
default:
	print 'Vigased sisendandmed!';
break;
}

print '<a href="' .$link .'">Jätka</a><br>';

if($failed):
	print 'Faili salvestamine ebaõnnestus.';
else:
	print '<script type="text/javascript">
  	window.location="' .$link .'";
	</script>';
endif;
?>
</body>
</html>