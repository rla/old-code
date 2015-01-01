<?php

/*
ParseHTML konfiguratsioon.
Raivo Laanemets 2004
*/

$html_conf['check_inv_tags']=true; //kontrollib või mitte valesid tääge.
$html_conf['log']=true; //logib errorid
$html_conf['logfile']='logs/html_errors.log';
$html_conf['log_date']='Y-m-d H:i:s';

//mittesobivad märgid html väljundis
$html_inv_char=array("\t");

//lubatud täägid.
$html_tags=array('HTML', '!DOCTYPE', 'HEAD', 'TITLE', 'BODY', 'LINK', 'META', 'STYLE',
'SCRIPT', 'DIV', 'SPAN', 'TABLE', 'TH', 'TR', 'TD', 'INPUT', 'FORM', 'P', 'BR',
'A', 'IMG', 'B', 'STRONG', 'OPTION', 'SELECT', 'TEXTAREA', 'H1', 'H2', 'H3', 'H4',
'H5', 'H6', 'H7', 'APPLET', 'U', 'I', 'CENTER', 'ABBR', 'ACRONYM', 'ADDRESS',
'AREA', 'BASE', 'BASEFONT');

?>