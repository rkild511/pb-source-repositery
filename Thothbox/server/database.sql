-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Ven 08 Juillet 2011 à 15:03
-- Version du serveur: 5.5.8
-- Version de PHP: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Base de données: `test`
--

-- --------------------------------------------------------

--
-- Structure de la table `code`
--

CREATE TABLE IF NOT EXISTS `code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `version` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `date` datetime NOT NULL,
  `author` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `comment` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `code`
--


-- --------------------------------------------------------

--
-- Structure de la table `code2compatibility`
--

CREATE TABLE IF NOT EXISTS `code2compatibility` (
  `code_id` int(11) NOT NULL,
  `compatibility_id` int(11) NOT NULL,
  UNIQUE KEY `code_id` (`code_id`,`compatibility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `code2compatibility`
--


-- --------------------------------------------------------

--
-- Structure de la table `code2file`
--

CREATE TABLE IF NOT EXISTS `code2file` (
  `code_id` int(11) NOT NULL,
  `file_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `code2file`
--


-- --------------------------------------------------------

--
-- Structure de la table `code2keyword`
--

CREATE TABLE IF NOT EXISTS `code2keyword` (
  `code_id` int(11) NOT NULL,
  `keyword_id` int(11) NOT NULL,
  UNIQUE KEY `code_id` (`code_id`,`keyword_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `code2keyword`
--


-- --------------------------------------------------------

--
-- Structure de la table `compatibility`
--

CREATE TABLE IF NOT EXISTS `compatibility` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Contenu de la table `compatibility`
--

INSERT INTO `compatibility` (`id`, `name`) VALUES
(1, 'windows x86'),
(2, 'windows x64'),
(3, 'Linux x86'),
(4, 'Linux x64'),
(5, 'MacOs PPC'),
(6, 'MacOs Intel'),
(7, 'AmigaOs'),
(8, 'Unicode'),
(9, 'Admin Mode');

-- --------------------------------------------------------

--
-- Structure de la table `file`
--

CREATE TABLE IF NOT EXISTS `file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `md5` varchar(64) NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `file`
--


-- --------------------------------------------------------

--
-- Structure de la table `keyword`
--

CREATE TABLE IF NOT EXISTS `keyword` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `keyword`
--

