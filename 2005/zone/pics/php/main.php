<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-13">
<title>Pildid</title>
<style type="text/css">
body, h1, h2, h3, li, a {
  font-family: verdana;
  font-weight: normal;
  color: #AB001F; 
}
h1 {
  font-size: 16pt;
  border-bottom: 1px dashed #AB001F;
}
h2 {
  font-size: 14pt;
  color: #AB001F;
}
h3 {
  font-size: 12pt;
  font-weight: bold;
}
body {
  background-color: #FFF280;
  margin: 0pt;
}
#ylemine {
  background-color: #FFE500;
  height: 60pt;
  font-family: verdana;
  color: #AB001F;
  padding: 4pt;
}
#menuu {
  margin-left: 20pt;
}
.menu-link {
  color: #AB001F;
  font-family: verdana;
}
#sisu {
  padding: 60pt;
}
img {
  border: 1px solid #AB001F;
}
td {
  padding: 20px;
  background-color: #FFE500;
}</style>
</head>

<body>

<div id="ylemine">
<h1>Raivo Laanemets</h1>
<p id="menuu">
<a href="http://www.rl.pri.ee/?leht=index" class="menu-link">Esileht</a> | <a href="http://www.rl.pri.ee/?leht=cv" class="menu-link">CV</a> | <a href="http://www.rl.pri.ee/pics" class="menu-link">Pildid</a> | <a href="http://www.rl.pri.ee/?leht=mitmesugust">Mitmesugust</a>
</p></div>
<div id="sisu">
<?php

if ($_GET['id']>2) Object($_GET['id']); else Object(3);

?>
</div>
</body>
</html>