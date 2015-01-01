<script language="JavaScript">
function SisestaLink(tekst) {
  vorm1.edit1.value+='<a href="'+tekst+'">'+tekst+'</a>';
}
function SisestaTag(tag) {
  vorm1.edit1.value+='<'+tag+'>';
}

function SisestaPilt(fnimi) {
  vorm1.edit1.value+='<img src="pildid/'+fnimi+'" alt="'+fnimi+'">';
}
function SisestaMark(mark) {
  vorm1.edit1.value+=mark;
}
</script>
<form method="post" action="index.php" name="vorm1">
<input name="mis" type="hidden" value="salvesta_objekt">
<input name="objekt" type="hidden" value="<?php print $_GET['objekt'] ?>">
Saidisisesed lingid:
<select name="sel1" onChange="JavaScript: SisestaLink(vorm1.sel1.value)">
<?php

	/*
    objekt_kood.php
    php ja html objektide redaktor.
    Raivo Laanemets
    12. august 2004
    */
	mysql_select_db($_SESSION['saidi_baas']);
	$res=mysql_query("SELECT id FROM " .$_SESSION['saidi_nimi'] ."_lehed");
    while($result=mysql_fetch_row($res)) print '<option value="?mis=' .$result[0] .'&#38;amp;keel=' .$_SESSION['saidi_keel'] .'">' .$result[0] .'</option>';
?>
</select>
Täägid:
<select name="sel2" onChange="JavaScript: SisestaTag(vorm1.sel2.value)">
<option value="html">HTML</option>
<option value="/html">/HTML</option>
<option value="head">HEAD</option>
<option value="/head">/HEAD</option>
<option value="title">TITLE</option>
<option value="/title">/TITLE</option>
</select>
Pildid: <select name="sel3" onChange="JavaScript: SisestaPilt(vorm1.sel3.value)">
<?php
	$d=dir($_SESSION['saidi_tee'] .'/pildid');
    while($entry=$d->read()) if ($entry!='..' && $entry!='.') print '<option value="' .$entry .'">' .$entry .'</option>';
    $d->close();
?>
</select><br>
Erimärgid: <select name="sel4" onChange="JavaScript: SisestaMark(vorm1.sel4.value)">
<option value="&#8704;">&#8704;</option>
<option value="&#8706;">&#8706;</option>
<option value="&#8707;">&#8707;</option>
<option value="&#8709;">&#8709;</option>
<option value="&#8711;">&#8711;</option>
<option value="&#8712;">&#8712;</option>
<option value="&#8713;">&#8713;</option>
<option value="&#8715;">&#8715;</option>
<option value="&#8719;">&#8719;</option>
<option value="&#8721;">&#8721;</option>
<option value="&#8722;">&#8722;</option>
<option value="&#8727;">&#8727;</option>
<option value="&#8730;">&#8730;</option>
<option value="&#8733;">&#8733;</option>
<option value="&#8734;">&#8734;</option>
<option value="&#8736;">&#8736;</option>
<option value="&#8743;">&#8743;</option>
<option value="&#8744;">&#8744;</option>
<option value="&#8745;">&#8745;</option>
<option value="&#8746;">&#8746;</option>
<option value="&#8747;">&#8747;</option>
<option value="&#8756;">&#8756;</option>
<option value="&#8764;">&#8764;</option>
<option value="&#8773;">&#8773;</option>
<option value="&#8776;">&#8776;</option>
<option value="&#8800;">&#8800;</option>
<option value="&#8801;">&#8801;</option>
<option value="&#8804;">&#8804;</option>
<option value="&#8805;">&#8805;</option>
<option value="&#8834;">&#8834;</option>
<option value="&#8835;">&#8835;</option>
<option value="&#8836;">&#8836;</option>
<option value="&#8838;">&#8838;</option>
<option value="&#8839;">&#8839;</option>
<option value="&#8853;">&#8853;</option>
<option value="&#8855;">&#8855;</option>
<option value="&#8869;">&#8869;</option>
<option value="&#8901;">&#8901;</option>

<option value="&#913;">&#913;</option>
<option value="&#914;">&#914;</option>
<option value="&#915;">&#915;</option>
<option value="&#916;">&#916;</option>
<option value="&#917;">&#917;</option>
<option value="&#918;">&#918;</option>
<option value="&#919;">&#919;</option>
<option value="&#920;">&#920;</option>
<option value="&#921;">&#921;</option>
<option value="&#922;">&#922;</option>
<option value="&#923;">&#923;</option>
<option value="&#924;">&#924;</option>
<option value="&#925;">&#925;</option>
<option value="&#926;">&#926;</option>
<option value="&#927;">&#927;</option>
<option value="&#928;">&#928;</option>
<option value="&#929;">&#929;</option>
<option value="&#930;">&#930;</option>
<option value="&#931;">&#931;</option>
<option value="&#932;">&#932;</option>
<option value="&#933;">&#933;</option>
<option value="&#934;">&#934;</option>
<option value="&#935;">&#935;</option>
<option value="&#936;">&#936;</option>
<option value="&#937;">&#937;</option>

<option value="&#945;">&#945;</option>
<option value="&#946;">&#946;</option>
<option value="&#947;">&#947;</option>
<option value="&#948;">&#948;</option>
<option value="&#949;">&#949;</option>
<option value="&#950;">&#950;</option>
<option value="&#951;">&#951;</option>
<option value="&#952;">&#952;</option>
<option value="&#953;">&#953;</option>
<option value="&#954;">&#954;</option>
<option value="&#955;">&#955;</option>
<option value="&#956;">&#956;</option>
<option value="&#957;">&#957;</option>
<option value="&#958;">&#958;</option>
<option value="&#959;">&#959;</option>
<option value="&#960;">&#960;</option>
<option value="&#961;">&#961;</option>
<option value="&#962;">&#962;</option>
<option value="&#963;">&#963;</option>
<option value="&#964;">&#964;</option>
<option value="&#965;">&#965;</option>
<option value="&#966;">&#966;</option>
<option value="&#967;">&#967;</option>
<option value="&#968;">&#968;</option>
<option value="&#969;">&#969;</option>

</select><br><br>
<textarea name="sisu" rows="20" cols="80" wrap="off" id="edit1">
<?php
    unset($result);
    $res=mysql_query("SELECT tyyp FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_GET['objekt'] ."' LIMIT 1");
    $result=mysql_fetch_row($res);
    if ($result[0]=='php'):
    	print htmlentities(file_get_contents($_SESSION['saidi_tee'] .'/php/' .$_GET['objekt'] .'.php'));
        $tyyp='php';
    else:
		$res=mysql_query("SELECT tekst FROM " .$_SESSION['saidi_nimi'] ."_sisu WHERE id='" .$_GET['objekt'] ."' AND keel='" .$_SESSION['saidi_keel'] ."'");
   		$result=mysql_fetch_row($res);
    	print htmlentities($result[0]);
    endif;
?>
</textarea><br><br>
<input name="tyyp" type="hidden" value="<?php print $tyyp ?>">
<input type="submit" value="Salvesta">
</form>