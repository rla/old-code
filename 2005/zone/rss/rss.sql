-- phpMyAdmin SQL Dump
-- version 2.6.0-pl2
-- http://www.phpmyadmin.net
-- 
-- Masin: localhost
-- Tegemisaeg: 01.07.2005 kell 18:53:07
-- Serveri versioon: 5.0.3
-- PHP versioon: 5.0.4
-- 
-- Andmebaas: `rss`
-- 

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `channels`
-- 

CREATE TABLE `channels` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(250) collate utf8_estonian_ci NOT NULL,
  `link` varchar(250) collate utf8_estonian_ci NOT NULL,
  `language` varchar(10) collate utf8_estonian_ci NOT NULL,
  `description` text collate utf8_estonian_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `items`
-- 

CREATE TABLE `items` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(250) collate utf8_estonian_ci NOT NULL,
  `link` varchar(250) collate utf8_estonian_ci NOT NULL,
  `description` text collate utf8_estonian_ci NOT NULL,
  `channel` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `new` enum('y','n') collate utf8_estonian_ci NOT NULL default 'y',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_estonian_ci AUTO_INCREMENT=3 ;
