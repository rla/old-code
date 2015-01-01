<h1>Objektid</h1>
<?php

/*
objekt.php
Lehekülje (objekti koodi muutmine)
Raivo Laanemets
25.juuli 2004
*/

print '<h2>Objekt "' .$_GET['objekt'] .'"</h2>';

if ($_GET['tyyp']=='php' || $_GET['tyyp']=='html') include('php/objekt_kood.php');
elseif($_GET['tyyp']=='css') include('php/objekt_css.php');
?>