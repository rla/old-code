<?

$hostName = "localhost";
$userName = "jim17";
$password = "xxx";
$dbName = "menuu";

$nimi="tere";
$link="www.tere.com";
 
mysql_connect($hostName,$userName,$password) or die("Unable to connect to host $hostName");

mysql_select_db($dbName) or die("Unable to select database $dbName");

$query = "INSERT INTO ylemine (nimi, link) VALUES($nimi, $link)";
$result = mysql_query($query);
print "Data submitted to database!<p>
    FirstName: $firstName<br>
    LastName: $lastName<br>";

// Close the database connection
mysql_close();
?>