<html>
<head>
<title>Guestbook</title>
</head>
<body>

<h2>Külalisteraamat</h2>

<form method="post" action="create_entry.php">
	<b>Nimi:</b>
	<input type="text" size="40" name="name">
	<br>
	<b>Asukoht:</b>
	<input type="text" size="40" name="location">
	<br>
	<b>Koduleht:</b>
	<input type="text" size="40" name="email">
	<br>
	<b>Kommentaarid:</b>
	<textarea name="comments" cols="40" rows="4" wrap="virtual"></textarea>
	<input type="submit" name="submit" value="Ok">
	<input type="reset" name="reset" value="Tühjenda">
</form>

</body>
</html>