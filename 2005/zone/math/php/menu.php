<?php

/*
menu.php

Väljastab terve saidi struktuuri.

Raivo Laanemets

20. märts 2005.
*/

$res=mysql_query("SELECT lft, rgt FROM " .prename ."_tree WHERE name='root'");
$row=mysql_fetch_array($res);
$right=array();

$res=mysql_query("SELECT name, objectid, lft, rgt FROM " .prename ."_tree WHERE lft BETWEEN " .$row['lft'] ." AND " .$row['rgt'] ." ORDER BY lft ASC");

while ($row=mysql_fetch_array($res)) {
	if (count($right)>0) while ($right[count($right)-1]<$row['rgt']) array_pop($right);
		if ($row['lft']>1) print str_repeat('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', count($right)-1) .'<a href="?id=' .$row['objectid'] .'" class="contents">' .$row['name'].'</a><br>';
		$right[]=$row['rgt'];
	}

?>