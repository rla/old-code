<?php

/*
Administreerimisliidesele vajalikud funktsioonid.
Raivo Laanemets 2004

Versioon 0.06
Funktsioon ReadTemplateVars
--end
*/

//templeidi muutujate lugemine
function ReadTemplateVars($filename, &$vars) {
	$ftempl=fopen($filename, 'r');
    $buffer='';
    $ch='';
    $last_ch='';
    $code='';
    $vars=array();
	while(!feof($ftempl)) {
    	$ch=fread($ftempl, 1);
		if (($ch=='%') and ($last_ch=='{')) {
			$buffer=substr($buffer, 0, strlen($buffer)-1);
        	$buffer=''; //muutuja algus, tühjendatakse buffer.
        }
        if (($ch=='}') and ($last_ch=='%')) {
        	$buffer=substr($buffer, 1, strlen($buffer)-2);
            array_push($vars, $buffer);
        	$buffer='';
            $ch='';
        }
        $buffer.=$ch;
        $last_ch=$ch;
    }
    fclose($ftempl);
}

//seadistuse muutmine
function WriteSetting($varname, $value) {
	global $objects_db;
    global $objects_data_tbl;
    $sql="UPDATE " .$objects_data_tbl ." SET value='" .$value ."' WHERE object_id=9999 AND varname='" .$varname ."'";
    if(mysql_query($sql, $objects_db)): return true;
    else:
        print mysql_error($objects_db);
        return false;
    endif;
}

//faili toomine ekraanile
//eemaldab /r ja konverdib teatud märgid
//html asenduskoodi
function ShowFile($filename) {
	$fp=fopen($filename, 'r');
    $content=fread($fp, filesize($filename));
    fclose($fp);
    print htmlentities(str_replace("\r", "", $content));
    return true;
}

//lihtne funktsioon, mis näitab,
//kas töö õnnestus, vt. ka järgmist.
function TaskOk($msg) {
	print '[<font color="green">+</font>] ' .$msg .'<br>';
}

function TaskFailed($msg) {
	print '[<font color="red">-</font>] ' .$msg .'<br>';
}

//loodud saitide nimede ja kaustade saamine.
function GetSites(&$sites) {
	global $objects_db;
    $sql="SELECT * FROM admin_sites";
    $res=mysql_query($sql, $objects_db);
    while($result=mysql_fetch_row($res)) {
    	$sites[$result[1]]=$result[2];
    }
}

//saidi nime saamine tema kausta järgi
function GetSiteNameByPath($path) {
	global $objects_db;
    $sql="SELECT name FROM admin_sites WHERE path='" .$path ."'";
    $res=mysql_query($sql, $objects_db);
    if($result=mysql_fetch_row($res)): return $result[0];
    else: return false;
    endif;
}

?>