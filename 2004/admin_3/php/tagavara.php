<h1>Tagavara</h1>
<?php

/*
tagavara.php
Tagavarakoopiate süsteem.
Raivo Laanemets
13. august 2004
*/

?>
<h2>Tagavara loomine</h2>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="tee_tagavara">
<input type="submit" value="Uus"></form>
<h2>Taastamine</h2>
<form action="index.php" method="post">
<input name="mis" type="hidden" value="taasta">
Vali fail:<input type="file" name="fail"><br><br>
<input type="submit" value="Taasta"></form>