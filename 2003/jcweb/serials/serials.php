<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Serialz</title>
	<link rel="stylesheet" href="style.css" type="text/css">
</head>

<body background="graphics/bg.gif">
    <table border="0" cellspacing="1" bgcolor="#999999" width="100%">
	<tr><td bgcolor="#999999" height="20">
	<div class="wintitel" align="left">&nbsp; &nbsp; Serialz 
	<?php
      if (isset($taht)) echo ' - ' .StrToUpper($taht);
	?>
	</div>
	</td></tr>
	<tr><td bgcolor="#eeeeee" height="500" valign="top">
	<p class="text">
	<br><br>
    <?php
	  if (isset($taht)) { 
	    include($taht .'.inc');
	  }
	  else {
	    if (isset($otsing)) {
		  for ($i=97; $i<=122; $i++) {
		    $fnimi=chr($i) .'.inc';
		    $fp=fopen($fnimi, 'r');
		    while (!feof($fp)) {
		      $rida=fgets($fp);
			  $pos=strpos(StrToUpper($rida), StrToUpper($otsing));
			  if ($pos !== false) print($rida);
		    }
		    fclose($fp);
		  }	
		}
	  }	
	?>
	</p>
	</td></tr>
	</table>
</body>
</html>
