<h1>Pealkirjad</h1>
<?php

/*
pealkirjad.php
Lehekülje pealkirja muutmine.
Raivo Laanemets
13. august 2004
*/

?>

<h2>Leht "<?php echo $_GET['leht'] ?>"</h2>

<form action="index.php" method="post">
<input name="mis" type="hidden" value="muuda_pealkiri">
<input name="leht" type="hidden" value="<?php echo $_GET['leht'] ?>">
Sisesta pealkiri:
<input name="pealkiri" type="text" value="<?php echo $_GET['pealkiri'] ?>">
<input type="submit" value="Salvesta">
</form>