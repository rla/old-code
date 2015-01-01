<?php

/*
Menüü seadistus.
Raivo Laanemets 2004
*/

$menu_conf['menu_pre']=''; //menuu algusosa
$menu_conf['menu_post']=''; //menüü lõpuosa
$menu_conf['mainitem_pre']=''; //põhimenüü elemendi eesosa
$menu_conf['mainitem_post']='<br>'; //põhimenüü elemendi järelosa
$menu_conf['item_pre']=''; //menu eesosa (avaldub ainult alamenüüle)
$menu_conf['item_post']='<br>'; //menu lõpuosa (avaldub ainult alamenüüle)
$menu_conf['item_offset']='&nbsp;&nbsp;';


$menu_conf['selected_item_class']='menu_selected'; //valitud elemendi klass
$menu_conf['mainitem_class']='vmenu';
$menu_conf['item_class']='menu_item';


$menu_conf['block_pre']=''; //bloki moodustab üks põhimenüü koos alammenüüdega
$menu_conf['block_post']='';
$menu_conf['selected_block_pre']='';
$menu_conf['insert_break']=999; //katkestuse asukoht
$menu_conf['break']='</tr><tr>'; //katkestus

?>