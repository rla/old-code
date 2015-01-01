<?

$hostName = "localhost";
$userName = "jim17";
$password = "xxx";
$dbName = "menuu";

mysql_connect($hostName, $userName, $password) or die("Unable to connect to host $hostName");

mysql_select_db($dbName) or die( "Unable to select database $dbName"); 

$query = "SELECT * 
          FROM ylemine
          ORDER BY nimi, link";
$result = mysql_query($query);

$number = mysql_numrows($result);

print "There are $number employees:<p>";
for ($i=0; $i<$number; $i++) {
     $firstName = mysql_result($result,$i,"nimi");
     $lastName = mysql_result($result,$i, "link");
     print "$firstName $lastName<br>";
}

mysql_close();
?>