<h1>Kasutajad</h1>
<?php

/*
kasutajad.php
Kasutajate nimekirja ja õiguste seadmine
Raivo Laanemets
23. juuli 2004

Kasutajad asuvad tabelis kasutajad, mis sisaldav välju:
	nimi: char(10)
    parool: char(32)
    kasutaja_id: int
*/

$res=mysql_query("SELECT nimi, kasutaja_id FROM kasutajad");
while($result=mysql_fetch_array($res)) {
	print '<a href="?mis=kasutaja&amp;kasutaja=' .$result[0] .'&amp;id=' .$result[1] .'">' .$result[0] .'</a><br>';
}

?>
<h2>Lisa</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="lisa_kasutaja">
Kasutaja nimi:<br>
<input name="nimi" type="text" value=""><br>
Parool:<br>
<input name="parool" type="text" value=""><br><br>
<input type="submit" value="Lisa">
</form>
<h2>Kustuta</h2>
<form method="post" action="index.php">
<input name="mis" type="hidden" value="kustuta_kasutaja">
<select name="kasutaja">
<?php
	$res=mysql_query("SELECT nimi,kasutaja_id FROM kasutajad");
    while($result=mysql_fetch_array($res)) {
    	print '<option value="' .$result[1] .'">' .$result[0] .'</option>';
    }
?>
</select><br><br>
<input type="submit" value="Kustuta">
</form>