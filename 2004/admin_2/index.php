<?php

/*
index.php
Veebimoototri administreerimisliides
Raivo Laanemets
23. juuli 2004
*/

//Sessioon
session_start();

require('conf.php');
$mysql=@mysql_connect($host, $user, $pass) or die('Ei saa ühendust andmebaasiga. Mysql server ei tööta, või vale aadress/kasutajanimi/parool. Kontrolli faili connect.php');
mysql_select_db($base);
$_SESSION['baas']=$base;

if (!isset($_SESSION['kasutaja'])) {
	if ($_POST['login']=='') {
    	Header('Location: login.html');
        die();
    } else {
    	$res=mysql_query("SELECT kasutaja_id FROM kasutajad WHERE nimi='" .$_POST['nimi'] ."' AND parool='" .md5($_POST['parool']) ."'");
        if ($result=mysql_fetch_array($res)): {
            $_SESSION['kasutaja']=$_POST['nimi'];
            $_SESSION['kasutaja_id']=$result[0];
            $res=mysql_query("SELECT saidi_id FROM kasutaja_saidid WHERE kasutaja_id=" .$result[0]);
            if ($result=mysql_fetch_row($res)) {
            	$_SESSION['saidi_id']=$result[0];
                $res=mysql_query("SELECT saidi_nimi,saidi_tee FROM saidid WHERE saidi_id=" .$result[0]);
                $result=mysql_fetch_row($res);
                $_SESSION['saidi_nimi']=$result[0];
                $_SESSION['saidi_tee']=$result[1];
            }
        }
        else:
         	Sleep(3);
        	Header('Location: login.html');
            die();
        endif;
    }
}
?>

<html>

<head>
  <title>Administreerimisliides</title>
  <style type="text/css">
	A {
    	font-family: verdana;
        font-size: 12pt;
        color: #556699;
        text-decoration: underlined;
	}
    .riba {
    	font-family: arial;
        font-size: 12pt;
        color: #ffffff;
        text-decoration: underlined;
        font-weight: normal;
    }
    .menu {
    	font-family: arial;
        font-size: 12pt;
        color: #ffffff;
        text-decoration: underlined;
        font-weight: normal;
	}
    H1 {
    	font-family: arial;
        font-size: 14pt;
        color: #556699;
    }
    H2 {
      	font-family: arial;
        font-size: 12pt;
        color: #556699;
        border-bottom: 1px solid #556699;
    }
    INPUT {
    	background-color: #eeeeee;
        border: 1px solid #000066;
    }
    TD {
        font-family: verdana;
        font-size: 11pt;
    }
    BODY {
    	background-color: #b1d3ec;
        margin: 0px;
    }
    .menuu {
    	border: 1px solid #556699;
    }
  </style>
</head>

<body>
<table style="width: 100%; height: 100%" cellspacing="0" cellpadding="6">
<tr>
<td colspan="2" style="height: 20pt; border-bottom: 2px solid #ffffff; background-color: #6caad9; color: #ffffff">
Sait <a href="<?php print $_SESSION['saidi_tee'] .'/index.php' ?>" target="vaade" class="riba"><?php print $_SESSION['saidi_nimi'] ?></a> <a href="?mis=valju" class="riba">Logi välja</a>
</td>
</tr>
<tr>
<td style="width: 80pt; border-right: 2px solid #ffffff; color: #b6c5f2; font-weight: bold; background-color: #6caad9" valign="top">
<br><br>
<a href="?mis=saidid" class="menu">Saidid</a><br>
<a href="?mis=kasutajad" class="menu">Kasutajad</a><br>
<a href="?mis=lehed" class="menu">Lehed</a><br>
<a href="?mis=objektid" class="menu">Objektid</a><br>
<a href="?mis=templeidid" class="menu">Templeidid</a><br>
<a href="?mis=abi" class="menu">Abi</a>
</td>
<td valign="top" width="100%" style="padding: 10pt">
<?php


$mis=$_GET['mis'];
if ($mis=='') {
	$mis=$_POST['mis'];
    if ($mis=='') $mis='index';
}

switch($mis) {
	case 'index':
    	include('php/tervitus.php');
	break;
    case 'saidid':
		include('php/saidid.php');
    break;
    case 'lisa_sait':
    	if ($_SESSION['kasutaja']=='root'): include('php/teesait.php');
        else: print 'Ainult kasutajal "root" on õigus saite lisada.'; endif;
    break;
    case 'kasutajad':
        if ($_SESSION['kasutaja']=='root'): include('php/kasutajad.php');
        else: print 'Ainult kasutajal "root" on õigus kasutajaid lisada ja kustutada.';
        endif;
    break;
    case 'lisa_kasutaja':
        if (mysql_query("INSERT INTO kasutajad VALUES('" .$_POST['nimi'] ."', '" .md5($_POST['parool']) ."', 0)")) print 'Kasutaja lisatud';
    break;
    case 'kasutaja':
    	if ($_SESSION['kasutaja']=='root'): include('php/kasutaja.php');
        else: print 'Ainult kasutajal "root" on õigus kasutaja andmeid muuta.';
        endif;
    break;
    case 'lisa_kasutaja_sait':
    	if ($_SESSION['kasutaja']=='root'):
        	if (mysql_query("INSERT INTO kasutaja_saidid VALUES ('" .$_POST['kasutaja_id'] ."', '" .$_POST['sait'] ."', 0) ")):
            	print 'Kasutaja sait lisatud';
            endif;
        else: print 'Ainult kasutajal "root" on õigus kasutaja andmeid muuta.';
        endif;
    break;
    case 'sait':
    	$_SESSION['sait']=$_GET['sait'];
        $_SESSION['saidi_nimi']=$_GET['nimi'];
        $_SESSION['saidi_baas']=$_GET['baas'];
        $_SESSION['saidi_tee']=$_GET['tee'];
        print 'Muudetav sait - ' .$_GET['nimi'];
    break;
    case 'kustuta_kasutaja':
         if ($_SESSION['kasutaja']=='root'):
        	if (mysql_query("DELETE FROM kasutajad WHERE kasutaja_id=" .$_POST['kasutaja'])
            && mysql_query("DELETE FROM kasutaja_saidid WHERE kasutaja_id=" .$_POST['kasutaja'])):
            	print 'Kasutaja kustutatud';
            endif;
        else: print 'Ainult kasutajal "root" on õigus kasutajat kustutada.';
        endif;
    break;
    case 'kustuta_sait':
    	if ($_SESSION['kasutaja']=='root'):
        	if (mysql_query("DELETE FROM saidid WHERE saidi_id=" .$_POST['sait'])
            && mysql_query("DELETE FROM kasutaja_saidid WHERE saidi_id=" .$_POST['sait'])):
            	print 'Sait kustutatud';
            endif;
        else: print 'Ainult kasutajal "root" on õigus saiti kustutada.';
        endif;
    break;
    case 'eemalda_sait':
         if ($_SESSION['kasutaja']=='root'):
        	if (mysql_query("DELETE FROM kasutaja_saidid WHERE saidi_id=" .$_POST['sait'] ." AND kasutaja_id=" .$_POST['kasutaja_id'])):
            	print 'Sait eemaldatud';
            endif;
        else: print 'Ainult kasutajal "root" on õigus saiti kustutada.';
        endif;
    break;
    case 'lehed': include('php/lehed.php'); break;
    case 'objekt': include('php/objekt.php'); break;
    case 'objektid': include('php/objektid.php'); break;
    case 'lisa_objekt':
    	mysql_select_db($_SESSION['saidi_baas']);
        $res=mysql_query("SELECT tekst FROM " .$_SESSION['saidi_nimi'] ."_templeidid WHERE id='" .$_POST['templeit'] ."'");
        $result=mysql_fetch_row($res);
        if (mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_sisu VALUES ('" .$_POST['nimi'] ."', '" .$result[0] ."', '" .$_POST['tyyp'] ."', '', 'ee')")) print 'Objekt lisatud';
        if ($_POST['tyyp']=='php') {
        	$fp=fopen($_SESSION['saidi_tee'] .'/php/' .$_POST['nimi'] .'.php', 'a');
            if (fwrite($fp, html_entity_decode($result[0]))) print 'Objekt lisatud';
            fclose($fp);
        }
    break;
    case 'lisa_leht':
    	mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_lehed VALUES ('" .$_POST['leht'] ."')"))
        	print 'Leht lisatud';
    break;
    case 'salvesta_objekt':
    	if ($_POST['tyyp']=='php'):
        	$fp=fopen($_SESSION['saidi_tee'] .'/php/' .$_POST['objekt'] .'.php', 'w');
            if (fwrite($fp, stripslashes(html_entity_decode($_POST['sisu']))))
            	print 'Objekt salvestatud';
            fclose($fp);
        else:
        	mysql_select_db($_SESSION['saidi_baas']);
            if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_sisu SET text='" .stripslashes($_POST['sisu']) ."' WHERE id='" .$_POST['objekt'] ."'"))
            	print 'Objekt salvestatud';
        endif;
    break;
    case 'valju':
    	session_unset();
        session_destroy();
        print '<a href="index.php">Logi uuesti sisse</a>
        <script language="JavaScript">window.location="index.php" </script>';
    break;
    case 'kustuta_objekt':
        mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("DELETE FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_POST['objekt'] ."'")
        && mysql_query("DELETE FROM " .$_SESSION['saidi_nimi'] ."_lehed WHERE id='" .$_POST['objekt'] ."'")) print 'Objekt kustutatud';
    break;
    case 'kustuta_leht':
        mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("DELETE FROM " .$_SESSION['saidi_nimi'] ."_lehed WHERE id='" .$_POST['leht'] ."'")) print 'Leht kustutatud';
	break;
    case 'templeidid':
    	include('php/templeidid.php');
    break;
    case 'lisa_templeit':
        mysql_select_db($_SESSION['saidi_baas']);
    	if (mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_templeidid VALUES ('" .$_POST['nimi'] ."', 'tühi')"))
        	print 'Templeit lisatud';
    break;
    case 'kustuta_templeit':
    	mysql_select_db($_SESSION['saidi_baas']);
    	if (mysql_query("DELETE FROM " .$_SESSION['saidi_nimi'] ."_templeidid WHERE id='" .$_POST['templeit'] ."'"))
        	print 'Templeit kustutatud';
    break;
    case 'templeit':
    	include('php/templeit.php');
    break;
    case 'salvesta_templeit':
        mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_templeidid SET tekst='" .stripslashes($_POST['sisu']) ."' WHERE id='" .$_POST['id'] ."'"))
        	print 'Templeit salvestatud';
    break;
    case 'saidi_info':
    	include('php/saidi_info.php');
    break;
    case 'lisa_keel':
    	mysql_select_db($_POST['baas']);
        if (mysql_query("INSERT INTO " .$_POST['nimi'] ."_keeled VALUES('" .$_POST['keel'] ."')")) print 'Keel lisatud.';
    break;
    case 'abi':
    	include('php/abi.php');
    break;
}

mysql_close();

?>

</td>
</tr>
</table>
</body>
</html>