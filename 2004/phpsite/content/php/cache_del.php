<?php

/*
Menüü objekt

Raivo Laanemets 2004
*/

$cache_del=array();
$cache_del['ee']['use_cache']=false; //cache kasutamine
$cache_del['ee']['title']='Cache'; //alamlehekülje pealkiri (tühi string ei muuda pealkirja).
$cache_del['ee']['template']='default.tpl'; //objekti poolt kasutatava templeidi nimi.
$sisu='';
$d=dir('cache');
$i=0;
$size=0;
while ($entry=$d->read()) {
	if (($entry<>'.') && ($entry<>'..')) {
        unlink('cache/' .$entry);
    }
}
$cache_del['ee']['sisu']='<div class="stitle">Cache</div>
<br>Failid kustutatud!:<br>
<table cellspacing="10">
<tr><td>
<form method="get" action="index.php">
<input type="hidden" name="id" value="cache">
<input type="submit" value="Tagasi" class="button">
</form>
</td></tr>
</table>';

$objektid['cache_del']=$cache_del;

?>