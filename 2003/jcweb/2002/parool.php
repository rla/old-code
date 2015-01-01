<HTML>
<HEAD>
  <TITLE>United</TITLE>
</HEAD>
<BODY> 
<?PHP
  if ($kood=="test") {
      include("menuuh.inc");
  }
  else {
      echo "<form action=$PHP_SELF method=post>";
      echo "<CENTER>Parool <input type=\"text\" name=\"kood\" >";
      echo "<input type=\"submit\" value=\" Ok\"></CENTER>";
     if (isset($kood)) {
       echo "<BR><BR><BR>";
       echo "<CENTER>";
       echo "<FONT color=\"#ff0000\">Sisestasid vale parooli!</FONT>";
       echo "</CENTER>";
    } 
  }
?>



</BODY>
</HTML>
