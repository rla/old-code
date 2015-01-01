Problem 67

By starting at the top of the triangle below and moving to
adjacent numbers on the row below, the maximum total from top to bottom is 23.

3
7 5
2 4 6
8 5 9 3

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom in triangle.txt
(right click and 'Save Target As...'), a 15K text file
containing a triangle with one-hundred rows.

NOTE: This is a much more difficult version of Problem 18.
It is not possible to try every route to solve this problem,
as there are 299 altogether! If you could check one trillion (1012)
routes every second it would take over twenty billion years to check them all.
There is an efficient algorithm to solve it. ;o)

Lahendus: Raivo Laanemets rl@starline.ee
Lahendame altpoolt üles, leiame suurima tee elememdist
alla liikumiseks. Keerukus n^2, kus n on kolmnurga kõrgus.


<?php

//Loeme sisse algandmed.

$fp=fopen("triangle.txt", "r");
while (!feof($fp)) $alg[]=explode(" ", fgets($fp));
fclose($fp);

for ($i=98; $i>=0; $i--) {

	for ($j=0; $j<=$i; $j++) {
	
		//Igalt elemendilt saab liikuda
		//kahele alumisele elemendile.
		//valime suurima nendest teedest.
		
		$alg[$i][$j]+=max($alg[$i+1][$j+1], $alg[$i+1][$j]);
	
	}

}

print "Vastus: " .$alg[0][0] ."\n";

?>