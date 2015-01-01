<?
$hostname="localhost"; //pane siia oma host
$username="jim17"; //oma kasutajanimi
$password="xxx"; //parool
$database="poll"; //andmebaasi nimi, kus kavatsed polli rakendada

$link= mysql_connect($hostname, $username, $password) or die ("Mingi jama SQL serveri ühendusega");
mysql_select_db($database) or die ("Ei saa andmebaasi kätte");

?>