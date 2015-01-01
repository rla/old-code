<html><head>
<title>Templeidid</title>
</head>
<body>
<?php

/*
Raivo Laanemets 2004
Lehtede muutmiseks vajalikud funktsioonid.
*/

//kõik väljaspoolt tulevad muutujad
//saame post meetodiga
$act=$_POST['act'];
$path=$_POST['tmp'];

switch($act) {
case 'new':
	$fp=fopen('../' .$_POST['path'] .'/content/pages/' .$_POST['nimi'] .'.html', 'w');
    fwrite($fp, '%' .$_POST['pealkiri'] ."\n");
    fwrite($fp, str_replace("\r", '', stripslashes($_POST['sisu'])));
    fclose($fp);
    $link='../index.php?id=lehed';
break;
case 'save':
	$fp=fopen('../' .$_POST['filename'], 'w');
    fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    fclose($fp);
    $link='../index.php?id=lehed';
break;
default:
	print 'Vigased sisendandmed!';
break;
}
?>
<script language="JavaScript">
window.location="<?php echo $link; ?>";
</script>
<?php echo '<a href="' .$link .'">Jätka</a>'; ?>
</body>
</html>