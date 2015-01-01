<?php

/*
Veateadete esitamise süsteem
Raivo Laanemets 2004
*/

//faili olemasolu kontrolliv include() funktsioon
//ei tööta hästi php koodi puhul, sest saadud
//muutujad on vaid funktsiooni skoobis (pole)
//saadaval põhiprogrammis
function IncludeHTML($filename) {
	if (!file_exists($filename)) ErrorMsg('IncludeHTML', 'Faili ' .$filename .' ei leitud!');
    else include($filename);
}

?>