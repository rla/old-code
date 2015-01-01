<?

$u=(float)$_POST['u'];
$i=(float)$_POST['i'];
$e=(float)$_POST['e'];

if (!($u && $i && $e)) die ('Proovi algandmed uuesti sisestada!');

$r=($e-$u)/$i;
$pr=$i*($e-$u)/1000.0;
$p=$u*$i/1000.0;

?>
<!DOCTYPE html
PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Eeltakisti kalkulaator</title>
<style type="text/css">
h1, h2, td, form, input, p, li { font-family:Helvetica, sans-serif; }
</style>
</head>
<body>
<h1>Eeltakisti kalkulaator</h1>
<h2>Tulemused</h2>
<ul>
<li>Tööpinge: <?=$u?> V</li>
<li>Rakendatav pinge: <?=$e?> V</li>
<li>Eeltakistil hajuv võimsus: <?=round($pr, 4)?> W</li>
<li>Seadme(valgusdiood või stabilitron) poolt tarbitav võimsus: <?=round($p, 4)?> W</li>
<li>Koguvõimsus: <?=round($e*$i/1000.0, 4)?> W</li>
</ul>
<a href="balance.html">Tagasi sisestuvormi juurde</a>
</body>
</html>