<?php

include_once('genre.inc.php');

$table=fopen('mp3.tbl', 'rb');
fseek($table, $id*168);//50+50+50+4+3+4+7

print '<table border="0">';
$title=rtrim(fread($table, 50));
print '<tr><td class="text">Pealkiri:</td><td class="text">' .$title .'</td></tr>';

$artist=rtrim(fread($table, 50));
print '<tr><td class="text">Esitaja:</td><td><a href="index.php?action=search&bywhat=artist&search=' .$artist .'" class="textlink">' .$artist .'</a></td></tr>';

$album=rtrim(fread($table, 50));
print '<tr><td class="text">Album:</td><td><a href="index.php?action=search&bywhat=album&search=' .$album .'" class="textlink">' .$album .'</a></td></tr>';

$year=rtrim(fread($table, 4));
if (strlen($year)<4) {
	$year='Unknown';
    print '<tr><td class="text">Aasta:</td><td class="text">' .$year .'</td></tr>';
} else {
    print '<tr><td class="text">Aasta:</td><td><a href="index.php?action=search&bywhat=year&search=' .$year .'" class="textlink">' .$year .'</td></tr>';
}

$genre=rtrim(fread($table, 3));
print '<tr><td class="text">Kategooria:</td><td><a href="index.php?action=search&bywhat=genre&search=' .$genre .'" class="textlink">' .Mp3DecodeGenre(intval($genre)) .'</td></tr>';
print '<tr><td class="text">Bitikiirus:</td><td class="text">' .rtrim(fread($table, 4)) .' kb/s</tr></tr>';
print '<tr><td class="text">Pikkus:</td><td class="text">' .rtrim(fread($table, 7)) .'</td></tr>';
print '<tr><td colspan="2" class="text"><a href="http://www.google.com/search?hl=en&lr=&ie=UTF-8&oe=UTF-8&safe=off&q=' .$artist .'+' .$title .'" class="textlink">Rohkem infot</a></td></tr>';
fclose($table);

print '</table>';

?>