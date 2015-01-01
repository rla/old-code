<HTML>
<HEAD>
  <TITLE>Kommentaarid</TITLE>
</HEAD>
<BODY>
<CENTER><FONT size="5">Kommentaarid</FONT></CENTER>
<HR>
<?PHP
  if (isset($nimi))
    {
    $text=htmlspecialchars($text);
    $nimi=htmlspecialchars($nimi);
    $mail=htmlspecialchars($mail);
    $kell=date("d/m/y-H:i:s");
    $fp=fopen("raamat.dat", "a");
    
    fwrite($fp, "$kell<BR><a href=mailto:$mail>$nimi</a>");
    fwrite($fp, " kirjutas:<BR>$text<BR><HR>");
    fclose($fp);
    }
  unset($nimi);
?>
<HR>
<?PHP include("raamat.dat"); ?>
<BR>
<FORM action="kyla.php" method="post">
<INPUT type="text" name="nimi"><BR>
<INPUT type="text" name="mail"><BR>
<TEXTAREA width="40" heigth="10" name="text">
</TEXTAREA><BR>
<INPUT type="submit" value="OK">
</FORM>
<BR><BR>
</BODY>
</HTML>