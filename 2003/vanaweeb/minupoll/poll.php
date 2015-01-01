<html>
<head>
<title>Poll</title>
<style>
	.poll
	{
	font-size: 12px;
	font-family: verdana;
	font-weight: bold;
	color: #ffff00;
	}

</style>
</head>
<body>

<font size="3" face="verdana"><b>Poll</b></font><br>

<form action="haaleta.php" method="post"> 
	<table border="0" cellspacing="1" cellpadding="2"> 
	<tr><td colspan="2">
<?	

	include("yhendus.inc");//ühendame ja valime andmebaasi

	$getkysimus="select id, aeg, kysimus from kysimused order by id desc limit 1";

	$saa1=mysql_query($getkysimus) or die ("Ei saanud küsimust!");

	$rida=mysql_fetch_assoc($saa1);
		
	$kys=$rida['kysimus']; 
	$id=$rida['id'];
	echo "<font size=\"2\" face=\"verdana\"><b>", $kys, "</b></font><br></td></tr>"; 

	$getvastused="select vastus1, vastus2, vastus3, vastus4, vastus5, vastus6, vastus7, vastus8, vastus9, vastus10, varv from vastused where id='$id'";

	$saa2=mysql_query($getvastused) or die ("Ei saanud pärida!");

	$rida=mysql_fetch_assoc($saa2);
	
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

	$bgcolor="bgcolor=\"#3399ff\"";

	if ($vastarv>0) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"1\"></td><td ",$bgcolor ," class=poll>", $vas1, "</td></tr>";
	if ($vastarv>1) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"2\"></td><td ",$bgcolor ," class=poll>", $vas2, "</td></tr>";
	if ($vastarv>2) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"3\"></td><td ",$bgcolor ," class=poll>", $vas3, "</td></tr>";
	if ($vastarv>3) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"4\"></td><td ",$bgcolor ," class=poll>", $vas4, "</td></tr>";
	if ($vastarv>4) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"5\"></td><td ",$bgcolor ," class=poll>", $vas5, "</td></tr>";
	if ($vastarv>5) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"6\"></td><td ",$bgcolor ," class=poll>", $vas6, "</td></tr>";
	if ($vastarv>6) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"7\"></td><td ",$bgcolor ," class=poll>", $vas7, "</td></tr>";
	if ($vastarv>7) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"8\"></td><td ",$bgcolor ," class=poll>", $vas8, "</td></tr>";
	if ($vastarv>8) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"9\"></td><td ",$bgcolor ," class=poll>", $vas9, "</td></tr>";
	if ($vastarv>9) echo "<tr><td ",$bgcolor ,"><input type=\"radio\" name=\"answer\" value=\"10\"></td><td ",$bgcolor ," class=poll>", $vas10, "</td></tr>";
	
	mysql_close();

?>
	<tr><td colspan="2"><input type="submit" value="Hääleta"></td></tr>
	</table>
</form>


</body>
</html>