<html>

<head>
  <title>Script tekitab index failist mittekorduva sisuga faili.</title>
</head>

<body>

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

$index=fopen('artists.ind', 'rb');
$artists_file=fopen('artists_list.ind', 'wb');
$artists=array();
while(!feof($index)) {
	$artist=rtrim(fread($index, 50));
    if(!in_array($artist, $artists)) {
    	array_push($artists, $artist);
        fwrite($artists_file, AddNull($artist, 50), 50);
    }
}
fclose($index);
fclose($artists_file);
print 'ARtistide fail edukalt tekitatud!<br>';

?>

</body>

</html>