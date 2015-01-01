<?php

/*
CSS failide toomine leheküljele.
Raivo Laanemets 2004
*/

global $objects_db;
global $objects_css_tbl;

$sql="SELECT css_file FROM " .$objects_css_tbl;
if($res=mysql_query($sql, $objects_db)):
	while($result=mysql_fetch_row($res)) print '<link href="./content/css/' .$result[0] .'" rel="stylesheet" type="text/css">';
endif;

?>