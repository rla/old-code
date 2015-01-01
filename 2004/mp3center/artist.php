<?php

function GetArtistList($letter) {
	print '<a href="index.php?action=artists" class="textlink">Esitajad</a>-&#62;<a href="index.php?action=artists&letter=' .$letter .'" class="textlink">' .$letter .'</a><br><br>';
	$artists=fopen('artists_list.ind', 'rb');
    while(!feof($artists)) {
    	$artist=fread($artists, 50);
        if(substr($artist, 0, 1)==$letter) {
        	print '<a href="index.php?action=artist&artist=' .rtrim($artist) .'&letter=' .$letter .'" class="textlink">' .rtrim($artist) .'</a><br>';
        }
    }
    fclose($artists);
}

function GetArtistAlphabet() {
	for($i=1; $i<=10; $i++) {
    	print '<a href="index.php?action=artists&letter=' .$i .'" class="textlink">'.$i .'</a>&nbsp;';
    }
    for($i=65; $i<=90; $i++) {
    	print '<a href="index.php?action=artists&letter=' .chr($i) .'" class="textlink">'.chr($i) .'</a>&nbsp;';
    }
}

?>