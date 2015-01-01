<html>
<head>
	<title>Doom Estonia 2K4</title>
	<link rel="StyleSheet" type="text/css" href="css/style.css">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta name="author" content="Raivo Laanemets">
</head>

<body>
<table width="750" align="center" cellspacing="0" cellpadding="0">
  <tr><td height="100" colspan="2"><img src="graphics/doomestonia.jpg"></td></tr>
  <tr><td height="1" colspan="2"><img src="graphics/black.bmp" height="1" width="750"></td></tr>
  <tr><td height="20" colspan="2">
  <?php include('dpages/menuu.html'); ?>
  </td></tr>
  <tr><td height="1" colspan="2"><img src="graphics/black.bmp" height="1" width="750"></td></tr>
  <tr>

  <td width="100">
  <br><br><br>
  <table border="0" bgcolor="#000000" width="100" cellspacing="1" height="100%" cellpadding="4">
    <tr><td bgcolor="#ffffff" height="100">hahaha</td></tr>
  </table>
  </td>

  <td valign="top">
  <br><br><br>
  <table border="0" bgcolor="#000000" cellspacing="1" cellpadding="4">
    <tr><td bgcolor="#ffffff">
  <?php
  include_once('dbpage.autoupdate.php');
  if(!isset($action)) $action='index';
  if($action=='index') {
	include('content/ind.php');
  } else {
  	if(is_file('content/' .$action .'.php')) include('content/' .$action .'.php');
    else print 'Sorry but ' .$action . ' is unavailible.';
  }
  ?>
    </td></tr>
  </table>
  <br><br><br>
  </td></tr>
  <tr><td height="1" colspan="2"><img src="graphics/black.bmp" height="1" width="750"></td></tr>
  <tr><td height="20" class="text" colspan="2">(c) R.Laanemets 2003-2004<script language="JavaScript">
<!-- Zone Counter
url = "<a href=\"http://counter.zone.ee/stats.php3?rid=KPMo1g1G\" TARGET=\"_blank\">";
img = "<img src=\"http://counter.zone.ee/count.php3?cid=KPMo1g1G&ref="+top.document.referrer+"\" BORDER=\"0\" NOCACHE>";
document.write(url+img+"</a>");
// -->
</script>
<noscript>
<a href="http://counter.zone.ee/stats.php3?rid=KPMo1g1G&ref=" TARGET="_blank">
<img src="http://counter.zone.ee/count.php3?cid=KPMo1g1G&ref=" BORDER="0" NOCACHE>
</a>
</noscript>&nbsp;&nbsp; <a href="textadmin.html">This site is managed using TextAdmin.</a></td></tr>
  <tr><td height="1" colspan="2"><img src="graphics/black.bmp" height="1" width="750"></td></tr>
</table>

</body>
</html>