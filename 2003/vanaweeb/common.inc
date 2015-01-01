<?php
// <--- Common Functions --->

// Function sets unset or blank variables
// to their configuration defaults
function default_ifempty ($key,$value) {

require("defaults.inc");

if (empty ($value)) {
    // determine the corresponding default name for KEY
    $defname = "def".ucfirst(strtolower($key));
    if (!empty ($$defname)) {
       $value = $$defname;
    }   // endif
}   // endif

return $value;

}   // endfunc


// Function does a simple check for a valid email address format

function bad_address ($email) {

if (!eregi("^[^@[:space:]]+@([[:alnum:]\-]+\.)+[[:alnum:]][[:alnum:]][[:alnum:]]?$", $email)) {
    return 1;
} else {
    return 0;
}   // endif

} // endfunc


// Function checks for existence of required fields

function check_required ($strRequired,&$aryMissing) {

// Set up for return counter
$j = 0;

// Check for empty required
if (!empty ($strRequired)) {
    // Create array for required fields
    $aryRequired = explode(",", $strRequired);

    // Traverse array for required fields
    for ($i=0 ; $i < count($aryRequired) ; $i++) {
       // Test if a required field is missing
       $curr_field = $aryRequired[$i];
       $glob_field = $GLOBALS[$curr_field];
       if (empty($glob_field)) {
          $aryMissing[$j] = $aryRequired[$i];
          $j++;
       }   // endif

    }   // endfor

}   // endif

// echo "<UL>\n";

return $j;

}   // endfunc


// Function replaces variables into templates

function build_body ($body) {

global $HTTP_POST_VARS;

reset($HTTP_POST_VARS);

if (!empty($body)) {

    // Fill in variables into the template
    while (list($header, $value) = each($HTTP_POST_VARS)) {
       $body = ereg_replace("%".$header."%", $value, $body);
    } // endwhile

} else {

    // Simply add variables line by line
    sort($HTTP_POST_VARS);
    while (list($header, $value) = each($HTTP_POST_VARS)) {
       $body = "$body\n$header: $value";
    }   // endwhile

}   // endif

return $body;

}   // endfunc


// Function sends mail to user
function send_mail ($to, $from, $subject, $body, $extras) {

// Build extra headers
$headers = "FROM:".$from."\n";
if (! empty ($extras)) {
    $headers = $headers.$extras;
}   // endfrom

// Send mail
mail ( $to, $subject, $body, $headers);

}   // endfunc


// Function formats mail headers and sends mail(s).
function mail_it () {

global $to, $subject, $from, $autofrom, $autosubject,
        $sendextras, $autoextras, $template, $autoreply,
        $autoprefix ;

// Send the message.
if (!empty ($to)) {
    $mainbody = build_body ($template);
    send_mail ($to, $from, $subject, $mainbody, $sendextras);
}

// Send the autoreply.
if ( (!empty($autoreply)) and (!bad_address($from)) ) {
    $mainbody = build_body ($autoreply);
    $mainto = $from;
    if (!empty($autosubject)) {
       $mainsubject = build_body($autosubject);
    } elseif (!empty ($autoprefix)) {
       $mainsubject = $autoprefix.$subject;
    } else {
       $mainsubject = "Auto-Reply: ".$subject;
    }   // endif
    if (!empty ($autofrom)) {
       $mainfrom = $autofrom;
    } else {
       $mainfrom = $to;
    }
    send_mail ($mainto, $mainfrom, $mainsubject, $mainbody, $autoextras);
}   // endif (auto reply)

}   // endfunc


// Function logs the email to a table
function log_it ($to, $from, $subject, $body) {

// Set up access to needed global values
global $hostname, $user, $password, $db, $table, $logbodies;

// Open a connection to the DBMS
$lnk = mysql_connect("$hostname", "$user", "$password");

// Log mail to database
if ($lnk) {
    $host = getenv($REMOTE_HOST); 
    $host ? "": $host = gethostbyaddr(getenv($REMOTE_ADDR));
    if ($logbodies) {
       $result = mysql_db_query ("$db", "INSERT INTO $table VALUES(null, '$host', '$to', '$subject', '$from', '$body')", $lnk);
    } else {
       $result = mysql_db_query ("$db", "INSERT INTO $table VALUES(null, '$host', '$to', '$subject', '$from')", $lnk);
    }   // endif
} else {
    $result = 0;
}   // endif

}   // endfunc
?>