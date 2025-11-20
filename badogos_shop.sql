-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 20, 2025 at 08:28 PM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `badogos_shop`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addAdress` (IN `cityIN` VARCHAR(100), IN `postalCodeIN` INT(4), IN `nameOfPublicAreaIN` VARCHAR(100), IN `houseNumberIN` INT(4))   BEGIN

INSERT INTO `address`(
	`address`.`city`,
    `address`.`postal_code`,
    `address`.`name_of_public_area`,
    `address`.`house_number`
)
VALUES(
	cityIN,
    postalCodeIN,
    nameOfPublicAreaIN,
    houseNumberIN
);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addBrand` (IN `brandNameIN` VARCHAR(255))   BEGIN
	INSERT INTO `brand`
    (
    	`brand`.`name`
    )
    VALUES
    (
    	brandNameIN
    )
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addCart` (IN `userIdIN` INT(11))   BEGIN
	INSERT INTO `cart`(
    	`cart`.`user_id`
    )
    VALUES(
    	userIdIN
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addCategory` (IN `categoryNameIN` LONGTEXT)   BEGIN
	INSERT INTO `category`
    (
    `category`.`name`
    )
    VALUES
    (
    categoryNameIN
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addDetail` (IN `weightIN` DOUBLE, IN `speciesIN` VARCHAR(255), IN `lengthIN` DOUBLE, IN `heightIN` INT, IN `widthIN` DOUBLE, IN `sizeIN` INT(11), IN `is_setIN` TINYINT(4))   BEGIN

 INSERT INTO `details`(
	`details`.`weight`,
    `details`.`species`,
     `details`.`length`,
     `details`.`height`,
     `details`.`width`,
     `details`.`size`,
     `details`.`is_set`
    )
    VALUES(
	weightIN,
    speciesIN,
    lengthIN,
    heightIN,
    widthIN,
    sizeIN,
    is_setIN
 );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addDiscount` (IN `productIdIN` INT(11), IN `discountRateIN` INT(2))   BEGIN
UPDATE `product`
SET `product`.`discount` = discountRateIN

WHERE `product`.`id` = productIdIN;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addProducts` (IN `nameIN` LONGTEXT, IN `descriptionIN` LONGTEXT, IN `price` INT(5), IN `amount` INT(100), IN `skuIN` VARCHAR(255), IN `detailIdIN` INT(11))   BEGIN
	
    INSERT INTO `product`(
    	`product`.`name`,
        `product`.`description`,
        `product`.`price`,
        `product`.`amount`,
        `product`.`stock_keeping_unit`,
        `product`.`detail_id`
    )
    VALUES(
	nameIN,
    descriptionIN,
    price,
    amount,
    skuIN,
    detailIdIN
 );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addProductToCartProduct` (IN `productIdIN` INT(11), IN `amountOfProductIN` INT(11), IN `cartIdIN` INT(11), IN `userIdIN` INT(11))   BEGIN

INSERT INTO `cart_product` (
`cart_product`.`product_id`,
`cart_product`.`cart_id`,
`cart_product`.`amount`
)
	VALUES (
    	productIdIN,
        cartIdIN,
        amountOfProductIN
    );
   
   INSERT INTO `cart`(
   	`cart`.`user_id`
   
   )VALUES(
   		userIdIN
   );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addReview` (IN `reviewTextIN` VARCHAR(255), IN `reviewstarIN` INT(1), IN `reviewerIdIN` INT(11), IN `reviewedProdIdIN` INT(11))   BEGIN
	INSERT INTO `review`(
		`review`.`product_id`,
        `review`.`user_id`,
        `review`.`review_text`,
        `review`.`review_star`
)
    VALUES(
	reviewedProdIdIN,
    reviewerIdIN,
    reviewTextIN,
    reviewstarIN
)
;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `firstNameIN` VARCHAR(100), IN `lastNameIN` VARCHAR(100), IN `emailIN` VARCHAR(200), IN `passwordIN` VARCHAR(255))   BEGIN
	INSERT INTO `user`(
	`user`.`first_name`,
    `user`.`last_name`,
    `user`.`email`,
    `user`.`password`,
    `user`.`auth_secret`,
    `user`.`guid`,
    `user`.`reg_token`
)
VALUES(
	firstNameIN,
    lastNameIN,
    emailIN,
    SHA2(passwordIN,256),
    "-",
    UUID(),
    UUID()
);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `changeAmount` (IN `productIdIN` INT(11), IN `newProductAmountIN` INT(100))   BEGIN

	UPDATE `product`
	SET `product`.`amount` = newProductAmountIN

	WHERE `product`.`id` = productIdIN;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `changePrice` (IN `productIdIN` INT(11), IN `newPriceIN` INT(10))   BEGIN

UPDATE `product`
SET `product`.`price` = newPriceIN

WHERE `product`.`id` = productIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBrand` (IN `brandIdIN` INT(11))   BEGIN

UPDATE `brand`
SET `brand`.`deleted_at` = CURRENT_TIMESTAMP,
	`brand`.`is_deleted` = 1
WHERE `brand`.`id` = brandIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCategory` (IN `categoryIdIN` INT(11))   BEGIN
	
    UPDATE `category`
    	SET `category`.`is_deleted`=1,
        	`category`.`deleted_at`=CURRENT_TIMESTAMP
    WHERE `category`.`id`=categoryIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePrimaryCategory` (IN `categoryIdIN` INT(11))   BEGIN
	UPDATE `category`
    SET `category`.`category_id` = NULL
    WHERE `category`.`id `= categoryIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProduct` (IN `productIdIN` INT)   BEGIN
	UPDATE `product`
	SET `deleted_at` = CURRENT_TIMESTAMP,
    `is_deleted` = 1
	WHERE `product`.`id` = productIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteReview` (IN `reviewIdIN` INT(11), IN `reviewedProductIdIN` INT(11), IN `reviewerIdIN` INT(11))   BEGIN
	UPDATE `review`
	SET `review`.`deleted_at` = CURRENT_TIMESTAMP

	WHERE `review`.`product_id` = reviewedProductIdIN AND `review`.`user_id`=reviewerIdIN AND `review`.`id`=reviewIdIN
;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser` (IN `userIdIN` INT(11))   BEGIN
	UPDATE `user`
	SET `user`.`deleted_at` = CURRENT_TIMESTAMP

	WHERE `user`.`id` = userIdIN;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAddressById` (IN `addressIdIN` INT(11))   BEGIN
	SELECT * FROM `address`
    WHERE `address`.`is_deleted`=0 AND `address`.`id`= addressIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllAdress` ()   BEGIN
	SELECT * FROM `address`
    WHERE `address`.`is_deleted`=0
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllBrand` ()   BEGIN

SELECT * FROM `brand`
	
    WHERE `brand`.`is_deleted`=0
    ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllCategory` ()   BEGIN

	SELECT * FROM `category`
    
    WHERE `category`.`is_deleted`=0
    ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllReview` ()   BEGIN
	
    SELECT * FROM `review`
    
    WHERE`review`.`is_deleted`=0;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUser` ()   BEGIN
	SELECT * FROM `user`
    WHERE `user`.`is_deleted`=0
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getBrandById` (IN `brandIdIN` INT(11))   BEGIN
	SELECT * FROM `brand`
    WHERE `brand`.`id`=brandIdIN AND `brand`.`is_deleted`=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReviewByProductId` (IN `productIdIN` INT(11))   BEGIN
	SELECT * FROM `review`
    WHERE `review`.`product_id`=productIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReviewByProductIdAndByReviewStar` (IN `productIdIN` INT(11), IN `reviewStarIN` INT(1))   BEGIN
	SELECT *FROM `review`
    
    WHERE `review`.`product_id`=productIdIN AND `review`.`review_star`=reviewStarIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getReviewByUserId` (IN `userIdIN` INT(11))   BEGIN
	SELECT * FROM `review`
    WHERE `review`.`user_id`=userIdIN AND `review`.`is_deleted`=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login` (IN `emailIN` VARCHAR(200), IN `passwordIN` VARCHAR(200))   BEGIN
SELECT
	`user`.`id` AS "user_id",
    `user`.`first_name`,
    `user`.`last_name`,
    `user`.`img`,
    `user`.`last_login`
   
FROM `user`
WHERE `user`.`email`= emailIN AND `user`.`password`= SHA2(passwordIN, 256);

UPDATE `user`
SET `user`.`last_login`=CURRENT_TIMESTAMP
WHERE `user`.`email`= emailIN AND `user`.`password`= SHA2(passwordIN, 256);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `organizeByAmountDecreasing` ()   BEGIN
SELECT *
FROM `product`
WHERE `product`.`deleted_at` IS NULL
ORDER BY `amount` DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `organizeByAmountIncreasing` ()   BEGIN
	SELECT *
FROM `product`
WHERE `product`.`deleted_at` IS NULL
ORDER BY `amount` ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `organizeBySKUDecreasing` ()   BEGIN
	SELECT *
FROM `product`
WHERE `product`.`deleted_at` IS NULL
ORDER BY `id` DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `organizeBySKUIncreasing` ()   BEGIN
	SELECT *
FROM `product`
WHERE `product`.`deleted_at` IS NULL
ORDER BY `id` ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `productAddToCart` (IN `productIdIN` INT)   BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchByBrand` (IN `nameOfBrand` VARCHAR(255))   BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchByProductName` (IN `productNameIN` VARCHAR(255))   BEGIN
SELECT * FROM `product`

WHERE `product`.`name` LIKE productNameIN
;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchByProductSKU` (IN `Stock_Keeping_Unit` VARCHAR(255))   BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBrand` (IN `brandIdIN` INT(11), IN `brandNameIN` VARCHAR(255))  COMMENT 'végrehajtásnál kiveszi a törlést az adott dologról' BEGIN
	UPDATE `brand`
    SET `brand`.`name`=brandNameIN,
    `brand`.`is_deleted`=0,
    `brand`.`deleted_at`=NULL
    	
    WHERE `brand`.`id`=brandIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCategoryIntoSubcategory` (IN `categoryIdIN` INT(11), IN `primaryCategoryIdIN` INT(11))   BEGIN
	UPDATE `category`
    SET `category`.`category_id` = primaryCategoryIdIN
    
    WHERE `category`.`id` = categoryIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCategoryName` (IN `categoryIdIN` INT(11), IN `categoryNameIN` LONGTEXT)   BEGIN
	UPDATE `category`
    	SET `category`.`name`=categoryNameIN,
        `category`.`is_deleted`=0,
        `category`.`deleted_at`= NULL
    WHERE `category`.`id`=categoryIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateReview` (IN `reviewIdIN` INT(11), IN `reviewStarIN` INT(1), IN `reviewTextIN` LONGTEXT)   BEGIN

	UPDATE `review`
    	SET `review`.`review_star`=reviewStarIN,
        `review`.`review_text`=reviewTextIN,
        `review`.`updated_at`=CURRENT_TIMESTAMP
    WHERE `review`.`id`=reviewIdIN;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `id` int(11) NOT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Magyarország',
  `city` varchar(100) NOT NULL,
  `postal_code` int(4) NOT NULL,
  `name_of_public_area` varchar(100) NOT NULL,
  `house_number` int(4) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`id`, `country`, `city`, `postal_code`, `name_of_public_area`, `house_number`, `is_deleted`, `deleted_at`) VALUES
(1, 'Magyarország', 'TesztVáros', 7357, 'utca', 7357, 0, NULL),
(2, 'Magyarország', 'tesztFalu1', 0, 'test1', 0, 0, NULL),
(3, 'Magyarország', 'tesztFalu2', 1, 'teszt1', 1, 0, NULL),
(4, 'Magyarország', 'tesztFalu2', 2, 'test2', 2, 0, NULL),
(5, 'Magyarország', 'tesztFalu3', 3, 'test3', 3, 0, NULL),
(6, 'Magyarország', 'tesztFalu4', 4, 'test4', 4, 0, NULL),
(7, 'Magyarország', 'tesztFalu5', 5, 'test5', 5, 0, NULL),
(8, 'Magyarország', 'tesztFalu6', 6, 'teszt6', 6, 0, NULL),
(9, 'Magyarország', 'tesztFalu7', 7, 'test7', 7, 0, NULL),
(10, 'Magyarország', 'tesztFalu8', 8, 'test8', 8, 0, NULL),
(11, 'Magyarország', 'tesztFalu9', 9, 'test9', 9, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `address_user`
--

CREATE TABLE `address_user` (
  `id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_billing` tinyint(4) DEFAULT NULL,
  `is_delivery` tinyint(4) DEFAULT NULL,
  `is_deleted` tinyint(4) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `address_user`
--

INSERT INTO `address_user` (`id`, `address_id`, `user_id`, `is_billing`, `is_delivery`, `is_deleted`, `deleted_at`) VALUES
(1, 1, 1, 1, 1, NULL, NULL),
(2, 2, 2, 1, 0, NULL, NULL),
(3, 3, 2, NULL, 1, NULL, NULL),
(4, 4, 3, 1, 1, NULL, NULL),
(5, 5, 4, 1, 1, NULL, NULL),
(6, 6, 5, 1, 1, NULL, NULL),
(7, 7, 6, 1, 1, NULL, NULL),
(8, 8, 7, 1, 1, NULL, NULL),
(9, 9, 8, 1, 1, NULL, NULL),
(10, 10, 9, 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

CREATE TABLE `brand` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `brand`
--

INSERT INTO `brand` (`id`, `name`, `is_deleted`, `deleted_at`) VALUES
(1, 'TestBrand1', 0, NULL),
(2, 'TestBrand2', 0, NULL),
(3, 'TestBrand3', 0, NULL),
(4, 'TestBrand4', 0, NULL),
(5, 'TestBrand5', 0, NULL),
(6, 'TestBrand6', 0, NULL),
(7, 'TestBrand7', 0, NULL),
(8, 'TestBrand8', 0, NULL),
(9, 'TestBrand9', 0, NULL),
(10, 'TestBrand10', 0, NULL),
(11, 'TesztBrandWithAddProcedure', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_modified_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `last_modified_at`, `created_at`) VALUES
(1, 1, NULL, '2025-11-20 16:32:53'),
(2, 2, NULL, '2025-11-20 16:33:54'),
(3, 3, NULL, '2025-11-20 16:34:01'),
(4, 4, NULL, '2025-11-20 16:34:04'),
(5, 5, NULL, '2025-11-20 16:34:07'),
(6, 6, NULL, '2025-11-20 16:34:10'),
(7, 7, NULL, '2025-11-20 16:34:12'),
(8, 8, NULL, '2025-11-20 16:34:15'),
(9, 9, NULL, '2025-11-20 16:34:18'),
(10, 10, NULL, '2025-11-20 16:34:21');

-- --------------------------------------------------------

--
-- Table structure for table `cart_product`
--

CREATE TABLE `cart_product` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_at` timestamp NULL DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cart_product`
--

INSERT INTO `cart_product` (`id`, `product_id`, `cart_id`, `created_at`, `last_modified_at`, `amount`) VALUES
(1, 1, 1, '2025-11-20 16:37:30', NULL, 1),
(2, 3, 1, '2025-11-20 16:37:30', NULL, 2),
(3, 5, 2, '2025-11-20 16:45:53', NULL, 1),
(4, 2, 2, '2025-11-20 16:45:53', NULL, 1),
(5, 5, 3, '2025-11-20 16:46:22', NULL, 1),
(6, 2, 3, '2025-11-20 16:46:22', NULL, 1),
(7, 5, 4, '2025-11-20 16:46:39', NULL, 1),
(8, 2, 4, '2025-11-20 16:46:39', NULL, 1),
(9, 5, 5, '2025-11-20 16:46:55', NULL, 1),
(10, 2, 5, '2025-11-20 16:46:55', NULL, 1),
(11, 5, 6, '2025-11-20 16:47:50', NULL, 1),
(12, 2, 6, '2025-11-20 16:47:50', NULL, 1),
(13, 9, 9, '2025-11-20 16:51:00', NULL, 1),
(14, 9, 6, '2025-11-20 16:51:01', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` longtext NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `category_id`, `is_deleted`, `deleted_at`) VALUES
(1, 'Kalapács', NULL, 0, NULL),
(2, 'Dugókulcs', NULL, 0, NULL),
(3, 'Seprű', NULL, 0, NULL),
(4, 'Partvis', 3, 0, NULL),
(5, 'Gumikalapács', 1, 0, NULL),
(6, 'Colstok', 8, 0, NULL),
(7, 'Centi', 8, 0, NULL),
(8, 'Mérőegységek', NULL, 0, NULL),
(9, 'Vízmértékek', NULL, 0, NULL),
(10, 'Nyelek', NULL, 0, NULL),
(11, 'Próba nem tudom', NULL, 0, NULL),
(12, 'Al kategória lesz', 11, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `details`
--

CREATE TABLE `details` (
  `id` int(11) NOT NULL,
  `weight` double DEFAULT NULL COMMENT 'kg-ban',
  `species` varchar(255) DEFAULT NULL,
  `length` double DEFAULT NULL COMMENT 'cm',
  `height` double DEFAULT NULL COMMENT 'cm',
  `width` double DEFAULT NULL COMMENT 'cm',
  `size` int(11) DEFAULT NULL,
  `is_set` tinyint(4) DEFAULT NULL COMMENT 'Szett-e (több dolog egyben)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `details`
--

INSERT INTO `details` (`id`, `weight`, `species`, `length`, `height`, `width`, `size`, `is_set`) VALUES
(1, 2, '(Teszt)', 3, 2, 0, 0, NULL),
(2, 2.3, '(Teszt)', 0, 0, 0, 0, NULL),
(3, 0.1, 'műanyag(Teszt)', 100, 50, 100, NULL, NULL),
(4, 20, 'fém(Teszt)', 100, 100, 100, NULL, NULL),
(5, 0.75, '(Teszt)', 1500, 20, 20, NULL, NULL),
(6, 2.5, 'Fém(Teszt)', 23, 12.5, 10, NULL, NULL),
(7, 50, 'kő(Teszt)', 100, NULL, NULL, 3, NULL),
(8, 1.5, 'fa(Teszt)', 150, 2.5, 5, 5, NULL),
(9, 4.5, '(Teszt)', NULL, NULL, NULL, 5, NULL),
(10, 0.025, '(Teszt)', 100, 100, 100, 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL,
  `status_id` int(2) NOT NULL,
  `address_user_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `order_id` int(8) NOT NULL COMMENT 'rendelés azonosító, 8 jegyű számsor, autómatikus generálással'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `order_date`, `status_id`, `address_user_id`, `payment_method_id`, `order_id`) VALUES
(1, 1, '2025-11-20 08:35:25', 7, 1, 1, 10000000),
(2, 1, '2025-11-20 08:35:25', 1, 1, 1, 10000001),
(3, 1, '2025-11-20 08:35:25', 6, 1, 1, 10000002),
(4, 1, '2025-11-20 08:35:25', 2, 1, 1, 10000003),
(5, 1, '2025-11-20 08:35:25', 5, 1, 1, 10000004),
(6, 1, '2025-11-20 08:35:25', 3, 1, 1, 10000005),
(7, 1, '2025-11-20 08:35:25', 3, 1, 1, 10000006),
(8, 1, '2025-11-20 08:35:25', 4, 1, 1, 10000007),
(9, 1, '2025-11-20 08:35:25', 7, 1, 1, 10000008),
(10, 1, '2025-11-20 08:35:25', 6, 1, 1, 10000009),
(11, 1, '2025-11-20 08:35:25', 6, 1, 1, 10000010),
(12, 1, '2025-11-20 08:35:25', 1, 1, 1, 10000011);

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified_at` timestamp NULL DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_product`
--

INSERT INTO `order_product` (`id`, `order_id`, `product_id`, `created_at`, `modified_at`, `amount`) VALUES
(1, 1, 1, '2025-11-20 09:45:18', NULL, 1),
(2, 1, 3, '2025-11-20 09:45:18', NULL, 1),
(3, 2, 1, '2025-11-20 16:54:54', NULL, 1),
(4, 2, 3, '2025-11-20 16:54:54', NULL, 1),
(5, 1, 2, '2025-11-20 16:54:54', NULL, 3),
(6, 2, 2, '2025-11-20 16:54:54', NULL, 3),
(7, 3, 2, '2025-11-20 16:54:54', NULL, 3),
(8, 2, 7, '2025-11-20 16:54:54', NULL, 3),
(9, 4, 7, '2025-11-20 16:55:41', NULL, 3),
(10, 6, 8, '2025-11-20 16:55:41', NULL, 3),
(11, 9, 2, '2025-11-20 16:56:48', NULL, 30);

-- --------------------------------------------------------

--
-- Table structure for table `payment_method`
--

CREATE TABLE `payment_method` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `payment_method`
--

INSERT INTO `payment_method` (`id`, `name`) VALUES
(1, 'Utánvét');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` longtext NOT NULL,
  `description` longtext NOT NULL,
  `price` int(7) NOT NULL,
  `discount` int(2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `amount` int(100) NOT NULL,
  `detail_id` int(11) NOT NULL,
  `stock_keeping_unit` varchar(255) NOT NULL,
  `brand_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `discount`, `created_at`, `updated_at`, `deleted_at`, `is_deleted`, `amount`, `detail_id`, `stock_keeping_unit`, `brand_id`) VALUES
(1, 'KalapácsTeszt', 'Kalapács teszt leírás', 50000, 0, '2025-10-22 09:44:26', NULL, '2025-10-22 10:14:21', 0, 500, 1, '888888881', NULL),
(2, 'SeprűTeszt', 'Teszt Seprű', 20000, NULL, '2025-10-22 13:28:15', NULL, NULL, 0, 200000, 2, '888888882', NULL),
(3, 'NemTudomCsakTeszt', 'NemTudomCsakTesztDesc', 100, NULL, '2025-10-22 13:58:03', NULL, NULL, 0, 10, 3, '888888883', NULL),
(4, 'Teszt1', 'Nagyon sok szöveg 1', 100, NULL, '2025-11-19 10:07:05', NULL, NULL, 0, 100, 4, '888888884', NULL),
(5, 'Teszt2', 'Nagyon sok szöveg 1', 200, NULL, '2025-11-19 10:07:05', NULL, NULL, 0, 0, 5, '888888885', NULL),
(6, 'Teszt3', 'Nagyon sok szöveg 3', 300, NULL, '2025-11-19 10:09:07', NULL, NULL, 0, 300, 6, '888888886', NULL),
(7, 'Teszt4', 'Nagyon sok szöveg 4', 400, NULL, '2025-11-19 10:09:07', NULL, NULL, 0, 0, 7, '888888887', NULL),
(8, 'Teszt5', 'Nagyon sok szöveg 5', 500, NULL, '2025-11-19 10:10:55', NULL, NULL, 0, 110, 8, '888888888', NULL),
(9, 'Teszt6', 'Nagyon sok szöveg 6', 600, NULL, '2025-11-19 10:10:55', NULL, NULL, 0, 10, 9, '888888889', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_categories`
--

INSERT INTO `product_categories` (`id`, `product_id`, `category_id`) VALUES
(1, 1, 1),
(2, 2, 4),
(3, 3, 5),
(4, 4, 2),
(5, 5, 9),
(6, 6, 10),
(7, 7, 9),
(8, 8, 4),
(9, 9, 6),
(10, 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `image_path` longtext NOT NULL,
  `placement` int(2) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `image_path`, `placement`, `product_id`) VALUES
(1, '', 1, 1),
(2, '', 99, 7),
(3, '', 2, 2),
(4, '', 3, 3),
(5, '', 4, 4),
(6, '', 5, 5),
(7, '', 6, 6),
(8, '', 7, 7),
(9, '', 8, 8),
(10, '', 9, 9);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `review_text` longtext NOT NULL,
  `review_star` int(1) NOT NULL,
  `review_dateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id`, `product_id`, `user_id`, `review_text`, `review_star`, `review_dateTime`, `deleted_at`, `is_deleted`, `updated_at`) VALUES
(1, 1, 1, 'Megint át lesz írva', 3, '2025-11-19 10:55:32', NULL, 0, '2025-11-20 20:01:24'),
(2, 2, 2, '(Teszt2)', 4, '2025-11-19 10:55:32', NULL, 0, NULL),
(3, 3, 3, '(Teszt3)', 5, '2025-11-19 10:56:03', NULL, 0, NULL),
(4, 4, 4, '(Teszt4)', 3, '2025-11-19 10:56:03', NULL, 0, NULL),
(5, 5, 5, '(Teszt5)', 5, '2025-11-19 10:56:35', NULL, 0, NULL),
(6, 6, 6, '(Teszt6)', 4, '2025-11-19 10:56:35', NULL, 0, NULL),
(7, 7, 7, '(Teszt7)', 5, '2025-11-19 10:58:38', NULL, 0, NULL),
(8, 8, 8, '(Teszt8)', 5, '2025-11-19 10:58:38', NULL, 0, NULL),
(9, 9, 9, '(Teszt9)', 5, '2025-11-19 10:59:34', NULL, 0, NULL),
(10, 9, 10, '(Teszt10)', 5, '2025-11-19 10:59:34', NULL, 0, NULL),
(11, 3, 8, 'tessszt', 5, '2025-11-20 12:25:21', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `status`
--

INSERT INTO `status` (`id`, `name`) VALUES
(1, 'Kiszállítva'),
(2, 'Szállítás alatt'),
(3, 'Átadva a futárnak'),
(4, 'Rendelésed összekészítve'),
(5, 'Rendelésed felvéve'),
(6, 'Rendelésed leadtad'),
(7, 'Rendelésed összekészítés alatt');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `img` varchar(255) NOT NULL DEFAULT 'default_path',
  `phone_number` varchar(30) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `auth_secret` varchar(16) NOT NULL,
  `guid` varchar(128) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `register_finished_at` datetime DEFAULT NULL,
  `reg_token` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `first_name`, `last_name`, `img`, `phone_number`, `is_admin`, `is_deleted`, `deleted_at`, `auth_secret`, `guid`, `last_login`, `register_finished_at`, `reg_token`) VALUES
(1, 'TesztElek@gmail.com', '248b646537648c1fbdeb42b56771dbdb42129e8bab527ff551a1f49ce499464f', 'Teszt', 'Elek', 'default_path', NULL, NULL, 0, NULL, '-', '6cf939c5-b89d-11f0-820d-047c16ad0c5a', NULL, NULL, '6cf939cc-b89d-11f0-820d-047c16ad0c5a'),
(2, 'JánosTesztel@gmail.com', '248b646537648c1fbdeb42b56771dbdb42129e8bab527ff551a1f49ce499464f', 'Teszt', 'János', 'default_path', NULL, NULL, 0, NULL, '-', '3161c695-b89d-11f0-820d-047c16ad0c5a', NULL, NULL, '3161c6d3-b89d-11f0-820d-047c16ad0c5a'),
(3, 'Email1@gmail.com', 'asd123', 'Teszt1', 'Teszt1', 'default_path', '+11111111111', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(4, 'Email2@gmail.com', 'asd123', 'Teszt2', 'Teszt2', 'default_path', '+11111111112', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(5, 'Email3@gmail.com', 'asd123', 'Teszt3', 'Teszt3', 'default_path', '+11111111113', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(6, 'Email4@gmail.com', 'asd123', 'Teszt4', 'Teszt4', 'default_path', '+11111111114', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(7, 'Email5@gmail.com', 'asd123', 'Teszt5', 'Teszt5', 'default_path', '+11111111115', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(8, 'Email6@gmail.com', 'asd123', 'Teszt6', 'Teszt6', 'default_path', '+11111111116', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(9, 'Email7@gmail.com', 'asd123', 'Teszt7', 'Teszt7', 'default_path', '+11111111117', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(10, 'Email8@gmail.com', 'asd123', 'Teszt8', 'Teszt8', 'default_path', '+11111111118', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(11, 'Email9@gmail.com', 'asd123', 'Teszt9', 'Teszt9', 'default_path', '+11111111119', NULL, 0, NULL, '', NULL, NULL, NULL, ''),
(12, 'Email10@gmail.com', 'asd123', 'Teszt10', 'Teszt10', 'default_path', '+11111111110', NULL, 0, NULL, '', NULL, NULL, NULL, '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `address_user`
--
ALTER TABLE `address_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `address_id` (`address_id`) USING BTREE,
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `brand`
--
ALTER TABLE `brand`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`) USING BTREE;

--
-- Indexes for table `cart_product`
--
ALTER TABLE `cart_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart` (`cart_id`),
  ADD KEY `product` (`product_id`) USING BTREE;

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `details`
--
ALTER TABLE `details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_method` (`payment_method_id`),
  ADD KEY `billing_details` (`address_user_id`),
  ADD KEY `status` (`status_id`),
  ADD KEY `order_user` (`user_id`),
  ADD KEY `address_user_id` (`address_user_id`) USING BTREE;

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order` (`order_id`),
  ADD KEY `order_product_product` (`product_id`) USING BTREE;

--
-- Indexes for table `payment_method`
--
ALTER TABLE `payment_method`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `detail` (`detail_id`) USING BTREE,
  ADD KEY `brand` (`brand_id`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category_id`),
  ADD KEY `product_category_product` (`product_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_image_product` (`product_id`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `address_user`
--
ALTER TABLE `address_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `brand`
--
ALTER TABLE `brand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `cart_product`
--
ALTER TABLE `cart_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `details`
--
ALTER TABLE `details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `order_product`
--
ALTER TABLE `order_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `payment_method`
--
ALTER TABLE `payment_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `cart_product`
--
ALTER TABLE `cart_product`
  ADD CONSTRAINT `cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`),
  ADD CONSTRAINT `product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `payment_method` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`id`),
  ADD CONSTRAINT `status` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`);

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_product_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`),
  ADD CONSTRAINT `detail` FOREIGN KEY (`detail_id`) REFERENCES `details` (`id`);

--
-- Constraints for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD CONSTRAINT `category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `product_category_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_image_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
