<h1>Keeled</h1>
<?php

/*
keeled.php
Administreerimisliidese keelte toetus.
Raivo Laanemets
10. august 2004
*/

print '<h2>Saidi "' .$_SESSION['saidi_nimi'] .'" keeled</h2>';

mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_keeled");
while($result=mysql_fetch_row($res)) {
	print '<a href="?mis=keel&amp;keel=' .$result[0] .'">' .$result[0] .'</a><br>';
}

?>