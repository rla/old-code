<?php

//muutujad
$sisu_array=array();
$sisu_array["keel"]=$keel;
$sisu_array["mis"]="quest";
$sisu_array["local_title"]="Questbook";
$sisu_array["pic"]="";

if ($subid=="1") {

	$sisu_array["sisu"]="&nbsp; &nbsp;Add your comments";

	//külalisteraamatu vormi osa
	$sisu_array["in_01"]="Name:";
	$sisu_array["in_02"]="Mail:";
	$sisu_array["in_03"]="Web:";
	$sisu_array["in_04"]="Text:";
	$sisu_array["in_05"]="Check comments";

} else {
	$dynamic=""; //muutuja kuhu läheb muutuv osa

	if (isset($lisa)) { //külalisteraamatusse lisamine
		$nimi=strip_tags($nimi);
		$mail=strip_tags($mail);
		$weeb=strip_tags($weeb);
		$msg=strip_tags($msg);
		if ((strlen($nimi)>2) && (strlen($msg)>2)) {
			$fp=fopen("quest.dat", "a+");
			flock($fp,LOCK_EX); //lukustame faili
			$qb_array=array();
			$qb_array[0]=$nimi;
			$qb_array[1]=$mail;
			$qb_array[2]=$weeb;
			$qb_array[3]=$msg;
			$qb_array[4]=date("d-m-Y H:i");
			$qb=implode('*', $qb_array);
			fwrite($fp, $qb ."\n");
			fclose($fp);
		} else {
			$dynamic="&nbsp; &nbsp<font color=\"#ff0000\" face=\"Courier\">Nimi ja tekst peavad olema vähemalt 3 tähte pikad.</font>";
		}
	}
	
	$msgs=array(); //teadete array
	$count=0;        //teadete arv

	//sissekanded vaja kuvada
	$fp=fopen("quest.dat", "r");
	flock($fp,LOCK_EX); //lukustame faili
	while (!feof($fp)) {
		$qb=fgets($fp);
		if (strlen($qb)>0) { //eemaldatakse tühi rida faili lõpust
			$msgs[$count]=$qb;
			$count++;
		}
	}
	$msgs=array_reverse($msgs);

	if ($subsubid=="1") {
		$s_count="0";
	} else {
		$s_count=($subsubid-1)*3; //mitmendast kirjest alustatakse
	}
	$e_count=$s_count+3; //mitmenda kirjega lõpetetekse
	if ($e_count>=$count) { //külalisteraamatu lõpp
		$e_count=$count;
		$mpage=false;
	}
	for ($i=$s_count; $i<$e_count; $i++) {
		$qb_array=explode('*', $msgs[$i]);
		$tyhik="&nbsp; &nbsp;";
		$dynamic=$dynamic ."<p class=\"text\">";
		$dynamic=$dynamic .$tyhik ."Name: " .$qb_array[0] ."<br>";
		$dynamic=$dynamic .$tyhik ."Mail: " .$qb_array[1] ."<br>";
		$dynamic=$dynamic .$tyhik ."Web: " .$qb_array[2] ."<br>";
		$dynamic=$dynamic .$tyhik ."Date: " .$qb_array[4] ."<br>";
		$dynamic=$dynamic .$tyhik ."Text: " .$qb_array[3] ."</p><hr>";
	}

	$q_link="&nbsp; &nbsp;"; //külalisteraamatus liikumise link
	if ($s_count>0) $q_link=$q_link ."<a href=\"index.php?mis=quest&keel=" .$keel ."&subid=2&subsubid=" .($subsubid-1) ."\" class=\"text\">Back</a>&nbsp; &nbsp;";
	if ($e_count<$count) $q_link=$q_link ."<a href=\"index.php?mis=quest&keel=" .$keel ."&subid=2&subsubid=" .($subsubid+1)  ."\" class=\"text\">Next</a>";

	$dynamic=$dynamic .$q_link;

	$sisu_array["sisu"]="&nbsp; &nbsp;Results " .($s_count+1) ." - " .$e_count ." of all " .$count;

	$sisu_array["dynamic"]=$dynamic;
	fclose($fp);
}
?>