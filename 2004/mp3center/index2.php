<html>
<head>
<title>JC Mp3</title>
<link rel="stylesheet" content="text/css" href="style.css">
</head>
<body>
<img src="banner.jpg" width="420" height="72" hspace="20" alt="jc_mp3_banner">
<img src="id3v2.gif" alt="id3v2_logo">
<img src="varv.bmp" height="15" width="750" alt="riba">

<table border="0" cellspacing="0" cellpadding="6" width="100%">
<tr>
<td width="120" background="varv.bmp" height="500" valign="top">
<br><br><br>
<a href="" class="menuu"><li>Esitajad</li></a>
<a href="" class="menuu"><li>Lingid</li></a>
<a href="" class="menuu"><li>Download</li></a>
<div class="menuu">
<form action="index.php" method="post">
Kasutaja<br>
<input type="text" maxlength="10" name="user" style="width: 70px; border:1px"><br>
Parool<br>
<input type="text" maxlength="10" name="pass" style="width: 70px; border:1px"><br><br>
<input type="hidden" name="action" value="login">
<input type="submit" value="Logi Sisse" style="background:#99cccc; color:#ffffff; font-weight: bold;">
</form>
</div>
</td>
<td valign="top" align="left">
<br><br>
  <?php
    $action=$_POST['action'];
    switch($action) {
      case 'login':
        print 'Ei tööta';
      break;
      default:
        include('search_form.html');
      break;
    }
  ?>
</td>
</tr>
</table>
<!--  <td colspan="2" height="15" bgcolor="#99cccc"></td>
</tr>
<tr>
  <td width="120" valign="top" bgcolor="#99cccc">
  <!--Menüü ja login
    Esitajad<br>
    Albumid<br>
    <hr size="1">
    <div class="login_form">
    <form action="index.php" method="post">
    Kasutaja<br>
    <input type="text" maxlength="10" name="user" style="width: 70px; border:1px"><br>
    Parool<br>
    <input type="text" maxlength="10" name="pass" style="width: 70px; border:1px"><br><br>
    <input type="hidden" name="action" value="login">
    <input type="submit" value="Logi Sisse" style="background:#000000; color:#ffffff; border:1px">
    </form>
    </div>
  </td>
  <td width="628"><!--Lehekülje sisu
  <?php
    $action=$_POST['action'];
    switch($action) {
      case 'login':
        print 'Ei tööta';
      break;
      default:
        include('search_form.html');
      break;
    }
  ?>
  </td>
</tr>
</table>
!-->

</body>

</html>