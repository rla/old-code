-- phpMyAdmin SQL Dump
-- version 2.6.0-pl2
-- http://www.phpmyadmin.net
-- 
-- Masin: localhost
-- Tegemisaeg: 08.07.2005 kell 18:27:00
-- Serveri versioon: 5.0.3
-- PHP versioon: 5.0.4
-- 
-- Andmebaas: `friends`
-- 

-- --------------------------------------------------------

-- 
-- Struktuur tabelile `friends`
-- 

CREATE TABLE `friends` (
  `id` int(11) NOT NULL auto_increment,
  `eesnimi` varchar(50) NOT NULL,
  `perenimi` varchar(50) NOT NULL,
  `s_kuu` varchar(15) NOT NULL,
  `s_paev` int(11) NOT NULL,
  `s_aasta` int(11) NOT NULL,
  `address` varchar(50) NOT NULL,
  `telephone` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `web` varchar(50) NOT NULL,
  `msn` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;
