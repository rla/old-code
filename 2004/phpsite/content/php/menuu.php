<?php

/*
Menüü objekt

Raivo Laanemets 2004
*/
print '<div style="color: #666666; font-family: arial; font-weight: bold">Navigatsioon</div>';

include_once('func/menu_tree.php');
global $id;
global $menu;
global $link_path;
if (OtsiLink($menu['ee'] ,'?id=' .$id, $link_path)) {
	PrintMenu($menu, $link_path);
} else {
	$sisu='Viga!';
}

?>