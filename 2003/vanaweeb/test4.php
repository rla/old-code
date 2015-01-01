<?php
    $dbname = 'test';

    if (!mysql_connect('localhost', 'jim17', 'xxx')) {
        print 'Could not connect to mysql';
        exit;
    }

    $result = mysql_list_tables($dbname);
    
    if (!$result) {
        print "DB Error, could not list tables\n";
        print 'MySQL Error: ' . mysql_error();
        exit;
    }
    
    while ($row = mysql_fetch_row($result)) {
        print "Table: $row[0]\n";
    }

    $result = mysql_query("SELECT * FROM tabel1");
    $num_rows = mysql_num_fields($result);

    echo "$num_rows Rows\n";

        $db_list = mysql_list_dbs();

    $i = 0;
    $cnt = mysql_num_rows($db_list);
    while ($i < $cnt) {
        echo mysql_db_name($db_list, $i) . "\n";
        $i++;
    }


    mysql_free_result($result);
?>
