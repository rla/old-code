<?php

$OBJECTS_DB=@mysql_connect($system['sql_host'], $system['sql_user'], $system['sql_pass'], true)
	or die($errors['no_mysql'][$LANG]);

if(!mysql_select_db($system['sql_db'], $OBJECTS_DB)) print mysql_error($OBJECTS_DB);

?>