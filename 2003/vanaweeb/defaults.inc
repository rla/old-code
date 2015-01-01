<?
// phpMail Basic Configuration

// See also "files.inc" if you want to change the names
// of the included HTML pages.

// See also the "dbase.inc" to set up your database parameters

// Define default values which are used when no config-data
// is found in the HTML form. Some will need to be uncommented
// (remove the leading "/") to work.

// Who the mail should go to.  Leave undefined skip send (log/autoreply only)
//$defTo = "thebook@thebook.com";

// Which values need to be input in form.
$defRequired = "from";

// Should we do a test for a valid from address?
// Note: even with this turned off, the script will not
// send an autoreply to an invalid address.  Also, if from
// is not a required field, it will not be checked.
$defCheckfrom = 1;

// If using the "call from html page" version, configure
// these lines.
$defUrl_error = "http://www.sun.com/";
$defUrl_success = "http://www.thebook.com/";

// The subject the sent mail should have.
// $defSubject = "Mail from a webuser!";

// Any extra headers for the sent mail.
// $defSendextras = "X-Priority: high\n";

// The body template for the sent mail.
// $defTemplate = "A mail was sent!\nIt was from %from% and to %to%";

// Who it should appear to be from.  Leave commented
// out if you don't want to allow empty from lines.
// $defFrom = "webuser@here.com";

// Who the autoreply should appear to be from.  Leave
// commented out if you want to maintain 1.0 compatibility.
// If defTo is undefined (i.e. you only want to log the mail)
// you can still have an autoreply by defining this variable
// and the autoreply variable.
// $defAutofrom = "lists@here.com";

// The subject the autoreply should have.  Leave it
// commented out if you want to maintain 1.0-style
// autoreply subjects.
// $defAutosubject = "Thanks for the mail!";

// A prefix to the subject of autoreply messages if
// left undefined, will default to "Auto-Reply: "
// Will not be used if "autosubject" is defined
// $defAutoprefix = "Re: ";

// Any extra headers for the autoreply.
// $defAutoextras = "Reply-To: realperson@here.com\nErrors-To:me@here.com\n";

// The body template for the autoreply.
// $defAutoreply = "Hi %name%!\nThanks for the mail!\nMe";

// Do logging?
$defLog = 0;

// Log bodies?
$defLogbodies = 0;

// Ask user for a second submission
$defAskagain = 0;

// That's it!
?>