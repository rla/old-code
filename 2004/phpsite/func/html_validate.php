<?php

/*
HTML Parser
Raivo Laanemets 2004
*/

//include_once('conf/parsehtml.php');

global $html_start_tags;
global $html_end_tags;

    $html_start_tags=array('HTML', '!DOCTYPE', 'HEAD', 'TITLE', 'BODY', 'LINK', 'META', 'STYLE',
	'SCRIPT', 'DIV', 'SPAN', 'TABLE', 'TH', 'TR', 'TD', 'INPUT', 'FORM', 'P', 'BR',
	'A', 'IMG', 'B', 'STRONG', 'OPTION', 'SELECT', 'TEXTAREA', 'H1', 'H2', 'H3', 'H4',
	'H5', 'H6', 'H7', 'APPLET', 'U', 'I', 'CENTER', 'ABBR', 'ACRONYM', 'ADDRESS',
	'AREA', 'BASE', 'BASEFONT', 'HR');

    $html_end_tags=array('HTML', 'HEAD', 'TITLE', 'BODY', 'STYLE',
	'SCRIPT', 'DIV', 'SPAN', 'TABLE', 'TH', 'TR', 'TD', 'FORM', 'P',
	'A', 'B', 'OPTION', 'SELECT', 'TEXTAREA', 'H1', 'H2', 'H3', 'H4',
	'H5', 'H6', 'H7', 'U', 'I', 'CENTER', 'ABBR', 'ACRONYM', 'ADDRESS',
	'AREA', 'BASE', 'BASEFONT');

function ValidateHtmlTag($tag, $reanum) {

   	global $html_start_tags;
	global $html_end_tags;

	/*
    täägi eeltöötlus,
    asendame teatud märgid eraldajaga
    */
    $separator=" ";
    $repl=array("\n", "\t", "\r");
    for($i=0; $i<strlen($tag); $i++) {
    	if(in_array($tag{$i}, $repl)) $tag{$i}=$sep;
    }

    /*
    täägi parsimisel eraldatud osad
    */
    $tokens=array();

	$tagname_found=false; //täägi nimi leitud või ei?

    $equatation=false; //atribuudi väärtustamine?

    $attribute_value_start=false; //atribuuti väärtus

    $quote_start=false; //delimiitori kasutamine?

    $d_quote_count=0; //iga attribuudi väärtusel peab olema paarisarv " või '
    $s_quote_count=0;
    $quote_count=0;
    $quote_start='';

    /*
    tokeniseerimine
    */
    for($i=0; $i<strlen($tag); $i++) {
    	$ch=$tag{$i};

        if($ch==$separator) {
        	if(!$tagname_found) {
            	if($buffer!='') {
                	$tagname_found=true;
                	$tagname=$buffer;
                	$buffer='';
                }
            } else {
            	if($equatation) {
                	if(trim($buffer)!='') {
                    	if($quote_count==0) {
                        	array_push($tokens, $buffer);
                        	$buffer='';
                        	$equatation=false;
                        }
                    }
                }
            }
        } else if ($ch=='=') {
        	if(!$equatation) {
            	if($buffer!='') {
                	array_push($tokens, $buffer);
                	$equatation=true;
                    $buffer='';
                }
            }
        } else if ($ch=='"') {
        	if($equatation) {
            	if (trim(substr($buffer,1))!='' && $quote_count==0) {
                	print 'Atribuudi viga real ' .$reanum .'<br>';
                    return;
                }

				$d_quote_count++;
                $quote_count++;

                if($quote_count==1) $quote_start='"';

                if($d_quote_count==2 && $quote_start=='"') {
                	$equatation=false;
                    array_push($tokens, $buffer);
                    $buffer='';
                    $quote_count=0;
                    $s_quote_count=0;
                    $d_quote_count=0;
                }
            } else {
            	print 'Arusaamatu märk täägis real ' .$reanum .' kohal ' .$i .'<br>';
                return;
            }
        } else if ($ch=="'") {

        	if($equatation) {
            	$s_quote_count++;
                $quote_count++;

                if($quote_count==1) $quote_start="'";

                if($s_quote_count==2 && $quote_start=="'") {
                	$equatation=false;
                    array_push($tokens, $buffer);
                    $buffer='';
                    $quote_count=0;
                    $s_quote_count=0;
                    $d_quote_count=0;
                }
            } else {
            	print 'Arusaamatu märk täägis real ' .$reanum .' kohal ' .$i .'<br>';
            }
        }

        if($ch!='"') $buffer.=$ch;
    }

    if($equatation) {
        if($quote_count!=0) {
        	print 'Atribuudi error real ' .$reanum;
            return;
        } else {
        	array_push($tokens, $buffer);
        }
    } else if($quote_count!=0) {
    	print 'Atribuudi error real ' .$reanum;
    }

    if(!$tagname_found) $tagname=$tag;

    $endtag=false;
    if($tag{0}=='/') {
    	$tagname=strtoupper(substr($tagname, 1));
        $endtag=true;
    } else {
    	$tagname=strtoupper($tagname);
    }

    if(!$endtag) {
    	if(!in_array($tagname, $html_start_tags)) {
        	print 'Tundmatu tääginimi (' .$tagname .') real' .$reanum .'<br>';
            return;
        }
    } else {
    	if(!in_array($tagname, $html_end_tags)) {
        	print 'Täägi nimi (' .$tagname .') pole õige või ei saa olla sulgev tääg real ' .$reanum .'<br>';
            return;
        }
    }

    $checktag=$tagname;

   	foreach($tokens as $value) {
    	if($value{0}=='=') $checktag.='"' .substr($value, 1) .'"';
        else $checktag.=' ' .$value .'=';
   	}

    $error_amount=levenshtein(strtoupper(substr($checktag, 0, 254)), strtoupper(substr($tag, 0, 254))) .'<br>';
    if($error_amount>10) {
    	print 'Vigane tääg real ' .$reanum .'<br>
        originaal:<br>';
        print strtoupper($tag) .'<br><br>
        taastekitatud:<br>';
        print strtoupper($checktag) .'<br>---------------<br>';
        return;
    }
}

function ValidateHTML($filename) {

	print 'HTML TESTI ALGUS<br>';

    $html=file_get_contents($filename);

    $reanum=1;
    $buf=''; //bufferisse lisatakse parasjagu töödeldava täägi sisu
    $tagstart=false; //märgitakse, kas on jõutu täägi alguseni

    for($i=0; $i<strlen($html); $i++) {
    	$ch=$html{$i}; //võtame ette järjekordse tähe

        if($ch=="\n") $reanum++;

		//TÄÄGI ALGUS
        if($ch=='<') {

            $buf='';

            //Kui tääg oli varem alanud, siis
            //on ilmselgelt tegemist veaga
        	if($tagstart) {
            	print 'Puuduv &#62; real ' .$reanum ."\n"; //>
            }
            //lipp tagstart seatakse tõeseks
            $tagstart=true;

        //TÄÄGI LÕPP
        } else if ($ch=='>') {

        	//tegemist peaks olema täägi lõpuga, kui
            //täägi algust pole seatud, siis on tegemist
            //veaga
            if(!$tagstart) {
            	print 'Puuduv &#60; real ' .$reanum ."\n"; //<
            }

            //lipp tagstart seatakse vääraks
            $tagstart=false;

            //töötleme täägi sisu
            ValidateHtmlTag($buf, $reanum);

            //puhastame puhvri
            $buf='';
        }

        if($ch!="\n" && $ch!="\r" && $ch!="\t" && $ch!="<" && $ch!=">") $buf.=$ch;
    }

    print 'HTML TESTI LÕPP';

}

?>