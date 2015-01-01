<? 
 
/* 
Concise. 
Veebimootor. 
 
RL 5. veebruar 2005. 
 
(c) Raivo Laanemets 2005 
*/ 
 
//Saidi nimi. 
define("prename", "audio"); 
 
mysql_connect("localhost", "d6349sa7045", "Diablo666") or die(mysql_error()); 
mysql_select_db("d6349sd4071"); 
 
//Kogu saiti objektide kaupa väljastav rekursiivselt töötav funktsioon. 
function Object ($id) { 
 
    global $action; 
    $resource = mysql_query("SELECT name, prepend, append, type FROM " .prename ."_objects WHERE id=" .$id); 
    $result = mysql_fetch_array($resource); 
      
    if ($result["prepend"] != 0) Object($result["prepend"]); 
      
    if ($result["type"] == "php") require("php/" .$result['name'] .".php"); 
    else if ($result["type"] == "html") { 
        $resource = mysql_query("SELECT content FROM " .prename ."_html WHERE id=" .$id); 
        $result2 = @mysql_fetch_row($resource); 
        echo stripslashes($result2[0]); 
    } 
      
    if ($result["append"] != 0) Object($result["append"]); 
      
    return 0; 
      
} 
 
//Väljastamist alustatakse kujundusest (php/main.php). 
//Kujundus on objektide tabelis esimesel kohal. 
Object(1); 
 
mysql_close(); 
 
?> 