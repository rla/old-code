<?php

/*
Menüü puu ehitamise süsteem.
Raivo Laanemets 2004

Versioon 0.06/0.07
Menüü seadistamine conf/menu.php.
Tee funktsioon PrintPath();
*/

global $menu_conf;
global $pathway;
global $pathlinks;

$pathway=array();
$pathlinks=array();

include('conf/menu.php');

global $menu;

function PrintPath() {
	global $pathway;
    global $pathlinks;
    include('conf/path.php');

    for($i=count($pathway)-1; $i>0; $i--) {
    	print '<a href="' .$pathlinks[$i] .'" class="path">' .$pathway[$i] .'</a>' .$path_conf['sep'];
    }
    print $pathway[$i];
}

function MenuDelNode(&$node_root, $place, $cnt) {
	if (count($place)=='1') {
    	$scount=count($node_root);
        if ($scount==1) {
        	//kui alammenüüs on vaid üks element,
            //siis eelmdame terve alammenüü,
            //vastasel juhul kustutame vaid ühe elemendi
            array_splice($node_root, $place[0], 1);

        } else {
            print $place[0];
            print_r($node_root);
			array_splice($node_root, $place[0], 1);
        }
    } else {
    	$pl=array_shift($place); //ühe elemendi eemaldamine
    	MenuDelNode($node_root[$pl]['sub'], $place, $cnt);
    }
}

function MenuNode(&$node_root, $place, $item, $link, $cnt) {
	if (count($place)=='1') {
    	$node_root[$place[0]]['sub'][$cnt]['name']=$item;
        $node_root[$place[0]]['sub'][$cnt]['link']=$link;
    } else {
    	$pl=array_shift($place); //ühe elemendi eemaldamine
    	MenuNode($node_root[$pl]['sub'], $place, $item, $link, $cnt);
    }
}

function CdeSaveNode($mnode, $fp, $offset='') {
	foreach($mnode as $value) {
    	if (!is_array($value['sub'])) {
        	fwrite($fp, $offset .$value['name'] .'(' .$value['link'] .',0)' .'{}' .nl);
 		} else {
            fwrite($fp, $offset .$value['name'] .'(' .$value['link'] .',0)' .'{' .nl);
            CdeSaveNode($value['sub'], $fp, $offset.'    ');
            fwrite($fp, $offset .'}' .nl);
        }
    }
}

function CdeSave($m, $filename) {
	$fp=fopen($filename, 'w');
    CdeSaveNode($m, $fp);
    fclose($fp);
}

function CdeBlock($code) {
	$qpos=strpos($code, '{');
	return substr($code, $qpos+1, strlen($code)-$qpos-2);
}

function ParseCdeName($buf) {
	$buf=trim($buf);
	return substr($buf, 0 ,strpos($buf, '('));
}

function ParseCdeLink($buf) {
	$buf=trim($buf);
    $spos=strpos($buf, '(');
    $epos=strpos($buf, ')');
    $arg=substr($buf, $spos+1, $epos-$spos);
    return substr($arg, 0, strrpos($arg, ','));
}

function ParseCdeBuf($buf) {
	$curlcnt=0;
    $lbuf='';
    $m=array();
    $pl_cnt=0;
    $ok=false;
	for($i=0; $i<strlen($buf); $i++) {
    	$ch=$buf{$i};
        if ($ch!=' ') $lbuf.=$ch;
        if($ch=='{') {
        	$curlcnt++;
            $ok=true;
        }
        if($ch=='}') $curlcnt--;
        if(($curlcnt==0) && ($ok)) {
        	$nbuf=CdeBlock($lbuf);
        	//print '<pre>*'.$nbuf;
        	$m[$pl_cnt]['name']=ParseCdeName($lbuf);
            $m[$pl_cnt]['link']=ParseCdeLink($lbuf);
        	$lbuf='';
            //print '*</pre>';
            $ok=false;
            if (strlen(trim($nbuf))>0) $m[$pl_cnt]['sub']=ParseCdeBuf($nbuf);
            $pl_cnt++;
        }
    }
    return $m;
}

function ParseCde($filename) {
	global $menu;
	$fp=fopen($filename, 'r');
    $buf=fread($fp, filesize($filename));
    fclose($fp);
    return ParseCdeBuf($buf);
}

$menu['ee']=ParseCde('conf/menu.cde');

function PrintRow($mnode, $offset, $place) {
    $sisu='';
	foreach($mnode as $key => $value) {
    	$sisu.=$offset. $value['name'] .'
        <a href="?id=menu&amp;act=lisa&amp;cnt=' .count($value['sub']) .'&amp;place=' .$place .',' .$key .'" class="textlink">Lisa</a>
        <a href="?id=menu&amp;act=del&amp;cnt=' .count($value['sub']) .'&amp;place=' .$place .',' .$key .'" class="textlink">Kustuta</a><br>';
        if (is_array($value['sub'])) $sisu.=PrintRow($value['sub'], $offset .'-', $place .',' .$key);
    }
    return $sisu;
}

function PrintTree($menu) {
    return PrintRow($menu['ee'], '', 's');
}

//globaalmuutuja menüüst lingi otsimiseks
$link_leitud=false;
//$link_path='0';

//lingi otsimine ja teekonna ülesmärkimine
function OtsiLink($mnode, $search, &$link_path) {
	$leitud=false;
    global $link_path;
    global $pathway;
    global $pathlinks;
    $i=0;
	while(!$leitud && $i<count($mnode)) {
    	if ($mnode[$i]['link']==$search) {
        	$leitud=true;
        }
        if (is_array($mnode[$i]['sub']) && !$leitud) $leitud=OtsiLink($mnode[$i]['sub'], $search, $link_path);
        if ($leitud):
        	$link_path.=',' .$i;
            array_push($pathway, $mnode[$i]['name']);
            array_push($pathlinks, $mnode[$i]['link']);
        endif;
        $i++;
    }
    return $leitud;
}

function PrintSingleBlock($mnode, $offset, $path) {
	global $menu_conf;
    $i=0;
	foreach($mnode as $value) {

    	//treppimine
    	print $offset;

       /* if ($value['link']=='huh'):
        	print $menu_conf['selected_item_pre'];
            print '<a href="' .$value['link'] .'" class="vmenu">' .$value['name'] .'</a>';
            print $menu_conf['selected_item_post'];
            */
       	if ($value['link']=='?id=' .$_GET['id'])
        	$iclass=$menu_conf['selected_item_class'];
        else if ($main_menu) $iclass=$menu_conf['mainitem_class'];
        else $iclass=$menu_conf['item_class'];


        print $menu_conf['item_pre'];
        print '<a href="' .$value['link'] .'" class="' .$iclass .'">' .$value['name'] .'</a>';
    	print $menu_conf['item_post'];
     	$i++;

    }
}

function PrintMenuBlock($mnode, $path, $offset, $main_menu) {
    $sisu='';
    global $menu_conf;
	foreach($mnode as $key => $value) {
    	//kirjutatakse välja kõik asukohast
        //kõrgemale olevad menüü
        //väljad

        if ($main_menu):

        	if($key==$path[0]): print $menu_conf['selected_block_pre'];
            else: print $menu_conf['block_pre'];
            endif;

            //treppimine
            print $offset;

			print $menu_conf['mainitem_pre'];
        else:
        	print $offset;
            print $menu_conf['item_pre'];
        endif;
        if ($value['link']=='?id=' .$_GET['id'])
        	$iclass=$menu_conf['selected_item_class'];
        else if ($main_menu) $iclass=$menu_conf['mainitem_class'];
        else $iclass=$menu_conf['item_class'];

        print '<a href="' .$value['link'] .'" class="' .$iclass .'">' .$value['name'] .'</a>';

        //kui tegelik menüü asi asub
        //sügavamal, siis liigutakse sügavamale

		if ($key==$path[0]) {

          	if ($main_menu):
            	print $menu_conf['mainitem_post'];
            else:
            	print $menu_conf['item_post'];
            endif;

        	if (count($path)>1) {
            	$tmp=$path;
                array_shift($tmp);
        		if (is_array($value['sub'])) PrintMenuBlock($value['sub'], $tmp, $offset .$menu_conf['item_offset'], false);
			} else {
        		if (is_array($value['sub'])) PrintSingleBlock($value['sub'], $offset .$menu_conf['item_offset'], $path);
            }
            if ($main_menu) print $menu_conf['block_post'];
        } else {


          	if ($main_menu):
            	print $menu_conf['mainitem_post'];
            else:
            	print $menu_conf['item_post'];
            endif;

        }

        //katkestus(menüü kaheks jaotamiseks ntx)
        if ($key==$menu_conf['insert_break'] && $main_menu) print $menu_conf['break'];

    }
    return 1;
}

function LeiaLink($otsitav) {
}

function PrintMenu($menu, $path) {
	global $menu_conf;
    global $pathway;

	$path_arr=explode(',', $path);
    array_shift($path_arr);
    $path_arr=array_reverse($path_arr, false);

    print $menu_conf['menu_pre'];
	PrintMenuBlock($menu['ee'], $path_arr, '', true);
    print $menu_conf['menu_post'];

}

?>