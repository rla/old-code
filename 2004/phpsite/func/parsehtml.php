<?php

/*
HTML Parser
Raivo Laanemets 2004
*/

include_once('conf/parsehtml.php');

function ParseTag($tag, $reanum, &$offset, $fp) {

	global $html_tags;
    global $html_conf;

	//täägid, mille korral treppingut ei kasutata
    $notrepp=array('META', 'A', 'LINK', 'IMG', 'BR', 'HTML', 'BODY');
    $aste="";

	$tagf=false;
    $buf='';
    $tagname='';
    $props=array();
    $seade=false;
    $propname='';
    $valstart=false;
    $startag=false;
    $endtag=false;

    for($i=0; $i<strlen($tag); $i++) {
    	$ch=$tag{$i};

        if ($ch==" " && $i==0) {
        	print 'TÄÄGI NIME VIGA REAL ' .$reanum .'.<br>';
            print $tag; return;

        //täägi nime saamine
        } else if (($ch==" " || $ch=="\t" || $ch=="\n") && !$tagf) {
        	$tagname=strtoupper(trim($buf));
            if ($tagname=='') {
            	'TÄÄGI NIME VIGA REAL ' .$reanum .'.<br>';
            } else {

            }
            $tagf=true;
            $buf='';
            $ch='';

        //ehk leitud seade nimi
        } else if ($ch=="=" && $tagf && !$seade) {
        	$propname=trim($buf);
            if ($propname=='') {
            	print 'PROBLEEM TÄÄGI SEADEGA REAL ' .$reanum .'<br>';
            } else {
            	$seade=true;

            }
            $valstart=false;
            $ch='';
            $buf='';
            $starttag=true;
        //seade väärtuse algus
        } else if ($ch=='"' && $seade && !$valstart) {
        	$valstart=true;
            $ch='';
        //seade väärtuse lõpp
        } else if ($ch=='"' && $seade && $valstart) {
        	$valstart=false;
            $props[strtoupper($propname)]=trim($buf);
            $seade=false;
            $ch='';
            $buf='';
        //ilma seadeteta või sulgev tääg
        } else if ($i==(strlen($tag)-1) && !$tagf) {
            if ($tag{0}=='/') {
                $tagname=strtoupper(substr($tag, 1));
                $endtag=true;
            } else {
            	$starttag=true;
                $tagname=strtoupper($tag);
            }

        }
        $buf.=$ch;
    }
    //trepping

    if (!in_array($tagname, $notrepp)) {

    	if ($starttag) {
        	$offset.=$aste;
            print $offset .'<' .strtoupper($tagname);
        } else if ($endtag) {
            print $offset .'</' .strtoupper($tagname);
        	$offset=substr($offset, 0,  strlen($offset)-strlen($aste));
        } else print $offset .'<' .strtoupper($tag);

	} else if ($endtag) {
    	print $offset .'</' .strtoupper($tagname);
	} else print $offset .'<' .strtoupper($tagname);

    //täägi nime kontrollimine

	if ($html_conf['log']) {
    	if ($html_conf['check_inv_tags'] && !in_array($tagname, $html_tags)) fwrite($fp, date($html_conf['log_date']) .' unknown tag(' .$tagname .') on line ' .$reanum .'<br>' ."\n");
    }

    //callback funktsioonide süsteem

    switch($tagname) {
    	case 'A':
        	if($starttag) HtmlLink($props);
        break;
    }

   	foreach($props as $key => $value) {
    	print ' ' .$key .'="' .$value .'"';
   	}
}

function ParseHTML(&$html) {
	global $html_conf;
    global $html_inv_char;

	if ($html_conf['log']) {
    	$fp=fopen($html_conf['logfile'], 'a');
        flock($fp, 2);
    }

	$body=false; //parsimine jõudnud kehani?

    $reanum=1;
    $buf=''; //bufferisse lisatakse parasjagu töödeldava täägi sisu
    $tagstart=false; //märgitakse, kas on jõutu täägi alguseni
    $outbuf=''; //otse välja kirjutatav(täägide vaheline tekst)
    $offset=''; //trepping

    for($i=0; $i<strlen($html); $i++) {
    	$ch=$html{$i}; //võtame ette järjekordse tähe

        //kui täht on \n, siis suurendame rea numbrit ühe võrra
        if($ch=="\n") $reanum++;

        //reeglid sisu lahendamiseks

		//TÄÄGI ALGUS
        if($ch=='<') {
            //Väljutame puhvri sisu ja nullime selle
            //puhvris peaks olema
            //$outbuf=trim($outbuf);
            print $offset .$outbuf;
            //print "<";
            $outbuf='';
            $buf='';

            //Kui tääg oli varem alanud, siis
            //on ilmselegelt tegemist veaga
        	if($tagstart) {
            	if ($html_conf['log']) fwrite($fp, date($html_conf['log_date']) .' missing > from line ' .$reanum ."\n"); //>
            }
            //lipp tagstart seatakse tõeseks
            $tagstart=true;

        //TÄÄGI LÕPP
        } else if ($ch=='>') {

        	//tegemist peaks olema täägi lõpuga, kui
            //täägi algust pole seatud, siis on tegemist
            //veaga
            if(!$tagstart) {
            	if ($html_conf['log']) fwrite($fp, date($html_conf['log_date']) .' missing < from line ' .$reanum ."\n"); //<
            }

            //lipp tagstart seatakse vääraks
            $tagstart=false;

            //töötleme täägi sisu
            ParseTag($buf, $reanum, $offset, $fp);
            print ">";
            //puhastame puhvri
            $buf='';
            //täägi äratundmist määrav lipp vääraks
            $tag=false;
        }

        //tähe lisamine buhvrisse(ei lisata \n , \r ja \t jm)
        if($ch!="<" && $ch!=">" && !$tagstart && !in_array($ch, $html_inv_char)) $outbuf.=$ch;
        if($ch!="\n" && $ch!="\r" && $ch!="\t" && $ch!="<" && $ch!=">") $buf.=$ch;


    }
    if ($html_conf['log']) fclose($fp);
}

?>