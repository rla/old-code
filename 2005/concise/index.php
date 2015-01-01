<?

/*
Concise 'minimal' administeerimisliides.
Raivo Laanemets 18. jaanuar 2005.
*/

/*
Tööks vajalikud konstandid.
*/

//MySql.
define('mysql_host', 'localhost');
define('mysql_user', 'd6349sa7045');
define('mysql_pass', 'Diablo666');
define('mysql_base', 'd6349sd4071');

//kõigi õigustega kasutaja parool.
define('root_pass', 'myass');

//Saitide juurkaust
define('sites_root', '..');

/*
Kõigepealt üritame ühenduda MySql serverisse.
Ebaõnnestumise korral väljastame vastavad veateated.
*/

mysql_connect(mysql_host, mysql_user, mysql_pass) or die('Ei saa ühendada MySql serveriga.');
mysql_select_db(mysql_base) or die('Soovitud andmebaasi ei eksisteeri või ei saa seda kasutada.');

/*
Seejärel paneme paika sessiooni.
*/

session_start();

/*
Väljastame HTML päise ja stiililehe. Selle järel on javascripti kood,
mis tõstab esile valitud objekti leheküljel.
*/

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-13">
<title>Concise 'minimal'</title>
<style type="text/css">
.shead, a, body, .triba, .raam, .menu, th {
	font-family: Arial, Helvetica;
	font-size: 12pt;
}
.shead {
	color: #333333;
	font-size: 16pt;
}
body {
	margin: 10px;
	background-color: #ffffff;
}
a {
	color: #666666;
}
.triba {
	background-color: #eeeeee;
	padding: 8px;
}
.raam {
	border: 1px solid #999999;
}
.menu, label {
	color: #666666;
	font-weight: bold;
	margin-left: 4px;
	margin-right: 4px;
}
input {
	margin-left: 4px;
}
</style>
</head>
<html>
<body>
<script language="JavaScript">
function hilight(e) {
	e.style.background="#ffffff";
}
function normal(e) {
	e.style.background="#eeeeee";
}
function edit(obj) {
	window.location="?action=editobj&i=" +obj;
}
</script>
<div class="raam">
<div class="triba"><span class="shead">Admin</span></div>

<?

/*
Funktsioonid.
*/

function checkroot() {

	/*
	Antud funktsioon kontrollib, kas kasutajal on root õigus,
	vastasel juhul väljastab veateate. Seda funktsiooni kasutatakse
	enne tegevust, mis nõuab root õigusi. Tagastab true, kui antud
	kasutaja on root.
	*/

	if ($_SESSION['userid']!=0) {
		echo 'Antud tegevus on lubatud vaid root kasutajale.';
		return false;
	}
	
	return true;
	
}

function sectionhead($what) {

	/*
	Antud funktsioon on siin ainult kujunduse tekitamise eesmärgiga.
	Väljastab tegevuse pealkirja kasti triba sees. Lisaks alustatakse
	tegevuse sisu kasti väljastamisega.
	*/
	
	echo '<div class="triba" style="border-bottom: 2px solid #ffffff"><span class="shead">' .$what .'</span></div>
	<div class="triba">';
	
}

/*
Kui kasutajal pole identifikaatorit, anname talle 9999-e selleks, 
ning tema kasutajanimeks dummy. Määrame mõnedele sessioonimuutujatele
algväärtused. Kui kasutaja on sisse loginud juba, siis loeme action
muutuja väärtuse. Antud muutuja asub $_GET või $_POST massiivis. Muutuja
väärtuse võtame sealt, kus ta määratud on.
*/

if (!isset($_SESSION['userid'])) {
	$_SESSION['userid']=9999;
	$_SESSION['user']='dummy';
	$_SESSION['siteid']=9999;
	$_SESSION['site']='määramata';
	$action='login';
} else {
	$action=$_GET['action'] or $action=$_POST['action'];
	if ($_SESSION['userid']==9999) $action='login';
}

/*
Kui kasutaja üritab sisse logida ja identifikaatorit parema vastu
vahetada, siis anname talle selleks võimaluse. Sisselogimisele
järgneb viivitus 3 sekundit, mis muudab kasutajate paroolide
lahtimurdmise jõumeetodil mõistliku ajavahemiku jooksul võimatuks.
*/

if ($_POST['login']==1) {
	if ($_POST['user']=='root') {
		if ($_POST['pass']==root_pass) {
			$_SESSION['userid']=0;
			$_SESSION['user']='root';
			$action='algus';
		}
	} else {
		$res=mysql_query("SELECT id FROM users WHERE user='" .$_POST['user'] ."' AND pass='" .md5($_POST['pass']) ."'");
		if ($result=mysql_fetch_row($res)) {
			 $_SESSION['userid']=$result[0];
			 $_SESSION['user']=$_POST['user'];
			 $action='algus';
		}
	}
	sleep(3);
}

/*
Väljastame kasutajanime, muudetava saidi ja muudetava keele. Sinna otsa menüü.
*/

echo '<div class="triba" style="border-bottom: 2px solid #ffffff; border-top: 2px solid #ffffff">
Kasutaja <b>' .$_SESSION['user'] .'</b> Sait <b>' .$_SESSION['site'] .'</b></div>
<div class="triba"><a href="?action=algus" class="menu">Algus</a> - <a href="?action=logout" class="menu">Logi välja</a> - 
<a href="?action=users" class="menu">Kasutajad</a> - <a href="?action=sites" class="menu">Saidid</a></div>';

/*
Kui saidi id on määratud, st. ei võrdu 9999'ga, siis näitame saidi menüüd.
Vastavad moodulid loeme said moodulite andmebaasist.
*/

if ($_SESSION['siteid']!=9999) {
	echo '<div class="triba" style="border-top: 2px solid #ffffff">
	<a href="?action=structure" class="menu">Struktuur</a> - 
	<a href="?action=pages" class="menu">Lehed</a> - 
	<a href="?action=files" class="menu">Failid</a> -
	<a href="?action=backup" class="menu">Tagavara</a>';
	
	$res=mysql_query("SELECT name FROM " .$_SESSION['site'] ."_modules");
	while ($result=mysql_fetch_row($res)) echo ' - <a href="?action=mod&amp;m=' .$result[0] .'">' .$result[0] .'</a>';
	
	echo '</div>';
	
}


/*
Ülemise osa musta raami lõpetamine ja alumise raami alustamine.
*/

echo '</div><br><div class="raam">';


switch ($action) {

	default:
	
		/*
		Määramata tegevuse korral väljastame sisselogimise vormi.
		*/
		
		sectionhead('Logi sisse');
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="login" value="1">
		<label for="user">Kasutajanimi</label><br>
		<input type="text" name="user"><br>
		<label for="pass">Parool</label><br>
		<input type="password" name="pass"><br><br>
		<input type="submit" value="Logi sisse">
		</form>';
		
		//DEBUG-abi
		echo  $action;
		
	break;
	
	case 'backup':
	
		/*
		Tagavarakoopiate tegemine/taastamine.
		*/
	
		sectionhead('Tagavarakoopia tegemine');
		
		require('lib/backup.php');
	
	break;
	
	case 'addparse':
		
		/*
		Html faili lisamine, kusjuures fail jaotatakse objektideks.
		*/
		
		sectionhead('Html faili lisamine');
		
		require('lib/addparse.php');
	
	break;
	
	case 'files':
	
		sectionhead('Failid');
		
		$_SESSION['file_root']=sites_root .'/' .$_SESSION['site'];
		
		if ($_GET['d']!='') $curdir=$_SESSION['file_root'] .'/' .$_GET['d'];
		else $curdir=$_SESSION['file_root'];
		
		echo '<table><tr><th>Fail</th><th>Tegevused</th></tr>';
		
		$d=@dir($curdir);
		while ($entry=$d->read()) {
			if ($entry!='.' && $entry!='..') {
				if (is_dir($curdir .'/' .$entry)) {
					echo '<tr><td><a href="?action=files&amp;d=' .$_GET['d'] .'/' .$entry .'">' .$entry .'</a></td><td>-</td></tr>';
				} else {
					echo '<tr><td>' .$entry .'</td><td><a href="?action=deletefile&amp;f=' .$_GET['d'] .'/' .$entry .'">Kustuta</a></td></tr>';
				}
			}
		}
		
		$d->close();
		
		echo '</table><br><a href="?action=uploadfile&amp;d=' .$_GET['d'] .'">Laadi üles uus fail.</a>';
	
	break;
	
	case 'uploadfile':
		
		/*
		Faili antud kausta üleslaadimine.
		*/
		
		sectionhead('Faili üleslaadimine');
		
		$_SESSION['dir']=$_GET['d'];
		
		echo '<form method="post" action="index.php" enctype="multipart/form-data">
		<input type="hidden" name="action" value="upload_do">
		<label for="file">Fail arvutist</label>
		<input type="file" name="file"><br><br>
		<input type="submit" value="Laadi üles">
		</form>';
	
	break;
	
	case 'upload_do':
		
		@move_uploaded_file($_FILES['file']['tmp_name'], $_SESSION['file_root'] .$_SESSION['dir'] .'/' .$_FILES['file']['name']);
		
		echo '<script language="JavaScript">window.location="index.php?action=files&d=' .$_SESSION['dir'] .'"</script>';

	break;
	
	case 'deletefile':
		
		sectionhead('Faili kustutamine');
		
		echo 'Kas sa soovid kustutada faili <b>' .$_GET['f'] .'</b> (<a href="?action=deletefile_do&amp;f=' .$_GET['f'] .'">jah</a>, <a href="?action=dir&amp;d=' .$_SESSION['dir'] .'">ei</a>)';
	
	break;
	
	case 'deletefile_do':
		
		$_GET['f']=str_replace('..', 'a', $_GET['f']);
		unlink($_SESSION['file_root'] .$_GET['f']);
		echo '<script language="JavaScript">window.location="index.php?action=files"</script>';
	
	break;
	
	case 'algus':
	
		/*
		Leht, mida kasutaja pärast sisselogimist näeb.
		*/
		
		sectionhead('Tere ' .$_SESSION['user']);
		
		echo '<b>Sooritatavad tegevused:</b><ul>
		<li><a href="?action=install">Tee alginstalleerimine (kaotad kõik seniloodud admin liidesega seotud andmed).</a>
		<li><a href="?action=users">Kasutajate lisamine, kustutamine ja nende õigused.</a>
		<li><a href="?action=sites">Saitide lisamine, kustutamine.</a>
		<li><a href="?action=site">Vali muudetav sait.</a>
		</ul>';
		
	break;
	
	case 'install':
		
		/*
		Algpaigaldamise kontrollküsimine.
		Antud tegevus on lubatud vaid root kasutajale.
		*/
		
		sectionhead('Algapigaldamine');
		
		if (!checkroot()) break;
		
		echo 'Algpaigaldus loob andmebaasi uued tabelid ja kustutab vanad. Kord kustutatud
		tabeleid enam tagasi ei saa. Seepärast on soovitav iga teatud aja tegant teha
		tagavarakoopiaid.<br><br>
		Kas sa soovid algpaigaldamist teha (<a href="?action=install_do">jah</a>, <a href="?action=algus">ei</a>).';
		
	break;
	
	case 'install_do':
	
		/*
		Algpaigaldamise sooritamine.
		*/
		
		sectionhead('Algapigaldamine');
		
		if (!checkroot()) break;
		
		/*
		Tabelite loomine. Vastavad käsud asuvad failis mysql/concise.php.
		*/
		
		require('mysql/concise.php');
		
		echo 'Algpaigaldamine lõpetatud.';
		
	break;
	
	case 'users':
	
		sectionhead('Kasutajad');
		
		if (!checkroot()) break;
		
		echo '<b>Kasutajatega seotud tegevused:</b>
		<ul>
		<li><a href="?action=userslist">Nimekiri</a>
		<li><a href="?action=adduser">Lisamine</a>
		<li><a href="?action=rmuser">Kustutamine</a>
		<li><a href="?action=user_s">Õigused saitidel</a>
		</ul>';
		
	break;
	
	case 'sites':
	
		sectionhead('Saidid');
		
		if (!checkroot()) break;
		
		echo '<b>Saitidega seotud tegevused:</b>
		<ul>
		<li><a href="?action=siteslist">Nimekiri</a>
		<li><a href="?action=addsite">Lisamine</a>
		<li><a href="?action=rmsite">Kustutamine</a>
		</ul>';
		
	break;
	
	case 'adduser':
		
		sectionhead('Kasutaja lisamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanime ja parooli maksimaalne pikkus on 8 tähte.
		Ära kasuta võõraid sümboleid ja muid tähti, mis võiksid töö süsteemiga
		ebamugavaks teha. Tugev parool on vähemalt kuus sümbolit pikk, sisaldab
		nii suuri kui väikeseid tähti ja numbreid.<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="adduser_do">
		<label for="user">Kasutajanimi:</label><br>
		<input type="text" name="user"><br>
		<label for="pass">Parool:</label><br>
		<input type="password" name="pass"><br><br>
		<input type="submit" value="Lisa kasutaja">
		</form>';		
		
	break;
	
	case 'adduser_do':
		
		sectionhead('Kasutaja lisamine');
		
		if (!checkroot()) break;
		
		mysql_query("INSERT INTO users VALUES (0, '" .$_POST['user'] ."', '" .md5($_POST['pass']) ."')");
		
		echo 'Kasutaja lisatud.';
	break;
	
	case 'userslist':
	
		sectionhead('Kasutajate nimekiri');
		
		if (!checkroot()) break;
		
		echo 'Vajutades kasutajanimele, saad muuta tema kasutajanime ja parooli.<br><br>
		<table><tr><th>ID</th><th>Kasutajanimi</th></tr>';
		
		$res=mysql_query("SELECT id, user FROM users ORDER BY user");
		while ($result=mysql_fetch_array($res)) echo '<tr><td>' .$result['id'] .'</td><td><a href="?action=userprops&amp;u=' .$result['id'] .'">' .$result['user'] .'</a></td></tr>';
		
		echo '</table>';
		
	break;
	
	case 'rmuser':
	
		sectionhead('Kasutaja kustutamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutaja kustutamiseks vali listist kasutajanimi ning vajuta "Kustuta kasutaja".<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="rmuser_do">
		<select name="userid">';
		
		$res=mysql_query("SELECT id, user FROM users ORDER BY user");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['id'] .'">' .$result['user'] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="Kustuta kasutaja">
		</form>';
		
	break;
	
	case 'rmuser_do':
	
		sectionhead('Kasutaja kustutamine');
		
		if (!checkroot()) break;
		
		mysql_query("DELETE FROM users WHERE id=" .$_POST['userid']);
		
		echo 'Kasutaja kustutatud';
		
	break;
	
	case 'addsite':
	
		sectionhead('Saitide lisamine');
		
		if (!checkroot()) break;
		
		echo 'Saidi nimi ei tohiks sisaldada midagi peale numbrite ja väikeste tähtede a-z.
		Juba sama olemasoleva nimega saidi lisamine tähendab vana kustutamist.<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="addsite_do">
		<label for="name">Saidi nimi:</label><br>
		<input type="text" name="name"><br><br>
		<input type="submit" value="Lisa sait">
		</form>';
		
	break;
	
	case 'addsite_do':
	
		sectionhead('Saitide lisamine');
		
		if (!checkroot()) break;
		
		mysql_query("INSERT INTO sites VALUES(0, '" .$_POST['name'] ."')");
		
		/*
		Concise 'minimal' veebimootori algtabelite loomine,
		Vastavad käsud asuvad failis mysql/new.php.
		*/
		
		require('mysql/new.php');
		
		echo 'Sait lisatud. Saidi töötamiseks vajalikud algfailid pead ise paigaldama.';
		
	break;
	
	case 'siteslist':
	
		sectionhead('Saitide nimekiri');
		
		if (!checkroot()) break;
		
		echo '<table><tr><th>Saidi nimi</th></tr>';
		
		$res=mysql_query("SELECT name FROM sites ORDER BY name");
		while ($result=mysql_fetch_row($res)) echo '<tr><td>' .$result[0] .'</td></tr>';
		
		echo '</table>';
		
	break;
	
	case 'rmsite':
	
		sectionhead('Saidi kustutamine');
		
		if (!checkroot()) break;
		
		echo 'Saidi kustutamiseks vali listist saidi nimi ning vajuta "Kustuta sait".<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="rmsite_do">
		<select name="site">';
		
		$res=mysql_query("SELECT id, name FROM sites ORDER BY name");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['name'] .'">' .$result['name'] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="Kustuta sait">
		</form>';
		
	break;
	
	case 'rmsite_do':
	
		sectionhead('Saidi kustutamine');
		
		if (!checkroot()) break;
		
		mysql_query("DELETE FROM sites WHERE name='" .$_POST['site'] ."'");
		mysql_query("DROP TABLE " .$_POST['site'] ."_objects");
		mysql_query("DROP TABLE " .$_POST['site'] ."_html");
		mysql_query("DROP TABLE " .$_POST['site'] ."_modules");
		mysql_query("DROP TABLE " .$_POST['site'] ."_tree");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_images");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_links");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_listitems");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_lists");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_objects");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_pars");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_titles");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_tables");
		mysql_query("DROP TABLE " .$_POST['site'] ."_pages_fields");
		
		echo 'Sait kustutatud andmebaasist. Failid pead ise ära kustutama.';
		
	break;
	
	case 'user_s':
	
		sectionhead('Kasutajate õigused');
		
		if (!checkroot()) break;
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="userperm">
		<label for="userid">Vali kasutaja</label><br>
		<select name="user">';
		
		$res=mysql_query("SELECT id, user FROM users ORDER BY user");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['user'] .':' .$result['id'] .'">' .$result['user'] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="Edasi">
		</form>';
	
	break;
	
	case 'userperm':
	
		sectionhead('Kasutaja õigused');
		
		if (!checkroot()) break;
		
		$user=explode(':' ,$_POST['user']);
		
		$_SESSION['userperm']=$user[0];
		$_SESSION['userpermid']=$user[1];
		
		echo 'Kasutajanimi: ' .$user[0] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
	break;
	
	case 'addperm':
	
		sectionhead('Juurdepääsu lisamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanimi: ' .$_SESSION['userperm'] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="addperm_do">
		<label for="site">Sait</label>
		<select name="site">';
		
		$res=mysql_query("SELECT id, name FROM sites ORDER BY name");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['id'] .'">' .$result['name'] .'</option>';
		
		echo '</select><br>		
		<input type="checkbox" name="php" value="y">
		<label for="php">PHP</label><br>
		<input type="checkbox" name="html" value="y">
		<label for="html">HTML</label><br><br>
		<input type="submit" value="Lisa juurdepääs">
		</form>';
		
	break;
	
	case 'addperm_do':
	
		sectionhead('Juurdepääsu lisamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanimi: ' .$_SESSION['userperm'] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
		$php='n'; $html='n';
		if ($_POST['php']=='y') $php='y';
		if ($_POST['html']=='y') $html='y';
		
		mysql_query("INSERT INTO u_sites VALUES (0, " .$_SESSION['userpermid'] .", " .$_POST['site'] .", '" .$php ."', '" .$html ."')");
		
		echo 'Juurdepääs lisatud.';
		
	break;
	
	case 'listperm':
	
		sectionhead('Juurdepääsu nimekiri');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanimi: ' .$_SESSION['userperm'] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
		$sites=array(); $php=array(); $html=array();
		$res=mysql_query("SELECT siteid, php, html FROM u_sites WHERE userid=" .$_SESSION['userpermid']);
		while ($result=mysql_fetch_row($res)) {
			$sites[]=$result[0];
			$php[]=$result[1];
			$html[]=$result[2];
		}
		
		$sites_str=implode(', ', $sites);
		
		echo 'Tabeli veerus PHP y tähendab, et antud kasutaja võib muuta ja sisestada PHP koodi
		antud saidil. Sama kehtib HTML kohta vastavalt HTML veerule.<br><br>
		<table><tr><th>Saidi nimi</th><th>PHP</th><th>HTML</th></tr>';
		
		$res=mysql_query("SELECT name FROM sites WHERE id IN (" .$sites_str .")");
		for ($i=0; $result=@mysql_fetch_row($res); $i++) echo '<tr><td>' .$result[0] .'</td><td>' .$php[$i] .'</td><td>' .$html[$i] .'</td></tr>';
		
		echo '</table>';
		
	break;
	
	case 'rmperm':
	
		sectionhead('Juurdepääsu eemaldamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanimi: ' .$_SESSION['userperm'] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
		$sites=array(); $php=array(); $html=array();
		$res=mysql_query("SELECT siteid, id FROM u_sites WHERE userid=" .$_SESSION['userpermid']);
		while ($result=mysql_fetch_row($res)) {
			$sites[]=$result[0];
			$id[]=$result[1];
		}
		
		$sites_str=implode(', ', $sites);
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="rmperm_do">
		<label for="site">Sait</label>
		<select name="site">';
		
		$res=mysql_query("SELECT name FROM sites WHERE id IN (" .$sites_str .")");
		for ($i=0; $result=mysql_fetch_row($res); $i++) echo '<option value="' .$id[$i] .'">' .$result[0] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="Eemalda">
		</form>';
		
	break;
	
	case 'rmperm_do':

		sectionhead('Juurdepääsu eemaldamine');
		
		if (!checkroot()) break;
		
		echo 'Kasutajanimi: ' .$_SESSION['userperm'] .' Tegevused: <a href="?action=listperm">Juurdepääs</a> - <a href="?action=addperm">Lisa sait</a> - <a href="?action=rmperm">Eemalda sait</a><br><br>';
		
		mysql_query("DELETE FROM u_sites WHERE id=" .$_POST['site']);
		
		echo 'Juurdepääs eemaldatud.';
	break;
	
	case 'site':
		
		/*
		Valitakse sait, mida hakatakse redigeerima.
		Saidi id ja nimi salvestatakse sessioonimuutujana.
		*/
		
		sectionhead('Saidi valimine');
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="select_site">
		<label for="site">Sait</label>
		<select name="site">';
		
		$res=mysql_query("SELECT id, name FROM sites ORDER BY name");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['id'] .'">' .$result['name'] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="Vali">
		</form>';
		
	break;
	
	case 'select_site':
		
		/*
		Toimub kontroll, kas antud kasutajal on õigus antud saiti valida.
		*/
		
		$res=mysql_query("SELECT id, php, html FROM u_sites WHERE userid=" .$_SESSION['userid'] ." AND siteid=" .$_POST['site']);
		if ($result=mysql_fetch_array($res) || $_SESSION['userid']==0) {
			$_SESSION['siteid']=$_POST['site'];
			
			$res=mysql_query("SELECT name FROM sites WHERE id=" .$_POST['site']);
			$result=mysql_fetch_row($res);
			
			$_SESSION['site']=$result[0];
			
			$_SESSION['file_root']=sites_root .'/' .$_SESSION['site'];
			
		} else {
			echo 'Viga! Antud saidi valimiseks puuduvad teil õigused.';
		}
		
		echo '<script language="JavaScript">window.location="index.php?action=algus"</script>';
		
	break;
	
	case 'logout':
	
		/*
		Välja logimine, Killitakse sessioon.
		*/	
		
		session_destroy();
		
		sectionhead('Välja logitud.');
		
		echo 'Head aega!';
	
	break;
	
	case 'structure':
	
		sectionhead('Saidi struktuur');
		
		echo 'Puu juurt (root) ei tohi ära kustutada. Vastasel
		juhul ei saa sa enam uusi harusid ja lehti lisada.<br><br>';
		
		$res=mysql_query("SELECT lft, rgt FROM " .$_SESSION['site'] ."_tree WHERE name='root'");
		$row=mysql_fetch_array($res);
		$right=array();
		$res=mysql_query("SELECT id, name, lft, rgt FROM " .$_SESSION['site'] ."_tree WHERE lft BETWEEN " .$row['lft'] ." AND " .$row['rgt'] ." ORDER BY lft ASC");

		while ($row = mysql_fetch_array($res)) {
			if (count($right)>0) while ($right[count($right)-1]<$row['rgt']) array_pop($right);
			echo str_repeat('&nbsp;&nbsp;', count($right)) .'<a href="?action=addnode&amp;place=' .$row['lft'] .'">' .$row['name'].'</a>&nbsp;&nbsp;
        		<a href="?action=deletenode&amp;place=' .$row['lft'] .'">Kustuta</a><br>';
			$right[]=$row['rgt'];
		}
		
	break;
	
	case 'addnode':
	
		/*
		Saidi struktuurile lehe lisamine.
		*/
		
		$_SESSION['treeplace']=$_GET['place'];
		
		sectionhead('Struktuurile lehe lisamine');
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="addnode_do">
		<label for="page">Leht</label>
		<select name="page">';
		
		$res=mysql_query("SELECT name, id FROM " .$_SESSION['site'] ."_objects");
		while ($result=mysql_fetch_array($res)) echo '<option value="' .$result['name'] .'">' .$result['name'] .'</option>';
		
		echo '</select><br><br>
		<input type="submit" value="lisa">
		</form>';
		
	break;
	
	case 'addnode_do':
	
		$place=$_SESSION['treeplace'];
		$lft=$_SESSION['treeplace']+1;
		$rgt=$_SESSION['treeplace']+2;
		
		mysql_query("UPDATE " .$_SESSION['site'] ."_tree SET rgt=rgt+2 WHERE rgt>" .$place);
		mysql_query("UPDATE " .$_SESSION['site'] ."_tree SET lft=lft+2 WHERE lft>" .$place);
		
		$res=mysql_query("SELECT id FROM " .$_SESSION['site'] ."_objects WHERE name='" .$_POST['page'] ."'");
		$result=mysql_fetch_array($res);

		mysql_query("INSERT INTO " .$_SESSION['site'] ."_tree VALUES (0, '" .$_POST['page'] ."', " .$result['id'] .", " .$lft .", " .$rgt .")");
		
		echo '<script language="javascript">window.location="?action=structure"</script>';	
	
	break;
	
	case 'deletenode':
	
		mysql_query("DELETE FROM " .$_SESSION['site'] ."_tree WHERE lft=" .$_GET['place']);
		mysql_query("UPDATE " .$_SESSION['site'] ."_tree SET lft=lft-2 WHERE lft>" .$_GET['place']);
		mysql_query("UPDATE " .$_SESSION['site'] ."_tree SET rgt=rgt-2 WHERE rgt>=" .$_GET['place']);
		
		echo '<script language="javascript">window.location="?action=structure"</script>';
		
	break;
	
	case 'pages':
	
		sectionhead('Lehed');
		
		echo '<ul>
		<li><a href="?action=pageslist">Nimekiri</a>
		<li><a href="?action=addpage">Lisa uus</a>
		<li><a href="?action=addparse">Lisa html failina</a>
		<li><a href="?action=deletepage">Kustuta</a>
		</ul>';
		
	break;
	
	case 'pageslist':
	
		/*
		Valitud saidi lehtede toomine ekraanile.
		*/
	
		sectionhead('Lehtede nimekiri');
		
		echo '<table>';
		
		$res=mysql_query("SELECT id, name FROM " .$_SESSION['site'] ."_pages ORDER BY name");
		while ($result=mysql_fetch_row($res)) echo '<tr><td><b>' .$result[1] .'</b></td><td><a href="?action=editpage&amp;i=' .$result[0] .'">Muuda</a></td><td><a href="?action=rename&amp;n=' .$result[1] .'">Nimeta ümber</a></td><td><a href="?action=delete_page&amp;n=' .$result[1] .'">Kustuta</a></td></tr>';
		
		echo '</table>';
	
	break;
	
	case 'delete_page':
		
		/*
		Lehekülje kustutamine. Enne küsitakse nõusolekut.
		*/
		
		sectionhead('Lehed');
		
		echo 'Kas sa soovid kustutada lehte ' .$_GET['n'] .'?(<a href="?action=delpage_do&amp;n=' .$_GET['n'] .'">jah</a>, <a href="?action=pageslist">ei</a>)';
		
	break;
	
	case 'delpage_do':
		
		/*
		Kustutatakse leht.
		*/
		
		mysql_query("DELETE FROM " .$_SESSION['site'] ."_objects WHERE name='" .mysql_escape_string($_GET['n']) ."'");
		mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages WHERE name='" .mysql_escape_string($_GET['n']) ."'");
		mysql_query("DELETE FROM " .$_SESSION['site'] ."_tree WHERE name='" .mysql_escape_string($_GET['n']) ."'");
		
		echo '<script language="JavaScript">window.location="index.php?action=pageslist"</script>';
		
	break;
	
	case 'rename':
	
		/*
		Lehe nime muutmine.
		*/
		
		sectionhead('Lehe ' .$_GET['n'] .' nime muutmine');
		$_SESSION['oldname']=$_GET['n'];
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="rename_do">
		<label for="name">Uus nimi</label><br>
		<input type="text" name="name"><br><br>
		<input type="submit" value="Edasi">
		</form>';
	
	break;
	
	case 'rename_do':
		
		/*
		Toimub lehe nime muutmine vastavates tabelites.
		*/
		
		mysql_query("UPDATE " .$_SESSION['site'] ."_objects SET name='" .mysql_escape_string($_POST['name']) ."' WHERE name='" .$_SESSION['oldname'] ."'");
		mysql_query("UPDATE " .$_SESSION['site'] ."_pages SET name='" .mysql_escape_string($_POST['name']) ."' WHERE name='" .$_SESSION['oldname'] ."'");
		mysql_query("UPDATE " .$_SESSION['site'] ."_tree SET name='" .mysql_escape_string($_POST['name']) ."' WHERE name='" .$_SESSION['oldname'] ."'");
		
		echo '<script language="JavaScript">window.location="index.php?action=pageslist"</script>';
		
	break;
	
	case 'addpage':
	
		sectionhead('Lehe lisamine');
		
		echo 'Lehe nimi ei tohi sisaldada tühikuid.<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="addpage_do">
		<label for="name">Lehe nimi</label><br>
		<input type="text" name="name"><br><br>
		<input type="submit" value="Lisa leht">
		</form>';
	
	break;
	
	case 'addpage_do':
	
		sectionhead('Lehe lisamine');
		
		$res=mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages VALUES (0, '" .$_POST['name'] ."')");
		
		if (!$res) { echo 'Sellise nimega leht eksisteerib juba'; break; }
		
		$res=mysql_query("SELECT id FROM " .$_SESSION['site'] ."_pages WHERE name='" .$_POST['name'] ."'");
		$result=mysql_fetch_row($res);
		$pageid=$result[0];
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_objects VALUES (0, 'html', '" .$_POST['name'] ."', 0, 0)");
		
		$res=mysql_query("SELECT id FROM " .$_SESSION['site'] ."_objects WHERE name='" .$_POST['name'] ."'");
		$result=mysql_fetch_row($res);
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_html VALUES(" .$result[0] .", 'pole siin midagi')");
		
		echo 'Uus leht loodud. <a href="?action=editpage&amp;i=' .$pageid .'">Vaata ja muuda.</a>';
		
	break;
	
	case 'editpage':
	
		sectionhead('Lehe muutmine');
		
		/*
		Iga lehel olev objekt kuvatakse div kasti sees. See muudab võimalikuks
		objektide eristamise. Kui hiirega liikuda üle objektide, siis
		tõused esile see objekt, mille peal hiir parasjagu on.
		Vajutades objektile, saab seda muuta või kustutada.
		*/
		
		$_SESSION['pageid']=$_GET['i'];
		
		$res=mysql_query("SELECT type, containerid, id, objectid FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_GET['i'] ." ORDER BY objectid");
		while ($result=mysql_fetch_array($res)) {
			
			echo '<div class="box" onMouseOver="hilight(this)" onMouseOut="normal(this)" onClick="edit(\'' .$result['objectid'] .'\')">';
			
			switch ($result['type']) {
				
				case 'title':
					$res2=mysql_query("SELECT title, level FROM " .$_SESSION['site'] ."_pages_titles WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					echo '<h' .$result2['level'] .'>' .$result2['title'] .'</h' .$result2['level'] .'>';
				break;
				
				case 'paragraph':
					$res2=mysql_query("SELECT content, fontsize, font FROM " .$_SESSION['site'] ."_pages_pars WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					echo '<p style="font-family: ' .$result2['font'] .'; font-size: ' .$result2['fontsize'] .'pt">' .$result2['content'] .'</p>';
				break;
				
				case 'list':
					$res2=mysql_query("SELECT type, id FROM " .$_SESSION['site'] ."_pages_lists WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$type=$result2['type'];
					$id=$result2['id'];
					
					echo '<' .$type .'>';
					
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_listitems WHERE listid=" .$id);
					while ($result2=mysql_fetch_array($res2)) echo '<li>' .$result2['content'] .'</li>';
					
					echo '</' .$type .'>';
				break;
				
				case 'link':
					$res2=mysql_query("SELECT link, name FROM " .$_SESSION['site'] ."_pages_links WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					echo '<a href="' .$result2['link'] .'">' .$result2['name'] .'</a><br>';
				break;
				
				case 'image':
					$res2=mysql_query("SELECT id, align, alt, break FROM " .$_SESSION['site'] ."_pages_images WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					echo '<img src="' .sites_root .'/' .$_SESSION['site'] .'/img/' .$result2['alt'] .'" alt="' .$result2['alt'] .'" align="' .$result2['align'] .'">';
					if ($result2['break']=='y') echo '<br>';
				break;
				
				case 'hr':
					echo '<hr>';
				break;
				
				case 'field':
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_fields WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_row($res2);
					echo $result2[0];
				break;
				
				case 'pre':
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_fields WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_row($res2);
					echo '<pre>' .$result2[0] .'</pre>';
				break;
				
				case 'table':
					echo '<table><tr>';
				
					$res2=mysql_query("SELECT cols, rows FROM " .$_SESSION['site'] ."_pages_tables WHERE id=" .$result['containerid']);
					$dims=mysql_fetch_array($res2);
				
					$c=0;
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result['containerid'] ." ORDER BY id");
					while ($result2=mysql_fetch_row($res2)) {
						if ($c!=0 && floor($c%$dims['cols'])==0) echo '</tr><tr>';
						if ($c<$dims['cols']) echo '<th>' .$result2[0] .'</th>';
						else echo '<td>' .$result2[0] .'</td>';
						$c++;
					}
					
					echo '</tr></table>';
				break;
			}
			
			echo '</div>';
		}
		
		echo '<br><br>
		<a href="?action=addobj">Lisa objekt</a>&nbsp;&nbsp;<a href="?action=savepage&amp;i=' .$_GET['i'] .'">Salvesta</a>';
	break;
	
	case 'savepage':
	
		/*
		Antud leheküljest genereeritakse objektide põhjal html kood
		ning salvestatakse see html objektide tabelisse.
		*/

		$html='';
		$_SESSION['pageid']=$_GET['i'];
		$res=mysql_query("SELECT type, containerid, id, objectid FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_GET['i'] ." ORDER BY objectid");
		while($result=mysql_fetch_array($res)) {
			
			switch ($result['type']) {
				
				case 'title':
					$res2=mysql_query("SELECT title, level FROM " .$_SESSION['site'] ."_pages_titles WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$html.='<h' .$result2['level'] .'>' .$result2['title'] .'</h' .$result2['level'] .'>';
				break;
				
				case 'paragraph':
					$res2=mysql_query("SELECT content, fontsize, font FROM " .$_SESSION['site'] ."_pages_pars WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$html.='<p style="font-family: ' .$result2['font'] .'; font-size: ' .$result2['fontsize'] .'pt">' .$result2['content'] .'</p>';
				break;
				
				case 'list':
					$res2=mysql_query("SELECT type, id FROM " .$_SESSION['site'] ."_pages_lists WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$type=$result2['type'];
					$id=$result2['id'];
					
					$html.='<' .$type .'>';
					
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_listitems WHERE listid=" .$id);
					while ($result2=mysql_fetch_array($res2)) $html.='<li>' .$result2['content'] .'</li>';
					
					$html.='</' .$type .'>';
				break;
				
				case 'link':
					$res2=mysql_query("SELECT link, name FROM " .$_SESSION['site'] ."_pages_links WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$html.='<a href="' .$result2['link'] .'">' .$result2['name'] .'</a><br>';
				break;
				
				case 'image':
					$res2=mysql_query("SELECT id, align, alt, break FROM " .$_SESSION['site'] ."_pages_images WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_array($res2);
					$html.='<img src="img/' .$result2['alt'] .'" alt="' .$result2['alt'] .'" align="' .$result2['align'] .'">';
					if ($result2['break']=='y') $html.='<br>';
				break;
				
				case 'hr':
					$html.='<hr>';
				break;
				
				case 'field':
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_fields WHERE id=" .$result['containerid']);
					$result2=mysql_fetch_row($res2);
					$html.=$result2[0];
				break;
				
				case 'table':
					$html.='<table><tr>';
				
					$res2=mysql_query("SELECT cols, rows FROM " .$_SESSION['site'] ."_pages_tables WHERE id=" .$result['containerid']);
					$dims=mysql_fetch_array($res2);
				
					$c=0;
					$res2=mysql_query("SELECT content FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result['containerid'] ." ORDER BY id");
					while ($result2=mysql_fetch_row($res2)) {
						if ($c!=0 && floor($c%$dims['cols'])==0) $html.='</tr><tr>';
						if ($c<$dims['cols']) $html.='<th>' .$result2[0] .'</th>';
						else $html.='<td>' .$result2[0] .'</td>';
						$c++;
					}
					
					$html.='</tr></table>';
				break;
				
			}
			
		}
		
		$res=mysql_query("SELECT name FROM " .$_SESSION['site'] ."_pages WHERE id=" .$_GET['i']);
		$result=mysql_fetch_array($res);
		
		$res=mysql_query("SELECT id FROM " .$_SESSION['site'] ."_objects WHERE name='" .$result['name'] ."'");
		$result=mysql_fetch_array($res);
		
		mysql_query("UPDATE " .$_SESSION['site'] ."_html SET content='" .mysql_escape_string($html) ."' WHERE id=" .$result['id']);
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_GET['i'] .'"</script>';
		
	break;
	
	case 'addobj':
	
		/*
		Kui $_SESSION['obi'] on võrdne nulliga, siis lisatakse
		objekt lehekülje lõppu, vastasel korral selle muutujaga
		määratud objekti ette.
		*/
		
		sectionhead('Objekti lisamine');
		
		$_SESSION['obi']=(int)$_GET['i'] or $_SESSION['obi']=0;
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="insertobj">
		<label for="type">Objekti tüüp</label>
		<select name="type">
		<option value="title">Pealkiri</option>
		<option value="paragraph">Lõik</option>
		<option value="list">List</option>
		<option value="table">Tabel</option>
		<option value="image">Pilt</option>
		<option value="link">Link</option>
		<option value="hr">Horisontaaljoon</option>
		<option value="field">Väli</option>
		<option value="pre">Eelformaaditud tekst</option>
		</select><br><br>
		<input type="submit" value="Edasi">
		</form>';
	
	break;
	
	case 'insertobj':
	
		sectionhead('Objekti lisamine');
		
		switch ($_POST['type']) {
		
			case 'title':
				echo '<h3>Pealkiri</h3><form method="post" action="index.php">
				<input type="hidden" name="action" value="inserttitle">
				<label for="level">Pealkirja tase</label>
				<select name="level">
				<option value="1">1.</option>
				<option value="2">2.</option>
				<option value="3">3.</option>
				<option value="4">4.</option>
				<option value="5">5.</option>
				<option value="6">6.</option>
				<option value="7">7.</option>
				</select><br>
				<label for="title">Pealkiri</label><br>
				<input type="text" name="title"><br><br>
				<input type="submit" value="Edasi">
				</form>';
			break;
			
			case 'paragraph':
				echo '<h3>Lõik</h3><form method="post" action="index.php">
				<input type="hidden" name="action" value="insertpar">
				<label for="size">Kirja suurus (pt)</label><br>
				<select name="size">
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				<option value="11">11</option>
				<option value="12">12</option>
				<option value="13">13</option>
				<option value="14">14</option>
				<option value="16">16</option>
				</select><br>
				<label for="font">Kirja font</label><br>
				<select name="font">
				<option value="arial">Arial</option>
				<option value="courier">Courier</option>
				<option value="georgia">Georgia</option>
				<option value="impact">Impact</option>
				<option value="verdana">Verdana</option>
				<option value="helvetica">Helvetica</option>
				</select><br>
				<label for="text">Tekst</label><br>
				<textarea name="text" cols="70" rows="10">lõigu sisu...</textarea><br><br>
				<input type="submit" value="Edasi">
				</form>';
			break;
			case 'list':
				echo '<h3>Nimekiri</h3><form method="post" action="index.php">
				<input type="hidden" name="action" value="newlist">
				<label for="size">Tüüp</label><br>
				<select name="type">
				<option value="ol">Nummerdatud</option>
				<option value="ul">Nummerdamata</option>
				</select><br>
				<label for="rows">Ridade arv</label><br>
				<input type="text" name="rows" value="5"><br><br>
				<input type="submit" value="Edasi">
				</form>';
			break;
			case 'link':
				echo '<h3>Link</h3><a href="?action=locallink">Link kohalikule leheküljele</a><br>
				<a href="?action=outl">Link väljapoole</a>';
			break;
			case 'image':
				echo '<h3>Pilt</h3>
				Pildid asuvad saidi kaustas /img. Enne kasutamist tuleb nad sinna panna.<br>
				Järgnevast listist vali pilt, mida tahad lehekülje sisse lisada.<br><br>';
				
				$d=dir(sites_root .'/' .$_SESSION['site'] .'/img');
				
				while ($entry=$d->read()) {
					if ($entry!='.' && $entry!='..') echo '<a href="?action=insertimg&amp;img=' .$entry .'">' .$entry .'</a></br>';
				};
				
				$d->close();
			break;
			case 'hr':
				if ($_SESSION['obi']==0) {
					$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
					$result=mysql_fetch_row($res);
					$next=$result[0];
				} else {
					mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
					$next=$_SESSION['obi']-1;
				}
		
				mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", 0, 'hr')");
		
				echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';	
			break;
			case 'table':
				echo '<h3>Tabel</h3>
				<form method="post" action="index.php">
				<input type="hidden" name="action" value="instab">
				<label for="cols">Veergude arv</label><br>
				<input type="text" name="cols" value="3"><br>
				<label for="rows">Ridade arv</label><br>
				<input type="text" name="rows" value="5"><br><br>
				<input type="submit" value="Lisa">
				</form>';				
			break;
			case 'field':
				echo '<h3>Väli</h3>Väli on mõeldud otseselt html koodi kirjutamiseks.
				<form method="post" action="index.php">
				<input type="hidden" name="action" value="insertfield">
				<label for="content">Html kood</label><br>
				<textarea name="content" rows="10" cols="70"><b>asdf</b>qwerty
				</textarea>
				<br><br>
				<input type="submit" value="Lisa">
				</form>';
			break;
			case 'pre':
				echo '<h3>Tekst</h3>Siis kirjutatud tekst säilitab taanded ja reavahetused.
				<form method="post" action="index.php">
				<input type="hidden" name="action" value="insertpre">
				<label for="content">Tekst</label><br>
				<textarea name="content" rows="10" cols="70">qwerty
				</textarea>
				<br><br>
				<input type="submit" value="Lisa">
				</form>';
			break;
			
		}
	
	break;
	
	case 'instab':
	
		sectionhead('Tabeli lisamine');
		
		$_SESSION['rows']=$_POST['rows'];
		$_SESSION['cols']=$_POST['cols'];
	
		echo 'Sisesta tabeli väljade tekstid. Esimese rea väljad on tabeli päiseks.<br><br>
		<form method="post" action="index.php">
		<input type="hidden" name="action" value="instab_do">';
		
		for ($i=1; $i<=$_POST['rows']; $i++) {
			for ($j=1; $j<=$_POST['cols']; $j++) echo '<input type="text" name="f_' .(($i-1)*$_POST['cols']+$j) .'">';
			echo '<br>';
		}
		
		echo '<input type="submit" value="Lisa">
		</form>';
		
	break;
	
	case 'instab_do':
	
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_tables VALUES (0, " .$_SESSION['rows'] .", " .$_SESSION['cols'] .")");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_tables");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];
		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			$result=mysql_fetch_row($res);
			$next=$result[0];
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
		}
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'table')");
		
		for ($i=1; $i<=$_SESSION['rows']*$_SESSION['cols']; $i++) mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_fields VALUES (0, '" .mysql_escape_string($_POST['f_' .$i]) ."', " .$c_id .", " .$i .")");
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
		
	break;
	
	case 'insertimg':
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_images VALUES (0, '', '" .$_GET['img'] ."', 'y')");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_images");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];
		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			$result=mysql_fetch_row($res);
			$next=$result[0];
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
		}
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'image')");
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
	
	break;
	
	case 'inserttitle':
	
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_titles VALUES(0, " .$_POST['level'] .", '" .mysql_escape_string($_POST['title']) ."')");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_titles");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];
		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			$result=mysql_fetch_row($res);
			$next=$result[0];
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
			echo 'next=' .$next;
		}
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'title')") or die(mysql_error());
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';

	break;
	
	case 'insertpar':
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_pars VALUES(0, '" .mysql_escape_string($_POST['text']) ."', '" .$_POST['size'] ."', '" .$_POST['font'] ."', '" .$_POST['color'] ."')");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_pars");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];

		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			if ($result=mysql_fetch_row($res)) $next=$result[0];
			$next=(int)$next;
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
		}
			
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'paragraph')") or die(mysql_error());
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
		
	break;
	
	case 'newlist':

		sectionhead('Listi lisamine');
	
		$_SESSION['listtype']=$_POST['type'];
		$_SESSION['listrows']=(int)$_POST['rows'];
		
		echo '<form method="post" action="index.php">
		<input type="hidden" name="action" value="insertlist">';
		
		for($i=0; $i<$_SESSION['listrows']; $i++) echo '<textarea name="' .$i .'"></textarea><br>';
		
		echo '<input type="submit" value="Edasi">
		</form>';

	break;
	
	case 'insertlist':
	
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_lists VALUES(0, '" .$_SESSION['listtype'] ."')");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_lists");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];
		
		for ($i=0; $i<$_SESSION['listrows']; $i++) mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_listitems VALUES (0, " .$c_id .", '" .mysql_escape_string($_POST[$i]) ."')");
		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			$result=mysql_fetch_row($res);
			$next=$result[0];
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
		}
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'list')");
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
		
	break;
	
	case 'editobj':
		
		sectionhead('Objekti muutmine');
		
		echo '<ul>
		<li><a href="?action=editobj_do&amp;i=' .$_GET['i'] .'">Muuda objekti</a>
		<li><a href="?action=deleteobj&amp;i=' .$_GET['i'] .'">Kustuta objekt</a>
		<li><a href="?action=addobj&amp;i=' .$_GET['i'] .'">Lisa ette</a>
		</ul>';
	
	break;
	
	case 'locallink':
	
		sectionhead('Kohaliku lingi lisamine');
		
		$res=mysql_query("SELECT id, name FROM " .$_SESSION['site'] ."_objects ORDER BY name");
		
		echo 'Vali listist link.<br><ul>';
		
		while ($result=mysql_fetch_array($res)) echo '<li><a href="?action=locallink_do&amp;i=' .$result['id'] .'&amp;name=' .$result['name'] .'">' .$result['name'] .'</a>';
		
		echo '</ul>';
	
	break;
	
	case 'locallink_do':
	
		$link='?id=' .$_GET['i'];
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_links VALUES(0, '" .$link ."', '" .$_GET['name'] ."', 'y')");
		$res=mysql_query("SELECT MAX(id) FROM " .$_SESSION['site'] ."_pages_links");
		$result=mysql_fetch_row($res);
		$c_id=$result[0];
		
		if ($_SESSION['obi']==0) {
			$res=mysql_query("SELECT MAX(objectid) FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid']);
			$result=mysql_fetch_row($res);
			$next=$result[0];
		} else {
			mysql_query("UPDATE " .$_SESSION['site'] ."_pages_objects SET objectid=objectid+1 WHERE objectid>=" .$_SESSION['obi'] ." AND pageid=" .$_SESSION['pageid']);
			$next=$_SESSION['obi']-1;
		}
		
		mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_objects VALUES (0, " .$_SESSION['pageid'] .", " .($next+1) .", " .$c_id .", 'link')");
	
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
		
	break;
	
	case 'deleteobj':
	
		/*
		Objekti eemaldamine lehelt. Kustutatakse kirje objekti kohta
		ja kirjed objekti tüübile vastavast tabelist.
		*/
	
		$res=mysql_query("SELECT id, containerid, type FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid'] ." AND objectid=" .$_GET['i']);
		$result=mysql_fetch_array($res);
		
		switch ($result['type']) {
			case 'title':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_titles WHERE id=" .$result['containerid']);
			break;
			case 'paragraph':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_pars WHERE id=" .$result['containerid']);
			break;
			case 'image':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_images WHERE id=" .$result['containerid']);
			break;
			case 'link':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_links WHERE id=" .$result['containerid']);
			break;
			case 'list':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_lists WHERE id=" .$result['containerid']);
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_listitems WHERE listid=" .$result['containerid']);
			break;
		}
		
		mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_objects WHERE id=" .$result['id']);
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
	
	break;
	
	case 'editobj_do':

		$res=mysql_query("SELECT type, containerid FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid'] ." AND objectid=" .$_GET['i']);
		$result=mysql_fetch_row($res);
		$_SESSION['objectid']=$_GET['i'];
		
		switch ($result[0]) {
			case 'title':
			
				sectionhead('Pealkirja muutmine');
			
				$res=mysql_query("SELECT title, level FROM " .$_SESSION['site'] ."_pages_titles WHERE id=" .$result[1]);
				$result=mysql_fetch_row($res);
				
				echo '<form method="post" action="index.php">
				<input type="hidden" name="action" value="updateobj">
				<label for="level">Tase</label><br>
				<select name="level">';
				
				for($i=1; $i<8; $i++) if ($i==$result[1]): echo '<option value="' .$i .'" selected>' .$i .'.</option>'; else:  echo '<option value="' .$i .'">' .$i .'.</option>'; endif;
				
				echo '</select><br>
				<label for="title">Pealkiri</label><br>
				<input type="text" name="title" value="' .$result[0] .'"><br><br>
				<input type="submit" value="Edasi">
				</form>';
			break;
			
			case 'paragraph':
			
				sectionhead('Lõigu muutmine');
			
				$res=mysql_query("SELECT content, fontsize, font FROM " .$_SESSION['site'] ."_pages_pars WHERE id=" .$result[1]);
				$result=mysql_fetch_array($res);

				echo '<form method="post" action="index.php">
				<input type="hidden" name="action" value="updateobj">
				<label for="size">Kirja suurus (pt)</label></br>
				<select name="size">';
				
				for ($i=7; $i<17; $i++) if ($i==$result['fontsize']): echo '<option value="' .$i .'" selected>' .$i .'</option>'; else: echo '<option value="' .$i .'">' .$i .'</option>'; endif;
				
				echo '</select><br>
				<label for="font">Font</label><br>
				<select name="font">';
				
				$fonts=array('arial', 'courier', 'georgia', 'impact', 'verdana', 'helvetica');
				for ($i=0; $i<count($fonts); $i++) if ($fonts[$i]==$result['font']): echo '<option value="' .$fonts[$i] .'" selected>' .ucwords($fonts[$i]) .'</option>'; else: echo '<option value="' .$fonts[$i] .'">' .ucwords($fonts[$i]) .'</option>'; endif;
				
				echo '</select><br>
				<label for="text">Sisu</label><br>
				<textarea name="text" rows="10" cols="70">' .stripslashes($result['content']) .'
				</textarea><br><br>
				<input type="submit" value="Edasi"></form>';
				
			break;
			
			case 'table':
			
				sectionhead('Tabeli muutmine');
				
				echo 'Linnukesega read kustutatakse ära<br><br>
				<form method="post" action="index.php">
				<input type="hidden" name="action" value="updateobj">';
				
				$res=mysql_query("SELECT rows, cols FROM " .$_SESSION['site'] ."_pages_tables WHERE id=" .$result[1]);
				$dims=mysql_fetch_array($res);
				
				$res=mysql_query("SELECT content, th FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result[1] ." ORDER BY th");
				
				$c=0; $r=1;
				while ($result=mysql_fetch_row($res)) {
					if (floor($c%$dims['cols'])==0) { echo '<br><input type="checkbox" name="d_' .$r .'" value="' .$result[1] .'">'; $r++; }
					echo '<input type="text" name="f_' .$result[1] .'" value="' .htmlentities($result[0]) .'">';
					$c++;
				}
				
				echo '<br><br><label for="addrows">Lisa ridu (0 tähendab, et ühtegi ei lisata)</label>
				<input type="text" name="addrows" value="0"><br><br>
				<input type="submit" value="Salvesta">
				</form>';
			
			break;
		}
		
	break;
	
	case 'updateobj':
	
		$res=mysql_query("SELECT type, containerid FROM " .$_SESSION['site'] ."_pages_objects WHERE pageid=" .$_SESSION['pageid'] ." AND objectid=" .$_SESSION['objectid']);
		$result=mysql_fetch_array($res);
		switch ($result['type']) {
			case 'paragraph':
				mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_pars WHERE id=" .$result['containerid']);
				mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_pars VALUES (" .$result['containerid'] .", '" .$_POST['text'] ."', '" .$_POST['size'] ."', '" .$_POST['font'] ."', '" .$_POST['color'] ."')");
			break;
			case 'table':
				$res=mysql_query("SELECT rows, cols FROM " .$_SESSION['site'] ."_pages_tables WHERE id=" .$result[1]);
				$dims=mysql_fetch_array($res);
				
				$res=mysql_query("SELECT MIN(th) FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result['containerid']);
				$min=mysql_fetch_row($res);
				
				$res=mysql_query("SELECT MAX(th) FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result['containerid']);
				$max=mysql_fetch_row($res);
				
				/*
				Ridade uuendamine
				*/
				
				for ($i=1; $i<=$dims['rows']*$dims['cols']; $i++) mysql_query("UPDATE " .$_SESSION['site'] ."_pages_fields SET content='" .mysql_escape_string($_POST['f_' .$i]) ."' WHERE th=" .$i ." AND containerid=" .$result['containerid']);
				
				/*
				Ridade lisamine
				*/
				
				if ($_POST['addrows']<0 || $_POST['addrows']>100) $_POST['addrows']=0;
				
				for ($i=0; $i<$_POST['addrows']*$dims['cols']; $i++) mysql_query("INSERT INTO " .$_SESSION['site'] ."_pages_fields VALUES(0, '&nbsp;', " .$result['containerid'] .", " .($max[0]+$i+1) .")");
				mysql_query("UPDATE " .$_SESSION['site'] ."_pages_tables SET rows=rows+" .$_POST['addrows'] ." WHERE id=" .$result['containerid']);
				
				/*
				Ridade kustutamine
				*/
				
				for ($i=0; $i<$dims['rows']; $i++)
					if ($_POST['d_' .($i+1)]) {
						mysql_query("DELETE FROM " .$_SESSION['site'] ."_pages_fields WHERE containerid=" .$result['containerid'] ." AND th >= " .$_POST['d_' .($i+1)] ." LIMIT " .$dims['cols']);
					}
			break;
		}
		
		echo '<script language="javascript">window.location="?action=editpage&i=' .$_SESSION['pageid'] .'"</script>';
		
	break;
	
}

/*
Lõpuks sulgeme MySql ühenduse.
*/

mysql_close();

?>

</div>
</div>
</body>
</html>