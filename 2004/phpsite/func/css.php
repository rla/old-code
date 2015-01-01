<html><head>
<title>CSS</title>
</head>
<body>
<?php

/*
Raivo Laanemets 2004
CSS failide muutmiseks vajalikud funktsioonid.
*/

switch($_POST['act']) {

case 'save_form':
	//css lehelt tulevad parsitud koodi muutujad.
	$fp=fopen($_POST['fname'], 'w');
    if(!$fp) : print 'EI SUUTNUD FAILI AVADA<br>'; break; endif;
	foreach($_POST as $key=> $value) {
    	$val=$_POST[$key];
        if (is_array($val)) {
           	$kkey=$key;
            $kkey=str_replace('=?=', '_', str_replace('=*=', '.', $kkey));
        	fwrite($fp, $kkey ."{\n");
            foreach($val as $key=>$subvalue) {
            	fwrite($fp, "  ".$key .": " .$subvalue .";\n");
            }
            fwrite($fp, "}\n");
        }
    }
    fclose($fp);
    $link='../index.php?id=css';
break;

case 'save_new':
	if($fp=fopen('../' .$_POST['path'] .'/content/css/' .$_POST['name'] .'.css', 'w')):
    	fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    	fclose($fp);
    	$link='../index.php?id=css';
    else: $failed=true;
    endif;
break;

case 'save_css':
	if($fp=fopen('../' .$_POST['filename'], 'w')):
    	fwrite($fp, str_replace("\r", '', stripslashes($_POST['temp'])));
    	fclose($fp);
    	$link='../index.php?id=css';
    else: $failed=true;
    endif;
break;
default:
	print 'Vigased sisendandmed!';
break;
}

print '<a href="' .$link .'">Jätka</a><br>';

/*if($failed):
	print 'Faili salvestamine ebaõnnestus.';
else:
	print '<script type="text/javascript">
  	window.location="' .$link .'";
	</script>';
endif;*/
?>
</body>
</html>