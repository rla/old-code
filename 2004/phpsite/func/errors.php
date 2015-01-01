<?php

/*
Veateadete näitamise/ üleskirjutamine.
Raivo Laanemets 2004
*/

function Error($msg) {
    global $LAST_ERROR;
    $LAST_ERROR=$msg;
    Object('error', 'ee');
}
?>