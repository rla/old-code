<HTML>
<HEAD>
  <TITLE>JimWeb special</TITLE>
</HEAD>
<BODY bgcolor="#cccccc" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
<IMG src="special.gif" width="100%" hspace="0" vspace="0" align="top">
<?PHP
  if ($kood=="killer") {
      include("special.inc");
  }
  else {
      echo "<CENTER>Sattusid JimWeebi special leheküljele.</CENTER>";
      echo "<CENTER>Edasipääsemiseks läheb sul vaja parooli.</CENTER><BR><BR>";
      echo "<form action=$PHP_SELF method=post>";
      echo "<CENTER>Parool <input type=\"text\" name=\"kood\" ><BR><BR>";
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
