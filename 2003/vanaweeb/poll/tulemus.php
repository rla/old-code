<?php 
include("connect.php"); // ühendus andbemaasiga 

//kui kysimuse id pole teada, siis annane $id-le kõige uuema küsimuse id 
if (!isset($id)) 
{ 
$esiteks="select id,aeg from kysimused order by aeg desc limit 1"; 
$uuri=mysql_query($esiteks,$link) or die ("Ei saanud pärida1!"); 
while ($rida=@mysql_fetch_assoc($uuri)) 
{ 
$id=$rida['id']; 
} 
} 

//kui küsimuse id on teada (link vanemale küsimusele), siis hakatakse koodi täitma siit 
$esiteks="select kysimus,id,aeg from kysimused where id='$id'"; 

//pärime andmebaasist $id-le vastava id-ga küsimuse 
$uuri=mysql_query($esiteks,$link) or die ("Ei saanud pärida1!"); 
while ($rida=@mysql_fetch_assoc($uuri)) 
{ 
$kysimus=$rida['kysimus']; 
$id=$rida['id']; 
} 

//küsimuse juurde käivad vastused kah välja 
$pari="select vastus1,vastus2,vastus3,vastus4,vastus5 
from vastused where kid='$id'"; 
$pari2=mysql_query($pari,$link) or die ("Ei saanud pärida2!"); 
while ($row=@mysql_fetch_assoc($pari2)) 
{ 
$vastus1=$row['vastus1']; 
$vastus2=$row['vastus2']; 
$vastus3=$row['vastus3']; 
$vastus4=$row['vastus4']; 
$vastus5=$row['vastus5']; 
} 
//palju hääli on igal vastusel? 
$query3="select v1,v2,v3,v4,v5 from haaletus where kid='$id'"; 
$query4=mysql_query($query3,$link) or die ("Ei saanud pärida3!"); 
while ($row=@mysql_fetch_assoc($query4)) 
{ 
$v1=$row['v1']; 
$v2=$row['v2']; 
$v3=$row['v3']; 
$v4=$row['v4']; 
$v5=$row['v5']; 
} 
//loeme hääled kokku 
$total=$v1+$v2+$v3+$v4+$v5; 

//kui hääli pole, siis nulliga jagamise vältimiseks saab summa väärtuseks 1 
if ($total==0) 
{$total=1;} 

//arvutame iga vastuse häälte protsendi 
$v1p=round(($v1*100)/$total,0); 
$v2p=round(($v2*100)/$total,0); 
$v3p=round(($v3*100)/$total,0); 
$v4p=round(($v4*100)/$total,0); 
$v5p=round(($v5*100)/$total,0); 

// joonistame nüüd tabeli tulemuste jaoks. vastava protsendi illustreerimiseks kasutatav riba.gif on suvalist värvi (peaasi, et mitte valge selle näite juures) 1x1 pixeliga pilt 

echo'<br><table><tr><td>'; 
echo "<b>".$kysimus."</b></td><td>&nbsp;</td><td><b>%</b></td><td><b>Hääli</b></td></tr><tr><td>"; 
echo $vastus1." </td><td width=100><img src=riba.gif width=".$v1p." height=5></td><td>".$v1p."</td><td><b>".$v1."</td></tr><tr><td>"; 
echo $vastus2." </td><td><img src=riba.gif width=".$v2p." height=5></td><td>".$v2p."</td><td><b>".$v2."</td></tr><tr><td>"; 
echo $vastus3." </td><td><img src=riba.gif width=".$v3p." height=5></td><td>".$v3p."</td><td><b>".$v3."</td></tr><tr><td>"; 
echo $vastus4." </td><td><img src=riba.gif width=".$v4p." height=5></td><td>".$v4p."</td><td><b>".$v4."</td></tr><tr><td>"; 
echo $vastus5." </td><td><img src=riba.gif width=".$v5p." height=5></td><td>".$v5p."</td><td><b>".$v5."</td></tr><tr><td>"; 
echo "<b>Hääli kokku: </b></td><td><img src=riba.gif width=100% height=5></td><td><b>100</b></td><td><b>".$total."</b></td></tr></table>"; 


// Arhiiv ehk siis vanemad küsimused tulevad tabeli alla. 
echo "<p><b>Vanemad küsimused:</b><p>"; 

// Teeme päringu, milles siis võtame välja kõik küsimused, mis kunagi on olemas olnud 
$kaeva="select kysimus,id,aeg from kysimused order by aeg desc"; 

$kaeva2=mysql_query($kaeva,$link) or die ("Ei saanud pärida1!"); 
while ($rida=@mysql_fetch_assoc($kaeva2)) 
{ 
$kysimus=$rida['kysimus']; 
$id=$rida['id']; 
//link viitab samale tulemus.php failile, ainult küsimuse id antakse ette 
echo "<a href=tulemus.php?id=".$id.">".$kysimus."</a><br>"; 
} 
?> 
