<h1>Külalisteraamat</h1>
<?php

/*
moodulid/guestbook/action.php
Külalisteraamatu back-end.
Raivo Laanemets
12. august 2004
*/

mysql_select_db($_SESSION['saidi_baas']);
switch($_POST['action']){
	case 'salvesta_conf':
    	mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['label'] ."' WHERE muutuja='label'");
        mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['input'] ."' WHERE muutuja='input'");
        mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['output'] ."' WHERE muutuja='output'");
        print 'Seadistus uuendatud.';
    break;
    case 'naita':
    	print '<h2>Kirjed '. $_POST['algus'] .'-' .$_POST['lopp'] .'</h2>';
    	$res=mysql_query("SELECT id,nimi,email,koduleht,tekst,aeg FROM " .$_SESSION['saidi_nimi'] ."_gb LIMIT " .$_POST['algus'] ."," .$_POST['lopp']);
        while($result=mysql_fetch_row($res)) {
        	print 'ID: ' .$result[0]
            .'<br>NIMI: ' .$result[1]
            .'<br>E-MAIL: ' .$result[2]
            .'<br>KODULEHT: ' .$result[3]
            .'<br>TEKST: ' .$result[4]
            .'<br>AEG: ' .date("Y-m-d H:i:s", $result[5]) .'<hr>';

        }
    break;
}

?>