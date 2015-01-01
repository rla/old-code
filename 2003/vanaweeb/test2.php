<?php
// hostname or ip of server (for local testing, localhost should work)
$dbServer='localhost';

// username and password to log onto db server (what you entered in Step 4)
$dbUser='jim17';
$dbPass='xxx';

// name of database (what you created in step 4)
$dbName='test';

    $link = mysql_connect("$dbServer", "$dbUser", "$dbPass") or die("Could not connect");
    print "Connected successfully<br>";
    mysql_select_db("$dbName") or die("Could not select database");
    print "Database selected successfully<br>";

// close connection
mysql_close($link);
?>
