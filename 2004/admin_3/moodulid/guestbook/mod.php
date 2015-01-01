<h1>Külalisteraamat</h1>
<h2>Settingud</h2>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="moodul_act">
<input name="moodul" type="hidden" value="guestbook">
<input name="action" type="hidden" value="salvesta_conf">
<table>
<?php

/*
moodulid/guestbook/mod.php
Külalisteraamat
Raivo Laanemets
12. august 2004

Külalisteraamatu sisu asub tabelis <saidi_nimi>_gb
	id int. postituse identifikaator.
    nimi char(50) postitaja nimi.
    email char(100) postitaja e-mail.
    koduleht char(100) postitaja koduleht.
    tekst text. postituse sisu.
    aeg int. lisamise kuupäev ja kellaaeg.

Külalisteraamatu konfiguratsioon asub tabelis <saidi_nimi>_gb_conf
	muutuja char(20).
    vaartus text.
*/

mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT muutuja,vaartus FROM " .$_SESSION['saidi_nimi'] ."_gb_conf");
while($result=mysql_fetch_row($res)) print '<tr><td>' .$result[0] .'</td><td><input type="text" name="' .$result[0] .'" value="' .$result[1] .'" style="width: 300pt"></td></tr>';

?>
</table>
<br><input type="submit" value="Salvesta">
</form>

<h2>Vaata kirjeid</h2>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="moodul_act">
<input name="moodul" type="hidden" value="guestbook">
<input name="action" type="hidden" value="naita">
Näita kirjeid,<br>algus: <input name="algus" type="text" value="0"><br>
lõpp: <input name="lopp" type="text" value="100"><br><br>
<input type="submit" value="Vaata">
</form>