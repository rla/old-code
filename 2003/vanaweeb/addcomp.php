<html>
<head><title>Computer Added</title>

<?
//include stylesheet for formatting
include("stylesheet.php");
?>

</head>
<body>
<?
// connection information
$hostName = "localhost";
$userName = "jim17";
$password = "xxx";
$dbName = "computers";

$computerDescription="arvuti2";

// make connection to database
mysql_connect($hostName, $userName, $password) or die("Unable to connect to host $hostName");

mysql_select_db($dbName) or die("Unable to select database $dbName");

$query = "INSERT INTO computers (computerDescription) VALUES('$computerDescription')";
$result = mysql_query($query);

print "<b>Data submitted to database!</b><p>
    <b>$computerDescription</b>
     has been added to the Computer List.<br>";

// Close the database connection
mysql_close();
?>

<p><a href="addComputer.phps">
<font color="red">View the source of computers.php3</font></a><p>
<a href="stylesheet.phps">
<font color="red">View the source of stylesheet.php3</font></a>
</body>
</html>