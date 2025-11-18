-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 18, 2025 at 08:14 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProduct` (IN `productIdIN` INT)   BEGIN
	UPDATE `product`
	SET `deleted_at` = CURRENT_TIMESTAMP,
    `is_deleted` = 1
	WHERE `product`.`id` = productIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser` (IN `userIdIN` INT(11))   BEGIN
	UPDATE `user`
	SET `user`.`deleted_at` = CURRENT_TIMESTAMP

	WHERE `user`.`id` = userIdIN;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUser` ()   BEGIN


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

CREATE DEFINER=`root`@`localhost` PROCEDURE `registerUser` (IN `firstNameIN` VARCHAR(100), IN `lastNameIN` VARCHAR(100), IN `emailIN` VARCHAR(200), IN `passwordIN` VARCHAR(255))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewAdd` (IN `reviewTextIN` VARCHAR(255), IN `reviewstarIN` INT(1), IN `reviewerIdIN` INT(11), IN `reviewedProdIdIN` INT(11))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewDelete` (IN `reviewIdIN` INT(11), IN `reviewedProductIdIN` INT(11), IN `reviewerIdIN` INT(11))   BEGIN
	UPDATE `review`
	SET `review`.`deleted_at` = CURRENT_TIMESTAMP

	WHERE `review`.`product_id` = reviewedProductIdIN AND `review`.`user_id`=reviewerIdIN AND `review`.`id`=reviewIdIN
;
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
(1, 'Magyarország', 'TesztVáros', 7357, 'utca', 7357, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `billing_details`
--

CREATE TABLE `billing_details` (
  `id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `brand`
--

CREATE TABLE `brand` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `last_modified_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `cart_product`
--

CREATE TABLE `cart_product` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_details`
--

CREATE TABLE `delivery_details` (
  `id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `details`
--

CREATE TABLE `details` (
  `id` int(11) NOT NULL,
  `weight` double DEFAULT NULL,
  `species` varchar(255) DEFAULT NULL,
  `length` double DEFAULT NULL,
  `height` double DEFAULT NULL,
  `width` double DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `is_set` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `details`
--

INSERT INTO `details` (`id`, `weight`, `species`, `length`, `height`, `width`, `size`, `is_set`) VALUES
(1, 2, '', 3, 2, 0, 0, 0),
(2, 2.3, '', 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `order_date` datetime NOT NULL,
  `status_id` int(2) NOT NULL,
  `billing_details_id` int(11) NOT NULL,
  `deliveri_details_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `order_id` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `payment_method`
--

CREATE TABLE `payment_method` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `brand_id` int(11) DEFAULT NULL,
  `review_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `discount`, `created_at`, `updated_at`, `deleted_at`, `is_deleted`, `amount`, `detail_id`, `stock_keeping_unit`, `brand_id`, `review_id`) VALUES
(1, 'KalapácsTeszt', 'Kalapács teszt leírás', 50000, 0, '2025-10-22 09:44:26', NULL, '2025-10-22 10:14:21', 0, 500, 1, '888888881', NULL, NULL),
(2, 'SeprűTeszt', 'Teszt Seprű', 20000, NULL, '2025-10-22 13:28:15', NULL, NULL, 0, 200000, 2, '888888882', NULL, NULL),
(3, 'NemTudomCsakTeszt', 'NemTudomCsakTesztDesc', 100, NULL, '2025-10-22 13:58:03', NULL, NULL, 0, 10, 2, '888888883', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `review_text` varchar(255) NOT NULL,
  `review_star` int(1) NOT NULL,
  `review_dateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `billing_detail_id` int(11) DEFAULT NULL,
  `delivery_detail_id` int(11) DEFAULT NULL,
  `auth_secret` varchar(16) NOT NULL,
  `guid` varchar(128) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `register_finished_at` datetime DEFAULT NULL,
  `reg_token` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `first_name`, `last_name`, `img`, `phone_number`, `is_admin`, `is_deleted`, `deleted_at`, `billing_detail_id`, `delivery_detail_id`, `auth_secret`, `guid`, `last_login`, `register_finished_at`, `reg_token`) VALUES
(1, 'TesztElek@gmail.com', '248b646537648c1fbdeb42b56771dbdb42129e8bab527ff551a1f49ce499464f', 'Teszt', 'Elek', 'default_path', NULL, NULL, 0, NULL, NULL, NULL, '-', '6cf939c5-b89d-11f0-820d-047c16ad0c5a', NULL, NULL, '6cf939cc-b89d-11f0-820d-047c16ad0c5a'),
(2, 'JánosTesztel@gmail.com', '248b646537648c1fbdeb42b56771dbdb42129e8bab527ff551a1f49ce499464f', 'Teszt', 'János', 'default_path', NULL, NULL, 0, NULL, NULL, NULL, '-', '3161c695-b89d-11f0-820d-047c16ad0c5a', NULL, NULL, '3161c6d3-b89d-11f0-820d-047c16ad0c5a');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `billing_details`
--
ALTER TABLE `billing_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `b_address` (`address_id`);

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
  ADD KEY `user` (`user_id`);

--
-- Indexes for table `cart_product`
--
ALTER TABLE `cart_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product` (`product_id`),
  ADD KEY `cart` (`cart_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `delivery_details`
--
ALTER TABLE `delivery_details`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `del_det_address` (`address_id`);

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
  ADD KEY `deliveri_details` (`deliveri_details_id`),
  ADD KEY `billing_details` (`billing_details_id`),
  ADD KEY `status` (`status_id`),
  ADD KEY `order_user` (`user_id`);

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order` (`order_id`),
  ADD KEY `order_product_product` (`product_id`);

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
  ADD KEY `detail` (`detail_id`),
  ADD KEY `brand` (`brand_id`),
  ADD KEY `review_id` (`review_id`);

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
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `delivery_detail_id` (`delivery_detail_id`),
  ADD UNIQUE KEY `billing_detail_id` (`billing_detail_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `billing_details`
--
ALTER TABLE `billing_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `brand`
--
ALTER TABLE `brand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_product`
--
ALTER TABLE `cart_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `delivery_details`
--
ALTER TABLE `delivery_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `details`
--
ALTER TABLE `details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_product`
--
ALTER TABLE `order_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_method`
--
ALTER TABLE `payment_method`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing_details`
--
ALTER TABLE `billing_details`
  ADD CONSTRAINT `address` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`),
  ADD CONSTRAINT `b_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`);

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
-- Constraints for table `delivery_details`
--
ALTER TABLE `delivery_details`
  ADD CONSTRAINT `del_det_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `billing_details` FOREIGN KEY (`billing_details_id`) REFERENCES `billing_details` (`id`),
  ADD CONSTRAINT `deliveri_details` FOREIGN KEY (`deliveri_details_id`) REFERENCES `delivery_details` (`id`),
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
  ADD CONSTRAINT `detail` FOREIGN KEY (`detail_id`) REFERENCES `details` (`id`),
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `review` (`id`);

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

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_3` FOREIGN KEY (`delivery_detail_id`) REFERENCES `delivery_details` (`id`),
  ADD CONSTRAINT `user_ibfk_4` FOREIGN KEY (`billing_detail_id`) REFERENCES `billing_details` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
