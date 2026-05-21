-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: unicompare
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `career_outcome`
--

DROP TABLE IF EXISTS `career_outcome`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `career_outcome` (
  `outcome_id` int unsigned NOT NULL AUTO_INCREMENT,
  `program_id` int unsigned NOT NULL,
  `job_title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `median_salary_aud` int unsigned DEFAULT NULL,
  `employment_rate_pct` decimal(5,2) DEFAULT NULL,
  `source_year` year DEFAULT NULL,
  PRIMARY KEY (`outcome_id`),
  KEY `fk_career_program` (`program_id`),
  KEY `idx_career_salary` (`median_salary_aud`),
  CONSTRAINT `fk_career_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `career_outcome`
--

LOCK TABLES `career_outcome` WRITE;
/*!40000 ALTER TABLE `career_outcome` DISABLE KEYS */;
INSERT INTO `career_outcome` VALUES (1,1,'Software Developer',110000,87.50,2024),(2,1,'IT Consultant',120000,82.00,2024),(3,2,'Data Scientist',125000,90.00,2024),(4,2,'Machine Learning Engineer',135000,88.00,2024),(5,3,'Software Engineer',105000,85.00,2024),(6,4,'AI/ML Engineer',130000,88.00,2024),(7,5,'Business Analyst',95000,84.00,2024),(8,5,'Product Manager',115000,80.00,2024),(9,7,'Software Engineer',108000,86.00,2024),(10,8,'IT Support Specialist',75000,82.00,2024),(11,9,'Cybersecurity Analyst',115000,91.00,2024),(12,10,'Data Analyst',105000,89.00,2024),(13,12,'Systems Administrator',90000,85.00,2024),(14,13,'Software Engineer',108000,87.00,2024);
/*!40000 ALTER TABLE `career_outcome` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comparison_item`
--

DROP TABLE IF EXISTS `comparison_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comparison_item` (
  `item_id` int unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int unsigned NOT NULL,
  `program_id` int unsigned NOT NULL,
  `added_order` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`item_id`),
  UNIQUE KEY `uq_session_program` (`session_id`,`program_id`),
  KEY `fk_item_program` (`program_id`),
  KEY `idx_item_session` (`session_id`),
  CONSTRAINT `fk_item_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_item_session` FOREIGN KEY (`session_id`) REFERENCES `comparison_session` (`session_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comparison_item`
--

LOCK TABLES `comparison_item` WRITE;
/*!40000 ALTER TABLE `comparison_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `comparison_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comparison_session`
--

DROP TABLE IF EXISTS `comparison_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comparison_session` (
  `session_id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int unsigned DEFAULT NULL,
  `session_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  KEY `idx_session_student` (`student_id`),
  CONSTRAINT `fk_session_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comparison_session`
--

LOCK TABLES `comparison_session` WRITE;
/*!40000 ALTER TABLE `comparison_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `comparison_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data_source`
--

DROP TABLE IF EXISTS `data_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_source` (
  `source_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scrape_frequency` enum('daily','weekly','monthly','manual') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'weekly',
  `last_scraped` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `uq_source_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data_source`
--

LOCK TABLES `data_source` WRITE;
/*!40000 ALTER TABLE `data_source` DISABLE KEYS */;
INSERT INTO `data_source` VALUES (1,'Study Australia','https://www.studyaustralia.gov.au/','weekly',NULL,1),(2,'QS Rankings','https://www.topuniversities.com/university-rankings/world-university-rankings/2025','monthly',NULL,1),(3,'CRICOS Register','https://cricos.education.gov.au/','monthly',NULL,1),(4,'University Sites','https://www.melbourneuni.edu.au','weekly',NULL,1);
/*!40000 ALTER TABLE `data_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program`
--

DROP TABLE IF EXISTS `program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program` (
  `program_id` int unsigned NOT NULL AUTO_INCREMENT,
  `university_id` int unsigned NOT NULL,
  `visa_pathway_id` int unsigned DEFAULT NULL,
  `name` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_of_study` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` enum('Certificate','Diploma','Associate Degree','Bachelor','Honours','Graduate Certificate','Graduate Diploma','Masters','Doctoral') COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tuition_fee` decimal(10,2) DEFAULT NULL,
  `min_gpa` decimal(4,2) DEFAULT NULL,
  `english_req` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ielts_score` decimal(3,1) DEFAULT NULL,
  `delivery_mode` enum('on-campus','online','blended') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'on-campus',
  `intake_months` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cricos_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`program_id`),
  KEY `fk_program_visa` (`visa_pathway_id`),
  KEY `idx_program_field` (`field_of_study`),
  KEY `idx_program_level` (`level`),
  KEY `idx_program_fee` (`tuition_fee`),
  KEY `idx_program_delivery` (`delivery_mode`),
  KEY `idx_program_ielts` (`ielts_score`),
  KEY `idx_program_university` (`university_id`),
  CONSTRAINT `fk_program_university` FOREIGN KEY (`university_id`) REFERENCES `university` (`university_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_program_visa` FOREIGN KEY (`visa_pathway_id`) REFERENCES `visa_pathway` (`visa_pathway_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program`
--

LOCK TABLES `program` WRITE;
/*!40000 ALTER TABLE `program` DISABLE KEYS */;
INSERT INTO `program` VALUES (1,1,1,'Master of Information Technology','Information Technology','Masters','2 years',49000.00,6.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February, July','093776J','https://study.unimelb.edu.au/find/courses/graduate/master-of-information-technology/','2026-05-12 19:27:42'),(2,1,1,'Master of Data Science','Data Science','Masters','2 years',49000.00,6.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February','107464E','https://study.unimelb.edu.au/find/courses/graduate/master-of-data-science/','2026-05-12 19:27:42'),(3,1,1,'Bachelor of Science (Computer Science)','Computer Science','Bachelor','3 years',46000.00,5.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February, July','078521B','https://study.unimelb.edu.au/find/courses/undergraduate/bachelor-of-science/','2026-05-12 19:27:42'),(4,2,1,'Master of Artificial Intelligence','Artificial Intelligence','Masters','2 years',47800.00,6.00,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February, July','106519K','https://www.monash.edu/study/courses/find-a-course/artificial-intelligence','2026-05-12 19:27:42'),(5,2,1,'Master of Business Administration','Business','Masters','2 years',51200.00,5.50,'IELTS 7.0 (no band below 6.5)',7.0,'on-campus','February, July, October','058764G','https://www.monash.edu/business/master-of-business-administration','2026-05-12 19:27:42'),(6,2,1,'Bachelor of Computer Science','Computer Science','Bachelor','3 years',43800.00,5.00,'IELTS 6.0 (no band below 5.5)',6.0,'on-campus','February, July','063543M','https://www.monash.edu/study/courses/find-a-course/computer-science','2026-05-12 19:27:42'),(7,3,1,'Master of Engineering (Software)','Software Engineering','Masters','2 years',41760.00,5.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February, July','093012B','https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters/software-engineering','2026-05-12 19:27:42'),(8,3,1,'Bachelor of Information Technology','Information Technology','Bachelor','3 years',36960.00,4.50,'IELTS 6.0 (no band below 5.5)',6.0,'on-campus','February, July','079606B','https://www.rmit.edu.au/study-with-us/levels-of-study/undergraduate-study/bachelor/bachelor-of-information-technology','2026-05-12 19:27:42'),(9,3,1,'Master of Cybersecurity','Cybersecurity','Masters','2 years',42240.00,5.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February, July','107148B','https://www.rmit.edu.au/study-with-us/levels-of-study/postgraduate-study/masters/cybersecurity','2026-05-12 19:27:42'),(10,4,1,'Master of Data Science and Innovation','Data Science','Masters','1.5 years',49500.00,6.50,'IELTS 7.0 (no band below 6.5)',7.0,'on-campus','February, July','104052G','https://www.sydney.edu.au/courses/courses/pc/master-of-data-science-and-innovation.html','2026-05-12 19:27:42'),(11,4,1,'Master of Computing','Computer Science','Masters','1.5 years',49500.00,5.50,'IELTS 7.0 (no band below 6.5)',7.0,'on-campus','February, July','108244A','https://www.sydney.edu.au/courses/courses/pc/master-of-computing.html','2026-05-12 19:27:42'),(12,5,1,'Master of Information Technology','Information Technology','Masters','2 years',48900.00,5.50,'IELTS 7.0 (no band below 6.5)',7.0,'on-campus','February, June, September','097844J','https://www.unsw.edu.au/study/postgraduate/master-of-information-technology','2026-05-12 19:27:42'),(13,5,1,'Bachelor of Engineering (Software)','Software Engineering','Bachelor','4 years',52000.00,5.50,'IELTS 6.5 (no band below 6.0)',6.5,'on-campus','February','096987K','https://www.unsw.edu.au/study/undergraduate/bachelor-of-engineering','2026-05-12 19:27:42'),(14,4,NULL,'Bachelor of Advanced Computing','Computer Science','Bachelor','4 years',48000.00,NULL,NULL,NULL,'on-campus',NULL,'096745M','https://www.sydney.edu.au','2026-05-12 20:08:18'),(15,5,NULL,'Master of Cybersecurity','Cybersecurity','Masters','2 years',50400.00,NULL,NULL,NULL,'on-campus',NULL,'107211G','https://www.unsw.edu.au','2026-05-12 20:08:18'),(16,6,NULL,'Master of Computing','Computer Science','Masters','2 years',46560.00,NULL,NULL,NULL,'on-campus',NULL,'094525K','https://www.anu.edu.au','2026-05-12 20:08:18'),(17,6,NULL,'Bachelor of Advanced Computing (R&D)','Computer Science','Bachelor','4 years',44640.00,NULL,NULL,NULL,'on-campus',NULL,'094524M','https://www.anu.edu.au','2026-05-12 20:08:18'),(18,7,NULL,'Master of Data Science','Data Science','Masters','2 years',47600.00,NULL,NULL,NULL,'on-campus',NULL,'105153C','https://www.uq.edu.au','2026-05-12 20:08:18'),(19,7,NULL,'Bachelor of Information Technology','Information Technology','Bachelor','3 years',43000.00,NULL,NULL,NULL,'on-campus',NULL,'078897G','https://www.uq.edu.au','2026-05-12 20:08:18'),(20,8,NULL,'Master of Information Technology','Information Technology','Masters','1.5 years',40700.00,NULL,NULL,NULL,'on-campus',NULL,'098098J','https://www.uwa.edu.au','2026-05-12 20:08:18'),(21,8,NULL,'Bachelor of Computer Science','Computer Science','Bachelor','3 years',37500.00,NULL,NULL,NULL,'on-campus',NULL,'081568K','https://www.uwa.edu.au','2026-05-12 20:08:18'),(22,9,NULL,'Master of Cybersecurity','Cybersecurity','Masters','2 years',38000.00,NULL,NULL,NULL,'blended',NULL,'096765C','https://www.deakin.edu.au','2026-05-12 20:08:18'),(23,9,NULL,'Bachelor of Information Technology','Information Technology','Bachelor','3 years',33600.00,NULL,NULL,NULL,'blended',NULL,'083828A','https://www.deakin.edu.au','2026-05-12 20:08:18'),(24,10,NULL,'Master of Information Technology','Information Technology','Masters','2 years',38400.00,NULL,NULL,NULL,'on-campus',NULL,'096312J','https://www.swinburne.edu.au','2026-05-12 20:08:18'),(25,10,NULL,'Bachelor of Computer Science','Computer Science','Bachelor','3 years',34800.00,NULL,NULL,NULL,'on-campus',NULL,'083563J','https://www.swinburne.edu.au','2026-05-12 20:08:18');
/*!40000 ALTER TABLE `program` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ranking`
--

DROP TABLE IF EXISTS `ranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ranking` (
  `ranking_id` int unsigned NOT NULL AUTO_INCREMENT,
  `program_id` int unsigned NOT NULL,
  `source_id` int unsigned NOT NULL,
  `rank_value` int unsigned DEFAULT NULL,
  `rank_year` year NOT NULL,
  `rank_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ranking_id`),
  UNIQUE KEY `uq_ranking_per_program_year` (`program_id`,`source_id`,`rank_type`,`rank_year`),
  KEY `fk_ranking_source` (`source_id`),
  KEY `idx_ranking_value` (`rank_value`),
  KEY `idx_ranking_year` (`rank_year`),
  CONSTRAINT `fk_ranking_program` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ranking_source` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ranking`
--

LOCK TABLES `ranking` WRITE;
/*!40000 ALTER TABLE `ranking` DISABLE KEYS */;
INSERT INTO `ranking` VALUES (1,1,2,33,2025,'QS World University Subject — Computer Science & IS'),(2,2,2,33,2025,'QS World University Subject — Computer Science & IS'),(3,3,2,33,2025,'QS World University Subject — Computer Science & IS'),(4,4,2,57,2025,'QS World University Subject — Computer Science & IS'),(5,5,2,57,2025,'QS World University Subject — Business & Management'),(6,6,2,57,2025,'QS World University Subject — Computer Science & IS'),(7,7,2,86,2025,'QS World University Subject — Engineering & Technology'),(8,10,2,61,2025,'QS World University Subject — Computer Science & IS'),(9,11,2,61,2025,'QS World University Subject — Computer Science & IS'),(10,12,2,43,2025,'QS World University Subject — Computer Science & IS'),(11,13,2,43,2025,'QS World University Subject — Engineering & Technology');
/*!40000 ALTER TABLE `ranking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` int unsigned NOT NULL AUTO_INCREMENT,
  `preferred_field` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_aud` decimal(10,2) DEFAULT NULL,
  `gpa` decimal(4,2) DEFAULT NULL,
  `ielts_score` decimal(3,1) DEFAULT NULL,
  `country_of_origin` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `english_level` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `university`
--

DROP TABLE IF EXISTS `university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `university` (
  `university_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `website_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`university_id`),
  UNIQUE KEY `uq_university_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `university`
--

LOCK TABLES `university` WRITE;
/*!40000 ALTER TABLE `university` DISABLE KEYS */;
INSERT INTO `university` VALUES (1,'University of Melbourne','Melbourne, VIC','https://www.unimelb.edu.au',NULL,'2026-05-12 19:27:42'),(2,'Monash University','Melbourne, VIC','https://www.monash.edu',NULL,'2026-05-12 19:27:42'),(3,'RMIT University','Melbourne, VIC','https://www.rmit.edu.au',NULL,'2026-05-12 19:27:42'),(4,'University of Sydney','Sydney, NSW','https://www.sydney.edu.au',NULL,'2026-05-12 19:27:42'),(5,'University of New South Wales','Sydney, NSW','https://www.unsw.edu.au',NULL,'2026-05-12 19:27:42'),(6,'Australian National University','Canberra, ACT','https://www.anu.edu.au',NULL,'2026-05-12 19:27:42'),(7,'University of Queensland','Brisbane, QLD','https://www.uq.edu.au',NULL,'2026-05-12 19:27:42'),(8,'University of Western Australia','Perth, WA','https://www.uwa.edu.au',NULL,'2026-05-12 19:27:42'),(9,'Deakin University','Australia',NULL,NULL,'2026-05-12 20:08:18'),(10,'Swinburne University of Technology','Australia',NULL,NULL,'2026-05-12 20:08:18');
/*!40000 ALTER TABLE `university` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visa_pathway`
--

DROP TABLE IF EXISTS `visa_pathway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visa_pathway` (
  `visa_pathway_id` int unsigned NOT NULL AUTO_INCREMENT,
  `visa_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `eligibility_rules` text COLLATE utf8mb4_unicode_ci,
  `duration_limit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `work_rights` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`visa_pathway_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visa_pathway`
--

LOCK TABLES `visa_pathway` WRITE;
/*!40000 ALTER TABLE `visa_pathway` DISABLE KEYS */;
INSERT INTO `visa_pathway` VALUES (1,'Student Visa Subclass 500','Primary visa for international students enrolled in a CRICOS-registered course in Australia.','Must be enrolled in CRICOS-registered course, meet health and character requirements, have Genuine Temporary Entrant (GTE) statement, and have sufficient funds.','2 years','48 hours per fortnight during session; unlimited during scheduled course breaks');
/*!40000 ALTER TABLE `visa_pathway` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_program_detail`
--

DROP TABLE IF EXISTS `vw_program_detail`;
/*!50001 DROP VIEW IF EXISTS `vw_program_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_program_detail` AS SELECT 
 1 AS `program_id`,
 1 AS `program_name`,
 1 AS `field_of_study`,
 1 AS `level`,
 1 AS `duration`,
 1 AS `tuition_fee`,
 1 AS `min_gpa`,
 1 AS `english_req`,
 1 AS `ielts_score`,
 1 AS `delivery_mode`,
 1 AS `intake_months`,
 1 AS `cricos_code`,
 1 AS `source_url`,
 1 AS `university_id`,
 1 AS `university_name`,
 1 AS `university_location`,
 1 AS `university_website`,
 1 AS `visa_type`,
 1 AS `work_rights`,
 1 AS `best_rank`,
 1 AS `rank_year`,
 1 AS `avg_salary_aud`,
 1 AS `avg_employment_pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_program_filter`
--

DROP TABLE IF EXISTS `vw_program_filter`;
/*!50001 DROP VIEW IF EXISTS `vw_program_filter`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_program_filter` AS SELECT 
 1 AS `program_id`,
 1 AS `program_name`,
 1 AS `university_name`,
 1 AS `location`,
 1 AS `field_of_study`,
 1 AS `level`,
 1 AS `tuition_fee`,
 1 AS `ielts_score`,
 1 AS `delivery_mode`,
 1 AS `duration`,
 1 AS `best_rank`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_program_detail`
--

/*!50001 DROP VIEW IF EXISTS `vw_program_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_program_detail` AS select `p`.`program_id` AS `program_id`,`p`.`name` AS `program_name`,`p`.`field_of_study` AS `field_of_study`,`p`.`level` AS `level`,`p`.`duration` AS `duration`,`p`.`tuition_fee` AS `tuition_fee`,`p`.`min_gpa` AS `min_gpa`,`p`.`english_req` AS `english_req`,`p`.`ielts_score` AS `ielts_score`,`p`.`delivery_mode` AS `delivery_mode`,`p`.`intake_months` AS `intake_months`,`p`.`cricos_code` AS `cricos_code`,`p`.`source_url` AS `source_url`,`u`.`university_id` AS `university_id`,`u`.`name` AS `university_name`,`u`.`location` AS `university_location`,`u`.`website_url` AS `university_website`,`vp`.`visa_type` AS `visa_type`,`vp`.`work_rights` AS `work_rights`,min(`r`.`rank_value`) AS `best_rank`,max(`r`.`rank_year`) AS `rank_year`,round(avg(`co`.`median_salary_aud`),0) AS `avg_salary_aud`,round(avg(`co`.`employment_rate_pct`),1) AS `avg_employment_pct` from ((((`program` `p` join `university` `u` on((`p`.`university_id` = `u`.`university_id`))) left join `visa_pathway` `vp` on((`p`.`visa_pathway_id` = `vp`.`visa_pathway_id`))) left join `ranking` `r` on((`p`.`program_id` = `r`.`program_id`))) left join `career_outcome` `co` on((`p`.`program_id` = `co`.`program_id`))) group by `p`.`program_id`,`p`.`name`,`p`.`field_of_study`,`p`.`level`,`p`.`duration`,`p`.`tuition_fee`,`p`.`min_gpa`,`p`.`english_req`,`p`.`ielts_score`,`p`.`delivery_mode`,`p`.`intake_months`,`p`.`cricos_code`,`p`.`source_url`,`u`.`university_id`,`u`.`name`,`u`.`location`,`u`.`website_url`,`vp`.`visa_type`,`vp`.`work_rights` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_program_filter`
--

/*!50001 DROP VIEW IF EXISTS `vw_program_filter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_program_filter` AS select `p`.`program_id` AS `program_id`,`p`.`name` AS `program_name`,`u`.`name` AS `university_name`,`u`.`location` AS `location`,`p`.`field_of_study` AS `field_of_study`,`p`.`level` AS `level`,`p`.`tuition_fee` AS `tuition_fee`,`p`.`ielts_score` AS `ielts_score`,`p`.`delivery_mode` AS `delivery_mode`,`p`.`duration` AS `duration`,min(`r`.`rank_value`) AS `best_rank` from ((`program` `p` join `university` `u` on((`p`.`university_id` = `u`.`university_id`))) left join `ranking` `r` on((`p`.`program_id` = `r`.`program_id`))) group by `p`.`program_id`,`p`.`name`,`u`.`name`,`u`.`location`,`p`.`field_of_study`,`p`.`level`,`p`.`tuition_fee`,`p`.`ielts_score`,`p`.`delivery_mode`,`p`.`duration` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-20 21:04:05
