<HTML>
<HEAD>
  <TITLE>United</TITLE>
</HEAD>
<BODY>
<?PHP
  $ip=$HTTP_SERVER_VARS["REMOTE_ADDR"];
  $aasta=date("Y");
  $kuu=date("m");
  $paev=date("d");
  $tund=date("H");
  $minut=date("i");
  $aegarr=array($paev, $kuu, $aasta, $tund, $minut);
  $aeg=implode("-", $aegarr);
  $ridaarr=array($aeg, $ip, "\n");
  $rida=implode(" ", $ridaarr);
  echo "<B>ip statistika:</B><BR><BR>";
  echo "<B>Sinu ip</B> $ip <BR><BR>";
  $fp=fopen("ip.dat", "a+");
  fwrite($fp, $rida);
  fclose($fp);
  $fp=fopen("ip.dat", "r");
  while (!feof($fp)) {
    $rida=fgets($fp, 4096);
    echo "$rida";
    echo "<BR>";
    }
  fclose($fp);
?>
</BODY>
</HTML>