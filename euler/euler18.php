Problem 18


By starting at the top of the triangle below and moving to
adjacent numbers on the row below, the maximum total from top to bottom is 23.

3
7 5
2 4 6
8 5 9 3

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom of the triangle below:

75
95 64
17 47 82
18 35 87 10
20 04 82 47 65
19 01 23 75 03 34
88 02 77 73 07 63 67
99 65 04 28 06 16 70 92
41 41 26 56 83 40 80 70 33
41 48 72 33 47 32 37 16 94 29
53 71 44 65 25 43 91 52 97 51 14
70 11 33 28 77 73 17 78 39 68 17 57
91 71 52 38 17 14 91 43 58 50 27 29 48
63 66 04 68 89 53 67 30 73 16 69 87 40 31
04 62 98 27 23 09 70 98 73 93 38 53 60 04 23

Lahendus: Raivo Laanemets rl@starline.ee
Lahendame altpoolt üles, leiame suurima tee elememdist
alla liikumiseks. Keerukus n^2, kus n on kolmnurga kõrgus.


<?php

$alg=array(
	array(75),
	array(95,64),
	array(17,47,82),
	array(18,35,87,10),
	array(20, 4,82,47,65),
	array(19, 1,23,75, 3,34),
	array(88, 2,77,73, 7,63,67),
	array(99,65, 4,28, 6,16,70,92),
	array(41,41,26,56,83,40,80,70,33),
	array(41,48,72,33,47,32,37,16,94,29),
	array(53,71,44,65,25,43,91,52,97,51,14),
	array(70,11,33,28,77,73,17,78,39,68,17,57),
	array(91,71,52,38,17,14,91,43,58,50,27,29,48),
	array(63,66, 4,68,89,53,67,30,73,16,69,87,40,31),
	array( 4,62,98,27,23, 9,70,98,73,93,38,53,60, 4,23)
);

for ($i=13; $i>=0; $i--) {

	for ($j=0; $j<=$i; $j++) {
	
		//Igalt elemendilt saab liikuda
		//kahele alumisele elemendile.
		//valime suurima nendest teedest.
		
		$alg[$i][$j]+=max($alg[$i+1][$j+1], $alg[$i+1][$j]);
	
	}

}

print "Vastus: " .$alg[0][0] ."\n";

?>