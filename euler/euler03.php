<?php

$eps=0.0000001;

mysql_connect("localhost", "root", "xxx") or die(mysql_error());
mysql_select_db("matemaatika");

/*echo "algarvude genereerimine\n".

$n=1;
while($n<317584931803) {
	$n+=2;
	$prime=true;
	
	$res=mysql_query("SELECT x FROM primes WHERE x<=" .floor(sqrt($n)));
	
	while($result=mysql_fetch_row($res)) {
		$x=$n/$result[0];
		if (abs($x-floor($x))<$eps) { $prime=false; break; }
	}	
	
	if ($prime) {
		//echo $n ."\n";
		mysql_query("INSERT INTO primes VALUES (" .$n .")");
	}

}

echo "algarvude genereerimise lõpp\n";
*/


//$arv=317584931803; //NB õige vastus oli 3919
$arv=4740073609;

echo "Arvu " .$arv ." algteguriteks jagamine\n";

$i=2;
while($arv>1) {
	$x=$arv/$i;
	if (abs($x-floor($x))<$eps) {$arv=$arv/$i; echo ":" .$i ." = " .$arv ."\n"; $i=1; }
	$i++;
}

/*
for ($i=2; $i<100000; $i++) {
	$x=$arv/$i;
	if (abs($x-floor($x))<$eps) echo "x=" .$x ." i=" .$i ." x*i=" .($x*$i) ."\n";
	$res=mysql_query("");
}
*/
mysql_close();

echo "Lõpp\n";

?>
