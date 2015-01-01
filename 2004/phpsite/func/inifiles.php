<?php

/*
inifiles.php - windowsi stiilis
konfiguratsioonifailide lugeja.

Raivo Laanemets 2004

$myini=new CIniFile('test.ini');
$myini->ReadFile();
$myvar=$myini->GetValue('section', 'variable', 'default'='');
$myini->SetValue('section', 'variable', 'value');
$myini->WriteFile();
$myini->Close();
*/

//funktsioonid ilma klassita
function FIniFile($filename) {
	if (file_exists($filename)) {
    	$fp=fopen($filename, 'r+');
    } else {
      	$fp=fopen($filename, 'w');
    }
    return $fp;
}

function FIniReadFile($fp, &$contents) {
	$buf='';
    $sect='';
    $varr='';
    $isvar=false;
    $val='';
    while(!feof($fp)) {
    	$ch=fread($fp, 1);
        if ($ch!=chr(10) and $ch!=chr(13) and $ch!=chr(9)) $buf.=$ch;
        //sektsiooni eraldaja
        if ($ch==']') {
        	$sect=substr($buf, 1, strlen($buf)-2);
            $buf='';
            $isvar=false;
        //muutuja ja väärtuse eraldaja
        } else if ($ch=='=') {
        	$varr=substr($buf, 0, strlen($buf)-1);
            $isvar=true;
            $buf='';
        //muutuja lõpp
        } else if ($ch==chr(10) and $isvar) {
        	$contents[$sect][$varr]=$buf;
            $buf='';
            $isvar=false;
        }
    }
    //faililõpu kontroll
    if ($isvar) $contents[$sect][$varr]=$buf;
    return true;
}

function FIniGetValue(&$contents, $section, $variable, $def='') {
	$tmp=$contents[$section][$variable];
    if ($tmp=='') return $def; else return $tmp;
}

function FIniSetValue(&$contents, $section, $variable, $value) {
	$contents[$section][$variable]=$value;
}

function FIniWriteFile($fp, &$contents) {
	fseek($fp, 0);
    ftruncate($fp, 0);
    foreach($contents as $key => $value) {
    	fwrite($fp, '[' .$key .']' ."\n");
        foreach ($value as $subkey => $subvalue) {
        	fwrite($fp, $subkey .'=' .$subvalue ."\n");
        }
    }
}

?>