<HTML>
<HEAD>
  <TITLE>United</TITLE>
</HEAD>
<BODY>
<?PHP 
  echo "<form action=$PHP_SELF method=post>";
  echo "<center><input type=\"text\" name=\"otsitav\" >";
  echo "<input type=\"submit\" value=\" Otsi\"></CENTER>";
  if (isset($otsitav)) {
    echo "<BR>";
    $fnimi="koik.lst";
    $fp=fopen($fnimi, 'r');
    while(!feof($fp)){
      $rida=fgets($fp, 4096);
      if (stristr($rida,$otsitav)) {
       echo $rida;
       echo "<br>";
       }
    }
    fclose($fp);
  }
?>

</BODY>
</HTML>