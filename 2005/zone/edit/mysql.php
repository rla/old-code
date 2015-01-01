<?php

/**
*MySql ühendust loov osa.
*
*Vajab ühendusfunktsiooni seadistamist vastavalt tegelikele
*parameetritele (serveri aadress, kasutajanimi, parool).
*
*@package Concise
*@author Raivo Laanemets <rlaanemt@ut.ee>
*@license http://opensource.org/licenses/gpl-license.php GNU Public License
*@version 1.0
*@filesource
*/

mysql_connect('localhost', 'd6349sa7045', 'Diablo666') or die('Ei saa ühendada MySql serveriga.');
mysql_select_db('d6349sd4071') or die('Soovitud andmebaasi ei eksisteeri või ei saa seda kasutada.');

?>