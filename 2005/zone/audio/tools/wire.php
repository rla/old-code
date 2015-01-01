<?

$d=(float)$_POST['d'];
$l=(float)$_POST['l'];
$t=(int)$_POST['m'];

if (!($d && $l)) die ('Proovi algandmed uuesti sisestada!');

$S=pow($d/2, 2)*3.14;

if ($t=='8920') $r=0.0175; else $r=0.028;
$R=$r*$l/$S;

?>
<!DOCTYPE html
PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Juhtme ristlõike, takistuse ja massi kalkulaator</title>
<style type="text/css">
h1, h2, td, form, input, p, li { font-family:Helvetica }
</style>
</head>
<body>
<h1>Juhtme ristlõike, takistuse ja massi kalkulaator</h1>
<h2>Tulemused</h2>
<ul>
<li>Juhtme läbimõõt: <?=$d?> mm</li>
<li>Juhtme pikkus: <?=$l?> m</li>
<li>Juhtme materjal: <?=$t==8920 ? 'vask' : 'alumiinium'?></li>
<li>Juhtme ristlõige: <?=round($S, 4)?> mm^2</li>
<li>Juhtme mass: <?=round($S/1000000*$l*$t, 4)?> kg</li>
<li>Juhtme takistus: <?=round($R, 4)?> oomi</li>
</ul>
<a href="wire.html">Tagasi sisestuvormi juurde</a>
</body>
</html>