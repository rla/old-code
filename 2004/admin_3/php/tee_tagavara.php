<h1>Tagavarakoopiad</h1>
<?php

/*
tee_tagavara.php
Saidist tagavarakoopia tegemine.
Raivo Laanemets
13. august 2004
*/

function encode_data($inp) { /*andmete kodeerimise funktsioon*/
	$outp='';
	for($i=0; $i<strlen($inp); $i++) $outp.='%' .ord($inp{$i});
    return $outp;
}

$content='';

$f_data_name=md5(date("Y-m-d H:i:s") .$_SESSION['saidi_nimi']) .'.tmp';
$fp=fopen('temp/' .$f_data_name, 'wb') or die('Faili ei saa avada!<br>Kontrolli kausta /temp õigusi.');
fwrite($fp, $_SESSION['saidi_nimi'] .':' .date("Y-m-d H:i:s") .':;');

/*keeled*/
mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_keeled");
while($result=mysql_fetch_row($res)) $content.=$result[0] .':'; $content.=';';

/*sisu*/
$res=mysql_query("SELECT id,tyyp,pealkiri,keel,tekst FROM " .$_SESSION['saidi_nimi'] ."_sisu");
while($result=mysql_fetch_row($res)) {
	if ($result[1]=='php') $result[4]=file_get_contents($_SESSION['saidi_tee'] .'/php/' .$result[0] .'.php');
    $content.=$result[0] .':' .$result[1] .':' .$result[2] .':' .$result[3] .':' .encode_data($result[4]) .';';
}

fwrite($fp, $content);
fclose($fp);

?>
Tagavara loodud! <a href="temp/<?php echo $f_data_name ?>">Andmefail</a><br>