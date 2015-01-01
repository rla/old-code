<html>
<head>
<title>Poll - Tulemus</title>
<style>
	.vas
	{
	font-size: 12px;
	font-family: arial;
	font-weight: bold;
	color: #eeeeee;
	}
	.pea
	{
	font-size: 12px;
	font-family: verdana;
	font-weight: bold;
	color: #000000;
	}
	.link
	{
	font-size: 12px;
	font-family: verdana;
	text-decoration: none;
	color: #6666ff;
	}

</style>
</head>
<body background="\graafika\hallsinine.gif">

<img src="\graafika\banner1.jpg">
<br>
<br>
<font face="arial" size="4">Poll</font>

<?

	include("yhendus.inc"); // ühendus andbemaasiga 
	include("varvid.inc"); //värvide fail

	if (!isset($id)) 
		{
		$getkysimus="select id, kysimus, aeg from kysimused order by id desc limit 1";
		}
		else
		{
		$getkysimus="select kysimus, id, aeg from kysimused where id='$id'";
		}
 
	$saa=mysql_query($getkysimus) or die ("Ei saanud pärida1!");

	$rida=mysql_fetch_assoc($saa);

	$id=$rida['id']; 
	$kysimus=$rida['kysimus'];
 
	$getvastused="select vastus1, vastus2, vastus3, vastus4, vastus5, vastus6, vastus7, vastus8, vastus9, vastus10, varv from vastused where id='$id'";
 
	$saa=mysql_query($getvastused) or die ("Ei saanud pärida2!");

	$rida=mysql_fetch_assoc($saa);
	
	$vastarv=$rida['varv'];	

	$vas1=$rida['vastus1']; 
	$vas2=$rida['vastus2']; 
	$vas3=$rida['vastus3']; 
	$vas4=$rida['vastus4']; 
	$vas5=$rida['vastus5'];  
	$vas6=$rida['vastus6']; 
	$vas7=$rida['vastus7']; 
	$vas8=$rida['vastus8']; 
	$vas9=$rida['vastus9']; 
	$vas10=$rida['vastus10'];
 
	$gethaaled="select v1, v2, v3, v4, v5, v6, v7, v8, v9, v10 from haaled where id='$id'"; 

	$saa=mysql_query($gethaaled) or die ("Ei saanud pärida3!");
 
	$rida=mysql_fetch_assoc($saa); 

	$v1=$rida['v1']; 
	$v2=$rida['v2']; 
	$v3=$rida['v3']; 
	$v4=$rida['v4']; 
	$v5=$rida['v5'];
	$v6=$rida['v6']; 
	$v7=$rida['v7']; 
	$v8=$rida['v8']; 
	$v9=$rida['v9']; 
	$v10=$rida['v10'];

	if ($vastarv>0) $total=$v1;
	if ($vastarv>1) $total=$total+$v2;
	if ($vastarv>2) $total=$total+$v3;
	if ($vastarv>3) $total=$total+$v4;
	if ($vastarv>4) $total=$total+$v5;
	if ($vastarv>5) $total=$total+$v6;
	if ($vastarv>6) $total=$total+$v7;
	if ($vastarv>7) $total=$total+$v8;
	if ($vastarv>8) $total=$total+$v9;
	if ($vastarv>9) $total=$total+$v10;

	if ($total==0) $total=1; 

	$v1p=round(($v1*100)/$total,0); 
	$v2p=round(($v2*100)/$total,0); 
	$v3p=round(($v3*100)/$total,0); 
	$v4p=round(($v4*100)/$total,0); 
	$v5p=round(($v5*100)/$total,0);
	$v6p=round(($v6*100)/$total,0); 
	$v7p=round(($v7*100)/$total,0); 
	$v8p=round(($v8*100)/$total,0); 
	$v9p=round(($v9*100)/$total,0); 
	$v10p=round(($v10*100)/$total,0);  

	echo "<table cellspacing=\"1\" border=\"0\">\n"; 

	echo "<tr><td class=pea>",$kysimus, "</td><td>&nbsp;</td><td class=pea>%</td><td class=pea>Hääli</tr>\n"; 


	if ($vastarv>0) echo "<tr><td ", $tabelcl, " class=\"vas\">",  $vas1, " </td><td width=100 class=\"vas\" ", $tabelcl, "><img src=pix.jpg width=", $v1p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v1p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v1, "</td></tr>\n";
	if ($vastarv>1) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas2, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v2p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v2p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v2, "</td></tr>\n"; 
	if ($vastarv>2) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas3, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v3p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v3p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v3, "</td></tr>\n"; 
	if ($vastarv>3) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas4, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v4p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v4p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v4, "</td></tr>\n";
	if ($vastarv>4) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas5, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v5p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v5p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v5, "</td></tr>\n"; 
	if ($vastarv>5) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas6, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v6p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v6p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v6, "</td></tr>\n";
	if ($vastarv>6) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas7, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v7p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v7p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v7, "</td></tr>\n";
	if ($vastarv>7) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas8, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v8p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v8p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v8, "</td></tr>\n";
	if ($vastarv>8) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas9, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v9p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v9p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v9, "</td></tr>\n";
	if ($vastarv>9) echo "<tr><td ", $tabelcl, " class=\"vas\">", $vas10, " </td><td ", $tabelcl, " class=\"vas\"><img src=pix.jpg width=", $v10p, " height=5></td><td ", $tabelcl, " class=\"vas\">", $v10p, "</td><td ", $tabelcl, " class=\"vas\"><b>", $v10."</td></tr>\n"; 

	echo "<tr><td ", $tabelcl, " class=\"vas\">Hääli kokku:</td><td ", $tabelcl, "><img src=pix.jpg width=100% height=5></td><td ", $tabelcl, " class=\"vas\">100</td><td ", $tabelcl, " class=\"vas\">", $total, "</td></tr></table>\n"; 

	echo "<p><font face=\"verdana\" size=\"2\"><b>Vanemad küsimused:</b></font><p>\n"; 

	$getkysimused="select kysimus, id, aeg from kysimused order by id desc"; 

	$saa=mysql_query($getkysimused) or die ("Viga! Ei saanud küsimusi"); 
	while ($rida=@mysql_fetch_assoc($saa)) 
		{ 
		$kysimus=$rida['kysimus']; 
		$id=$rida['id']; 
	
		echo "<a href=\"tulemus.php?id=", $id, "\" class=\"link\">", $kysimus, "</a><br>\n"; 
		} 

	mysql_close();

?> 

</body>
</html>