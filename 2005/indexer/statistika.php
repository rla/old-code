Statistika
<?php

$count=0; $size=0;

function directory($directory) {
	global $count;
	global $size;
	$d=dir($directory);
	while ($entry=$d->read())
		if ($entry!='.' and $entry!='..')
			if (is_dir($directory .'/' .$entry)) directory($directory .'/' .$entry);
			else {
				$count++;
				$size+=filesize($directory .'/' .$entry);
			}
	$d->close();
}

$failid=file('list.txt');
foreach ($failid as $value) directory('/home/raivo/' .trim($value));

echo "Failide arv on: " .$count ."\n" .
	"Failide suurus on kokku: " .$size ."\n";

?>