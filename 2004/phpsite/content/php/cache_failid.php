<?php //2004-04-16
$objektid['cache_failid']['ee']['title']='Cache - Failid';
$d=dir('cache');
print '<table border="1" cellspacing="0" bordercolor="#cccccc">';
while($entry = $d->read()) {
	if (($entry<>'.') && ($entry<>'..')) {
    	$ext=substr(strrchr($entry, '.'), 1, 10);
        print '<tr><td class="text">' .strtoupper($ext) .'</td><td class="text">' .$entry .'</td><td class="text">' .date("Y-m-d H:i:s", filemtime('cache/' .$entry)) .'</td></tr>';
  	}
}
print '</table>';
$d->close();
?>