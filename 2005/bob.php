<? 
 
/* 
IRC teadete logimiseks mõeldud skript. 
 
Copyright (c) 2005 Raivo Laanemets 
*/ 
 
//Kuna skript töötab pidevalt, siis ei vaja ta tööaega 
//piiravat ajalimiiti. Ei toimi veebist käivitamisel, 
//sest apache'l endal on 300 sekundit ajapiirang. 
set_time_limit(0); 
 
//Lukustusfail lock. Kui 
//see eksisteerib, siis botti ei käivitata. 
if (file_exists('lock')) die("Viga! Bot lukustatud\n"); 
 
//Ühendame serveriga 
if ($fp=fsockopen('irc.ircworld.org', 6667, $errno, $errstr, 30)) { 
 
 
    //Loome boti lukustusfaili. 
    $lock=fopen("lock", "w"); fclose($lock); 
 
    //Saadame serverile kasutaja andmed. 
    //Teise rea täpsema kirjelduse leiad rfc1459-st. 
    fwrite($fp, "PASS umbluu\r\n"); 
    fwrite($fp, "USER bob bla irc.ircworld.org :username\r\n"); 
    fwrite($fp, "NICK bob_\r\n"); 
     
    //Kanaliga #test ühinemise soov 
    fwrite($fp, "JOIN #test\r\n"); 
     
    $day=date("d"); 
     
    //Avame logifaili. 
    $log=fopen(date("y-m-d") .".log", "w"); 
 
    //Põhitsükkel 
    while (!feof($fp)) { 
     
        $line=fgets($fp); 
         
        //Kui päev on vahetunud, võtame kasutusele uue logifaili. 
        if (date("d") != $day) { 
            fclose($log); 
            $log=fopen(date("y-m-d") .".log", "w"); 
            $day=date("d"); 
        } 
         
        //Kirjutame rea logifaili, lisame timestampi. 
        fwrite($log, date("H-i-s") .$line); 
         
        $tokenpos=strpos($line, ":"); 
        $token=substr($line, 0, $tokenpos-1); 
         
        //Boti peatamine privaatteate vms. kaudu. 
        if (strpos($line, "kill_my_bob")) break; 
         
        switch ($token) { 
            case 'PING': 
                //Pingile pongiga vastamine. 
                $pong="PONG " .substr($line, $tokenpos+2); 
                fwrite($fp, $pong); 
            break; 
        } 
         
        } 
     
    print "Väljusime tsükilist.\n"; 
 
} else print "Ei suuda ühendada serveriga.(" .$errstr .")\n"; 
 
//Logifaili sulgemine 
fclose($log); 
 
//Lukustusfaili kustutamine 
unlink("lock"); 
 
print "Valmis\n"; 
         
?> 