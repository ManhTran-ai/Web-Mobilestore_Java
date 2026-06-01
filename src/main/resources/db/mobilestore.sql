-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: localhost    Database: mobilestore
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpu4bcbluhsxagirmbdn7dilm5` (`variant_id`),
  KEY `FKg5uhi8vpsuy0lgloxk2h4w5o6` (`user_id`),
  KEY `idx_cart_user` (`user_id`),
  CONSTRAINT `FK_cart_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`),
  CONSTRAINT `FKg5uhi8vpsuy0lgloxk2h4w5o6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (22,1,68,14),(51,1,126,5);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_item`
--

DROP TABLE IF EXISTS `cart_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `cart_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quantity` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjcyd5wv4igqnw413rgxbfu4nv` (`product_id`),
  KEY `FKjnaj4sjyqjkr4ivemf9gb25w` (`user_id`),
  KEY `FK3fx72yo9k5xauka8mlto7a8bf` (`variant_id`),
  CONSTRAINT `FK3fx72yo9k5xauka8mlto7a8bf` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`),
  CONSTRAINT `FKjcyd5wv4igqnw413rgxbfu4nv` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FKjnaj4sjyqjkr4ivemf9gb25w` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_item`
--

LOCK TABLES `cart_item` WRITE;
/*!40000 ALTER TABLE `cart_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Mobile'),(2,'Tablet'),(3,'MacBook');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_phone` varchar(255) DEFAULT NULL,
  `district_id` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `order_status` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `payment_status` varchar(255) DEFAULT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `shipping_cost` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `vnp_order_id` varchar(255) DEFAULT NULL,
  `vnp_transaction_id` varchar(255) DEFAULT NULL,
  `ward_code` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `FKcpl0mjoeqhxvgeeeq5piwpd3i` (`user_id`),
  CONSTRAINT `FKcpl0mjoeqhxvgeeeq5piwpd3i` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `order_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` double DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKlb8mofup9mi791hraxt9wlj5u` (`order_id`),
  KEY `FKb8bg2bkty0oksa3wiq5mp5qnc` (`product_id`),
  KEY `FKbefv6bj4521cnkru5r9iwdvml` (`variant_id`),
  CONSTRAINT `FKb8bg2bkty0oksa3wiq5mp5qnc` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  CONSTRAINT `FKbefv6bj4521cnkru5r9iwdvml` FOREIGN KEY (`variant_id`) REFERENCES `product_variant` (`variant_id`),
  CONSTRAINT `FKlb8mofup9mi791hraxt9wlj5u` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `order_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` double DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `order_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKjyu2qbqt8gnvno9oe9j2s2ldk` (`order_id`),
  KEY `idx_order_details_order` (`order_id`),
  KEY `FK_order_variant` (`variant_id`),
  CONSTRAINT `FK_order_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`),
  CONSTRAINT `FKjyu2qbqt8gnvno9oe9j2s2ldk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (1,12000000,1,24,78),(2,12000000,1,25,78),(3,20000000,1,26,76),(4,15000000,1,27,71),(5,15000000,1,28,71),(6,15000000,1,29,71),(7,15000000,1,30,71),(8,12500000,1,31,68),(9,12500000,1,32,68),(10,12500000,1,33,68),(11,9000000,1,34,16),(12,9000000,1,35,16),(13,12500000,1,36,68),(14,12500000,1,37,68),(15,12500000,1,38,68),(16,12500000,1,39,68),(17,50000000,1,40,74),(18,15000000,1,40,71),(19,20000000,2,40,76),(20,50000000,1,41,74),(21,9000000,2,42,16),(22,50000000,1,43,74),(23,50000000,1,44,74),(24,50000000,2,45,74),(25,50000000,1,46,74),(26,50000000,1,47,74),(27,15000000,1,48,71),(28,50000000,1,49,74),(29,50000000,1,50,74),(30,50000000,1,51,74),(31,50000000,1,52,74),(32,50000000,1,53,74),(33,50000000,1,54,74),(34,50000000,1,55,74),(35,50000000,1,56,74),(36,50000000,1,57,74),(37,50000000,1,58,74),(38,14500000,2,59,56);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_status` varchar(255) DEFAULT NULL,
  `order_date` datetime(6) DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `shipping_address` text,
  `customer_phone` varchar(20) DEFAULT NULL,
  `note` text,
  `payment_method` varchar(20) DEFAULT 'CASH',
  `payment_status` varchar(20) DEFAULT 'PENDING',
  `vnp_transaction_id` varchar(100) DEFAULT NULL,
  `vnp_order_id` varchar(100) DEFAULT NULL,
  `shipping_cost` decimal(10,2) DEFAULT '0.00',
  `district_id` int(11) DEFAULT NULL,
  `ward_code` varchar(20) DEFAULT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `FK32ql8ubntj5uh44ph9659tiih` (`user_id`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_status` (`order_status`),
  KEY `idx_orders_created` (`order_date`),
  CONSTRAINT `FK32ql8ubntj5uh44ph9659tiih` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (10,'PENDING','2025-12-30 13:31:16.216000',99500000,6,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(11,'PENDING','2026-01-10 18:04:13.043000',15000000,5,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(12,'PENDING','2026-01-15 05:34:24.770000',69500000,6,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(13,'PENDING','2026-01-15 05:40:28.878000',69000000,6,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(14,'PENDING','2026-01-15 06:46:16.934000',61000000,6,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(15,'COMPLETED','2026-01-16 08:25:12.955000',60000000,6,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(16,'PENDING','2026-03-10 18:48:09.529000',12500000,9,NULL,NULL,NULL,'CASH','PENDING','15445629','ORDER_1773168450094',0.00,NULL,NULL,NULL),(17,'PENDING','2026-03-11 04:43:35.762000',20000000,8,NULL,NULL,NULL,'CASH','PENDING','15446140','ORDER_1773204156553',0.00,NULL,NULL,NULL),(18,'PENDING','2026-03-14 03:39:01.843000',20000000,9,NULL,NULL,NULL,'CASH','PENDING','15450276','ORDER_1773459490787',0.00,NULL,NULL,NULL),(19,'PENDING','2026-03-16 04:16:34.581000',15000000,9,NULL,NULL,NULL,'CASH','PENDING',NULL,NULL,0.00,NULL,NULL,NULL),(24,'PENDING','2026-04-18 16:05:17.533000',9600000,14,NULL,NULL,NULL,'CASH','PENDING','15502712','ORDER_1776528133138',0.00,NULL,NULL,NULL),(25,'PENDING','2026-04-18 16:40:54.483000',9600000,14,'','','','CASH','PENDING','15502744','ORDER_1776530403186',0.00,NULL,NULL,NULL),(26,'PENDING','2026-04-18 16:44:12.680000',20000000,14,'','','','CASH','PENDING','15502747','ORDER_1776530599040',0.00,NULL,NULL,NULL),(27,'PENDING','2026-04-18 16:52:01.528000',15000000,14,'','','','CASH','PENDING','15502750','ORDER_1776531085667',0.00,NULL,NULL,NULL),(28,'PENDING','2026-04-18 17:04:16.035000',15000000,14,'','','','CASH','PENDING','15502763','ORDER_1776531815666',0.00,1454,'20813',NULL),(29,'PENDING','2026-04-18 17:13:40.354000',15000000,14,'','','','CASH','PENDING','15502769','ORDER_1776532385082',0.00,1454,'20813',NULL),(30,'PENDING','2026-04-18 17:23:53.820000',15000000,14,'','','','CASH','PENDING','15502778','ORDER_1776532937588',0.00,1454,'20813',NULL),(31,'PENDING','2026-04-18 17:26:58.702000',12500000,14,'','','','CASH','PENDING','15502780','ORDER_1776533186022',0.00,1454,'20813',NULL),(32,'PENDING','2026-04-18 17:32:12.924000',12500000,14,'','','','CASH','PENDING','15502785','ORDER_1776533485213',0.00,1454,'20813',NULL),(33,'PENDING','2026-04-18 17:34:06.535000',12500000,14,'','','','CASH','PENDING','15502788','ORDER_1776533610835',0.00,1454,'20813',NULL),(34,'PENDING','2026-04-18 17:38:22.020000',3600000,14,'','','','CASH','PENDING','15502793','ORDER_1776533841035',0.00,1454,'20813',NULL),(35,'PENDING','2026-04-18 17:46:11.250000',3600000,14,'','','','CASH','PENDING','15502796','ORDER_1776534340911',0.00,1454,'20813',NULL),(36,'PENDING','2026-04-18 17:53:43.178000',12500000,14,'','','','CASH','PENDING','15502801','ORDER_1776534765378',0.00,1454,'20813',NULL),(37,'PENDING','2026-04-18 18:13:45.818000',12500000,14,'','','','CASH','PENDING','15502812','ORDER_1776535990995',0.00,1454,'20813',NULL),(38,'PENDING','2026-04-18 18:24:07.940000',12500000,14,'','','','CASH','PENDING','15502815','ORDER_1776536604682',60500.00,1454,'20813',NULL),(39,'DELIVERED','2026-04-20 17:29:45.950000',12500000,15,'','0978120646','','CASH','PENDING',NULL,NULL,0.00,2028,'560801',NULL),(40,'DELIVERED','2026-05-25 19:47:21.798000',105000000,5,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,60500.00,2163,'230317',NULL),(41,'PENDING','2026-05-29 22:17:30.860000',50000000,5,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1778,'471003',NULL),(42,'PENDING','2026-05-30 19:10:42.074000',7200000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1883,'61094',NULL),(43,'PENDING','2026-05-30 19:19:30.983000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(44,'PENDING','2026-05-30 19:22:17.945000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(45,'PENDING','2026-05-30 19:22:45.430000',100000000,16,'','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(46,'CANCELLED','2026-05-30 19:23:33.347000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(47,'PENDING','2026-05-30 19:24:15.676000',50000000,16,'','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(48,'PENDING','2026-05-30 19:24:41.899000',15000000,16,'','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(49,'PENDING','2026-05-30 19:29:48.682000',50000000,16,'','0394921920 ','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(50,'PENDING','2026-05-30 19:30:10.404000',50000000,16,'xã Hàm Thuận Nam, tỉnh Lâm Đồng','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(51,'PENDING','2026-05-30 19:30:29.714000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(52,'PENDING','2026-05-30 19:34:01.892000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(53,'PENDING','2026-05-30 19:51:03.354000',50000000,5,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1770,'370604',NULL),(54,'PENDING','2026-05-30 19:51:50.005000',50000000,5,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1782,'610205',NULL),(55,'PENDING','2026-05-30 21:46:57.733000',50000000,16,'','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(56,'PENDING','2026-05-30 21:50:09.429000',50000000,16,'','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(57,'PENDING','2026-05-30 21:50:35.194000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','CASH','PENDING',NULL,NULL,82500.00,1935,'600408',NULL),(58,'PENDING','2026-05-30 21:54:46.588000',50000000,16,'HAM THUAN NAM, LAM DONG','0394921920','','VNPAY','PAID','15562556','ORDER_1780152858097',82500.00,1935,'600408',NULL),(59,'COMPLETED','2026-05-30 21:56:40.466000',29000000,NULL,NULL,'0394921920','','OFFLINE','PAID',NULL,NULL,0.00,NULL,NULL,NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_tokens`
--

DROP TABLE IF EXISTS `otp_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `otp_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `otp_code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expired_at` datetime NOT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `attempt_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_email_otp` (`email`,`otp_code`),
  KEY `idx_expired` (`expired_at`),
  KEY `idx_email_valid` (`email`,`is_used`,`expired_at`,`attempt_count`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_tokens`
--

LOCK TABLES `otp_tokens` WRITE;
/*!40000 ALTER TABLE `otp_tokens` DISABLE KEYS */;
INSERT INTO `otp_tokens` VALUES (1,'hothanhhai879@gmail.com','131019','2026-05-25 19:43:56','2026-05-25 19:48:57',0,0);
/*!40000 ALTER TABLE `otp_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_token`
--

DROP TABLE IF EXISTS `password_reset_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `password_reset_token` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `expires_at` datetime(6) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `used` bit(1) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_token`
--

LOCK TABLES `password_reset_token` WRITE;
/*!40000 ALTER TABLE `password_reset_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `password_reset_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_token` (`token`),
  KEY `FK_password_reset_user` (`user_id`),
  CONSTRAINT `FK_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (1,'7011a61cd08847b2a5f5de5274470af2',13,'manht7000@gmail.com','2026-03-15 16:08:47',1,'2026-03-15 15:38:46');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `discount` bigint(20) DEFAULT '0',
  `manufacturer` varchar(255) DEFAULT NULL,
  `product_condition` varchar(255) DEFAULT NULL,
  `product_info` text,
  `product_name` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `FK1mtsbur82frn64de7balymq9s` (`category_id`),
  CONSTRAINT `FK1mtsbur82frn64de7balymq9s` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variant`
--

DROP TABLE IF EXISTS `product_variant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product_variant` (
  `variant_id` int(11) NOT NULL AUTO_INCREMENT,
  `color` varchar(255) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `quantity_in_stock` int(11) DEFAULT NULL,
  `storage` varchar(255) DEFAULT NULL,
  `variant_image` text,
  `product_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`variant_id`),
  KEY `FKgrbbs9t374m9gg43l6tq1xwdj` (`product_id`),
  CONSTRAINT `FKgrbbs9t374m9gg43l6tq1xwdj` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variant`
--

LOCK TABLES `product_variant` WRITE;
/*!40000 ALTER TABLE `product_variant` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_variant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `product_variants` (
  `variant_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `storage` varchar(50) DEFAULT NULL,
  `price` bigint(20) NOT NULL,
  `quantity_in_stock` int(11) NOT NULL,
  `variant_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`variant_id`),
  KEY `FK_variant_product` (`product_id`),
  CONSTRAINT `FK_variant_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,10,'Natural Titanium','128GB',12000000,5,'images/products/e0dd45b7-58e3-4382-8612-ff268fe06921.png'),(9,11,'Natural Titanium','128GB',25000000,3,'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),(10,11,'Blue Titanium','128GB',25000000,3,'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),(11,11,'White Titanium','128GB',25000000,2,'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),(12,11,'Black Titanium','128GB',25000000,2,'images/products/a773815c-3857-4466-86d5-84209c7f2b37.png'),(13,12,'Black','64GB',7000000,20,'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),(14,12,'White','64GB',7000000,15,'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),(15,12,'Blue','64GB',7000000,15,'images/products/01d57027-ac66-4333-9098-38ee7861c181.png'),(16,13,'Black','64GB',9000000,18,'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),(17,13,'White','64GB',9000000,15,'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),(18,13,'Green','64GB',9000000,15,'images/products/2ff2f283-7386-4e96-a91c-6d89ef259bbe.png'),(19,14,'Midnight','128GB',13000000,15,'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),(20,14,'Starlight','128GB',13000000,10,'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),(21,14,'Blue','128GB',13000000,8,'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),(22,14,'Pink','128GB',13000000,7,'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),(23,14,'Midnight','256GB',15500000,5,'images/products/2d5c3d94-c977-4dc8-b2fa-2192fe1eb282.png'),(24,15,'Midnight','128GB',15000000,8,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(25,15,'Purple','128GB',15000000,8,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(26,15,'Blue','128GB',15000000,7,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(27,15,'Starlight','128GB',15000000,7,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(28,15,'Midnight','256GB',18000000,5,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(29,15,'Purple','256GB',18000000,5,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(30,15,'Blue','256GB',18000000,4,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(31,15,'Yellow','256GB',18000000,3,'images/products/1693a3e0-f704-43e2-b735-d1b45b8bc5b9.png'),(32,16,'Deep Purple','128GB',19000000,10,'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),(33,16,'Gold','128GB',19000000,8,'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),(34,16,'Silver','128GB',19000000,7,'images/products/51319fad-853d-4cd3-9f65-2da560db816a.png'),(35,17,'Black','128GB',18000000,10,'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),(36,17,'Pink','128GB',18000000,10,'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),(37,17,'Green','128GB',18000000,10,'images/products/0b7a70ec-43ce-48d4-b1f4-acf7a28b2ab3.png'),(38,18,'Natural Titanium','256GB',28000000,8,'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),(39,18,'Blue Titanium','256GB',28000000,7,'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),(40,18,'White Titanium','256GB',28000000,5,'images/products/33aca89a-fbc1-4921-829c-4e5b9137d9eb.png'),(41,19,'Black','128GB',22000000,15,'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),(42,19,'White','128GB',22000000,15,'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),(43,19,'Blue','128GB',22000000,10,'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),(44,19,'Teal','128GB',22000000,10,'images/products/0f11c558-01e9-4d63-a30c-77f597d98238.png'),(45,20,'Black','128GB',24000000,10,'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),(46,20,'White','128GB',24000000,10,'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),(47,20,'Blue','128GB',24000000,10,'images/products/5a37c593-51bf-4b7b-adbc-d0bfcd620f8e.png'),(48,21,'Black','128GB',27000000,30,'images/products/564c168a-cae1-4b16-9f79-a3078bc89fb2.jpeg'),(49,21,'White','128GB',27000000,25,'images/products/1ecdc28a-6a10-4bec-a7d6-6ad8a89af80a.png'),(50,21,'Blue','128GB',26000000,25,'images/products/09dea404-f0c6-444e-b1f0-9578f30c96f6.png'),(51,21,'Teal','128GB',26999000,20,'images/products/1ecdc28a-6a10-4bec-a7d6-6ad8a89af80a.png'),(52,23,'Silver','64GB',10500000,20,'images/products/b6dc74a6-da46-467d-aaa5-533b18c859fa.png'),(53,23,'Blue','64GB',10500000,20,'images/products/b6dc74a6-da46-467d-aaa5-533b18c859fa.png'),(54,24,'Space Gray','64GB',14500000,10,'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),(55,24,'Starlight','64GB',14500000,7,'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),(56,24,'Blue','64GB',14500000,8,'images/products/0af0a633-b612-4218-b042-ef822e99264f.png'),(57,25,'Space Gray','64GB',7500000,25,'images/products/de33773e-bc38-46c8-a7f0-cd1e7e71d655.png'),(58,25,'Silver','64GB',7500000,25,'images/products/de33773e-bc38-46c8-a7f0-cd1e7e71d655.png'),(59,26,'Silver','256GB',29000000,7,'images/products/prom4.png'),(60,26,'Space Black','256GB',29000000,7,'images/products/prom4.png'),(61,27,'Space Gray','128GB',17000000,8,'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),(62,27,'Starlight','128GB',17000000,5,'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),(63,27,'Blue','128GB',17000000,5,'images/products/0c334961-a3e2-4b40-93f1-b45bce5ce52a.png'),(64,28,'Space Gray','128GB',15000000,10,'images/products/mini7.png'),(65,28,'Starlight','128GB',15000000,9,'images/products/mini7.png'),(66,29,'Space Gray','64GB',25000000,15,'images/products/mini_6.png'),(67,29,'Purple','64GB',25000000,13,'images/products/mini_6.png'),(68,30,'Blue','64GB',12500000,10,'images/products/12.png'),(69,30,'Black','64GB',12500000,8,'images/products/12.png'),(70,30,'White','64GB',12500000,8,'images/products/12.png'),(71,31,'Black','128GB',15000000,2,'images/products/16e.png'),(72,31,'White','128GB',15000000,4,'images/products/16e.png'),(73,31,'Red','128GB',15000000,4,'images/products/16e.png'),(74,32,'Silver','256GB',50000000,33,'images/products/4eef0b69-5658-4014-b9ff-d65881d378b3.png'),(75,32,'Space Black','256GB',50000000,50,'images/products/4eef0b69-5658-4014-b9ff-d65881d378b3.png'),(76,33,'Silver','128GB',20000000,4,'images/products/07fb6758-a24f-4993-8141-92dcbe635838.png'),(77,33,'Space Black','128GB',20000000,25,'images/products/07fb6758-a24f-4993-8141-92dcbe635838.png'),(78,10,'Blue Titanium','128GB',12000000,10,'images/products/96aee917-a333-496d-94e3-4a30eb4c2930.png'),(79,34,'Cam Vũ Trụ','256GB',37000000,10,'images/products/50882775-c3f9-4b0e-b683-aa9ac4ac82f1.webp'),(80,34,'Cam Vũ Trụ','512GB',43000000,19,'images/products/e1f0ead4-f39f-45d9-9dfb-907ec9982a73.webp'),(81,34,'Cam Vũ Trụ','1T',50000000,14,'images/products/cc85d954-1f54-444f-b091-d42ea882f0b4.webp'),(82,34,'Cam Vũ Trụ','2T',63000000,13,'images/products/78079d5d-1a26-47e9-b253-8073353399bb.webp'),(83,34,'Xanh Đậm','256GB',37000000,22,'images/products/8c101758-3c55-4cb2-950b-09ce07959c22.webp'),(84,34,'Xanh Đậm','512GB',44000000,11,'images/products/a2d0a4b5-6c46-4cc3-b433-beb469026f31.webp'),(85,34,'Xanh Đậm','1T',50000000,33,'images/products/cd452a20-6b2a-4827-be1a-20645e26f19f.webp'),(86,34,'Xanh Đậm','2T',66000000,44,'images/products/a81f0394-457b-47d9-92d7-338b1c827dee.webp'),(87,35,'Vàng','256GB',20000000,11,'images/products/26fc40e0-4374-4245-a624-d3920eb23571.jpg'),(88,35,'Vàng','256GB',27000000,12,'images/products/e2456ce8-9def-4522-99ab-df9b64db80ce.jpg'),(89,35,'Tím','512GB',21000000,21,'images/products/5f0fd9af-575d-4cd6-a89e-6a128c0c1aa0.jpg'),(90,35,'Tím','128GB',17000000,12,'images/products/58369796-e625-4166-b08f-9e0f84ad9896.jpg'),(91,35,'Trắng','256GB',18000000,11,'images/products/db69b545-50d6-4b11-864a-c924381667c1.jpg'),(92,35,'Đen','512GB',26000000,12,'images/products/e7163630-42a7-4bdb-9e4b-63ce38fa78ea.jpg'),(93,35,'Trắng','512GB',25000000,21,'images/products/41898f3b-35d5-4be8-b4ae-e7461f7d6c8a.jpg'),(94,35,'Đen','128GB',20000000,32,'images/products/16b919aa-fa26-4f60-8a94-5a44bcf20343.jpg'),(95,36,'Black','128GB',20000000,12,'images/products/e9d673d7-be50-4d71-becb-3ec12b8c09df.jpg'),(96,36,'Black','256GB',25000000,22,'images/products/dcd225c3-a8e8-4cae-86ca-12ed94f83479.jpg'),(97,36,'Vàng','128GB',20000000,21,'images/products/34dc3c7a-8fb3-41fd-af4f-2105a928826f.jpg'),(98,36,'Vàng','512GB',25000000,21,'images/products/5281acc0-2ec1-44e9-8c65-a9d9d1d60687.jpg'),(99,36,'Xanh Rêu','256GB',23000000,12,'images/products/b00ea314-2547-4047-81db-dae50da83d33.jpg'),(100,36,'Xanh Rêu','256GB',20000000,32,'images/products/4fae6390-c4b0-43c0-830d-327e4f39af72.jpg'),(101,36,'Trắng','512GB',20000000,12,'images/products/09e65f0c-e532-4e7a-9428-eb429902010d.png'),(102,36,'Trắng','128GB',15000000,22,'images/products/f7e99ca4-fdee-48a6-b69c-5c800d6f464e.png'),(103,37,'Titan Sa Mạc','256GB',37000000,33,'images/products/b32040bb-ead5-4d1c-801c-83f3433c37c3.webp'),(104,37,'Trắng','256GB',35000000,23,'images/products/15f451cc-a0c6-4eec-b7ed-fbe937b0b7ed.webp'),(105,37,'Đen','512GB',43000000,33,'images/products/0d2c5577-0f5c-4a42-84ad-35a0b1a0132d.webp'),(106,37,'Titan tự nhiên','512GB',45000000,32,'images/products/abc25170-a53e-41a1-8a9c-86ece5735176.webp'),(107,38,'Vàng','128GB',30000000,23,'images/products/86d6231c-87b5-4c48-901d-85371c55c3a2.webp'),(108,38,'Vàng','256GB',35000000,45,'images/products/44b29899-8541-47f6-bfbc-aa477498f042.webp'),(109,38,'Vàng','512GB',37000000,34,'images/products/9ea41993-bfb8-4b68-8205-0fd90897d57b.webp'),(110,38,'Xanh lá','128GB',20000000,46,'images/products/4dfa4c42-1750-4f36-aee9-a818a588f0ac.webp'),(111,38,'Xanh lá','256GB',25000000,12,'images/products/dffdd5e9-4356-4f6f-b14c-a812a970fdd7.webp'),(112,38,'Xanh dương','512GB',25999000,34,'images/products/d14d2f11-3028-461d-b7f8-c97ef22e738a.webp'),(113,38,'Xanh dương','128GB',29000000,34,'images/products/49aa6b8a-d2a1-407e-9b15-46f42881ad0b.webp'),(114,39,'Xám','128GB',14000000,22,'images/products/d9931e19-8727-47a6-b83f-a5da57e0b0c7.webp'),(115,39,'Xám','256GB',19000000,22,'images/products/05cf2309-3116-4680-9029-3b8439610fd5.webp'),(116,39,'Vàng','128GB',14000000,22,'images/products/f628984a-8594-46a9-a326-26a9a6d3d10c.webp'),(117,39,'Vàng','512GB',20000000,12,'images/products/bc0ff856-8e68-4fb9-9de2-99263a8a0370.webp'),(118,39,'Xanh dương','256GB',23000000,23,'images/products/2df3753c-79d9-4a79-98b4-8742093df436.webp'),(119,39,'Xanh dương','512GB',26000000,34,'images/products/b9fe3ee3-ff62-4ac1-9d4d-e374d948cffe.webp'),(120,39,'Tím','128GB',23000000,344,'images/products/b400c421-c650-40c1-9456-a2b9a96572d1.webp'),(121,39,'Tím','1T',34000000,43,'images/products/cbe80c24-d96d-4515-8781-089e33b31ea4.webp'),(122,40,'Vàng','128GB',9000000,12,'images/products/b154bc9b-5db0-4eff-83e6-53ec62f7067b.webp'),(123,40,'Vàng','256GB',14000000,12,'images/products/986f1273-6174-4d5d-ada5-bb0f78e5ddea.webp'),(124,40,'Xanh','128GB',9000000,10,'images/products/262bbb66-ad46-4cfc-8b75-011b92d18cee.webp'),(125,40,'Xanh','256GB',14000000,12,'images/products/a7761e07-f9eb-4113-9e67-01d4a2ea96c4.webp'),(126,40,'Hồng','256GB',8999000,12,'images/products/aa0a096c-eb4a-44dc-b06a-4680bb1c5ca0.webp'),(127,40,'Hồng','512GB',14000000,12,'images/products/b9572d34-4a3f-470f-9c4b-6036fa14ca2e.webp'),(128,40,'Xám','128GB',9000000,15,'images/products/9c3e992d-356f-48ba-a7dc-617602518c3d.webp'),(129,40,'Xám','256GB',14000000,12,'images/products/9e9367fc-3b46-4280-b1cb-3409ceb002ac.webp'),(130,41,'Xanh','128GB',25000000,31,'images/products/f02ce8c6-f482-4864-978c-6c75dc4e713c.webp'),(131,41,'Xanh','256GB',26998000,31,'images/products/474ee6fc-627e-49d7-96e2-428b27b05e2d.webp'),(132,41,'Xanh','512GB',27000000,31,'images/products/84319501-740f-46be-9e14-cdeb0e7b8b04.webp'),(133,41,'Xanh','1T',20000000,31,'images/products/c06fa7d7-4d8c-4136-adba-c379577bdb3a.webp'),(134,41,'Vàng','1T',22999000,31,'images/products/549f2bac-a0d4-4755-b830-0462b31c5d1d.webp'),(135,41,'Vàng','256GB',21000000,31,'images/products/485ba759-4be7-4af6-b793-ce8e6d75ee70.webp'),(136,41,'Vàng','512GB',26997000,31,'images/products/1d66c29d-6198-4115-acee-30c82dd7eb58.webp'),(137,41,'Vàng','128GB',24998000,37,'images/products/02002b9d-0bd1-45ee-b8a7-c5c8968bf3e3.webp');
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `manufacturer` varchar(255) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_condition` varchar(255) NOT NULL,
  `product_info` varchar(255) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `discount` int(11) DEFAULT '0',
  PRIMARY KEY (`product_id`),
  KEY `FKog2rp4qthbtt2lfyhfo32lsw9` (`category_id`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_name` (`product_name`),
  CONSTRAINT `FKog2rp4qthbtt2lfyhfo32lsw9` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (10,'APPLE','iPhone 17 Pro','Mới','iPhone 17 Pro – Chip A19 Pro mạnh mẽ, màn hình Super Retina XDR 6.3\", camera 48MP, pin 4500mAh, sạc nhanh USB-C.',1,20),(11,'APPLE','iPhone 15 Pro','Mới','iPhone 15 Pro – Chip A17 Pro (3nm), khung viền Titan bền nhẹ, màn hình 120Hz, camera zoom 3x, cổng USB-C tốc độ cao.',1,30),(12,'APPLE','iPhone XR','Mới','iPhone XR – Chip A12 Bionic, màn hình Liquid Retina 6.1\", camera đơn 12MP sắc nét, Face ID, nhiều màu sắc lựa chọn.',1,50),(13,'APPLE','iPhone 11','Mới','iPhone 11 – Chip A13 Bionic, hệ thống camera kép 12MP (Góc rộng & Siêu rộng), màn hình 6.1\", pin bền bỉ cả ngày.',1,60),(14,'APPLE','iPhone 13','Mới','iPhone 13 – Chip A15 Bionic, màn hình Super Retina XDR, cụm camera chéo đặc trưng, thời lượng pin cải tiến vượt trội.',1,30),(15,'APPLE','iPhone 14','Mới','iPhone 14 – Chip A15 Bionic (5 nhân GPU), tính năng an toàn qua vệ tinh, camera cải thiện chụp thiếu sáng, màn hình 6.1\".',1,20),(16,'APPLE','iPhone 14 Pro','Mới','iPhone 14 Pro – Chip A16 Bionic, màn hình Always-On với Dynamic Island, camera chính 48MP, độ sáng cực cao 2000 nits.',1,0),(17,'APPLE','iPhone 15','Mới','iPhone 15 – Chip A16 Bionic, Dynamic Island tiện lợi, camera chính 48MP, cổng sạc USB-C hiện đại, thiết kế mặt lưng kính pha màu.',1,0),(18,'APPLE','iPhone 15 Pro Max','Mới','iPhone 15 Pro Max – Chip A17 Pro, khung Titan, camera Zoom quang học 5x, màn hình 6.7\", nút Action tùy chỉnh linh hoạt.',1,0),(19,'APPLE','iPhone 16','Mới','iPhone 16 – Chip A18 mạnh mẽ, nút Camera Control mới, hỗ trợ Apple Intelligence, camera kép 48MP, màn hình 6.1\".',1,0),(20,'APPLE','iPhone 16 Plus','Mới','iPhone 16 Plus – Chip A18, màn hình lớn 6.7\", dung lượng pin cực khủng, nút Camera Control, hỗ trợ trí tuệ nhân tạo Apple.',1,0),(21,'APPLE','iPhone 17','Mới','iPhone 17 – Chip A19 thế hệ mới, màn hình 120Hz ProMotion (dự kiến), camera 48MP, hỗ trợ AI chuyên sâu, sạc nhanh USB-C.',1,0),(23,'APPLE','iPad Gen 10','Mới','iPad Gen 10 – Chip A14 Bionic, thiết kế tràn viền hiện đại, màn hình 10.9\", cổng USB-C, hỗ trợ Magic Keyboard Folio.',2,0),(24,'APPLE','iPad Air 5 M1','Mới','iPad Air 5 – Chip M1 mạnh vượt trội, camera trước Ultra Wide 12MP với Center Stage, kết nối 5G siêu tốc, hỗ trợ Apple Pencil 2.',2,0),(25,'APPLE','iPad Gen 9','Mới','iPad Gen 9 – Chip A13 Bionic, màn hình Retina 10.2\" với True Tone, camera trước Ultra Wide 12MP, nút Home Touch ID truyền thống.',2,0),(26,'APPLE','iPad Pro M4','Mới','iPad Pro M4 – Chip M4 đột phá, màn hình Ultra Retina XDR (OLED), thiết kế siêu mỏng, hiệu năng đồ họa chuyên nghiệp.',2,0),(27,'APPLE','iPad Air M2','Mới','iPad Air M2 – Chip M2 hiệu suất cao, hỗ trợ Apple Pencil Pro, màn hình Liquid Retina sắc nét, kích thước 11\" hoặc 13\".',2,0),(28,'APPLE','iPad mini 7','Mới','iPad mini 7 – Chip A17 Pro, thiết kế nhỏ gọn 8.3\", hỗ trợ Apple Pencil Pro, Wi-Fi 6E siêu nhanh, camera 12MP sắc nét.',2,0),(29,'APPLE','iPad mini 6','Mới','iPad mini 6 – Chip A15 Bionic, thiết kế tràn viền 8.3\", Touch ID tích hợp nút nguồn, cổng USB-C, nhỏ gọn và mạnh mẽ.',2,0),(30,'APPLE','iPhone 12','Mới','iPhone 12 – Chip A14 Bionic, thiết kế cạnh vuông, màn hình Super Retina XDR OLED, hỗ trợ kết nối 5G, mặt kính Ceramic Shield.',1,0),(31,'APPLE','iPhone 16e','Mới','iPhone 16e – Phiên bản tối ưu chip A18, thiết kế mỏng nhẹ, hỗ trợ Apple Intelligence, màn hình 6.1\" sắc nét, giá rẻ.',1,0),(32,'APPLE','iPad M4 Pro','Mới','iPad Pro M4 – Chip M4 thế hệ mới nhất, màn hình OLED 120Hz, hỗ trợ Pencil Pro, dung lượng lưu trữ lên đến 2TB.',2,0),(33,'APPLE','iPad M5 Pro','Mới','iPad Pro M5 – Chip M5 (dự kiến), hiệu năng AI siêu cấp, màn hình OLED độ sáng cao, tiêu chuẩn mới cho máy tính bảng.',2,0),(34,'APPLE','iPhone 17 Pro Max','Mới','Chính hãng, Mới 100%, Nguyên seal\r\nMàn hình: 6.9\" OLED Super Retina XDR\r\nCamera sau: 3 x 48MP\r\nCamera trước: 18MP\r\nCPU: Apple A19 Pro\r\nRAM: 12GB, bộ nhớ: 256GB\r\nHệ điều hành: iOS',1,0),(35,'APPLE','iPhone 14 Pro Max','Mới','',1,0),(36,'APPLE','iPhone 11 Pro Max','Mới','iPhone 11 Pro Max sở hữu hệ thống 3 camera đẳng cấp, một bước nhảy vọt về thời lượng pin và con chip mới có hiệu năng mạnh mẽ chưa từng thấy. Mạnh mẽ, khác biệt và chuyên nghiệp, iPhone 11 Pro Max hoàn toàn xứng đáng với tên gọi.',1,0),(37,'APPLE','iPhone 16 Pro Max','Mới','Camera chính: 48MP, f/1.78, 24mm, 2µm, chống rung quang học dịch chuyển cảm biến thế hệ thứ hai, Focus Pixels 100%\r\nTelephoto 2x 12MP: 52 mm, ƒ/1.6\r\nCamera góc siêu rộng: 48MP, 13 mm,ƒ/2.2 và trường ảnh 120°, Hybrid Focus Pixels, ảnh có độ phân giải',1,0),(38,'APPLE','iPhone 13 Pro Max','Mới','Camera góc rộng: 12MP, ƒ/1.5\r\nCamera góc siêu rộng: 12MP, ƒ/1.8\r\nCamera tele : 12MP, /2.8',1,0),(39,'APPLE','iPad Air M3','Mới','Camera góc rộng: 12MP, ƒ/1.8, Độ thu phóng kỹ thuật số lên đến 5x\r\nChụp ảnh toàn cảnh Panorama: 63MP',2,0),(40,'APPLE','iPad Air M1','Mới','Kích thước màn hình	\r\n10.9 inches\r\nCông nghệ màn hình	\r\nIPS LCD\r\nCamera sau	\r\n12 MP góc rộng,khẩu độ f/1.8\r\nCamera trước	\r\n7 MP, khẩu độ f/2.2',2,0),(41,'APPLE','iPhone 14 Plus','Mới','Apple đã không cho ra mắt thêm bất cứ phiên bản Plus nào kể từ năm 2017, nhưng cuối cùng thì hãng cũng đã quyết định \'hồi sinh\' tên gọi này với phiên bản iPhone 14 Plus 128GB Quốc Tế.',1,0);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `review` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_reply` text,
  `admin_reply_at` datetime(6) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `is_approved` bit(1) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKiyof1sindb9qiqr9o8npj8klt` (`product_id`),
  KEY `FKiyf57dy48lyiftdrf7y87rnxi` (`user_id`),
  CONSTRAINT `FKiyf57dy48lyiftdrf7y87rnxi` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `FKiyof1sindb9qiqr9o8npj8klt` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text,
  `admin_reply` text,
  `admin_reply_at` timestamp NULL DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_approved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`),
  KEY `FK_reviews_product` (`product_id`),
  CONSTRAINT `FK_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,15,30,5,'sản phẩm tốt','shop cảm ơn bạn rất nhiều','2026-05-11 18:08:30','2026-05-11 15:27:59','2026-05-11 18:08:30',1);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_step`
--

DROP TABLE IF EXISTS `shipping_step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `shipping_step` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status_description` text,
  `status_name` varchar(255) DEFAULT NULL,
  `updated_date` date DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3w5ot1t6rws0euaesgq46rddg` (`order_id`),
  CONSTRAINT `FK3w5ot1t6rws0euaesgq46rddg` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_step`
--

LOCK TABLES `shipping_step` WRITE;
/*!40000 ALTER TABLE `shipping_step` DISABLE KEYS */;
/*!40000 ALTER TABLE `shipping_step` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slider_image`
--

DROP TABLE IF EXISTS `slider_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `slider_image` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `display_order` int(11) DEFAULT NULL,
  `image_url` text,
  `is_active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slider_image`
--

LOCK TABLES `slider_image` WRITE;
/*!40000 ALTER TABLE `slider_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `slider_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slider_images`
--

DROP TABLE IF EXISTS `slider_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `slider_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_url` varchar(500) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slider_images`
--

LOCK TABLES `slider_images` WRITE;
/*!40000 ALTER TABLE `slider_images` DISABLE KEYS */;
INSERT INTO `slider_images` VALUES (14,'images/slider/63f4762e-e23d-4a27-aed1-febb0021c195.jpg',0);
/*!40000 ALTER TABLE `slider_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_likes`
--

DROP TABLE IF EXISTS `user_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_like` (`customer_id`,`product_id`),
  KEY `fk_user_likes_product` (`product_id`),
  CONSTRAINT `fk_user_likes_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_likes_user` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_likes`
--

LOCK TABLES `user_likes` WRITE;
/*!40000 ALTER TABLE `user_likes` DISABLE KEYS */;
INSERT INTO `user_likes` VALUES (6,7,12),(7,7,14),(8,7,16),(9,8,10),(10,8,19),(11,8,21),(12,9,11),(13,9,26);
/*!40000 ALTER TABLE `user_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `role_name` varchar(255) DEFAULT NULL,
  `account_status` varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE | INACTIVE | DELETED',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Thời điểm xóa mềm',
  `oauth_provider` varchar(20) DEFAULT NULL,
  `oauth_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `shipping_address` text,
  `customer_phone` varchar(20) DEFAULT NULL,
  `note` text,
  `district_id` int(11) DEFAULT NULL,
  `ward_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  KEY `FK6e7f1kfvvn2k48olww485qvo3` (`role_name`),
  KEY `idx_users_account_status` (`account_status`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (5,'$2a$10$342ro1UObsU/8YP0Dy1HNOQ92Fxy3hYI/KLTc0ygh7j5Q6NyeIyP6','levantai','ADMIN','ACTIVE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'$2a$10$w0KzLYHDgs5PI0Q4r3BjRu9RM3UbNa4IHSnfIb74KrHsTAlOnRfzW','manh','CUSTOMER','ACTIVE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'$2a$10$bj4SkPMUK3jTJ7FD.9blzeYmCo.bUF5vd1wJVh2ldpIxQ8F5DHetG','hung','CUSTOMER','ACTIVE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,NULL,'tai1','CUSTOMER','ACTIVE',NULL,'google','116054212909485433236','levantai066@gmail.com',NULL,NULL,NULL,NULL,NULL),(9,NULL,'tai2','CUSTOMER','ACTIVE',NULL,'google','110613103348013667969','23130283@st.hcmuaf.edu.vn',NULL,NULL,NULL,NULL,NULL),(13,'$2a$10$KmcjsGN/04htrhRedfIIO.RqacQC3kU9NuhK0Dk84F6P0z7ifEP4K','manh1','CUSTOMER','ACTIVE',NULL,NULL,NULL,'manht7000@gmail.com',NULL,NULL,NULL,NULL,NULL),(14,'$2a$10$NzkDMZg8oeJ5akLVIPgqRuH3wVU0.7FeBBr0oOpd9jsPBHIvO6b2y','taile','CUSTOMER','ACTIVE',NULL,NULL,NULL,'levantaii066@gmail.com','22a/6 đường Thống Nhất, khu phố Tân Hoà, phường Đông Hoà, Thành phố Dĩ An, Tỉnh Bình Dương','0978120646',NULL,1454,'20813'),(15,'$2a$10$YybLYnr4agTft9BiBVslxuDrCaT3tD.dF3RROwh1xw4e1zwwlu4cG','tailevan','CUSTOMER','ACTIVE',NULL,NULL,NULL,'levantai0667@gmail.com',NULL,'0978120646',NULL,2028,'560801'),(16,NULL,'Hồ Thanh Hải','INVENTORY_MANAGER','ACTIVE',NULL,'google','114809370835337981240','hothanhhai879@gmail.com','','','',1935,'600408');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-31 20:24:46
