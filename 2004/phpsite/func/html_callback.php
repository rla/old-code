<?php

/*
ParseHTML callback funktsioonid.
Raivo Laanemets 2004
*/

function HtmlLink(&$props) {
	global $LANG;
	$props['HREF'].='&amp;lang=' .$LANG;
}

?>