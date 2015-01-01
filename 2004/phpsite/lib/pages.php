<?php

/*
/lib/pages.php
Pager functions.
(c) Raivo Laanemets
16th July 2004 - 17th July 2004
*/

function IsPage() {
  global $OBJECTS_DB;
  global $PAGE;
  global $SYSTEM; print $PAGE;
  $res=mysql_query("SELECT obj_id FROM " .$SYSTEM['name'] ."_pages WHERE id='" .$PAGE ."'", $OBJECTS_DB);
  return @$result=mysql_fetch_row($res);
}

?>