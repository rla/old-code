<?php 
	include("yhendus.inc"); //ühendus andmebaasiga

	$getkysimus="select id, kysimus, aeg from kysimused order by id desc limit 1";
 
	$saa=mysql_query($getkysimus) or die ("Ei saanud pärida1!");

	$rida=mysql_fetch_assoc($saa);

	$id=$rida['id']; 

	switch($answer)
		{ 
    		case 1: 
        			$v=v1; 
        		break; 
    		case 2: 
        			$v=v2; 
        		break; 
    		case 3: 
        			$v=v3; 
        		break; 
    		case 4: 
        			$v=v4; 
        		break; 
    		case 5: 
        			$v=v5; 
        		break; 
    		case 6: 
        			$v=v6; 
        		break; 
    		case 7: 
        			$v=v7; 
        		break; 
    		case 8: 
        			$v=v8; 
        		break; 
    		case 9: 
        			$v=v9; 
        		break; 
    		case 10: 
        			$v=v10; 
        		break;
		} 

       
	$sethaaled="update haaled set $v=$v+1 where id='$id'"; 

	@mysql_query($sethaaled) or die ("Ei saanud pärida!"); 

	mysql_close();

header("Location: tulemus.php"); 
//kasutaja suunatakse failile tulemus.php 

exit(); 
?> 