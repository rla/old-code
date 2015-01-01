<?php

/*
Menüü tee näitamine
Raivo Laanemets 2004
*/

include_once('func/menu_tree.php');

print "<script name=\"javascript\" type=\"text/javascript\">
	document.getElementById('show_path').innerHTML='";
	PrintPath();
print "'
</script>";


?>