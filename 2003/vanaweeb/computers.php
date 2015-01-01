<?
// script to display all the Computers in the Computers table

// connection information
$hostName = "localhost";
$userName = "jim17";
$password = "xxx";
$dbName = "computers";

// make connection to database
mysql_connect($hostName, $userName, $password) or die("Unable to connect to host $hostName");

mysql_select_db($dbName) or die( "Unable to select database $dbName");

// Select all the fields in all the records of the Computers table
$query = "SELECT *
          FROM computers
          ORDER BY computerDescription";
$result = mysql_query($query);

// Determine the number of computers
$number = mysql_numrows($result);

// print the computer names

print "There are $number types of computers:<p>";

for ($i=0; $i<$number; $i++) {
     $computerDescription = mysql_result($result,$i,"computerDescription");
     print "$computerDescription<br>";
}

// Close the database connection
mysql_close();
?>