<?php

/*
MySql administreerimise lisafunktsioonid.
Raivo Laanemets 2004.
*/

switch($_POST['act']){
case 'tee_tabel':
	include('../conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) print mysql_error($db);
    if(!mysql_select_db($_POST['db'])) print mysql_error($db);

    $sql='CREATE TABLE ' .$_POST['tbl'] .'(' .$_POST['nimi_0'] .' ' .$_POST['type_0'] .' ';
    if ($_POST['inc_0']=='on') $sql.='auto_increment ';
    $sql.='primary key not null ';
    for($i=1; $i<$_POST['v_arv']; $i++) {
    	$sql.=',' .$_POST['nimi_' .$i] .' ' .$_POST['type_' .$i];
        if ($_POST['len_' .$i]!='') $sql.='(' .$_POST['len_' .$i] .') ';
        if ($_POST['inc_' .$i]=='on') $sql.='auto_increment';
    }
    $sql.=')';
    mysql_query($sql, $db);
    mysql_close($db);
    $link='?id=mysql&amp;act=data_succ';
break;
case 'save_data':
	include('../conf/system_mysql.php');

    $db=mysql_connect($objects_host, $objects_user, $objects_pass, true);
    if(!$db) Error(mysql_error($db));
    if(!mysql_select_db($_POST['db'])) print mysql_error($db);

    $sql='SHOW FIELDS FROM ' .$_POST['tbl'];
    if(!($res=mysql_query($sql))) print mysql_error($db);

    $sql="INSERT INTO " .$_POST['tbl'] ." VALUES(";
    $first=true;
    while($result=mysql_fetch_row($res)) {
    	if (!($first)): $sql.=', ';
        else: $first=false;
        endif;
    	if ($result[5]!='auto_increment'): $sql.="'" .$_POST[$result[0]] ."'";
        else: $sql.="0";
        endif;
    }
    $sql.=')';
    if (!mysql_query($sql, $db)) print mysql_error();
    mysql_close($db);

    $link='?id=mysql&amp;act=data_succ';
break;
}

?>

<script type="text/javascript">
  window.location="../index.php<?php echo $link; ?>";
</script>