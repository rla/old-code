<?php

/*
Menüü muutmise objekt!
NB! võib konflikti minna lehekülje menüüga.

Raivo Laanemets 2004
*/

include_once('func/menu_tree.php'); //menüü puu fail
global $menu;
global $title;

$act=$_GET['act'];
$place=$_GET['place'];

switch($act) {
case 'lisa':
    $title='Menüü - lisamine';
	Object('title', 'ee');

    print '<form method="get" action="index.php">
    <input type="hidden" name="act" value="lisa_do">
    <input type="hidden" name="place" value="' .$place .'">
    <input type="hidden" name="id" value="menu">
    <input type="hidden" name="cnt" value="' .$_GET['cnt'] .'">
    Lingi kiri:<br>
    <input type="text" name="m_item"><br>
    Link (href):<br>
    <input type="text" name="m_link"><br>
    <input type="checkbox" name="use_id" checked> Kasuta id-d (nõutav).<br>
    ID <input type="text" name="_id"><br>
    <input type="submit" value="Lisa" class="button">
    </form>';
break;
case 'lisa_do':
    $title='Menüü - lisamine';
	Object('title', 'ee');

    if ($place=='0') {
    	$fp=fopen('conf/menu.cde', 'a');
        fwrite($fp, nl .$_GET['m_item'] .'(' .$_GET['m_link'] .',0){}');
        fclose($fp);
    } else {
        if ($_GET['use_id']=='on'): $link='?id=' .$_GET['_id'];
        else: $link=$_GET['m_link'];
        endif;
    	$pl_arr=explode(',', html_entity_decode($place));
		//avame menüü faili
    	$m=ParseCde('conf/menu.cde');
    	array_shift($pl_arr);
    	//lisame tüki menüüsse
    	MenuNode($m, $pl_arr, $_GET['m_item'], $link, $_GET['cnt']);
    	//salvestame faili uuesti
    	CdeSave($m, 'conf/menu.cde');
    }
    print 'Menüüsse lisatud!';
break;
case 'del':
	print '<div class="stitle">Menüü - kustutamine</div>';
    $pl_arr=explode(',', html_entity_decode($place));
    $m=ParseCde('conf/menu.cde');
    array_shift($pl_arr);
    MenuDelNode($m, $pl_arr, $_GET['cnt']);
    CdeSave($m, 'conf/menu.cde');
break;
default:
    $title='Menüü';
	Object('title', 'ee');

	print PrintTree($menu);
    print '<a href="?id=menu&amp;act=lisa&amp;cnt=0&amp;place=0" class="textlink">Lisa</a>';
break;
}

?>