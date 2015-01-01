-- phpMyAdmin SQL Dump
-- version 2.6.0-pl2
-- http://www.phpmyadmin.net
-- 
-- Masin: localhost
-- Tegemisaeg: 08.07.2005 kell 17:14:50
-- Serveri versioon: 5.0.3
-- PHP versioon: 5.0.4
-- 
-- Andmebaas: `indexer`
-- 

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `directories`
-- 

CREATE TABLE `directories` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(250) NOT NULL,
  `path` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `lastindexed` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `node_words`
-- 

CREATE TABLE `node_words` (
  `id` int(11) NOT NULL auto_increment,
  `node` int(11) NOT NULL,
  `word` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `node` (`node`,`word`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `nodes`
-- 

CREATE TABLE `nodes` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `type` enum('file','directory') NOT NULL default 'file',
  `path` varchar(250) NOT NULL,
  `mtime` int(11) NOT NULL,
  `atime` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `hash` varchar(60) NOT NULL,
  `parent` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `words`
-- 

CREATE TABLE `words` (
  `id` int(11) NOT NULL auto_increment,
  `word` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `word` (`word`)
) ENGINE=MyISAM DEFAULT;
