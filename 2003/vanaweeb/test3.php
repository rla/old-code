<?php
    /* Connecting, selecting database */

    $link = mysql_connect("localhost", "jim17", "xxx")
        or die("Could not connect");
    print "Connected successfully<br>";
    mysql_select_db("test") or die("Could not select database");

    /* Performing SQL query */
    $query = "SELECT * FROM tabel1";
    $result = mysql_query($query) or die("Query failed<br>");

    print "<table>\n";
    while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
        print "\t<tr>\n";
        foreach ($line as $col_value) {
            print "\t\t<td>$col_value</td>\n";
        }
        print "\t</tr>\n";
    }
    print "</table>\n";

    /* Free resultset */
    mysql_free_result($result);

    /* Closing connection */
    mysql_close($link);
?>
 
 
