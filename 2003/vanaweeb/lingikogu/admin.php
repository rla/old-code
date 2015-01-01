<html>
<head>
<title>Lingikogu</title>

<style>
	.tabel
	{
	font-family: verdana;
	font-size: 11px;
	color: #6666cc;
	}
	.lisa
	{
	font-family: arial;
	font-weight: bold;
	font-size: 12px;
	{
</style>

</head>
<body>

<form method="post" action="lisalink.php">
	<table>
	<tr><td class="lisa">Nimi</td><td><input type="text" name="nimi" maxlength="100"></td></tr>
	<tr><td class="lisa">Link</td><td><input type="text" name="link" maxlength="100"></td></tr>
	<tr><td class="lisa">Kirjeldus</td><td><input type="text" name="kirjeldus" maxlength="100"></td></tr>
	</table>
	<input type="submit" value="lisa">
</form>

</body>
</html>