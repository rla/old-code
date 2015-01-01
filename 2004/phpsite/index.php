<?php

$LANG=$_GET['lang']; if ($LANG=='') $LANG='ee';
$PAGE=$_GET['page']; if ($PAGE=='') $PAGE='index';

include('main/errors.php');
include('main/system.php');
include('main/mysql.php');
include('lib/pages.php');

if (IsPage()) print 'Õige lehekülg'; else print 'Lehte ei leitud';


mysql_close($OBJECTS_DB);

?>