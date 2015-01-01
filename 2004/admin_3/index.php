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
$_SESSION['keel']=$keel;

if (!isset($_SESSION['kasutaja'])) {
	if ($_POST['login']=='') {
    	Header('Location: login-' .$keel .'.html');
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
                $res=mysql_query("SELECT id FROM " .$result[0] ."_keeled");
                $result=mysql_fetch_row($res);
                $_SESSION['saidi_keel']=$result[0];
            } elseif($_SESSION['kasutaja']=='root') {
            	$res=mysql_query("SELECT saidi_nimi,saidi_tee FROM saidid LIMIT 1");
                if ($result=mysql_fetch_row($res)) {
                	$_SESSION['saidi_nimi']=$result[0];
                    $_SESSION['saidi_tee']=$result[1];
                    $res=mysql_query("SELECT id FROM " .$result[0] ."_keeled");
                	$result=mysql_fetch_row($res);
                	$_SESSION['saidi_keel']=$result[0];
                }
            }
        }
        else:
         	Sleep(3);
        	Header('Location: login-' .$keel .'.html');
            die();
        endif;
    }
}

$mis=$_GET['mis'];
if ($mis=='') {
	$mis=$_POST['mis'];
    if ($mis=='') $mis='index';
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
    .submenu {
    	font-family: arial;
        font-size: 11pt;
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
    INPUT,OPTION,TEXTAREA {
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
Sait <a href="<?php print $_SESSION['saidi_tee'] .'/index.php' ?>" target="vaade" class="riba"><?php print $_SESSION['saidi_nimi'] .':' .$_SESSION['saidi_keel'] ?></a> <a href="?mis=valju" class="riba">Logi välja</a>
</td>
</tr>
<tr>
<td style="width: 80pt; border-right: 2px solid #ffffff; color: #b6c5f2; font-weight: bold; background-color: #6caad9" valign="top">
<br><br>
<a href="?mis=saidid" class="menu">Saidid</a><br>
<a href="?mis=kasutajad" class="menu">Kasutajad</a><br>
<a href="?mis=keeled" class="menu">Keeled</a><br>
<a href="?mis=lehed" class="menu">Lehed</a><br>
<?php
if ($mis=='lehed' || $mis=='pealkirjad' || $mis=='pealkiri') print '&nbsp;&nbsp;<a href="?mis=pealkirjad" class="submenu">Pealkirjad</a><br>';
?>
<a href="?mis=objektid" class="menu">Objektid</a><br>
<a href="?mis=templeidid" class="menu">Templeidid</a><br>
<a href="?mis=abi" class="menu">Abi</a><br>
<a href="?mis=moodulid" class="menu">Moodulid</a>
<?php
if ($mis=='moodulid' || $mis=='moodul' || $mis=='moodul_act') {
	mysql_select_db($_SESSION['saidi_baas']);
    $res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_moodulid");
    while($result=mysql_fetch_row($res)) print '&nbsp;&nbsp;<a href="?mis=moodul&amp;moodul=' .$result[0] .'" class="submenu">' .$result[0] .'</a><br>';
}
?>
<a href="?mis=ajalugu" class="menu">Ajalugu</a>
<a href="?mis=tagavara" class="menu">Tagavara</a>
<a href="?mis=failid" class="menu">Failid</a>
</td>
<td valign="top" width="100%" style="padding: 10pt">
<?php

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
        $tekst=$result[0];

        $keeled=array();
        $res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_keeled");
        while($result=mysql_fetch_row($res)) array_push($keeled, $result[0]);

        if ($_POST['tyyp']=='css') $keeled=array('--');

        foreach($keeled as $value) if (mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_sisu VALUES ('" .$_POST['nimi'] ."', '" .$tekst ."', '" .$_POST['tyyp'] ."', '', '" .$value ."')")) print 'Objekt lisatud - ' .$value .'<br>';

        /*if ($_POST['tyyp']=='php') {
        	$fp=fopen($_SESSION['saidi_tee'] .'/php/' .$_POST['nimi'] .'.php', 'a');
            if (fwrite($fp, html_entity_decode($result[0]))) print 'Objekt lisatud';
            fclose($fp);
        }*/
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
            if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_sisu SET tekst='" .stripslashes($_POST['sisu']) ."' WHERE id='" .$_POST['objekt'] ."' AND keel='" .$_SESSION['saidi_keel'] ."'"))
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
    case 'keeled': include('php/keeled.php'); break;
    case 'keel':
    	$_SESSION['saidi_keel']=$_GET['keel'];
        print 'Keel muudetud - ee';
    break;
    case 'lisa_klass':
    	$res=mysql_query("SELECT tekst FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_POST['objekt'] ."'");
        $result=mysql_fetch_row($res);
    	if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_sisu SET tekst='" .mysql_escape_string($result[0] .$_POST['nimi'] ." {}") ."' WHERE id='" .$_POST['objekt'] ."'")) print 'Klass lisatud';
        else print mysql_error();
    break;
    case 'salvesta_css':
        function ReFix($inp) {
        	$outp=str_replace('=*=', '.', $inp);
            $outp=str_replace('==*', '_', $outp);
            return $outp;
        }
        $content='';
    	foreach($_POST as $key=> $value) {
    		$val=$_POST[$key];
        	if (is_array($val)) {
           		$kkey=$key;
        		$content.=ReFix($kkey) ."{\n";
                $n=false; $k='';
            	foreach($val as $key=>$subvalue) {
                    if ($n) {$key=$k; $n=false; }
                	if ($key=='_new__var_') { $k=$subvalue; $n=true; }
            		if (!$n && $subvalue!='') { $content.="  ".ReFix($key) .": " .ReFix($subvalue) .";\n"; };
            	}
            	$content.="}\n";
        	}
    	}
        if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_sisu SET tekst='" .mysql_escape_string($content) ."' WHERE id='" .$_POST['objekt'] ."'")) print 'Stiil salvestatud';
        else print mysql_error();
    break;
    case 'moodulid': include('php/moodulid.php'); break;
    case 'lisa_moodul':
    	mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_moodulid VALUES ('" .$_POST['moodul'] ."')")) print 'Moodul lisatud';
        else print 'Lisamine ebaõnnestus: ' .mysql_error();
        include('moodulid/' .$_POST['moodul'] .'/install.php');
    break;
    case 'moodul':
    	include('moodulid/' .$_GET['moodul'] .'/mod.php');
    break;
    case 'moodul_act':
        include('moodulid/' .$_POST['moodul'] .'/action.php');
    break;
    case 'ajalugu':
    	include('php/ajalugu.php');
    break;
    case 'tagavara':
    	include('php/tagavara.php');
    break;
    case 'tee_tagavara':
    	include('php/tee_tagavara.php');
    break;
    case 'pealkirjad':
    	include('php/pealkirjad.php');
    break;
    case 'pealkiri':
    	include('php/pealkiri.php');
    break;
    case 'muuda_pealkiri':
    	mysql_select_db($_SESSION['saidi_baas']);
        if (mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_sisu SET pealkiri='" .$_POST['pealkiri'] ."' WHERE id='" .$_POST['leht'] ."' AND keel='" .$_SESSION['saidi_keel'] ."'")) print 'Pealkiri muudetud';
    break;
    case 'failid':
    	include('php/failid.php');
    break;
    case 'yleslaad':
		$filen=$_SESSION['saidi_tee'] .'/' .$_POST['kaust'] .'/' .$_FILES['fail']['name'];
		if (move_uploaded_file($_FILES['fail']['tmp_name'], $filen)) {
   			print 'Fail üles laetud<br><a href="?mis=failid&amp;kaust=' .$_POST['kaust'] .'">Failide juurde</a>';
		} else {
   			print "Tekkis viga";
		}
    break;
    case 'kustuta_fail':
    	if (@unlink($_SESSION['saidi_tee'] .'/' .$_GET['kaust'] .'/' .$_GET['fail'])) print 'Fail kustutatud.<br><a href="?mis=failid&amp;kaust=' .$_GET['kaust'] .'">Tagasi</a>';
        	else print 'Faili kustutamise viga!';
    break;
}

mysql_close();

?>

</td>
</tr>
</table>
</body>
</html>