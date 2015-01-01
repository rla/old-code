<html>
<head>
<title>JC Mp3</title>
<link rel="stylesheet" content="text/css" href="style.css">
</head>
<body>
<img src="banner.gif" hspace="20" alt="jc_mp3_banner" border="1">
<img src="id3v2.gif" alt="id3v2_logo">
<img src="varv.bmp" height="15" width="750" alt="riba">

<table border="0" cellspacing="0" cellpadding="6" width="100%">
<tr>
<td width="120" background="varv.bmp" height="500" valign="top">
<br><br><br>
<a href="index.php" class="menuu"><li>Otsing</li></a>
<a href="index.php?action=artists" class="menuu"><li>Esitajad</li></a>
<a href="index.php?action=lingid" class="menuu"><li>Lingid</li></a>
<a href="index.php?action=download" class="menuu"><li>Download</li></a>
<div class="menuu">
<form action="index.php" method="post">
Kasutaja<br>
<input type="text" maxlength="10" name="user" style="width: 70px; border:1px"><br>
Parool<br>
<input type="text" maxlength="10" name="pass" style="width: 70px; border:1px"><br><br>
<input type="hidden" name="action" value="login">
<input type="submit" value="Logi Sisse" style="background: #99cccc; color:#ffffff; font-weight: bold; border-style: solid; border-color: #ffffff;">
</form>
</div>
</td>
<td valign="top" align="left">
<br><br>
  <?php
    //$action=$_POST['action'];
    $action=$_GET['action'];
    switch($action) {
      case 'login':
        print 'Ei tööta';
      break;
      case 'info':
        print '<div class="title">Info</div><hr><br><br>';
        $id=$_GET['id'];
        include('info.php');
      break;
      case 'search':
        include('search.php');
        $search=$_GET['search'];
		$bywhat=$_GET['bywhat'];
        print '<div class="title">Otsingu tulemused</div><hr><br><br>';
        if(strlen($search)>2) Mp3SearchQuery($bywhat, $search);
      break;
      case 'artists':
        print '<div class="title">Esitajad</div><hr><br><br>';
        include('artist.php');
        $letter=$_GET['letter'];
        if($letter=='') GetArtistAlphabet();
        else GetArtistList($letter);
      break;
      case 'artist':
        $artist=$_GET['artist'];
        $letter=$_GET['letter'];
        include('search.php');
        print '<div class="title">Esitajad</div><hr><br><br>';
        print '<a href="index.php?action=artists" class="textlink">Esitajad</a>-&#62;<a href="index.php?action=artists&letter=' .$letter .'" class="textlink">' .$letter .'</a>-&#62<span class="text">' .$artist .'</span><br><br>';
        if(strlen($artist)>2) Mp3SearchQuery('artist', $artist);
      break;
      case 'lingid':
        print '<div class="title">Lingid</div><hr><br><br>';
        include('lingid.html');
      break;
      case 'download':
        print '<div class="title">Download</div><hr><br><br>';
        include('download.html');
      break;
      default:
        print '<div class="title">Otsing</div><br>
        Andmebaasi viimati uuendatud ' .date("d-m-Y H:i", filemtime('mp3.tbl')) .'<br><hr>';
        include('search_form.html');
      break;
    }
  ?>
</td>
</tr>
</table>
</body>
</html>