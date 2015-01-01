<h1>Puu</h1>
<h2>Üldvaade</h2>
<?php

/*
Struktureeritud andmehulga koostamise süsteem.
Andmed jaotatakse kategooriateks, millel omakorda
võivad olla alamkategooriad. Igale teemale vastab üks
leht, mis võib koosneda objektidest.
Addministraatori leht
Raivo Laanemets
*/

mysql_select_db($_SESSION['saidi_baas']);

switch($_POST['action']){
	case 'salvesta_conf':
    	mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['label'] ."' WHERE muutuja='label'");
        mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['input'] ."' WHERE muutuja='input'");
        mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_gb_conf SET vaartus='" .$_POST['output'] ."' WHERE muutuja='output'");
        print 'Seadistus uuendatud.';
    break;
    default:
		print '<h3>Puu</h3>juur';
    break;
}




?>