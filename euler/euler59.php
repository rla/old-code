Problem 59

Each character on a computer is assigned a unique code
and the preferred standard is ASCII (American Standard Code for Information Interchange). 
For example, uppercase A = 65, asterisk (*) = 42, and lowercase k = 107.

A modern encryption method is to take a text file,
convert the bytes to ASCII, then XOR each byte with a given value,
taken from a secret key. The advantage with the XOR function is
that using the same encryption key on the cipher text,
restores the plain text; for example, 65 XOR 42 = 107, then 107 XOR 42 = 65.

For unbreakable encryption, the key is the same
length as the plain text message, and the key is made up of random bytes.
The user would keep the encrypted message and the encryption
key in different locations, and without both "halves",
it is impossible to decrypt the message.


Unfortunately, this method is impractical for most users,
so the modified method is to use a password as a key.
If the password is shorter than the message,
which is likely, the key is repeated cyclically
throughout the message. The balance for this method
is using a sufficiently long password key for security,
but short enough to be memorable.


Your task has been made easy, as the encryption key consists of
three lower case characters. Using cipher1.txt (right click and 'Save Target As...'),
a file containing the encrypted ASCII codes, and the knowledge that
the plain text must contain common English words,
decrypt the message and find the sum of the ASCII values
in the original text.

Lahendus: Raivo Laanemets rl@starline.ee
Parool sisaldab kolme väikest tähte inglise tähestikust. Järelikult
on parooli valikuks 26^3 võimalust. Eeldame et tekst sisaldab sõna
'about', leiame parooli, mille korral selline täheühend välja tuleb.

Antud lahenduse saaks realiseerida keeles C palju ratsionaalsemalt.

Ingliskeelsete populaarseimate sõnade loend:
http://www.paulnoll.com/China/Teach/words-01-02-hundred.html

<?php

//Inglise tähestik.
$tah=array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
//Baitidena
for ($i=0; $i<26; $i++) $asc[$i]=ord($tah[$i]);

//Loeme sisse faili
$fp=fopen("cipher1.txt", "r");
$baidid=explode(",", fgets($fp));
fclose($fp);

for ($i=0; $i<26; $i++) for ($j=0; $j<26; $j++) for ($k=0; $k<26; $k++) {

	$dec="";
	$sum=0;
	$m=0;
	$pass=array($asc[$i], $asc[$j], $asc[$k]);
	
	//Dekrüpeerime teate, arvutame summa.
	for ($l=0; $l<count($baidid); $l++) {
		$xor=$pass[$m]^$baidid[$l];
		$dec.=chr($xor);
		$sum+=$xor;
		$m++;
		if ($m==3) $m=0;
	}
	
	//Vaatame, kas dekrüpteeritud tekst sisaldab sõna 'about'.
	if (strstr($dec, "about")) die($dec ."-" .chr($i) .chr($j) .chr($k) ." " .$sum ."\n");
	print $i ." " .$j ." " .$k ."\n";

}

print "Lõpp\n";

?>