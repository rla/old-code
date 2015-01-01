<?php

require_once('mysql.php');

mysql_query("
CREATE TABLE `site` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(250) NOT NULL,
  `rel_path` varchar(250) NOT NULL,
  `abs_path` varchar(250) NOT NULL,
  `default_page` int(11) NOT NULL,
  `created` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;
") or die(mysql_error());

mysql_query("
CREATE TABLE `site_ob` (
  `id` int(11) NOT NULL auto_increment,
  `parent` int(11) NOT NULL,
  `object` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;
") or die(mysql_error());

mysql_query("
CREATE TABLE `sitepage` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(250) NOT NULL,
  `type` varchar(10) NOT NULL,
  `content` text NOT NULL,
  `template` int(11) NOT NULL,
  `created` varchar(10) NOT NULL,
  `modified` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;
") or die(mysql_error());

?>