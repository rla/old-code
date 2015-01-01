<?php 
include("connect.php"); //ühendus baasiga 

switch($answer) { 
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
//vastalt valitud vastusevariandist saab muutuja $v väärtuse, mis on siis mysql-i tabelis haaletus vastava tunnuse nimi 
} 

       
$query="update haaletus set $v=$v+1 where kid='$kid'"; 
//valitud vastusevariant $v saab ühe hääle juurde 

@mysql_query($query,$link) or die ("Ei saanud pärida!"); 
//vastav päring sooritatakse 

header("Location: tulemus.php"); 
//kasutaja suunatakse failile tulemus.php 

exit(); 
?> 