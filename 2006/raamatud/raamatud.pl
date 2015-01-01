#!/usr/bin/perl 

#Perli neljas praktikum
#Raamatute andmebaas
#
#Raivo Laanemets

#Alamprogrammide deklareerimine.
#Niimoodi on mugavam näha, milliseid alamprogramme kasutame.

sub muutujad;
sub get_muutujad;
sub post_muutujad;
sub vaata;
sub loefaili;
sub sorteeri;


#Seda massiivi saab kasutada otsingus ja sorteerimises.
#Kahjuks muudab programmikoodi vähemloetavaks.

@sveerud=("Autori", "Pealkirja", "Kirjastuse linna", "Kirjastuse nime", "Väljaandmise aasta");


#Väljastame http ja html päised.
#http://www.faqs.org/rfcs/rfc1945.html

print "Content-Type: text/html; charset: iso-8859-13\r\n\r\n
<html>
<head><title>Raamatud</title></head>
<body>
<h1>Raamatud</h1>";


#Kõigepealt vajame muutujaid, mille järgi otsustada
#tegevuse üle.

muutujad;


#Kui muutuja tegevus pole seatud, siis vaikimisi
#väärtuseks saab ta valik.

$tegevus=$m{"tegevus"} or $tegevus="valik";


#Veerg, mille järgi sorteerime või otsime, vaikimisi esimene veerg.
	
$veerg=$m{"veerg"} or $veerg=0;


#Anname kasutajale nimekirja tegevustest.

print '<a href="?tegevus=vaata">Vaata</a><br>
<a href="?tegevus=otsi">Otsi</a><br>
<a href="?tegevus=lisa">Lisa</a><hr>';

if ("vaata" eq $tegevus) {
	
	#Loeme sisse faili.
	
	loefaili;
	
	#Võrdlusfunktsioon sorteeri on eraldi kirjeldatud.
	
	@read=sort sorteeri @read;
	
	vaata;

} elsif ("otsi" eq $tegevus) {

	#Näitame kasutajale otsinguvormi.
	
	print '<h2>Otsing</h2><form method="post" action="raamatud.pl">
	<input type="hidden" name="tegevus" value="otsing">
	<label for="sona">Otsingusõna (väiketähtedes)</label>
	<input type="text" name="sona"><br><br>
	<label for="veerg">Mille järgi?</label>
	<select name="veerg">';
	
	for ($i=0; $i<=$#sveerud; $i++) { print '<option value="' .$i .'">' .$sveerud[$i] .'</option>' }
	
	print '</select><br><br><input type="submit" value="Otsi">
	</form>';

} elsif ("otsing" eq $tegevus) {

	#Teostame otsingu ja väjastame tabeli.
	
	print '<h2>Otsingu tulemused</h2>';
	
	loefaili;
	
	#URL encoding/decoding
	#Vaata ka http://www.faqs.org/rfcs/rfc1738.html.
	#Kahtlased märgid asendatakse hendiga %<märgi baidikood>,
	#baidikood on 16-nd ssteemis esitus ascii märkidega kujul 00 kuni FF;
	
	$m{'sona'}=~tr/+/ /;
	$m{'sona'}=~s/%([a-fA-F0-9]{2,2})/chr(hex($1))/eg;
	
	print 'Otsingusõna: ' .$m{'sona'} .'<br><br>
	<table border="1" cellspacing="0"><tr>
	<th>Autor</th>
	<th>Pealkiri</th>
	<th>Kirjastuse linn</th>
	<th>Kirjastuse nimi</th>
	<th>Väljaandmise aasta</th>
	</tr>';
	
	foreach $rida (@read) {
	
		chop $rida;
	
		@valjad=split(/;/, $rida);
		
		#Kontrollime malli järgi, kas antud sõne
		#asub soovitud veerus soovitud real. Mall
		#on siin tõusutundetu. Otsitava alamsõne
		#tõstame esile, tehes selle paksuks.
		
		#Eesti suurte täpitähtede asendamine väikestega.
		#Miskipärast tõusutundetu mallvõrdlus ei töötanud,
		#samuti ei toimi funktsioonid lc() ja uc() täpitähtede korral.
		#Tundub olevat ebaefektiivne meetod, aga
		#praeguse andmekoguse korral ei oma tähtsust.
		
		@valjad[$veerg]=~s/Ü/ü/g;
		@valjad[$veerg]=~s/Ä/ä/g;
		@valjad[$veerg]=~s/Õ/õ/g;
		@valjad[$veerg]=~s/Ö/ö/g;
		
		if (@valjad[$veerg]=~s/($m{'sona'})/<b>\1<\/b>/i) {
		
			print '<tr>';
		
			$c=0;
		
			foreach $vali (@valjad) {
			
				if ($c==$veerg) { print '<td bgcolor="yellow">&nbsp;' .$vali .'</td>' } else { print '<td>&nbsp;' .$vali .'</td>' }
			
				$c++;
		
			}
		
			print '</tr>';
		
		}
	
	}
	
	print '</table>';

} elsif ("lisa" eq $tegevus) {

	#Näitame kasutajale lisamisvormi.
	
	print '<h2>Lisamine</h2>Tühje välju ära jäta.<br><br>
	<form method="post" action="raamatud.pl">
	<input type="hidden" name="tegevus" value="lisamine">
	
	<label for="autor">Autor</label><br>
	<input type="text" name="autor"><br>
	
	<label for="pealkiri">Pealkiri</label><br>
	<input type="text" name="pealkiri"><br>
	
	<label for="linn">Kirjastuse linn</label><br>
	<input type="text" name="linn"><br>
	
	<label for="kirjastus">Kirjastus</label><br>
	<input type="text" name="kirjastus"><br>
	
	<label for="aasta">Aasta</label><br>
	<input type="text" name="aasta"><br><br>
	
	<input type="submit" value="Lisa">
	</form>'

} elsif ("lisamine" eq $tegevus) {

	#Avame faili lisamiseks ja kirjutame
	#uue andmerea selle lõppu.
	
	#Teisendame ja kontrollime muutujaid.
	#Kõigepealt kontrollime.
	
	unless ($m{'autor'} && $m{'pealkiri'} && $m{'linn'} && $m{'kirjastus'} && $m{'aasta'}=~/\d{4,4}/) { print "Sisestasid midagi valesti, palun proovi uuesti."; exit; }
	
	#Liidame üheks sõneks kokku. Failis raamatud.txt on iga rea lõpus ;,
	#paneme siia ka.
	
	$rida=$m{'autor'} .";" .$m{'pealkiri'} .";" .$m{'linn'} .";" .$m{'kirjastus'} .";" .$m{'aasta'} .";\n";
	
	unless (open(FAIL, ">>raamatud.txt")) { print "Faili raamatud.txt ei saa lisamiseks avada!"; die() }
	
	
	#Dekodeerime url kodeeringust tavalisse märgitabelisse.
	#Vaata eespool URL encoding/decoding.
	
	$rida=~tr/+/ /;
	$rida=~s/%([a-fA-F0-9]{2,2})/chr(hex($1))/eg;
	
	#Lõpuks kirjutame faili.
	
	print FAIL $rida;
	
	if (close(FAIL)) { print "Uus kirje raamatute hulka edukalt lisatud." };

}

print "</body>
</html>";

sub sorteeri {

	#Eraldi võrdlusfunktsioon.
	#Võrreldakse ühes reas mingeid välju.
		
	@rida1=split(/;/, $a);
	@rida2=split(/;/, $b);
	return $rida1[$veerg] cmp $rida2[$veerg];

}

sub loefaili {

	#Andmefaili sisselugemine. Tekitatakse
	#massiiv ridadest, mis on stringid (Kuhu jäid Perlis mitmemõõtmelised massiivid?).
	
	open(DB, "<raamatud.txt") or die("Faili raamatud.txt ei saa lugemiseks avada.");
	
	@read=<DB>;
	
	close(DB);

}

sub vaata {

	#Andmemassiivi @read väljastamine.
	
	print '<h2>Kõik raamatud</2>
	<form method="get" action="raamatud.pl">
	<input type="hidden" name="tegevus" value="vaata">
	<label for="veerg">Sorteeri</label>
	<select name="veerg">';
	
	#Valikukastis näitame valikut, mille kasutaja viimati sooritas.
	
	for ($i=0; $i<=$#sveerud; $i++) {
	
		print '<option value="' .$i .'"';
		if ($i==$veerg) { print ' selected="selected">' } else { print '>' }
		print $sveerud[$i] .' järgi</option>';
	
	}
	
	print '</select>
	&nbsp;&nbsp;<input type="submit" value="Sorteeri">
	</form>
	<table border="1" cellspacing="0"><tr>
	<th>Autor</th>
	<th>Pealkiri</th>
	<th>Kirjastuse linn</th>
	<th>Kirjastuse nimi</th>
	<th>Väljaandmise aasta</th>
	</tr>';
	
	foreach $rida (@read) {
	
		#Miskipärast on rea lõpus eraldi ;, siin eemaldame selle.
	
		chop($rida);
		
		@valjad=split(/;/, $rida);
	
		print '<tr>';
		
		$c=0;
		
		foreach $vali (@valjad) {
			
			if ($c==$veerg) { print '<td bgcolor="yellow">&nbsp;' .$vali .'</td>' } else { print '<td>&nbsp;' .$vali .'</td>' }
			
			$c++;
		
		}
		
		print '</tr>';
	
	}
	
	print '</table>';
	
}

sub muutujad {

	#Programmile väljaspoolt saadetud muutujate
	#äratundmine. Siin kontrollime, millisel
	#viisil on muutujad seedetud.
	
	if ("POST" eq $ENV{"REQUEST_METHOD"}) {
		post_muutujad;
	} else {
		get_muutujad;
	}

}

sub get_muutujad {

	#GET muutujaid ja väärtusi sisaldava sõne saamine.
	#Lahendame GET muutujad ja
	#salvestame nad paisktabelisse.
	#Teine võimalus oleks lihtsalt CGI moodulit kasutada.

	@muutujad=split(/&/, $ENV{"QUERY_STRING"});
	
	foreach $s (@muutujad) {
	
		($nimi, $vaartus)=split(/=/, $s);
		
		$m{$nimi}=$vaartus;

	}
	
}

sub post_muutujad {
	
	#POST meetodil saadetud muutujate vastuvõtmine
	#ja lahendamine.
	
	read(STDIN, $str, $ENV{"CONTENT_LENGTH"});
	
	@muutujad=split(/&/, $str);
	
	foreach $s (@muutujad) {
	
		($nimi, $vaartus)=split(/=/, $s);
		
		$m{$nimi}=$vaartus;

	}

}