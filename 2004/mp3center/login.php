<?php

//login script

function UserLogin($user, $pass) {
}

function CreateUser($user, $pass) {
	$udir='users/' .$user;
	mkdir($udir, 0777);
    $ufile=$udir .'/' .'auth.pwd';
    touch($ufile);
    chmod($ufile, 0777);
    $ufp=fopen($ufile, 'w');
    fwrite($ufp, $user .':' .md5($pass));
    fclose($ufp);
    touch($udir .'/login.dat');
    chmod($udir .'/login.dat', 0777);
}

CreateUser('mega', 'mega');

?>