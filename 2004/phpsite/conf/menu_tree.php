<?php

/*
Menüü puu ehitamise süsteem.
Raivo Laanemets 2004
*/

global $menu;

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
        <a href=?id=menu&amp;act=lisa&amp;cnt=' .count($value['sub']) .'&amp;place=' .$place .',' .$key .' class="textlink">Lisa</a>
        <a href=?id=menu&amp;act=del&amp;cnt=' .count($value['sub']) .'&amp;place=' .$place .',' .$key .' class="textlink">Kustuta</a><br>';
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
    $i=0;
	while(!$leitud && $i<count($mnode)) {
    	if ($mnode[$i]['link']==$search) {
        	$leitud=true;
        }
        if (is_array($mnode[$i]['sub']) && !$leitud) $leitud=OtsiLink($mnode[$i]['sub'], $search, $link_path);
        if ($leitud) $link_path.=',' .$i;
        $i++;
    }
    return $leitud;
}

function PrintSingleBlock($mnode, $offset) {
	foreach($mnode as $value) {
    	print $offset. '<a href="' .$value['link'] .'" class="vmenu">' .$value['name'] .'</a><br>';
    }
}

function PrintMenuBlock($mnode, $path, $offset) {
    $sisu='';
	foreach($mnode as $key => $value) {
    	//kirjutatakse välja kõik asukohast
        //kõrgemale olevad menüü
        //väljad
    	print $offset. '<a href="' .$value['link'] .'" class="vmenu">' .$value['name'] .'</a><br>';
        //kui tegelik menüü asi asub
        //sügavamal, siis liigutakse sügavamale
        if ($key==$path[0]) {
        	if (count($path)>1) {
            	$tmp=$path;
                array_shift($tmp);
        		if (is_array($value['sub'])) PrintMenuBlock($value['sub'], $tmp, $offset .'&nbsp;&nbsp;&nbsp;&nbsp;');
			} else {
        		if (is_array($value['sub'])) PrintSingleBlock($value['sub'], $offset .'&nbsp;&nbsp;&nbsp;&nbsp;');
            }
        }
    }
    return 1;
}

function LeiaLink($otsitav) {
}

function PrintMenu($menu, $path) {
	$path_arr=explode(',', $path);
    array_shift($path_arr);
    $path_arr=array_reverse($path_arr, false);
	return PrintMenuBlock($menu['ee'], $path_arr, '');
}

?>