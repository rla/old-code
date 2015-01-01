<html><head>
<title>Install</title>
</head>
<body>
<?php

/*
Raivo Laanemets 2004
Uue saidi tekitamiseks vajalikud funktsioonid.
*/

//kõik väljaspoolt tulevad muutujad
//saame post meetodiga
$act=$_POST['act'];
$path=$_POST['path'];
include('../conf/main.php');

switch($act) {
case 'struct_set':
    include('../' .$path .'/conf/main.php');
	$fp=fopen('../' .$path .'/content/p_structure.php', 'w');
    fwrite($fp, '<?php' .nl);
    fwrite($fp, chr(36) ."objektid['structure']['" .DEFAULT_LANG ."']['template']='structure.tpl';" .nl);
    foreach(array_keys($_POST) as $value) {
       print $value;
       if (substr($value, 0, 2)=='v_') fwrite($fp, chr(36) ."objektid['structure']['" .DEFAULT_LANG ."']['" .substr($value, 2) ."']='" .$_POST[$value] ."';" .nl);
    }
    fwrite($fp, '?>');
    fclose($fp);
    $link='../index.php?id=settings&amp;act=menu&amp;path=' .$path;
break;
case 'menu':
	$fp=fopen('../' .$path .'/css/menu.css', 'w');
    fwrite($fp, 'vmenu {' .nl .$_POST['mstyle'] .'}' .nl);
    fclose($fp);
    $link='../index.php?id=settings&amp;act=finish&amp;path=' .$path;
break;
case 'css':
    $fp=fopen('../' .$path .'/css/default.css', 'w');
    fwrite($fp, 'BODY {' .nl .$_POST['s_body'] .'}' .nl);
    fwrite($fp, '.text {' .nl .$_POST['s_text'] .'}' .nl);
    fwrite($fp, '.textlink {' .nl .$_POST['s_textlink'] .'}' .nl);
    fwrite($fp, '.title {' .nl .$_POST['s_title'] .'}' .nl);
    fwrite($fp, '.stitle {' .nl .$_POST['s_stitle'] .'}' .nl);
    fclose($fp);
    $link='../index.php?id=settings&amp;act=struct&amp;path=' .$path;
break;
case 'save_set':
	$fp=fopen('../' .$path .'/conf/main.php', 'w');
    fwrite($fp, '<?php' .nl);
    fwrite($fp, "define('DEFAULT_DOCTYPE', '" .$_POST['default_doctype'] ."');" .nl);
    fwrite($fp, "define('DEFAULT_CHARSET', '" .$_POST['default_charset'] ."');" .nl);
    fwrite($fp, "define('DEFAULT_LANG', '" .$_POST['default_lang'] ."');" .nl);
    fwrite($fp, "define('DEFAULT_TITLE', '" .$_POST['default_title'] ."');" .nl);
    fwrite($fp, "define('DEFAULT_ID', '" .$_POST['default_id'] ."');" .nl);
    fwrite($fp, "define('TITLE_SEP', '" .$_POST['title_sep'] ."');" .nl);
    fwrite($fp, "define('CACHE_EXPIRES', '" .$_POST['cache_exp'] ."');" .nl);
    fwrite($fp, '?>');
    fclose($fp);
	$link='../index.php?id=settings&amp;act=header&amp;path=' .$path;
break;
case 'header':
    include('../' .$path .'/conf/main.php');
	$fp=fopen('../' .$path .'/content/p_header.php', 'w');
    fwrite($fp, '<?php' .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['doctype']=DEFAULT_DOCTYPE;" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['author']='" .$_POST['author'] ."';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['keywords']='" .$_POST['keywords'] ."';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['description']='" .$_POST['description'] ."';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['robots']='" .$_POST['robots'] ."';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['copyright']='" .$_POST['copyright'] ."';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['title']=DEFAULT_TITLE;" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['charset']=DEFAULT_CHARSET;" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['template']='header.tpl';" .nl);
    fwrite($fp, chr(36) ."objektid['header']['" .DEFAULT_LANG ."']['head_code']='" .$_POST['head_code'] ."';" .nl);
    fwrite($fp, '?>');
    fclose($fp);
    $link='../index.php?id=settings&amp;act=footer&amp;path=' .$path;
break;
case 'footer':
    $fp=fopen('../' .$path .'/content/p_footer.php', 'w');
    fwrite($fp, '<?php' .nl);
    fwrite($fp, 'print "' .$_POST['footer'] .'";' .nl);
    fwrite($fp, '?>');
    fclose($fp);
    $link='../index.php?id=settings&amp;act=css&amp;path=' .$path;
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