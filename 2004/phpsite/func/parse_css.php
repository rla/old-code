<?php

/*
Lihtne CSS parser.
Raivo Laanemets 2004
*/

function ParseCss($filename, &$content) {
	if (!file_exists($filename)) return false;
	$fp=fopen($filename, 'r');
    $ch='';
    $buf='';
    $classname='';
    $varname='';
    $isvar=false;
    $isclass=false;
    while(!feof($fp)) {
    	$ch=fread($fp, 1);
    	if ($ch!="\n" && $ch!="\r") $buf.=$ch;

        //klassi algus
        if ($ch=='{') {
        	$classname=trim(substr($buf, 0, strlen($buf)-1));
            //array_push($content, $classname);
            $buf='';
            $isvar=false;
            $isclass=true;
        }

        //muutuja nime lõpp
        elseif ($ch==':' && $isclass) {
        	$varname=trim(substr($buf, 0, strlen($buf)-1));
            $buf='';
            $isvar=true;
        }

        //muutuja-väärtuse paari lõpp
        elseif ($ch==';') {
        	$buf=trim($buf);
        	$content[$classname][$varname]=trim(substr($buf, 0, strlen($buf)-1));
        	$buf='';
            $isvar=false;
        }

        //klassi lõpp
        elseif ($ch=='}') {
        	//viimane muutuja-väärtuse paar ei pruugi lõppeda ';'-ga
        	if ($isvar) {
            	$content[$classname][$varname]=trim(substr($buf, 0, strlen($buf)-1));
            }
            $classname='';
        	$buf='';
            $isvar=false;
            $isclass=false;
        }
    }
    fclose($fp);
    return true;
}

?>