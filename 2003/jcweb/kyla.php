<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
   <style type="text/css">
   <!--
   .tabel {
     font-size:11pt ;
	 font-color:#999999 ;
     background-color:#eeeeee }
   .vorm {
     font-size:10pt ;
	 font-weight:bold }	 
   A:link {
     color: #666666;
     font-size: 9pt;
     font-weight: bold;
     text-decoration: none;
     font-family: verdana, arial }
   A:visited {
     color: #666666;
     font-size: 9pt;
     font-weight: bold;
     text-decoration: none;
     font-family: verdana, arial }
   A:hover {
     color: #ff6666;
     font-size: 9pt;
     font-weight: bold;
     text-decoration: none;
     font-family: verdana, arial }
   -->
   </style>
	<title>Külalisteraamat</title>
</head>

<body bgcolor="#eeeeee">

<table width="100%" bgcolor="#999999" border="0" cellspacing="0" cellpadding="0">
<tr><td>
<table width="100%" border="0" cellspacing="1">
<?PHP
  $kuupäev=date('Y-m-d H:i:s');
  $failinimi='kyla.txt';
  $my_rida=array('','','','','');
  $my_rida[0]=$kuupäev;
  
  if ((strlen($nimi)>0) && (strlen($tekst)>0)) {
    $fp=fopen($failinimi, 'a');
	$my_rida[1]=$nimi;
	$my_rida[2]=$tekst;
	$my_rida[3]="<a href=\"mailto: $mail \"> $mail </a>";
	$rida=join('|', $my_rida)."\n";
	fwrite($fp, $rida, strlen($rida));
	fclose($fp); 
  } 

    $fp=fopen($failinimi, 'r');

    while (!feof($fp)) {
      $my_array=explode('|', fgets($fp, 4096));
	  if (strlen($my_array[0]>0)) {
	    echo "<tr><td class=\"tabel\">";
        echo "<b>Kuupäev:</b> $my_array[0] <br>";
		echo "<b>Nimi:</b> $my_array[1] <br>";
	    echo "<b>Mail:</b> $my_array[3] </td>";
	    echo "<td class=\"tabel\" valign=\"top\"><b>Tekst:</b> $my_array[2] </td></tr>";
	  }	 
    }
  fclose($fp) 
?>
</table>
</td></tr>
</table>
<form action="index.php" method="post">
<table width="100">
<tr><td class="vorm">Nimi*</td></td><td><input type="text" name="nimi" maxlength="20" style="border:1px solid rgb (0,0,0)"></td></tr>
<tr><td class="vorm">Mail</td></td><td><input type="text" name="mail" maxlength="20" style="border:1px solid rgb (0,0,0)"></td></tr>
<tr><td class="vorm" valign="top">Tekst*</td><td><textarea name="tekst" rows="5" cols="20" style="border:1px solid rgb (0,0,0)"></textarea></td></tr>
<tr><td></td><td><input type="submit" value="Lisa->" style="border:1px solid rgb (0,0,0)"></td></tr>
</table>
</form>
<br>
<font size="2" face="courier">
* - tähistatud väljad on kohustuslikud
</font>
</body>
</html>
