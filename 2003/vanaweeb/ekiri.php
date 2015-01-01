<!-- see skript ei t88ta zone.ee tasuta serveris kuna zone on mail() funktsiooni 2ra keelanud -->
<html>
<head>
<title>Linuxator Kontakt</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="author" content="Martin Rebane - martin@linuxator.com; http://www.linuxator.com">
</head>
<body bgcolor="#FFFFFF">
<?php

if(isset($checkme))
{
if(!strlen($email) || !strlen($nimi) || !strlen($teema) || !strlen($kiri))
	{
	echo"<h3 style=\"color: red;\">Palun vajuta brauseri back-nuppu, osad v&auml;ljad j&auml;id t&auml;itmata!</h3>";
	}
else
{	
echo ("<div align=\"center\" style=\"color: red; font-family: verdana, serif; font-weight: bold; font-size: 14px;\">T&auml;name kirja eest!&nbsp;<br>Me loeme Sinu kirja niipea kui v&otilde;imalik ja vastame kui vajalik.<br></div>");

mail("jc17@solo.ee", "$teema (Veebilehelt)", $kiri, "From: $nimi<$email>\nReply-To: $email\nX-Mailer: PHP/" . phpversion());
}
}
?>

   	 <div class="tbl2">
   	 <form method="post" action="ekiri.php">
   	 <table style="color: black; font-family: arial; font-size: 12px;">
   	 <tr>
   	 <td colspan="2">
   	 <div align="center" style="color: navy; font-weight: bold; font-size: 14px; text-transform: uppercase;">
   	 kontakteeru meiega
   	 </div>
   	 </td></tr>
   	 <tr><td width="35%" valign="top">
 	 <div align="center">
 	 <label>Sinu nimi</label><br>
 	 <input type="text" name="nimi" size="25" tabindex="1" maxlength="256"><br>
 	 <label>Sinu e-post</label><br>
 	 <input type="text" name="email" size="25" tabindex="2" maxlength="256"><br>
 	 <label>Teema</label><br>
 	 <input type="text" name="teema" size="25" tabindex="3" maxlength="256"><br>
 	 </td><td class="65%">
 	 <label>Kiri</label><br>
 	 <textarea rows="10" cols="30" name="kiri"></textarea><p>
 	 <input type="hidden" name="checkme" value="formmail">
 	 <input type="submit" value="Saada"></div>
 	 </td>
 	 </tr>
 	 </table>
 	 </form>
 	 </div>
</body>
</html>
