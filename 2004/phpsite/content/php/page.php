<?php

/*
Lehekülgede süsteem
Raivo Laanemets 2004
*/

include_once('func/errors.php');

$fname='content/pages/' .$_GET['page'] .'.html';

if (file_exists($fname)): include($fname);
else: Error('VASTAVAT LEHEKÜLGE EI LEITUD (' .$fname .')!');
endif;

?>