<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
  <title>Uue tabeli loomine</title>
  <meta name="Description" content="Uue tabeli loomine">
  <meta name="Author" content="Raivo Laanemets">
  <meta name="Copyright" content="(c) 2005 Raivo Laanemets">
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-13">
  <style type="text/css">
  body, li, i, h1, h2, h3, h4, h5, p, td {
    font-family: Helvetica, sans-serif;
  }
  td {
    padding: 6px;
  }
  </style>
  </head>
<body style="width:600px">
<h1>Uue arvutustabeli loomine</h1>
<h2>Veergude pealkirjade ja valemite sisestamine</h2>

<p>
Rea elemente saab valemis kasutada kui muutujaid c_n, kus n on veeru number. Veerg numbriga
0 on rea identifikaator. Näide summa arvutamiseks: c_1+c_2.
Kui valemit ei soovita, siis pole vaja valemi lahtrisse midagi sisestada.
</p>

<form method="post" action="new_table.create.php">

<?php $cols=(int)$_POST['cols']; if ($cols>12 || $cols<1) $cols=2; ?>

<input type="hidden" name="cols" value="<?=$cols?>">
<input type="hidden" name="name" value="<?=$_POST['name']?>">

<?php
for ($i=1; $i<=$cols; $i++) echo '<label for="v' .$i .'">Veerg ' .$i .'</label><br><input type="text" name="v' .$i .'">&nbsp;&nbsp;<input type="text" name="v' .$i .'f"><br>';
?>

<br>
<input type="submit" value="Lisa">
</form>

<p><i>Autor: Raivo Laanemets, <a href="mailto:rlaanemt@ut.ee">rlaanemt@ut.ee</a><br>
Copyright (c) 2005 Raivo Laanemets<br>
<p>
<a href="http://validator.w3.org/check?uri=referer"><img
  src="http://www.w3.org/Icons/valid-html401"
  alt="Valid HTML 4.01!" height="31" width="88"></a>
</p>
</body>
</html>