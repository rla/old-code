#!/usr/bin/perl

#100! numbrite summa leidmine
#Raivo Laanemets

#korrutise algväärtus

$korrutis[0]=1;

for ($i=0; $i<10; $i++) {

	for ($j=0; $j<10; $j++) {
	
		$arv[0]=$j;
		$arv[1]=$i;
		
		if ($j == 0) {
		
			#10, 20, .., 90
			#teisendatakse 10->01, 20->02 jne.
			
			#$arv[0]=$i;
			#$arv[1]=0;
			
			#00->01
			
			if ($i == 0) { $arv[0]=1 }
			
			
		}
		
		#print $arv[1] .$arv[0] ."\n";
		
		#korrutame
		
		#ületäitumist näitav muutuja
		
		$l=0;
		
		#korrutises konkreetsel kohal olev number
		
		$num=0;
			
		#m-korrutise numbrite arv
		
		$m=$#korrutis +1;
		
		#teeme korrutisest ühe koopia kümnelisega korrutamise jaoks
		
		for ($k=0; $k<$m; $k++) { $temp[$k]=$korrutis[$k] }
		
		#ühelisega korrutamine
		
		for ($k=0; $k<$m; $k++) {
			
			$acc=$korrutis[$k]*$arv[0]+$l;
			$num=$acc%10;
			$l=int($acc/10);
			$korrutis[$k]=$num;
				
		}
			
		if ($l) { $korrutis[$k]=$l; $l=0 }
		
		#kümnelisega korrutamine
		
		$m=$#temp +1;
		
		for ($k=0; $k<$m; $k++) {
			
			$acc=$temp[$k]*$arv[1]+$l;
			$num=$acc%10;
			$l=int($acc/10);
			$temp[$k]=$num;
				
		}
		
		if ($l) { $temp[$k]=$l; $l=0 }
		
		#summeerime korrutised arvestades, et kümnelised peavad saama
		#nihutatud 1 koht vasakule
		
		if ($#korrutis>1+$#temp) { $n=$#korrutis } else { $n=$#temp+1 }
		
		for ($k=1; $k<=$n; $k++) {
		
			$acc=$korrutis[$k]+$temp[$k-1]+$l;
			$num=$acc%10;
			$l=int($acc/10);
			$korrutis[$k]=$num;
			
		}
		
		if ($l) { $korrutis[$k]=$l }
		
		#kontrolliks väljastame osakorrutise
		
		#print "\nkorrutis=";
		
		#$m=$#korrutis +1;
		#for ($k=0; $k<$m; $k++) { print $korrutis[$k] }
		
		#print "\n";
		
	}
	
}

#leiame numbrite summa

$sum=0;

$m=$#korrutis +1;

for ($k=0; $k<$m; $k++) { $sum+=$korrutis[$k] }

print $sum ."\n";