<h2>Templeidid</h2>
<?php

/*
templeit.php
Templeidi muutmine.
Raivo Laanemets
28. juuli 2004
*/

mysql_select_db($_SESSION['saidi_baas']);
print '<h2>Templeit "' .$_GET['id'] .'"</h2>';

?>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="salvesta_templeit">
<input name="id" type="hidden" value="<?php print $_GET['id'] ?>">
<textarea name="sisu" rows="15" cols="60" wrap="off">
<?php
$res=mysql_query("SELECT tekst FROM " .$_SESSION['saidi_nimi'] ."_templeidid WHERE id='" .$_GET['id'] ."'");
$result=mysql_fetch_row($res); print htmlentities($result[0]);
?>
</textarea><br><br>
<input type="submit" value="Salvesta">
</form>