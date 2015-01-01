<html>

<head>
  <title>MP3 failide tabelisse panek.</title>
</head>

<body>
Raivo Laanemets 2003 rl@starline.ee

<?php

function AddNull($input, $data_length) { //muutuja lõppu vastava arvu tühikute lisamine.
	$len=strlen($input);
    $output=$input;
    if($data_length>=$len) {
    	for($i=1; $i<=($data_length-$len); $i++) {
        	$output.=' ';
        }
    } else {
    	print '<br>AddNull error.<br>';
        print $input .'<br>';
    }
    return $output;
}


$fp=fopen('mp3files.txt', 'r');
$table=fopen('mp3.tbl', 'wb');//mp3 tabel
$lood_index=fopen('songs.ind', 'wb');//lugude index
$esitajad_index=fopen('artists.ind', 'wb');
$albumid_index=fopen('albums.ind', 'wb');
$aastad_index=fopen('years.ind', 'wb');
$kat_index=fopen('genres.ind', 'wb');
$row=array();
$l_arv=0;
while(!feof($fp)) {
	$rida=fgets($fp, 2048);//failist ühe rea lugemine
    $row=explode('*', $rida);

    $lugu=substr(strrchr($row[0], '-'), 1);
    $lugu=substr($fn_lugu, 1, strlen($fn_lugu)-4);
    if (strlen($lugu)<strlen(rtrim($row[1]))) $lugu=$row[1];

    //lugu
    $data=AddNull(ucwords(strtolower($lugu)), 50);
    fwrite($table, $data, strlen($data));
    fwrite($lood_index, $data, strlen($data));

    //esitaja
    $data=AddNull(ucwords(strtolower($row[2])), 50);
    fwrite($table, $data, strlen($data));
    fwrite($esitajad_index, $data, strlen($data));

    //album
    $data=AddNull(ucwords(strtolower($row[3])), 50);
    fwrite($table, $data, strlen($data));
    fwrite($albumid_index, $data, strlen($data));

    //aasta
    $data=AddNull(trim($row[4]), 4);
    fwrite($table, $data, strlen($data));
    fwrite($aastad_index, $data, strlen($data));

    //kategooria
    $data=AddNull(trim($row[5]), 3);
    fwrite($table, $data, strlen($data));
    fwrite($kat_index, $data, strlen($data));

    //bitrate
    $data=AddNull(trim($row[6]), 4);
    fwrite($table, $data, strlen($data));

    //pikkus
    $data=AddNull(trim($row[7]), 7);
    fwrite($table, $data, strlen($data));

    $l_arv++;
}
fclose($fp);
fclose($table);
fclose($lood_index);
fclose($esitajad_index);
fclose($albumid_index);
fclose($aastad_index);
fclose($kat_index);
print 'Lugude arv: ' .$l_arv;

?>

</body>

</html>