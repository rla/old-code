<?php

/*
objekt_css.php
Stiilifailide muutmine.
Raivo Laanemets
12. august 2004
*/

function Fix($inp) {
	$outp=str_replace('.', '=*=', $inp);
    $outp=str_replace('_', '==*', $outp);
    return $outp;
}

function ParseCss($text, &$content) {
    $ch='';
    $buf='';
    $classname='';
    $varname='';
    $isvar=false;
    $isclass=false;
    for($i=0; $i<strlen($text); $i++) {
    	$ch=$text{$i};
    	if ($ch!="\n" && $ch!="\r") $buf.=$ch;

        //klassi algus
        if ($ch=='{') {
        	$classname=trim(substr($buf, 0, strlen($buf)-1));
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
        	if ($isvar) $content[$classname][$varname]=trim(substr($buf, 0, strlen($buf)-1));
            if (!is_array($content[$classname])) $content[$classname]='';
            $classname='';
        	$buf='';
            $isvar=false;
            $isclass=false;
        }
    }
    return true;
}?>

<form action="index.php" method="post">
<input name="mis" type="hidden" value="salvesta_css">
<input name="objekt" type="hidden" value="<?php echo $_GET['objekt'] ?>">
<?php
mysql_select_db($_SESSION['saidi_baas']);
$res=mysql_query("SELECT tekst FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_GET['objekt'] ."'");
$result=mysql_fetch_row($res);
$css=array();
ParseCss($result[0], $css);
print '<table>';
foreach($css as $key => $value) {
	print '<tr><td colspan="2" style="background-color: #efefef">&nbsp;<b>' .$key .'</b><td></tr>';
    if (is_array($value)) foreach($value as $subkey => $subvalue) {
    	print '<tr><td>' .$subkey .':</td><td><input type="text" name="' .Fix($key) .'[' .Fix($subkey) .']" value="' .Fix($subvalue) .'"></td></tr>';
    }
    print '<tr><td><input type="text" name="' .Fix($key) .'[_new__var_]" value="">:</td><td><input type="text" name="' .Fix($key) .'[_new__value_]" value=""></td></tr>';
}
print '</table>';

?>
<input type="submit" value="Salvesta">
</form>

<form action="index.php" method="post">
<input name="mis" type="hidden" value="lisa_klass">
<input name="objekt" type="hidden" value="<?php echo $_GET['objekt'] ?>">
Lisa klass:
<input name="nimi" type="text" value="">
<input type="submit" value="Lisa">
</form>
