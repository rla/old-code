<h1>Failid</h1>
<?php

/*
failid.php
Failihaldus
Raivo Laanemets
30. august 2004
*/

function upload_form($kaust) {
	print '<form method="post" action="index.php" enctype="multipart/form-data">
    Fail:<br>
    <input type="hidden" name="kaust" value="' .$kaust .'">
    <input type="hidden" name="mis" value="yleslaad">
    <input type="file" name="fail"><br>
    <input type="submit" value="Laadi üles">
    </form>';
}


switch($_GET['kaust']) {
	default:
		print '<h2>Saidi "' .$_SESSION['saidi_nimi'] .'" failid</h2>
		<a href="?mis=failid&amp;kaust=pildid">Pildid</a><br>
        <a href="?mis=failid&amp;kaust=failid">Failid</a>';
	break;
    case 'pildid':
        print '<h2>Failid kaustas /pildid</h2>';
    	if(!($d=dir($_SESSION['saidi_tee'] .'/pildid'))): print 'Kausta avamise viga!'; break; endif;
        while($entry=$d->read()) if ($entry!='..' && $entry!='.') print $entry .'&nbsp;&nbsp;<a href="?mis=kustuta_fail&amp;fail=' .$entry .'&amp;kaust=pildid">Kustuta</a><br>';
        $d->close();
        upload_form($kaust);
    break;
    case 'failid':
        print '<h2>Failid kaustas /failid</h2>';
    	if(!($d=dir($_SESSION['saidi_tee'] .'/failid'))): print 'Kausta avamise viga!'; break; endif;
        while($entry=$d->read()) if ($entry!='..' && $entry!='.') print $entry .'&nbsp;&nbsp;<a href="?mis=kustuta_fail&amp;fail=' .$entry .'&amp;kaust=failid">Kustuta</a><br>';
        $d->close();
        upload_form($kaust);
    break;
}

?>