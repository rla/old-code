<?php

/*
Raivo Laanemets 2004
Funktsioonid
*/

/*NB! Alates versioonist 0.02 on objektifailidel
teistsugune formaat.
muudetud /content kausta sisu:
scriptid asuvad /content/php
html /content/html
text /content/text

lisatud templeitide loomise ja muutmise võimalus
--end

Versioon 0.03:
toetus vanadele objektifailidele puudub.
objekti konfi lisatud muutuja data, mis
tähistab templeidi andmefaili.
uus objektitüüp js ehk javaskript.
--end

Versioon 0.04:
lisatud funktsioon SetTitle($new_one).
--end

Versioon 0.05:
Objektide info andmebaasist.
Templeidid kaustas content/temps.
Pildid kaustas content/pics.
Keele seade html objektidele.
--end

Versioon 0.06
Vaikimisi pealkirja seadmine.
Templeiti toodud funktsioonid.
--end

Versioon 0.08
Objektide html outputi kontrollimine
--end

Kõiki objekte kirjeldav üldised andmed asuvad
ühes suures globaalfailis conf/objektid.ini.
Fail on tavalises windowsi inifaili formaadis.
Objekti nimi ei või sisaldada tühikui ja erimärke (k.a [ ja ])

Objeti parameetrid:

type - võib olla exec, text, html, thtml.
	exec - objekt sisaldab scripti (php koodi).
    text - tavaline tekst (lisatakse <pre></pre> täägid).
    html - html või formaatimatta tekst.
    thtml - templeiditud html, võib sisaldada alamobjekte.
    xsl - xml'l põhinev objekt.

temp - templeidi nimi. Vajalik ainult siis,
kui objekti tüüp on thtml.

data - templeidi andmefaili nimi, Vajalik ainult siis,
kui objekti tüüp on thtml.

Kuna ükski parameeter ei väljenda, millises keeles
Infot objekt väljastab, on jäetud mitmekeelesüsteem
kasutaja mureks.

Näidis
...
[kuupaev]
type=exec

[header]
type=thtml
temp=header

[footer]
type=html
...

*/

//Funktsioon lehekülje pealkirja seadmiseks.
function SetTitle($new_one) {
	global $title;
    $title=$new_one;
}

//spec. admin süsteemis ja muude
//seadistuste lugemiseks sisu tabelist.
function ReadSetting($varname) {
	global $objects_db;
    global $objects_data_tbl;
    $sql="SELECT * FROM " .$objects_data_tbl ." WHERE object_id='9999' AND varname='" .$varname ."'";
    $res=mysql_query($sql, $objects_db);
    if(!$res) return false;
    if ($result=mysql_fetch_row($res)): return $result[3];
    else: return false;
    endif;
}

//sama funktsioon, mis üleval, kuid loeb
//muutuja välisbaasist (mitte-kodubaasist).
function ReadSettingOutside($varname, $table, $db) {
	$sql="SELECT * FROM " .$table ." WHERE object_id='9999' AND varname='" .$varname ."'";
    $res=mysql_query($sql, $db);
    if ($result=mysql_fetch_row($res)): return $result[3];
    else: return false;
    endif;
}

//andmebaasist info saamine, tagastab
//massiiivi, ebaõnnestumise korral false.
function QueryDBObject($object_name) {
	global $objects_db;
    global $objects_table;
    $sql="SELECT * FROM " .$objects_table ." WHERE name='" .$object_name ."'";
    $res=mysql_query($sql, $objects_db);
    if($result=mysql_fetch_row($res)):
    	$object_data['name']=$result[1];
        $object_data['template']=$result[2];
        $object_data['type']=$result[3];
        $object_data['title']=$result[4];
        $object_data['object_id']=$result[5];
        return $object_data;
    else: return false;
    endif;
}

//andmebaasist objecti sisu saamine (thtml).
function QueryObjectData($object_id, $lang, &$data_array) {
	global $objects_db;
    global $objects_data_tbl;
    $sql="SELECT * FROM " .$objects_data_tbl ." WHERE object_id='" .$object_id ."' AND lang='" .$lang ."'";
    $res=mysql_query($sql, $objects_db);
    while($result=mysql_fetch_row($res)) {
    	$data_array[$result[2]]=$result[3];
    }
}

//objekti andmete sisu sidumine
//templeidiga, kus $object_id on objekti id,
//$lang keel ja $tpl templeidi nimi.
function ParseObject($object_id, $LANG, $tpl) {
	//Küsime objekti sisu.
    QueryObjectData($object_id, $LANG, $ob_data);

    //avame objektiga seotud templeidi
    $fname='content/temps/' .$tpl .'.tpl';
    if (file_exists($fname)): $ftempl=fopen($fname, 'r');
    else:
    	print '<div class="err">VIGA: PUUDUB TEMPLEIT (' .$fname .')!</div>';
        return;
    endif;

    $buffer='';
    $ch='';
    $last_ch='';
    $code='';
	while(!feof($ftempl)) {
    	$ch=fread($ftempl, 1);
		if (($ch=='%') and ($last_ch=='{')) {
			$buffer=substr($buffer, 0, strlen($buffer)-1);
        	print $buffer;
        	$buffer=''; //muutuja algus, tühjendatakse buffer.
        }
        if (($ch=='}') and ($last_ch=='%')) {
        	$buffer=substr($buffer, 1, strlen($buffer)-2);
            if ($buffer{0}==':') {
            	Object(substr($buffer, 1), $LANG);
            }
            //funktsioonide tugi
            else if ($buffer{0}=='=') {

            //'tavaline' objekt
            } else {
              	if ($buffer=='@@') { Object($_GET['id'], $LANG); } //sisuobjecti kutsumine
            	else {
                    $parpos=strpos($buffer, '(');
                    $def='';
                    if ($parpos!=0) {
                		$def=substr($buffer, $parpos+1, strlen($buffer)-$parpos-2);
                    	$buffer=substr($buffer, 0, $parpos);
                    }
                	$tmp=$ob_data[$buffer];
                    if (strlen($tmp)==0): print $def;
                    else:
                    	//sisaldab php koodi
                    	if ($tmp{0}=='%'): eval(substr($tmp, 1));
                    	else: print $tmp;
                        endif;
                    endif;
                }
            }
        	$buffer='';
            $ch='';
        }
        $buffer.=$ch;
        $last_ch=$ch;
    }
    print $buffer;
    fclose($ftempl);
}

function Object($object_name, $LANG) {

    $object_conf=QueryDBObject($object_name);

    if (!$object_conf):
    	print 'FATAALNE VIGA (' .$object_name .',' .$LANG .')!';
        return;
    endif;

    //vaikimisi lehekülje pealkirja seadmine
    if($object_conf['title']!='') SetTitle($object_conf['title']);

    //sõltuvalt objekti tüübist tehakse järgnevad toimingud:
    switch($object_conf['type']) {
    case 'html':
    	//keele toetus

    	$fname='content/html/'.$LANG .'.' .$object_name .'.html';
        if (file_exists($fname)): include($fname);


        else: print 'PUUDUB HTML OBJEKT (' .$fname .')!';
        endif;
    break;
    case 'thtml':
    	ParseObject($object_conf['object_id'], $LANG, $object_conf['template']);
    break;
    case 'php':
        $fname='content/php/' .$object_name .'.php';
    	if (file_exists($fname)): include($fname);
        else: print 'PUUDUB PHP OBJEKT (' .$fname .')!';
        endif;
    break;
    case 'js':
    	$fname='content/js/' .$object_name .'.js';
        if (file_exists($fname)): include($fname);
        else: print 'PUUDUB JS OBJEKT (' .$fname .')!';
        endif;
    break;
    case 'text':
    	$fname='content/text/' .$object_name .'.txt';
        if (file_exists($fname)):
        	print '<pre>';
        	include($fname);
            print '</pre>';
        else: print 'PUUDUB TEXT OBJEKT (' .$fname .')!';
        endif;
    break;
    default:
        //antud viga esineb juhul, kui objekti
        //kirjeldus puudub failist conf/objects.ini
    	print 'TUNDMATU OBJEKT (' .$object_name .')!';
    break;
    }
}

//salvestab lehe sisu faili
function CacheOutput() {
	global $cache_file_name;
    global $html;
    $html=ob_get_contents();
    $fp=fopen($cache_file_name, 'w');
    fwrite($fp, $html, strlen($html));
    fclose($fp);
}

function CheckDataUpdate($lang, $iid) {
	if (filemtime('cache/p_' .$iid .'_' .$lang .'.php')<filemtime('content/p_' .$iid .'.php')) return false;
    else return true;
}

//objekti failinime moodustamine
function MakeFilePath($lang, $id) {
	$path='p_' .$id;
    return $path;
}

//Funktsioon kontrollib, kas soovitav lehekülg on vahekaustas.
function CheckCache($page, $lang, $iid) {
	if (file_exists('cache/' .MakeFilePath($lang, $iid))) return true;
    else return false;
}

?>