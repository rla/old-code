<?php

/*
Templeitide modimiseks mõeldud script.
Raivo Laanemets 2004
*/

include_once('func/admin.php');

switch($_GET['act']) {
case 'lisa':
	SetTitle('Css - uue lisamine');

    print '<form method="post" action="func/css.php">
    <input type="hidden" name="act" value="save_new">
    <input type="hidden" name="path" value="' .ReadSetting('admin_path') .'">
    Nimi:<br>
    <input type="text" name="name"><br>
    <textarea name="temp" rows="15" cols="80" wrap="off"></textarea><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'kood':
	SetTitle('CSS - kood');

    print '<form method="post" action="func/css.php">
    <input type="hidden" name="act" value="save_css">
    <input type="hidden" name="filename" value="' .ReadSetting('admin_path') .'/content/css/' .$_GET['file'] .'">
    Faili sisu:<br>
    <textarea name="temp" rows="20" cols="70" wrap="off">';
    ShowFile(ReadSetting('admin_path') .'/content/css/' .$_GET['file']);
    print '</textarea><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'muuda':
    SetTitle('CSS - muutmine');

    include_once('func/parse_css.php');
    $css=array();
    $fname=ReadSetting('admin_path'). '/content/css/' .$_GET['file'];

    print 'Fail <b>' .$_GET['file'] .'</b>
    <br><br><form method="post" action="func/css.php">
    <input type="hidden" name="act" value="save_form">
    <input type="hidden" name="fname" value="' .ReadSetting('admin_path') .'/../content/css/' .$_GET['file'] .'">';

    ParseCss($fname, $css);

    print '<table>';
    foreach($css as $key => $value) {
    	print '<tr><td colspan="2" style="background-color: #efefef">&nbsp;<b>' .$key .'</b><td></tr>';
        if (is_array($value)) foreach($value as $subkey => $subvalue) {
        	print '<tr><td>' .$subkey .':</td><td><input type="text" name="' .str_replace('_', '=?=', str_replace('.', '=*=', $key)) .'[' .$subkey .']" value="' .$subvalue .'"></td></tr>';
        }
    }
    print '</table>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'new_2':
	$path=ReadSetting('admin_path') .'/content/css/';
	if (@copy($path .$_GET['old'], $path .$_GET['new'] .'.css')):
    	print 'Fail loodud.';
    else:
    	print 'FAILI EI SUUDETUD KOPEERIDA!';
    endif;
break;
case 'new':
	SetTitle('Css - uue loomine');

    print 'Uue stiililehe loomine vana baasil.<br>
    Vana fail: <b>' .$_GET['file'] .'</b><br>Sisesta uue faili
    nimi ilma laiendita.<br><br>
    <form method="get" action="index.php">
    <input type="hidden" name="id" value="css">
    <input type="hidden" name="act" value="new_2">
    <input type="hidden" name="old" value="' .$_GET['file'] .'">
    Uus failinimi:<br>
    <input type="text" name="new"><br>
    <input type="submit" value="Salvesta" class="button">
    </form>';
break;
case 'del':
	if(@unlink(ReadSetting('admin_path') .'/content/css/' .$_GET['file'])):
    	print 'Fail kustutatud.';
    else:
    	print 'EI SUUTNUD FAILI KUSTUTADA!';
    endif;
break;
default:
    SetTitle('CSS');

    //loeme millised failid on kasutuses
    global $objects_db;
    global $objects_css_tbl;

    $sql="SELECT * FROM " .$objects_css_tbl;
    $res=mysql_query($sql);

    $used=array();
    while($result=mysql_fetch_row($res)) $used[$result[0]]=$result[1];

    print 'Saadaolevad stiilifailid.<br><br><table>';

    $d=ReadSetting('admin_path') .'/content/css';
    $temps=dir($d);
    while($entry=$temps->read()) {
    	if ((!is_dir($entry)) && ($entry!='.') && ($entry!='..')) {
        	print '<tr><td>' .$entry .'</td>
        	<td><a href="?id=css&amp;act=muuda&amp;file=' .$entry .'" class="textlink">Muuda</a></td>
            <td><a href="?id=css&amp;act=kood&amp;file=' .$entry .'" class="textlink">Kood</a></td>
            <td><a href="?id=css&amp;act=del&amp;file=' .$entry .'" class="textlink">Kustuta</a></td>
            <td><a href="?id=css&amp;act=new&amp;file=' .$entry .'" class="textlink">Uus(laiendus)</a></td>';

            $posit=array_search($entry, $used);
            if ($posit!==false):
            	print '<td>Kasutuses</td>';
                print '<td><a href="?id=css_used&amp;act=remove&amp;fid=' .$posit .'" class="textlink">Eemalda</a></td>';
            else:
            	print '<td>-</td>';
                print '<td><a href="?id=css_used&amp;act=lisa_2&amp;file=' .$entry .'" class="textlink">Lisa</a></td>';
            endif;
            print '</tr>';
        }
    }
    $temps->close();
    print '</table><br><a href="?id=css&amp;act=lisa" class="textlink">Lisa</a>';
}

?>