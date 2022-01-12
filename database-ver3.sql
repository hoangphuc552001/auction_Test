CREATE DATABASE  IF NOT EXISTS `auction` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 */;
USE `auction`;
-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: localhost    Database: auction
-- ------------------------------------------------------
-- Server version	8.0.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `automation`
--

DROP TABLE IF EXISTS `automation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `user` int(11) NOT NULL,
                              `offer` float NOT NULL,
                              `product` int(11) NOT NULL,
                              PRIMARY KEY (`id`),
                              KEY `automation-user_idx` (`user`),
                              KEY `automation-product_idx` (`product`),
                              CONSTRAINT `automation-product` FOREIGN KEY (`product`) REFERENCES `product` (`id`),
                              CONSTRAINT `automation-user` FOREIGN KEY (`user`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation`
--

LOCK TABLES `automation` WRITE;
/*!40000 ALTER TABLE `automation` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `automation_AFTER_INSERT` AFTER INSERT ON `automation` FOR EACH ROW BEGIN
    declare user int;
    declare increment int;
    declare offer float;
    declare current float;
    set user = (select product.holder from product where product.id = new.product);
    if(user <> new.user) then
        begin
            set user = (select automation.user from automation where automation.user <> new.user and automation.product = new.product and automation.offer > new.offer order by automation.offer desc limit 1);
            set increment = (select product.increment from product where product.id = new.product);
            if (user) then
                begin
                    insert into history(user, offer, product) values(new.user, new.offer, new.product);
                    call UpdateHistory(new.user,new.product,new.offer);
                end;
            else
                begin
                    set current = (select product.current from product where product.id = new.product);
                    set offer = (select automation.offer from automation where automation.user <> new.user and automation.product = new.product and automation.offer >= current order by automation.offer limit 1);
                    if (offer) then
                        insert into history(user, offer, product) values(new.user, offer + increment, new.product);
                        call UpdateHistory(new.user,new.product,offer + increment);
                    else
                        insert into history(user, offer, product) values(new.user, current + increment, new.product);
                        call UpdateHistory(new.user,new.product,current + increment);
                    end if;
                end;
            end if;
        end;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `name` varchar(45) DEFAULT NULL,
                            `parent` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `category-category_idx` (`parent`),
                            CONSTRAINT `category-category` FOREIGN KEY (`parent`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES(1,'Mobile Phone', NULL),(2,'Laptop', NULL),(3,'Tablet', NULL),(4,'Smart Watch', NULL),(5,'E-reader', NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `history` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `user` int(11) NOT NULL,
                           `offer` float NOT NULL,
                           `product` int(11) NOT NULL,
                           `time` datetime DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history`
--

LOCK TABLES `history` WRITE;
/*!40000 ALTER TABLE `history` DISABLE KEYS */;

/*!40000 ALTER TABLE `history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `history_AFTER_INSERT` AFTER INSERT ON `history` FOR EACH ROW BEGIN
    declare current float;
    set current = (select product.current from product where product.id = new.product);
    if(new.offer > current) then
        update product set product.holder = new.user, product.current = new.offer where product.id=new.product;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `image` longtext NOT NULL,
                         `product` int(11) NOT NULL,
                         PRIMARY KEY (`id`),
                         KEY `image-product_idx` (`product`),
                         CONSTRAINT `image-product` FOREIGN KEY (`product`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
INSERT INTO `image` (image,product) VALUES ('/public/imgs/phone/1/1.jpg',1),
                                           ('/public/imgs/phone/1/2.jpg',1),
                                           ('/public/imgs/phone/1/3.jpg',1),
                                           ('/public/imgs/phone/1/4.jpg',1),
                                           ('/public/imgs/phone/2/1.jpg',2),
                                           ('/public/imgs/phone/2/2.jpg',2),
                                           ('/public/imgs/phone/2/3.jpg',2),
                                           ('/public/imgs/phone/2/4.jpg',2),
                                           ('/public/imgs/phone/3/1.jpg',3),
                                           ('/public/imgs/phone/3/2.jpg',3),
                                           ('/public/imgs/phone/3/3.jpg',3),
                                           ('/public/imgs/phone/3/4.jpg',3),
                                           ('/public/imgs/phone/3/5.jpg',3),
                                           ('/public/imgs/phone/4/1.jpg',4),
                                           ('/public/imgs/phone/4/2.jpg',4),
                                           ('/public/imgs/phone/4/3.jpg',4),
                                           ('/public/imgs/phone/4/4.jpg',4),
                                           ('/public/imgs/phone/5/1.jpg',5),
                                           ('/public/imgs/phone/5/2.jpg',5),
                                           ('/public/imgs/phone/5/3.jpg',5),
                                           ('/public/imgs/phone/5/4.jpg',5),
                                           ('/public/imgs/phone/5/5.jpg',5),
                                           ('/public/imgs/phone/6/1.jpg',6),
                                           ('/public/imgs/phone/6/2.jpg',6),
                                           ('/public/imgs/phone/6/3.jpg',6),
                                           ('/public/imgs/phone/6/4.jpg',6),
                                           ('/public/imgs/phone/6/5.jpg',6),
                                           ('/public/imgs/phone/7/1.jpg',7),
                                           ('/public/imgs/phone/7/2.jpg',7),
                                           ('/public/imgs/phone/7/3.jpg',7),
                                           ('/public/imgs/phone/7/4.jpg',7),
                                           ('/public/imgs/phone/7/5.jpg',7),
                                           ('/public/imgs/phone/8/1.jpg',8),
                                           ('/public/imgs/phone/8/2.jpg',8),
                                           ('/public/imgs/phone/8/3.jpg',8),
                                           ('/public/imgs/phone/8/4.jpg',8),
                                           ('/public/imgs/phone/8/5.jpg',8),
                                           ('/public/imgs/phone/9/1.jpg',9),
                                           ('/public/imgs/phone/9/2.jpg',9),
                                           ('/public/imgs/phone/9/3.jpg',9),
                                           ('/public/imgs/phone/9/4.jpg',9),
                                           ('/public/imgs/phone/9/5.jpg',9),
                                           ('/public/imgs/phone/10/1.jpg',10),
                                           ('/public/imgs/phone/10/2.jpg',10),
                                           ('/public/imgs/phone/10/3.jpg',10),
                                           ('/public/imgs/phone/10/4.jpg',10),
                                           ('/public/imgs/phone/10/5.jpg',10),
                                           ('/public/imgs/phone/11/1.jpeg',11),
                                           ('/public/imgs/phone/11/2.jpeg',11),
                                           ('/public/imgs/phone/11/3.jpeg',11),
                                           ('/public/imgs/phone/11/4.jpeg',11),
                                           ('/public/imgs/phone/12/1.jpeg',12),
                                           ('/public/imgs/phone/12/2.jpeg',12),
                                           ('/public/imgs/phone/13/1.jpeg',13),
                                           ('/public/imgs/phone/13/2.jpeg',13),
                                           ('/public/imgs/phone/14/1.jpeg',14),
                                           ('/public/imgs/phone/14/2.jpeg',14),
                                           ('/public/imgs/phone/15/1.jpeg',15),
                                           ('/public/imgs/phone/15/2.jpeg',15),
                                           ('/public/imgs/phone/15/3.jpeg',15),
                                           ('/public/imgs/phone/16/1.jpeg',16),
                                           ('/public/imgs/phone/16/2.jpeg',16),
                                           ('/public/imgs/phone/16/3.jpeg',16),
                                           ('/public/imgs/phone/17/1.jpeg',17),
                                           ('/public/imgs/phone/17/2.jpeg',17),
                                           ('/public/imgs/phone/17/3.jpeg',17),
                                           ('/public/imgs/phone/17/4.jpeg',17),
                                           ('/public/imgs/phone/18/1.jpeg',18),
                                           ('/public/imgs/phone/18/2.jpeg',18),
                                           ('/public/imgs/phone/18/3.jpeg',18),
                                           ('/public/imgs/phone/19/1.jpeg',19),
                                           ('/public/imgs/phone/19/2.jpeg',19),
                                           ('/public/imgs/phone/19/3.jpeg',19),
                                           ('/public/imgs/phone/20/1.jpeg',20),
                                           ('/public/imgs/phone/20/2.jpeg',20),
                                           ('/public/imgs/phone/20/3.jpeg',20),
                                           ('/public/imgs/phone/21/1.jpeg',21),
                                           ('/public/imgs/phone/21/2.jpeg',21),
                                           ('/public/imgs/phone/21/3.jpeg',21),
                                           ('/public/imgs/phone/22/1.jpg',22),
                                           ('/public/imgs/phone/22/2.jpg',22),
                                           ('/public/imgs/phone/22/3.jpg',22),
                                           ('/public/imgs/phone/22/4.jpg',22),
                                           ('/public/imgs/phone/23/1.jpeg',23),
                                           ('/public/imgs/phone/23/2.jpeg',23),
                                           ('/public/imgs/phone/24/1.jpeg',24),
                                           ('/public/imgs/phone/24/2.jpeg',24),
                                           ('/public/imgs/phone/25/1.jpeg',25),
                                           ('/public/imgs/phone/25/2.jpeg',25),
                                           ('/public/imgs/phone/25/1.jpeg',26),
                                           ('/public/imgs/phone/25/2.jpeg',26),
                                           ('/public/imgs/laptop/1/1.jpeg',27),
                                           ('/public/imgs/laptop/1/2.jpeg',27),
                                           ('/public/imgs/laptop/1/3.jpeg',27),
                                           ('/public/imgs/laptop/1/4.jpeg',27),
                                           ('/public/imgs/laptop/2/1.jpeg',28),
                                           ('/public/imgs/laptop/2/2.jpeg',28),
                                           ('/public/imgs/laptop/2/3.jpeg',28),
                                           ('/public/imgs/laptop/2/4.jpeg',28),
                                           ('/public/imgs/laptop/2/5.jpeg',28),
                                           ('/public/imgs/laptop/3/1.jpeg',29),
                                           ('/public/imgs/laptop/3/2.jpeg',29),
                                           ('/public/imgs/laptop/3/3.jpeg',29),
                                           ('/public/imgs/laptop/4/1.jpeg',30),
                                           ('/public/imgs/laptop/4/2.jpeg',30),
                                           ('/public/imgs/laptop/4/3.jpeg',30),
                                           ('/public/imgs/laptop/4/4.jpeg',30),
                                           ('/public/imgs/laptop/4/5.jpeg',30),
                                           ('/public/imgs/laptop/5/1.jpeg',31),
                                           ('/public/imgs/laptop/5/2.jpeg',31),
                                           ('/public/imgs/laptop/5/3.jpeg',31),
                                           ('/public/imgs/laptop/6/1.jpeg',32),
                                           ('/public/imgs/laptop/6/2.jpeg',32),
                                           ('/public/imgs/laptop/6/3.jpeg',32),
                                           ('/public/imgs/laptop/7/1.jpeg',33),
                                           ('/public/imgs/laptop/7/2.jpeg',33),
                                           ('/public/imgs/laptop/7/3.jpeg',33),

                                           ('/public/imgs/laptop/8/1.jpeg',34),
                                           ('/public/imgs/laptop/8/2.jpeg',34),
                                           ('/public/imgs/laptop/8/3.jpeg',34),
                                           ('/public/imgs/laptop/9/1.jpeg',35),
                                           ('/public/imgs/laptop/9/2.jpeg',35),
                                           ('/public/imgs/laptop/9/3.jpeg',35),
                                           ('/public/imgs/laptop/10/1.jpeg',36),
                                           ('/public/imgs/laptop/10/2.jpeg',36),
                                           ('/public/imgs/laptop/10/3.jpeg',36),
                                           ('/public/imgs/laptop/11/1.jpeg',37),
                                           ('/public/imgs/laptop/11/2.jpeg',37),
                                           ('/public/imgs/laptop/11/3.jpeg',37),
                                           ('/public/imgs/laptop/11/4.jpeg',37),
                                           ('/public/imgs/laptop/12/1.jpeg',38),
                                           ('/public/imgs/laptop/12/2.jpeg',38),
                                           ('/public/imgs/laptop/12/3.jpeg',38),
                                           ('/public/imgs/laptop/13/1.jpeg',39),
                                           ('/public/imgs/laptop/13/2.jpeg',39),
                                           ('/public/imgs/laptop/13/3.jpeg',39),
                                           ('/public/imgs/laptop/13/4.jpeg',39),
                                           ('/public/imgs/laptop/14/1.jpeg',40),
                                           ('/public/imgs/laptop/14/2.jpeg',40),
                                           ('/public/imgs/laptop/14/3.jpeg',40),
                                           ('/public/imgs/laptop/15/1.jpeg',41),
                                           ('/public/imgs/laptop/15/2.jpeg',41),
                                           ('/public/imgs/laptop/16/1.jpeg',42),
                                           ('/public/imgs/laptop/16/2.jpeg',42),
                                           ('/public/imgs/laptop/16/3.jpeg',42),
                                           ('/public/imgs/laptop/17/1.jpg',43),
                                           ('/public/imgs/laptop/17/2.jpeg',43),
                                           ('/public/imgs/laptop/17/3.jpeg',43),
                                           ('/public/imgs/laptop/17/4.jpeg',43),
                                           ('/public/imgs/laptop/17/5.jpeg',43),

                                           ('/public/imgs/laptop/18/1.jpeg',44),
                                           ('/public/imgs/laptop/18/2.jpeg',44),
                                           ('/public/imgs/laptop/18/3.jpeg',44),
                                           ('/public/imgs/laptop/19/1.jpeg',45),
                                           ('/public/imgs/laptop/19/2.jpeg',45),
                                           ('/public/imgs/laptop/19/3.jpeg',45),
                                           ('/public/imgs/laptop/20/1.jpeg',46),
                                           ('/public/imgs/laptop/20/2.jpeg',46),

                                           ('/public/imgs/laptop/21/1.jpeg',47),
                                           ('/public/imgs/laptop/21/2.jpeg',47),
                                           ('/public/imgs/laptop/21/3.jpeg',47),
                                           ('/public/imgs/laptop/22/1.jpeg',48),
                                           ('/public/imgs/laptop/22/2.jpeg',48),
                                           ('/public/imgs/laptop/22/3.jpeg',48),
                                           ('/public/imgs/laptop/23/1.jpg',49),
                                           ('/public/imgs/laptop/23/2.jpg',49),
                                           ('/public/imgs/laptop/23/3.jpg',49),
                                           ('/public/imgs/laptop/24/1.jpeg',50),
                                           ('/public/imgs/laptop/24/2.jpeg',50),
                                           ('/public/imgs/laptop/24/3.jpeg',50),
                                           ('/public/imgs/laptop/25/1.jpeg',51),
                                           ('/public/imgs/laptop/25/2.jpeg',51),
                                           ('/public/imgs/laptop/25/3.jpeg',51),
                                           ('/public/imgs/laptop/25/1.jpeg',52),
                                           ('/public/imgs/laptop/25/2.jpeg',52),
                                           ('/public/imgs/laptop/25/3.jpeg',52),

                                           ('/public/imgs/tablet/1/1.jpeg',53),
                                           ('/public/imgs/tablet/1/2.jpeg',53),
                                           ('/public/imgs/tablet/1/3.jpeg',53),
                                           ('/public/imgs/tablet/1/4.jpeg',53),
                                           ('/public/imgs/tablet/2/1.jpeg',54),
                                           ('/public/imgs/tablet/2/2.jpeg',54),
                                           ('/public/imgs/tablet/2/3.jpeg',54),
                                           ('/public/imgs/tablet/2/4.jpeg',54),
                                           ('/public/imgs/tablet/3/1.jpeg',55),
                                           ('/public/imgs/tablet/3/2.jpeg',55),
                                           ('/public/imgs/tablet/3/3.jpeg',55),
                                           ('/public/imgs/tablet/3/4.jpeg',55),
                                           ('/public/imgs/tablet/4/1.jpeg',56),
                                           ('/public/imgs/tablet/4/2.jpeg',56),
                                           ('/public/imgs/tablet/4/3.jpeg',56),
                                           ('/public/imgs/tablet/5/1.jpeg',57),
                                           ('/public/imgs/tablet/5/2.jpeg',57),
                                           ('/public/imgs/tablet/5/3.jpeg',57),
                                           ('/public/imgs/tablet/6/1.jpeg',58),
                                           ('/public/imgs/tablet/6/2.jpeg',58),
                                           ('/public/imgs/tablet/6/3.jpeg',58),
                                           ('/public/imgs/tablet/7/1.jpeg',59),
                                           ('/public/imgs/tablet/7/2.jpeg',59),
                                           ('/public/imgs/tablet/7/3.jpeg',59),
                                           ('/public/imgs/tablet/7/4.jpeg',59),
                                           ('/public/imgs/tablet/8/1.jpeg',60),
                                           ('/public/imgs/tablet/8/2.jpeg',60),
                                           ('/public/imgs/tablet/8/3.jpeg',60),
                                           ('/public/imgs/tablet/9/1.jpeg',61),
                                           ('/public/imgs/tablet/9/2.jpeg',61),
                                           ('/public/imgs/tablet/9/3.jpeg',61),
                                           ('/public/imgs/tablet/9/4.jpeg',61),
                                           ('/public/imgs/tablet/10/1.jpeg',62),
                                           ('/public/imgs/tablet/10/2.jpeg',62),
                                           ('/public/imgs/tablet/10/3.jpeg',62),
                                           ('/public/imgs/smartwatch/1/1.jpeg',63),
                                           ('/public/imgs/smartwatch/1/2.jpeg',63),
                                           ('/public/imgs/smartwatch/1/3.jpeg',63),
                                           ('/public/imgs/smartwatch/2/1.jpeg',64),
                                           ('/public/imgs/smartwatch/2/2.jpeg',64),
                                           ('/public/imgs/smartwatch/2/3.jpeg',64),
                                           ('/public/imgs/smartwatch/2/4.jpeg',64),
                                           ('/public/imgs/smartwatch/3/1.jpeg',65),
                                           ('/public/imgs/smartwatch/3/2.jpeg',65),
                                           ('/public/imgs/smartwatch/3/3.jpeg',65),
                                           ('/public/imgs/smartwatch/3/4.jpeg',65),
                                           ('/public/imgs/smartwatch/4/1.jpeg',66),
                                           ('/public/imgs/smartwatch/4/2.jpeg',66),
                                           ('/public/imgs/smartwatch/4/3.jpeg',66),
                                           ('/public/imgs/smartwatch/4/4.jpeg',66),
                                           ('/public/imgs/smartwatch/5/1.jpeg',67),
                                           ('/public/imgs/smartwatch/5/2.jpeg',67),
                                           ('/public/imgs/smartwatch/5/3.jpeg',67),
                                           ('/public/imgs/smartwatch/5/4.jpeg',67),
                                           ('/public/imgs/smartwatch/6/1.jpeg',68),
                                           ('/public/imgs/smartwatch/6/2.jpeg',68),
                                           ('/public/imgs/smartwatch/6/3.jpeg',68),
                                           ('/public/imgs/smartwatch/7/1.jpeg',69),
                                           ('/public/imgs/smartwatch/7/2.jpeg',69),
                                           ('/public/imgs/smartwatch/7/3.jpeg',69),
                                           ('/public/imgs/smartwatch/7/4.jpeg',69),
                                           ('/public/imgs/smartwatch/8/1.jpeg',70),
                                           ('/public/imgs/smartwatch/8/2.jpeg',70),
                                           ('/public/imgs/smartwatch/8/3.jpeg',70),
                                           ('/public/imgs/smartwatch/8/4.jpeg',70),
                                           ('/public/imgs/smartwatch/9/1.jpeg',71),
                                           ('/public/imgs/smartwatch/9/2.jpeg',71),
                                           ('/public/imgs/smartwatch/9/3.jpeg',71),
                                           ('/public/imgs/smartwatch/9/4.jpeg',71),
                                           ('/public/imgs/smartwatch/10/1.jpeg',72),
                                           ('/public/imgs/smartwatch/10/2.jpeg',72),
                                           ('/public/imgs/smartwatch/10/3.jpeg',72),
                                           ('/public/imgs/smartwatch/10/4.jpeg',72),


                                           ('/public/imgs/ereader/1/1.jpeg',73),
                                           ('/public/imgs/ereader/1/2.jpeg',73),
                                           ('/public/imgs/ereader/1/3.jpeg',73),
                                           ('/public/imgs/ereader/2/1.jpeg',74),
                                           ('/public/imgs/ereader/2/2.jpeg',74),
                                           ('/public/imgs/ereader/2/3.jpeg',74),
                                           ('/public/imgs/ereader/2/4.jpeg',74),
                                           ('/public/imgs/ereader/3/1.jpeg',75),
                                           ('/public/imgs/ereader/3/2.jpeg',75),
                                           ('/public/imgs/ereader/3/3.jpeg',75),
                                           ('/public/imgs/ereader/4/1.jpeg',76),
                                           ('/public/imgs/ereader/4/2.jpeg',76),
                                           ('/public/imgs/ereader/4/3.jpeg',76),
                                           ('/public/imgs/ereader/5/1.jpeg',77),
                                           ('/public/imgs/ereader/5/2.jpeg',77),
                                           ('/public/imgs/ereader/5/3.jpeg',77),
                                           ('/public/imgs/ereader/6/1.jpeg',78),
                                           ('/public/imgs/ereader/6/2.jpeg',78),
                                           ('/public/imgs/ereader/6/3.jpeg',78),
                                           ('/public/imgs/ereader/7/1.jpeg',79),
                                           ('/public/imgs/ereader/7/2.jpeg',79),
                                           ('/public/imgs/ereader/7/3.jpeg',79),
                                           ('/public/imgs/ereader/8/1.jpeg',80),
                                           ('/public/imgs/ereader/8/2.jpeg',80),
                                           ('/public/imgs/ereader/8/3.jpeg',80),
                                           ('/public/imgs/ereader/9/1.jpeg',81),
                                           ('/public/imgs/ereader/9/2.jpeg',81),
                                           ('/public/imgs/ereader/9/3.jpeg',81),
                                           ('/public/imgs/ereader/10/1.jpeg',82),
                                           ('/public/imgs/ereader/10/2.jpeg',82),
                                           ('/public/imgs/ereader/10/3.jpeg',82);
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp`
--

DROP TABLE IF EXISTS `otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp` (
                       `id` int(11) NOT NULL AUTO_INCREMENT,
                       `start` datetime DEFAULT CURRENT_TIMESTAMP,
                       `end` datetime DEFAULT NULL,
                       `email` varchar(100) NOT NULL,
                       `otp` varchar(6) NOT NULL,
                       PRIMARY KEY (`id`),
                       KEY `otp-user_idx` (`email`),
                       CONSTRAINT `otp-user` FOREIGN KEY (`email`) REFERENCES `user` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `otp_BEFORE_INSERT` BEFORE INSERT ON `otp` FOR EACH ROW BEGIN
    set new.end = new.start + interval 15 minute;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `name` varchar(45) NOT NULL,
                           `seller` int(11) NOT NULL,
                           `start` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           `end` datetime NOT NULL,
                           `cap` float unsigned NOT NULL,
                           `current` float unsigned NOT NULL DEFAULT '0',
                           `increment` float DEFAULT '0',
                           `holder` int(11) DEFAULT NULL,
                           `info` varchar(45) DEFAULT NULL,
                           `bids` int(10) unsigned NOT NULL DEFAULT '0',
                           `description` longtext,
                           `category` int(11) DEFAULT NULL,
                           `image` longtext NOT NULL,
                           `status` varchar(45) DEFAULT NULL,
                           `allow` tinyint(1) DEFAULT 0,
                           `renew` tinyint(1) DEFAULT 0,
                           `annoucement`  varchar(300) DEFAULT NULL,
                           PRIMARY KEY (`id`),
                           KEY `product-seller_idx` (`seller`),
                           KEY `product-holder_idx` (`holder`,`info`),
                           KEY `product-category_idx` (`category`),
                           FULLTEXT KEY `name` (`name`,`description`),
                           CONSTRAINT `product-category` FOREIGN KEY (`category`) REFERENCES `category` (`id`),
                           CONSTRAINT `product-seller` FOREIGN KEY (`seller`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--
ALTER TABLE product
    ADD FULLTEXT(name);
ALTER TABLE product
    ADD FULLTEXT(description);
LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'OPPO A15',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000, 5199000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1,'/public/imgs/phone/1/1.jpg','bidding',0,0,NULL)
                           , (2, 'OPPO A54',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,4199000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/2/1.jpg','bidding',0,0,NULL)
                           , (3, 'OPPO A20',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000, 7199000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/3/1.jpg','bidding',0,0,NULL)
                           , (4, 'OPPO A30',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',16500000,6500000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/4/1.jpg','bidding',0,0,NULL)
                           , (5, 'Galaxy S21',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/5/1.jpg','bidding',0,0,NULL)
                           , (6, 'Galaxy S22',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/6/1.jpg','bidding',0,0,NULL)
                           , (7, 'Galaxy S23',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/7/1.jpg','bidding',0,0,NULL)
                           , (8, 'Galaxy S24',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/8/1.jpg','bidding',0,0,NULL)
                           , (9, 'Galaxy S25',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/9/1.jpg','bidding',0,0,NULL)
                           , (10, 'Galaxy S26',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/10/1.jpg','bidding',0,0,NULL)
                           , (11, 'Galaxy S27',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/11/1.jpeg','bidding',0,0,NULL)
                           , (12, 'Galaxy S28',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/12/1.jpeg','bidding',0,0,NULL)
                           , (13, 'Galaxy S29',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/13/1.jpeg','bidding',0,0,NULL)
                           , (14, 'Galaxy S30',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/14/1.jpeg','bidding',0,0,NULL)
                           , (15, 'Galaxy S31',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/15/1.jpeg','bidding',0,0,NULL)
                           , (16, 'Galaxy S32',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/16/1.jpeg','bidding',0,0,NULL)
                           , (17, 'Galaxy S33',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/17/1.jpeg','bidding',0,0,NULL)
                           , (18, 'Galaxy S34',null,'2021-12-1 20:47:00','2022-4-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/18/1.jpeg','bidding',0,0,NULL)
                           , (19, 'Galaxy S35',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/19/1.jpeg','bidding',0,0,NULL)
                           , (20, 'Galaxy S36',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/20/1.jpeg','bidding',0,0,NULL)
                           , (21, 'Galaxy S37',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/21/1.jpeg','bidding',0,0,NULL)
                           , (22, 'Galaxy S38',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/22/1.jpg','bidding',0,0,NULL)
                           , (23, 'Galaxy S39',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/23/1.jpeg','bidding',0,0,NULL)
                           , (24, 'Galaxy S40',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/24/1.jpeg','bidding',0,0,NULL)
                           , (25, 'Galaxy S41',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,12000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/25/1.jpeg','bidding',0,0,NULL)
                           , (26, 'Galaxy S100',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,5600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>6.52 inch, droplets screen; LCD; Corning Gorilla Glass 3; 720 x 1600 (HD+); 16 million colors</td></tr><tr><td>CPU:</td><td>Helio G35 8 core; max 2.3GHz; IMG GE8320</td></tr><tr><td>RAM:</td><td>3GB</td></tr><tr><td>Camera back:</td><td>13 MP; F/2.2; Light flash behind;</td></tr><tr><td>Camera front:</td><td>5 MP; F/2.4</td></tr><tr><td>Internal memory:</td><td>32GB</td></tr><tr><td>Memory stick:</td><td>Maximum memory card support 1TB</td></tr><tr><td>Multi sim support:</td><td>Dual nano-SIM + 1 memory card slot</td></tr><tr><td>Operating System:</td><td>ColorOS 11, Android Platform 11</td></tr><tr><td>Wifi:</td><td>2.4G/5G, 802.11 a/b/g/n/ac</td></tr><tr><td>Pin:</td><td>4230mAh (Typ)</td></tr></tbody></table></figure>',1, '/public/imgs/phone/25/1.jpeg','bidding',0,0,NULL)
                           , (27, 'Dell Vostro 5510',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',50000000,15600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/1/1.jpeg','bidding',0,0,NULL)
                           , (28, 'Dell Vostro 3400',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/2/1.jpeg','bidding',0,0,NULL)
                           , (29, 'Dell Inspiron 5410',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',28600000,18600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/3/1.jpeg','bidding',0,0,NULL)
                           , (30, 'Lenovo Ideapad 3',null,'2021-12-1 20:47:00','2022-5-31 00:00:00',0,23600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/4/1.jpeg','bidding',0,0,NULL)
                           , (31, 'Dell Vostro 3500',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/5/1.jpeg','bidding',0,0,NULL)
                           , (32, 'Dell Vostro 3510',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/6/1.jpeg','bidding',0,0,NULL)
                           , (33, 'Dell Vostro 3520',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/7/1.jpeg','bidding',0,0,NULL)
                           , (34, 'Dell Vostro 3530',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',30000000,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/8/1.jpeg','bidding',0,0,NULL)
                           , (35, 'Dell Vostro 3540',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/9/1.jpeg','bidding',0,0,NULL)
                           , (36, 'Dell Vostro 3550',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/10/1.jpeg','bidding',0,0,NULL)
                           , (37, 'Dell Vostro 3560',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/11/1.jpeg','bidding',0,0,NULL)
                           , (38, 'Dell Vostro 3570',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/12/1.jpeg','bidding',0,0,NULL)
                           , (39, 'Dell Vostro 3580',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/13/1.jpeg','bidding',0,0,NULL)
                           , (40, 'Dell Vostro 3590',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/14/1.jpeg','bidding',0,0,NULL)
                           , (41, 'Dell Vostro 3600',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/15/1.jpeg','bidding',0,0,NULL)
                           , (42, 'Dell Vostro 3610',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/16/1.jpeg','bidding',0,0,NULL)
                           , (43, 'Dell Vostro 3620',null,'2021-12-1 20:47:00','2022-2-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/17/1.jpg','bidding',0,0,NULL)
                           , (44, 'Dell Vostro 3630',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/18/1.jpeg','bidding',0,0,NULL)
                           , (45, 'Dell Vostro 3640',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/19/1.jpeg','bidding',0,0,NULL)
                           , (46, 'Dell Vostro 3650',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/20/1.jpeg','bidding',0,0,NULL)
                           , (47, 'Dell Vostro 3660',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/21/1.jpeg','bidding',0,0,NULL)
                           , (48, 'Dell Vostro 3670',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/22/1.jpeg','bidding',0,0,NULL)
                           , (49, 'Dell Vostro 3680',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/23/1.jpg','bidding',0,0,NULL)
                           , (50, 'Dell Vostro 3690',null,'2021-12-1 20:47:00','2022-3-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/24/1.jpeg','bidding',0,0,NULL),
(51, 'Dell Vostro 36940',null,'2021-12-1 20:47:00','2022-5-1 00:00:00',0,25600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/25/1.jpeg','bidding',0,0,NULL),

(52, 'Dell Vostro 36941',null,'2021-12-4 7:10:00','2022-12-4 6:45:00',30000000,26000000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>15.6Inch Full HD</td></tr><tr><td>Processor:</td><td>Ryzen 7 5700U 1.8GHz to 4.3 GHz-8Mb</td></tr><tr><td>Memory:</td><td>8Gb (Two SODIMM slots)</td></tr><tr><td>Hard Disk:</td><td>512GB SSD (two M.2 solid-state drives (M.2 2230 or M.2 2280)</td></tr><tr><td>Operating System:</td><td>Win11 + OfficeHS2021</td></tr><tr><td>Graphics Card:</td><td>Integrated AMD Radeon Graphics</td></tr><tr><td>Webcam:</td><td>Yes</td></tr><tr><td>Size:</td><td>35.6 x 22.8 x 1.79 cm</td></tr><tr><td>Weight:</td><td>1.55 kg</td></tr><tr><td>Pin Type:</td><td>4 cell</td></tr><tr><td>Connecting:</td><td>WiFi 802.11a/b/g - Bluetooth 5.0; Two USB 3.2 Gen 1 ports/ One USB 3.2 Gen 1 Type-C port with DisplayPort 1.4 and Power Delivery/One USB 3.2 Gen 1 Type-C/HDMI 1.4 port/One SD-card slot</td></tr></tbody></table></figure>',2, '/public/imgs/laptop/25/1.jpeg','bidding',0,0,NULL)
                           ,(53, 'Tablet 1',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/1/1.jpeg','bidding',0,0,NULL)
                           ,( 54, 'Tablet 2',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/2/1.jpeg','bidding',0,0,NULL)
                           ,( 55, 'Tablet 3',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/3/1.jpeg','bidding',0,0,NULL)
                           ,( 56, 'Tablet 4',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/4/1.jpeg','bidding',0,0,NULL)
                           ,( 57, 'Tablet 5',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/5/1.jpeg','bidding',0,0,NULL)
                           ,( 58, 'Tablet 6',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/6/1.jpeg','bidding',0,0,NULL)
                           ,( 59, 'Tablet 7',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/7/1.jpeg','bidding',0,0,NULL)
                           ,( 60, 'Tablet 8',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/8/1.jpeg','bidding',0,0,NULL)
                           ,( 61, 'Tablet 9',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/9/1.jpeg','bidding',0,0,NULL)
                           ,( 62, 'Tablet 10',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen:</td><td>PLS LCD</td></tr><tr><td>Size:</td><td>Length 244.5 mm - Horizontal 154.3 mm - Thick 7.0 mm</td></tr><tr><td>CPU:</td><td>Exynos 9611 8 cores</td></tr><tr><td>RAM:</td><td>4 GB</td></tr><tr><td>Internal Memory:</td><td>64 GB</td></tr><tr><td>Camera:</td><td>Beauty mode, Autofocus, Touch focus, Face detection, HDR, Panorama</td></tr><tr><td>Memory Stick:</td><td>Micro SD</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 a/b/g/n/ac, Dual-band, Wi-Fi hotspot</td></tr><tr><td>Weight:</td><td>467 g</td></tr><tr><td>Pin:</td><td>7040 mAh</td></tr></tbody></table></figure>',3, '/public/imgs/tablet/10/1.jpeg','bidding',0,0,NULL)
                           ,( 63, 'Smart Watch 1',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/1/1.jpeg','bidding',0,0,NULL)
                           ,( 64, 'Smart Watch 2',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/2/1.jpeg','bidding',0,0,NULL)
                           ,( 65, 'Smart Watch 3',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/3/1.jpeg','bidding',0,0,NULL)
                           ,( 66, 'Smart Watch 4',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/4/1.jpeg','bidding',0,0,NULL)
                           ,( 67, 'Smart Watch 5',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/5/1.jpeg','bidding',0,0,NULL)
                           ,( 68, 'Smart Watch 6',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/6/1.jpeg','bidding',0,0,NULL)
                           ,( 69, 'Smart Watch 7',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/7/1.jpeg','bidding',0,0,NULL)
                           ,( 70, 'Smart Watch 8',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/8/1.jpeg','bidding',0,0,NULL)
                           ,( 71, 'Smart Watch 9',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/9/1.jpeg','bidding',0,0,NULL)
                           ,( 72, 'Smart Watch 10',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,2600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Screen Size:</td><td>1.3 inch Color Touch Screen (240 x 240)</td></tr><tr><td>Pin using time:</td><td>Lithium-Polymer, 690mAh, standby time up to 72 hours</td></tr><tr><td>Face material:</td><td>ABS plastic + Silicon</td></tr><tr><td>Language:</td><td>Multi language</td></tr><tr><td>Utilities:</td><td>Positioning, Look up journey history, Listen to calls + 2-way messages, SOS emergency calls, Health monitoring features, Safe zoning, Alarms</td></tr></tbody></table></figure>',4, '/public/imgs/smartwatch/10/1.jpeg','bidding',0,0,NULL)
                           ,( 73, 'E Reader 1',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/1/1.jpeg','bidding',0,0,NULL)
                           ,( 74, 'E Reader 2',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/2/1.jpeg','bidding',0,0,NULL)
                           ,( 75, 'E Reader 3',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/3/1.jpeg','bidding',0,0,NULL)
                           ,( 76, 'E Reader 4',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/4/1.jpeg','bidding',0,0,NULL)
                           ,( 77, 'E Reader 5',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/5/1.jpeg','bidding',0,0,NULL)
                           ,( 78, 'E Reader 6',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/6/1.jpeg','bidding',0,0,NULL)
                           ,( 79, 'E Reader 7',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/7/1.jpeg','bidding',0,0,NULL)
                           ,( 80, 'E Reader 8',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/8/1.jpeg','bidding',0,0,NULL)
                           ,( 81, 'E Reader 9',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/9/1.jpeg','bidding',0,0,NULL)
                           ,( 82, 'E Reader 10',null,'2021-12-4 7:10:00','2022-6-4 6:45:00',10000000,1600000,100000,null,null,0,'<figure class="table"><table><tbody><tr><td>Material:</td><td>Metal</td></tr><tr><td>Screen:</td><td>IPS. 10.1"; 800 x 1280 Pixel. 16M</td></tr><tr><td>Size :</td><td>160.4 x 9.5 x 241.6mm</td></tr><tr><td>CPU:</td><td>SC9863A; Octa-Core; 8 cores;1.60 GHz; IMG8322</td></tr><tr><td>RAM:</td><td>3 GB</td></tr><tr><td>Internal Memory:</td><td>32 GB</td></tr><tr><td>Camera:</td><td>Front 2.0 MP, Face detection, Beauty, HDR; Sau 5.0 MP, Pro mode, HDR, Autofocus, Panorama, LED Flash, Phase detection focus, Beauty mode, Night shot, Time Lapse, Digital Zoom, Face detection</td></tr><tr><td>Memory Stick:</td><td>MicroSD; Supports memory cards up to 128 GB</td></tr><tr><td>3G:</td><td>4G</td></tr><tr><td>Wifi:</td><td>Wi-Fi 802.11 b/g/n, 2.4GHz</td></tr><tr><td>Trọng lượng:</td><td>510 g</td></tr><tr><td>Pin:</td><td>6000 mAh; Lithium polymer</td></tr></tbody></table></figure>',5, '/public/imgs/ereader/10/1.jpeg','bidding',0,0,NULL);

/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `product_AFTER_UPDATE` BEFORE UPDATE ON `product` FOR EACH ROW BEGIN
    IF new.end < old.start THEN
        BEGIN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid end date!';
        END;
    END IF;
    IF (old.status = new.status and old.status <> 'bidding') THEN
        BEGIN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Bidding expires!';
        END;
    END IF;
    IF new.current >= old.cap and old.cap <> 0 THEN
        BEGIN
            set new.current = old.cap;
            set new.status = 'sold';
        END;
    END IF;
    set new.info = (select name from user where user.id = new.holder);
    set new.bids = (select count(*) from history where history.product=new.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
                            `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                            `expires` int(11) unsigned NOT NULL,
                            `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
                            PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('aWFoc4uJJbi3PUjHM-XWDGg6AfWW1bRE',1578584856,'{\"cookie\":{\"originalMaxAge\":3600000,\"expires\":\"2020-01-09T14:58:50.917Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"authenticated\":true,\"user\":{\"id\":3,\"name\":\"Lena\",\"email\":\"lena@gmail.com\",\"privilege\":\"admin\",\"rating\":8.3}}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `name` varchar(100) NOT NULL,
                        `email` varchar(100) NOT NULL,
                        `birthday` date NOT NULL,
                        `password` varchar(255) NOT NULL,
                        `privilege` varchar(45) DEFAULT NULL,
                        `rating` float DEFAULT NULL,
                        `request` varchar(15) DEFAULT NULL,
                        `address` nvarchar(100) DEFAULT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--
LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Dumping events for database 'auction'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `Refresh_Product` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `e_store_ts` ON SCHEDULE EVERY 1 HOUR STARTS '2020-01-09 21:44:10' ON COMPLETION NOT PRESERVE ENABLE DO call Refresh() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'auction'
--
/*!50003 DROP PROCEDURE IF EXISTS `Refresh` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Refresh`()
BEGIN
    update product set status = 'sold' where end < now() and status = 'bidding' and bids > 0;
    update product set status = 'expired' where end < now() and status = 'bidding' and bids = 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateHistory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateHistory`(user int, product int, offer float)
BEGIN
    declare host int;
    set host = (select automation.user from automation where automation.user <> user and automation.product= product and automation.offer > offer order by automation.offer desc limit 1);
    if(host) then
        begin
            declare increment float;
            set increment = (select auction.product.increment from product where auction.product.id=product);
            insert into history (user, offer, product) values (host, offer + increment, product);
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist` (
                             `user` int(11) NOT NULL AUTO_INCREMENT,
                             `product` int(11) DEFAULT NULL,
                             KEY `fk_watchlist_user_idx` (`user`),
                             KEY `fk_watchlist_product_idx` (`product`),
                             CONSTRAINT `fk_watchlist_product` FOREIGN KEY (`product`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
                             CONSTRAINT `fk_watchlist_user` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating`(
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `product` nvarchar(30) DEFAULT NULL,
                         `bidder` int(11) DEFAULT NULL,
                         `seller` int(11) DEFAULT NULL,
                         `like` int(11) DEFAULT NULL,
                         `time` datetime,
                         `sender` nvarchar(10) DEFAULT NULL,
                         `comment` nvarchar(50) DEFAULT NULL,
                         PRIMARY KEY (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `mailwon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mailwon`(
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `productid` int(11) DEFAULT NULL,
                         `email` varchar(100) DEFAULT NULL,
                         `check` tinyint(1) DEFAULT 0,
                         PRIMARY KEY (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `category`
--
DROP TABLE IF EXISTS `reject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reject`(
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `productid` int(11) DEFAULT NULL,
                          `userid` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `category`
--
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `category`
--
DROP TABLE IF EXISTS `canceldeal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `canceldeal`(
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `productid` int(11) DEFAULT NULL,
                         `userid` int(11) DEFAULT NULL,
                         PRIMARY KEY (`id`)

) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `category`
--
LOCK TABLES `category` WRITE;

--
-- Dumping data for table `watchlist`
--

--
-- Dumping events for database 'auction'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


