-- phpMyAdmin SQL Dump
-- version 4.1.11
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 30, 2014 at 03:51 PM
-- Server version: 5.6.17
-- PHP Version: 5.4.24

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `shineisp2`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `uid` varchar(50) DEFAULT NULL,  
  `company` varchar(50) DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `birthplace` varchar(200) DEFAULT NULL,
  `birthdistrict` varchar(50) DEFAULT NULL,
  `birthcountry` varchar(50) DEFAULT NULL,
  `birthnationality` varchar(50) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `taxpayernumber` varchar(20) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL DEFAULT '1',
  `legalform_id` int(11) DEFAULT NULL,
  `note` text,
  `createdat` datetime DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `legalform_id` (`legalform_id`),
  KEY `type_id` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

DROP TABLE IF EXISTS `customer_address`;
CREATE TABLE IF NOT EXISTS `customer_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `street` text NOT NULL,
  `city` varchar(150) NOT NULL,
  `area` varchar(100) DEFAULT NULL,
  `code` varchar(20) NOT NULL,
  `country_id` int(11) NOT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_id_idx` (`country_id`),
  KEY `addresses_customer_id_idx` (`customer_id`),
  KEY `addresses_region_id_idx` (`region_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_company_type`
--

DROP TABLE IF EXISTS `customer_company_type`;
CREATE TABLE IF NOT EXISTS `customer_company_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `legalform_id` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `legalform_id` (`legalform_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `customer_company_type`
--

INSERT INTO `customer_company_type` (`id`, `name`, `legalform_id`, `active`) VALUES
(1, 'S.p.A.', 2, 1),
(2, 'S.r.l.', 2, 1),
(3, 's.n.c.', 2, 1),
(4, 's.a.s.', 2, 1),
(5, 's.c.a.r.l.', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_contact`
--

DROP TABLE IF EXISTS `customer_contact`;
CREATE TABLE IF NOT EXISTS `customer_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact` varchar(100) NOT NULL,
  `type_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`),
  KEY `customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_contact_type`
--

DROP TABLE IF EXISTS `customer_contact_type`;
CREATE TABLE IF NOT EXISTS `customer_contact_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `customer_contact_type`
--

INSERT INTO `customer_contact_type` (`id`, `name`, `enabled`) VALUES
(1, 'Telephone', 1),
(2, 'Skype', 1),
(3, 'Additional E-mail', 1),
(4, 'Mobile', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer_legalform`
--

DROP TABLE IF EXISTS `customer_legalform`;
CREATE TABLE IF NOT EXISTS `customer_legalform` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `customer_legalform`
--

INSERT INTO `customer_legalform` (`id`, `name`) VALUES
(1, 'Individual'),
(2, 'Corporation'),
(3, 'Association'),
(4, 'Other');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD CONSTRAINT `customer_address_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `base_region` (`region_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `customer_address_ibfk_2` FOREIGN KEY (`country_id`) REFERENCES `base_country` (`id`),
  ADD CONSTRAINT `customer_address_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_company_type`
--
ALTER TABLE `customer_company_type`
  ADD CONSTRAINT `customer_company_type_ibfk_1` FOREIGN KEY (`legalform_id`) REFERENCES `customer_legalform` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_contact`
--
ALTER TABLE `customer_contact`
  ADD CONSTRAINT `customer_contact_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `customer_contact_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `customer_contact_type` (`id`) ON DELETE CASCADE;
SET FOREIGN_KEY_CHECKS=1;
