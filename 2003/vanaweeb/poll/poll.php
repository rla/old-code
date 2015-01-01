<html> 
<body> 
<form action="vote.php" method="post"> 
    <table border="0" cellspacing="1" cellpadding="2" width="100%"> 
       <tr> 
         <td> 
<?php 
// loome ühenduse andbemaasiga 
include("connect.php"); 

//päringuga võtame baasist välja kõige uuema küsimuse 
$esiteks="select id,aeg,kysimus from kysimused order by aeg desc limit 1"; 

$uuri=mysql_query($esiteks,$link) or die ("Ei saanud pärida!"); 
while ($rida=@mysql_fetch_assoc($uuri)) 
{ 
$kys=$rida['kysimus']; 
$id=$rida['id']; 
} 

//eelmise päringuga saadud id alusel saame kätte selle küsimuse juurde käivad vastused
$teiseks="select vastus1,vastus2,vastus3,vastus4,vastus5 
from vastused where kid='$id'"; 
$query=mysql_query($teiseks,$link) or die ("Ei saanud pärida!"); 
while ($row=@mysql_fetch_assoc($query)) 
{
 
$vastus1=$row['vastus1']; 
$vastus2=$row['vastus2']; 
$vastus3=$row['vastus3']; 
$vastus4=$row['vastus4']; 
$vastus5=$row['vastus5']; 

// võtame baasist vastusevariandid välja ja omistame neile muutujad 
} 

// trükime välja küsimuse koos vastusevariantidega 
echo "<b>".$kys."</b><p>"; 
echo "<input type=radio name=answer value=1>".$vastus1."<br>"; 
echo "<input type=radio name=answer value=2>".$vastus2."<br>"; 
echo "<input type=radio name=answer value=3>".$vastus3."<br>"; 
echo "<input type=radio name=answer value=4>".$vastus4."<br>"; 
echo "<input type=radio name=answer value=5>".$vastus5."<br>"; 
echo "<input type=hidden value=".$id." name=kid>"; 

// saadame valiku teele 
echo '<br><center><input type="submit" value="hääleta">'; 

?> 
<br> 
</center> 
</td> 
</tr> 
</table> 

</form> 
</body> 
</html> 