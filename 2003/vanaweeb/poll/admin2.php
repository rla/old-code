<html> 
<head> 
<title>Admin</title> 
<meta http-equiv="refresh" content="2; url=admin.php"> 
</head> 
<body > 
<?php 
include("connect.php"); // ühendus andmebaasiga 

if (isset($kysimus))
	 { 
             	$query1="insert into kysimused (kysimus,aeg, id) values ('$kysimus',now(), 1)"; 

	$query2="select id,aeg from kysimused order by aeg desc limit 1"; 

	mysql_query($query1,$link) or die ("Ei saanud lisada andmeid!");
 
	$uuri=mysql_query($query2,$link) or die ("Ei saanud pärida!"); 

	while ($rida=@mysql_fetch_assoc($uuri)) 
		{ 
		$id=$rida['id']; 
		} 
	$query3="insert into vastused (vastus1,vastus2,vastus3,vastus4,vastus5,kid) values ('$yks','$kaks','$kolm','$neli','$viis','$id')"; 

	mysql_query($query3,$link) or die ("Ei saanud lisada vastuseid"); 

	$n=0; 

	$query4="insert into haaletus (v1,v2,v3,v4,v5,kid) values ('$n','$n','$n','$n','$n','$id')"; 

	mysql_query($query4,$link) or die ("Ei saanud lisada 0 hääli!"); 

	echo "<font size=2 face=tahoma>Küsimus lisatud</font><br>"; 

	} 
	else 
	{ 
    	echo "<font size=2 color=red face=tahoma>Täida kõik väljad!</font>"; 
	} 

?> 

</body> 
</html> 
