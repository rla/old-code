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

function display_tree_admin($root) {
	$result = mysql_query("SELECT lft, rgt FROM " .$_SESSION['saidi_nimi'] ."_puu WHERE nimi='" .$root. "'");
	$row = mysql_fetch_array($result);
	$right = array();
	$result = mysql_query("SELECT nimi, leht, lft, rgt FROM " .$_SESSION['saidi_nimi'] ."_puu WHERE lft BETWEEN " .$row['lft'] ." AND " .$row['rgt'] ." ORDER BY lft ASC");

	while ($row = mysql_fetch_array($result)) {
		if (count($right)>0) while ($right[count($right)-1]<$row['rgt']) array_pop($right);
		print str_repeat('&nbsp;&nbsp;', count($right)) .'<a href="?mis=moodul&amp;moodul=puu&amp;action=lisa&amp;place=' .$row['lft'] .'">' .$row['nimi'].'</a>&nbsp;&nbsp;
        <a href="?mis=moodul&amp;moodul=puu&amp;action=kustuta&amp;place=' .$row['lft'] .'">Kustuta</a><br>';
		$right[]=$row['rgt'];
	}
}

function add_node($place, $nimi, $leht) {
	$lft=$place+1;
    $rgt=$place+2;
    mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_puu SET rgt=rgt+2 WHERE rgt>" .$place);
    mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_puu SET lft=lft+2 WHERE lft>" .$place);

    mysql_query("INSERT INTO " .$_SESSION['saidi_nimi'] ."_puu SET nimi='" .$nimi ."', leht='" .$leht ."', lft=" .$lft .", rgt=" .$rgt) or print mysql_error();
}

function delete_node($place) {
	mysql_query("DELETE FROM " .$_SESSION['saidi_nimi'] ."_puu WHERE lft=" .$place);
    mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_puu SET lft=lft-2 WHERE lft>" .$place);
    mysql_query("UPDATE " .$_SESSION['saidi_nimi'] ."_puu SET rgt=rgt-2 WHERE rgt>" .$place);
}

mysql_select_db($_SESSION['saidi_baas']);

switch($_GET['action']){
	case 'lisa':
        print '<form method="get" action="index.php">
        <input type="hidden" name="mis" value="moodul">
        <input type="hidden" name="moodul" value="puu">
        <input type="hidden" name="action" value="lisa_oks">
        <input type="hidden" name="place" value="' .$_GET['place'] .'">
        <input type="text" name="nimi">
        <select name="leht">';
        $r=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed");
        while($result=mysql_fetch_row($r)) print '<option value="' .$result[0] .'">' .$result[0] .'</option>';
        print '</select>
        <input type="submit" value="Lisa">
        </form>';
    break;
    case 'lisa_oks':
    	add_node($_GET['place'], $_GET['nimi'], $_GET['leht']);
        print '<a href="?mis=moodul&amp;moodul=puu">Tagasi</a>';
    break;
    case 'kustuta':
    	delete_node($_GET['place']);
        print '<a href="?mis=moodul&amp;moodul=puu">Tagasi</a>';
    break;
    default:
		print '<h3>Puu</h3>';
		display_tree_admin('juur');
    break;
}




?>