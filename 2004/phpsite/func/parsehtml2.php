<?php

/*
HTML Parser
Raivo Laanemets 2004
*/

function ParseHTML(&$html) {


	$body=false; //parsimine jõudnud kehani?

    $reanum=1;
    $buf=''; //bufferisse lisatakse parasjagu töödeldava täägi sisu
    $tagstart=false; //märgitakse, kas on jõutu täägi alguseni
    $tagname=''; //parasjagu töödeldava täägi nimi
    $tag=false; //näitab, kas tääg on ära tuntud või mitte
    $varname=''; //näitab parasjagu oleva täägi käesolevat muutujat
    $vared=false; //näitab, kas seade nimi on ära tuntud
    $curvars=array(); //töödeldava täägi seaded
    $value=''; //töödeldava täägi seade väärtus
    $valed=false; //näitab, kas leitud väärtus

    for($i=0; $i<strlen($html); $i++) {
    	$ch=$html{$i}; //võtame ette järjekordse tähe

        //kui täht on \n, siis suurendame rea numbrit ühe võrra
        if($ch=="\n") $reanum++;

        //reeglid sisu lahendamiseks

		//TÄÄGI ALGUS
        if($ch=='<') {
            //Väljutame puhvri sisu ja nullime selle
            //puhvris peaks olema
            $buf=trim($buf);
            if ($buf!='') print $buf ."\n";
            print "<";
            $buf='';

            //Kui tääg oli varem alanud, siis
            //on ilmselegelt tegemist veaga
        	if($tagstart) {
            	print 'HTML VIGA REAL ' .$reanum .'. PUUDUB "&#62;"<br>'; //>
            }
            //lipp tagstart seatakse tõeseks
            $tagstart=true;

        //TÄÄGI LÕPP
        } else if ($ch=='>') {

        	//tegemist peaks olema täägi lõpuga, kui
            //täägi algust pole seatud, siis on tegemist
            //veaga
            if(!$tagstart) {
            	print 'HTML VIGA REAL ' .$reanum .'. PUUDUB "&#60"'; //<
            }

            //kui täägi nime pole varem ära tuntud,
            //siis tegemist on ehk üksiktäägiga või
            //lõputäägiga
            if(!$tag) {
            	$tagname=trim($buf);
                $tag=true;
                //Kui üksiktäägi või lõputäägi nimi on tühi,
                //siis on tegemist veaga
                if($tagname=='') print 'PROBLEEM TÄÄGI NIMEGA REAL ' .$reanum .'<br>';
            }
            //lipp tagstart seatakse vääraks
            $tagstart=false;

            //prindime täägi nime
            print strtoupper($tagname) .">\n";
            //puhastame puhvri
            $buf='';
            //täägi äratundmist määrav lipp vääraks
            $tag=false;

        //TÄÄGI SISU KONTROLL (võimalik ka ülemine variant)
        } if ($tagstart) {
        	//leitud täägi osade eraldaja
        	if (($ch==" " || $ch=="\n") && !$tag) {
            	$tagname=trim($buf);

                //kui täägi nimi on tühi, siis on
                //tegemist veaga
                if ($tagname!='') {
                	$tag=true;
                } else {
                	print 'PROBLEEM TÄÄGI NIMEGA REAL ' .$reanum .'<br>';
                }
                //puhastame puhvri
                $buf='';
                $vared=false;

            //kui täägi nimi teada, siis tegemist täägi
            //seadetega või seade väärtusega, = näitab
            //seade nime
            } else if ($tag && $ch=="=" && !$vared) {
            	$varname=trim($buf);

                if ($varname!='') {
                	$vared=true;
                } else {
                	print 'PROBLEEM TÄÄGI SEADEGA REAL ' .$reanum .'<br>';
                }
                $buf=''; $ch='';

            //seade nimi leitud, tegemist arvatavasti
            //seade väärtuse alguse või lõpuga
            } else if ($tag && $vared && ($ch=='"' || $ch=="\n")) {
            	$value=
            }
        }

        //tähe lisamine buhvrisse(ei lisata \n , \r ja \t jm)
        if($ch!="\n" && $ch!="\r" && $ch!="\t" && $ch!="<" && $ch!=">") $buf.=$ch;


    }
}

?>