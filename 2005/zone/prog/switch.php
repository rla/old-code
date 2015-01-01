<?php

/**
*Common small site template.
*This file should be named index.php
*
*@author Raivo Laanemets
*/

//Get user query.
//If it's not set either by POST and GET, use default value 'index'.

$page=$_GET['page'] or $what=$_POST['page'] or $page='index';

//Set the title or other variables and the page file name.

switch ($page) {
	case 'index':
		$title='Index';
		$contents='myindex.php';
	break;
	default:
		//The page was set to something unknown.
		$title='Error';
		$contents='nosuchpage.php';
	break;
}

//Include the header.

include('header.php');

//Include the contents.

include($contents);

//Include the footer.

include('footer.php')

?>