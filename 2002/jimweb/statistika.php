<HTML>
<HEAD>
  <TITLE>JimWeb Statistika (test)</TITLE>
</HEAD>
<BODY>
<?PHP
echo "<CENTER><FONT size=\"5\">Statistika</FONT></CENTER>";
  echo "<HR>";
  $fp=fopen("ip.dat", "r");
  $count=-1;
  while (!feof($fp)) {
    $rida=fgets($fp, 4096);
    $count=$count+1;
    echo "$rida";
    echo "<BR>";
    }
  fclose($fp);
  echo "<HR>";
  echo "<B>$count sissekannet</B>";
?>
</BODY>
</HTML>
