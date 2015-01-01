<?

define('jv', 0.1); //Jõudevool 100mA

$p=(int)$_POST['P'];
$r=(int)$_POST['R'];

if (!($p && $r)) die ('Proovi algandmed uuesti sisestada!');

if ($_POST['sild']) {

	$um=sqrt(2*$p*$r)/2;
	$u=sqrt($p*$r)/2;
	$im=sqrt(2*$p/$r)*2;
	$i=$im/3.14;
	$e=$um+3;
	$s=$e/sqrt(2);
	$jp=$e*jv;

} else {

	$um=sqrt(2*$p*$r);
	$u=sqrt($p*$r);
	$im=sqrt(2*$p/$r);
	$i=$im/3.14;
	$e=$um+3;
	$s=$e/sqrt(2);
	$jp=$e*jv;
	
}

?>
<!DOCTYPE html
PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Võimendi toitepinge kalkulaator</title>
<style type="text/css">
h1, h2, td, form, input, p, li { font-family:Helvetica }
</style>
</head>
<body>
<h1>Võimendi toitepinge kalkulaator</h1>
<h2>Tulemused</h2>
<ul>
<li>Soovitud võimsus: <?=$p?>W</li>
<li>Kõlari takistus: <?=$r?> oomi</li>
<li>Väljundpinge amplituudväärtus: <?=round($um, 2)?>V</li>
<li>Väljundpinge efektiivväärtus: <?=round($u, 2)?>V</li>
<li>Toitevoolu amplituudväärtus: <?=round($im, 2)?>A</li>
<li>Toitevoolu efektiivväärtus: <?=round($i, 2)?>A</li>
<li><b>Toiteseade</b>
  <ul>
  <li>Ühe poole toitepinge: <?=round($e, 0)?>V</li>
  <li>Voolutaluvus: <?=round($i, 0)?>A</li>
  <li>Võimsus: <?=round(2*$i*$e, 0)?>W</li>
  </ul>
</li>
<li><b>Väljundaste</b>
  <ul>
  <li>Ühe poole hajuvvõimsus signaalita ja koormuseta: <?=round($jp, 0)?>W</li>
  <li>Ühe poole hajuvvõimsus: <?=round(($e*$e)/(3.14*3.14*$r)+$jp, 0)?>W</li>
  </ul>
</li>
</ul>
<a href="power.html">Tagasi sisestuvormi juurde</a>
</body>
</html>