<h1>Objektid</h1>
<?php

/*
objekt.php
Lehekülje (objekti koodi muutmine)
Raivo Laanemets
25.juuli 2004
*/

print '<h2>Objekt ' .$_GET['objekt'] .'</h2>';

?>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="salvesta_objekt">
<input name="objekt" type="hidden" value="<?php print $_GET['objekt'] ?>">
<textarea name="sisu" rows="15" cols="60" wrap="off">
<?php
    mysql_select_db($_SESSION['saidi_baas']);
	$res=mysql_query("SELECT tyyp,text,keel FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_GET['objekt'] ."'");
    $result=mysql_fetch_row($res);
    mysql_select_db($_SESSION['baas']);
    if ($result[0]=='php'): print htmlentities(file_get_contents($_SESSION['saidi_tee'] .'/php/' .$_GET['objekt'] .'.php'));
    else: print htmlentities($result[1]); endif;
?>
</textarea><br><br>
<input name="tyyp" type="hidden" value="<?php print $result[0] ?>">
<input name="keel" type="hidden" value="<?php print $result[2] ?>">
<input type="submit" value="Salvesta">
</form>