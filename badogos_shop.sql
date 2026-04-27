-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 27, 2026 at 11:53 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addAddressXUser` (IN `addressIdIN` INT(11), IN `userIdIN` INT(11), IN `is_billing` TINYINT(1), IN `is_delivery` TINYINT(1))   BEGIN
	INSERT INTO `address_user`
    (
    	`address_user`.`address_id`,
        `address_user`.`user_id`,
        `address_user`.`is_billing`,
        `address_user`.`is_delivery`
    )
    VALUES
    (
    	addressIdIN,
        userIdIN,
        is_billing,
        is_delivery
    )
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `addDetail` (IN `weightIN` DOUBLE, IN `materialIN` VARCHAR(255), IN `lengthIN` DOUBLE, IN `heightIN` INT, IN `widthIN` DOUBLE, IN `sizeIN` INT(11), IN `is_setIN` TINYINT(4))   BEGIN

 INSERT INTO `details`(
	`details`.`weight`,
    `details`.`material`,
     `details`.`length`,
     `details`.`height`,
     `details`.`width`,
     `details`.`size`,
     `details`.`is_set`
    )
    VALUES(
	weightIN,
    materialIN,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `addProductXcategories` (IN `productIdIN` INT(11), IN `cartegoryIdIN` INT(11))   BEGIN

	INSERT INTO `product_categories`
    (
    	`product_categories`.`product_id`,
    	`product_categories`.`category_id`
	)
    VALUES
    (
    	productIdIN,
        cartegoryIdIN
    )
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `addTransportDetail` (IN `townIN` VARCHAR(100), IN `postalCodeIN` INT(4), IN `addressIN` VARCHAR(100), IN `houseNumberIN` INT(3), IN `addressTypeIdIN` INT(11))   BEGIN

INSERT INTO `transport_detail`(
	`transport_detail`.`town`,
    `transport_detail`.`post_code`,
    `transport_detail`.`address_type_id`,
    `transport_detail`.`address`,
    `transport_detail`.`house_number`
)
VALUES(
	townIN,
    postalCodeIN,
    addressTypeIdIN,
    addressIN,
    houseNumberIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `clearCart` (IN `idIN` INT)   BEGIN 
	UPDATE `cart_product` SET 
    `is_deleted`=1,`deleted_at`=CURRENT_DATE() 
    WHERE
    cart_product.cart_id = idIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAddress` (IN `addressIdIN` INT(11))   BEGIN
	UPDATE `address`
    SET `address`.`is_deleted`=1,
    `address`.`deleted_at`=CURRENT_TIMESTAMP
    	
    WHERE `address`.`id`= addressIdIN
    ;
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
    WHERE category.id = categoryIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProduct` (IN `productIdIN` INT)   BEGIN
	UPDATE `product`
	SET `deleted_at` = CURRENT_TIMESTAMP,
    `is_deleted` = 1
	WHERE `product`.`id` = productIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProductFromCart` (IN `idIN` INT)   BEGIN
	UPDATE `cart_product` SET 
    `is_deleted`=1,`deleted_at`=CURRENT_DATE() 
    WHERE
    cart_product.id = idIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProductXcategories` (IN `productXcategoriesIdIN` INT(11))   BEGIN
	UPDATE `product_categories`
    SET `product_categories`.`is_deleted`=1,
    `product_categories`.`deleted_at`= CURRENT_TIMESTAMP
    WHERE `product_categories`.`id`=productXcategoriesIdIN
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAddressXuserById` (IN `AddressXuserIdIN` INT(11))   BEGIN
	SELECT* FROM `address_user`
    WHERE `address_user`.`is_deleted`=0 AND `address_user`.`id`=AddressXuserIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllAddressXuser` ()   BEGIN
	SELECT*FROM`address_user`
    WHERE `address_user`.`is_deleted`=0 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProduct` ()   BEGIN
	SELECT *FROM product
    WHERE product.is_deleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProductXcategories` ()   BEGIN
	SELECT *from `product_categories`
    WHERE `product_categories`.`is_deleted`=0
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllReview` ()   BEGIN
	
    SELECT * FROM `review`
    
    WHERE`review`.`is_deleted`=0;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllSubcategory` ()   BEGIN
	SELECT * FROM category WHERE category.category_id IS NOT NULL AND category.is_deleted=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllTransportDetail` ()   BEGIN
	SELECT * FROM transport_detail
    
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getCartByUserId` (IN `idIN` INT)   BEGIN 
	SELECT * FROM cart
    WHERE 
    cart.user_id = idIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMainCategory` ()   BEGIN
	SELECT * FROM category WHERE category.category_id IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMostViewedProducts` ()   BEGIN 
	SELECT * FROM product
    WHERE product.is_deleted = 0
    ORDER BY product.view_count DESC
    LIMIT 4;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderedProductOfMonth` (IN `monthNumber` INT)   BEGIN
	SELECT p.id FROM product p
    INNER JOIN order_product op ON
    p.id = op.product_id
    WHERE 
    MONTH(op.created_at) = monthNumber;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getProductByCategoryID` (IN `categoryIdIN` INT)   BEGIN
	SELECT * FROM product WHERE product.category_id=categoryIdIN AND product.is_deleted=0;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSubcatByPrimCat` (IN `primCategoryIdIN` INT(11))   BEGIN
	SELECT * FROM category WHERE category.category_id = primCategoryIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTransportDetailsById` (IN `transportDetailsIdIN` INT(11))   BEGIN
	SELECT * FROM transport_detail
    WHERE transport_detail.id= transportDetailsIdIN
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchProduct` (IN `searchTerm` VARCHAR(100))   BEGIN 
	SELECT * FROM product
    WHERE 
    (product.name LIKE CONCAT(searchTerm, '', '%')
    OR 
    product.stock_keeping_unit LIKE CONCAT(searchTerm, '', '%'))
    AND 
    product.is_deleted = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_avg_order_price` (IN `monthIN` INT, IN `yearIN` INT)   BEGIN 
	SELECT SUM(p.price * op.amount) 
    / 
    COUNT(DISTINCT oh.id)
    FROM order_history oh 
    INNER JOIN order_product op ON 
    oh.id = op.order_id
    INNER JOIN product p ON 
    p.id = op.product_id
    WHERE 
	MONTH(oh.ordered_at) = monthIN
	AND 
    YEAR(oh.ordered_at) = yearIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_count_orders` (IN `monthIN` INT, IN `yearIN` INT)   BEGIN 
	SELECT COUNT(oh.id) FROM order_history oh 
    INNER JOIN order_product op ON 
    oh.id = op.order_id
    INNER JOIN product p ON 
    p.id = op.product_id
    WHERE 
	MONTH(oh.ordered_at) = monthIN
	AND 
    YEAR(oh.ordered_at) = yearIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_sum_profit` (IN `monthIN` INT, IN `yearIN` INT)   BEGIN 
	SELECT SUM(p.price * op.amount) FROM order_history oh 
    INNER JOIN order_product op ON 
    oh.id = op.order_id
    INNER JOIN product p ON 
    p.id = op.product_id
    WHERE 
	MONTH(oh.ordered_at) = monthIN
	AND 
    YEAR(oh.ordered_at) = yearIN
	;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_sum_sold_items` (IN `monthIN` INT, IN `yearIN` INT)   BEGIN 
	SELECT SUM(op.amount) FROM order_history oh 
    INNER JOIN order_product op ON 
    oh.id = op.order_id
    INNER JOIN product p ON 
    p.id = op.product_id
    WHERE 
	MONTH(oh.ordered_at) = monthIN
	AND 
    YEAR(oh.ordered_at) = yearIN
	;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAddress` (IN `addressIdIN` INT(11), IN `cityIN` VARCHAR(100), IN `postalCodeIN` INT(4), IN `nameOfPublicAreaIN` VARCHAR(100), IN `houseNumberIN` INT(4))   BEGIN
	UPDATE `address`
    SET `address`.`city`=cityIN,
    `address`.`postal_code`=postalCodeIN,
    `address`.`name_of_public_area`=nameOfPublicAreaIN,
    `address`.`house_number`=houseNumberIN

	WHERE `address`.`id`=addressIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAddressXuser` (IN `addressXuserIdIN` INT(11), IN `isBillingChange` TINYINT, IN `isDeliveryChange` TINYINT)   BEGIN
	UPDATE `address_user`
    SET`address_user`.`is_billing`=isBillingChange,
    `address_user`.`is_delivery`=isDeliveryChange,
    `address_user`.`is_deleted`=NULL,
    `address_user`.`deleted_at`=NULL
    
    WHERE `address_user`.`id`=addressXuserIdIN
    ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDetails` (IN `detailIdIN` INT(11), IN `weightIN` DOUBLE, IN `materialIN` VARCHAR(255), IN `lengthIN` DOUBLE, IN `heightIN` DOUBLE, IN `widthIN` DOUBLE, IN `sizeIN` INT(11), IN `is_setIN` TINYINT(4))   BEGIN

 UPDATE `details`
	SET `details`.`weight`=weightIN,
    `details`.`material`=materialIN,
     `details`.`length`=lengthIN,
     `details`.`height`=heightIN,
     `details`.`width`=widthIN,
     `details`.`size`=sizeIN,
     `details`.`is_set`=is_setIN
    

WHERE details.id=detailIdIN;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProductXcategories` (IN `productXcategoriesIdIN` INT(11), IN `productIdIN` INT(11), IN `categoryIdIN` INT(11))   BEGIN
	UPDATE `product_categories`
    SET `product_categories`.`id`=productIdIN,
    `product_categories`.`id`=categoryIdIN
    
    WHERE `product_categories`.`id`=productXcategoriesIdIN
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateReview` (IN `reviewIdIN` INT(11), IN `reviewStarIN` INT(1), IN `reviewTextIN` LONGTEXT)   BEGIN

	UPDATE `review`
    	SET `review`.`review_star`=reviewStarIN,
        `review`.`review_text`=reviewTextIN,
        `review`.`updated_at`=CURRENT_TIMESTAMP
    WHERE `review`.`id`=reviewIdIN;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTransportDetail` (IN `transportIdIN` INT(11), IN `postalCodeIN` INT(4), IN `townIN` VARCHAR(100), IN `addressIN` VARCHAR(100), IN `addressTypeIdIN` INT(11), IN `houseNumberIN` INT(3), IN `otherIN` LONGTEXT)   BEGIN
	
    UPDATE transport_detail
	SET transport_detail.post_code=postalCodeIN,
    transport_detail.town=townIN,
    transport_detail.address=addressIN,
    transport_detail.address_type_id=addressTypeIdIN,
    transport_detail.house_number=houseNumberIN,
    transport_detail.other=otherIN 
    WHERE transport_detail.id=transportIdIN
;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address_type`
--

CREATE TABLE `address_type` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `address_type`
--

INSERT INTO `address_type` (`id`, `name`) VALUES
(1, 'tér'),
(2, 'utca'),
(3, 'Út'),
(4, 'Körút'),
(5, 'akna'),
(6, 'alja'),
(7, 'almáskert'),
(8, 'alsó'),
(9, 'alsósor'),
(10, 'aluljáró'),
(11, 'autópálya'),
(12, 'autóversenypálya'),
(13, 'állomás'),
(14, 'árok'),
(15, 'átjáró'),
(16, 'barakképület'),
(17, 'bánya'),
(18, 'bányatelep'),
(19, 'bekötőút'),
(20, 'benzinkút'),
(21, 'bérc'),
(22, 'bisztró'),
(23, 'bokor'),
(24, 'burgundia'),
(25, 'büfé'),
(26, 'camping'),
(27, 'campingsor'),
(28, 'centrum'),
(29, 'célgazdaság'),
(30, 'csapás'),
(31, 'csarnok'),
(32, 'csárda'),
(33, 'cser'),
(34, 'domb'),
(35, 'dunapart'),
(36, 'dunasor'),
(37, 'dűlő'),
(38, 'dűlője'),
(39, 'dűlők'),
(40, 'dűlőút'),
(41, 'egyesület'),
(42, 'egyéb'),
(43, 'elágazás'),
(44, 'erdészház'),
(45, 'erdészlak'),
(46, 'erdő'),
(47, 'erdősarok'),
(48, 'erdősor'),
(49, 'épület'),
(50, 'épületek'),
(51, 'észak'),
(52, 'étterem'),
(53, 'falu'),
(54, 'farm'),
(55, 'fasor'),
(56, 'fasora'),
(57, 'feketeerdő'),
(58, 'feketeföldek'),
(59, 'felső'),
(60, 'felsősor'),
(61, 'fennsík'),
(62, 'fogadó'),
(63, 'fok'),
(64, 'forduló'),
(65, 'forrás'),
(66, 'föld'),
(67, 'földek'),
(68, 'földje'),
(69, 'főtér'),
(70, 'főút'),
(71, 'fürdő'),
(72, 'fürdőhely'),
(73, 'fürésztelepe'),
(74, 'gazdaság'),
(75, 'gát'),
(76, 'gátőrház'),
(77, 'gátsor'),
(78, 'gimnázium'),
(79, 'gödör'),
(80, 'gulyakút'),
(81, 'gyár'),
(82, 'gyártelep'),
(83, 'halom'),
(84, 'határ'),
(85, 'határátkelőhely'),
(86, 'határrész'),
(87, 'határsor'),
(88, 'határút'),
(89, 'hatházak'),
(90, 'hát'),
(91, 'ház'),
(92, 'háza'),
(93, 'házak'),
(94, 'hegy'),
(95, 'hegyhát'),
(96, 'hegyhát dűlő'),
(97, 'hely'),
(98, 'hivatal'),
(99, 'híd'),
(100, 'hídfő'),
(101, 'horgásztanya'),
(102, 'hotel'),
(103, 'I'),
(104, 'I.'),
(105, 'II.'),
(106, 'III'),
(107, 'III.'),
(108, 'intézet'),
(109, 'ipari park'),
(110, 'ipartelep'),
(111, 'iparterület'),
(112, 'irodaház'),
(113, 'iskola'),
(114, 'IV'),
(115, 'IV.'),
(116, 'IX'),
(117, 'jánoshegy'),
(118, 'járás'),
(119, 'juhászház'),
(120, 'kapcsolóház'),
(121, 'kapu'),
(122, 'kastély'),
(123, 'kálvária'),
(124, 'kemping'),
(125, 'kert'),
(126, 'kertek'),
(127, 'kertek-köze'),
(128, 'kertsor'),
(129, 'kertváros'),
(130, 'kerület'),
(131, 'kikötő'),
(132, 'kilátó'),
(133, 'kishajtás'),
(134, 'kitérő'),
(135, 'kocsiszín'),
(136, 'kolónia'),
(137, 'korzó'),
(138, 'kórház'),
(139, 'körönd'),
(140, 'körtér'),
(141, 'körútja'),
(142, 'körvasútsor'),
(143, 'körzet'),
(144, 'köz'),
(145, 'köze'),
(146, 'középsor'),
(147, 'központ'),
(148, 'kút'),
(149, 'kútház'),
(150, 'Külkerület'),
(151, 'kültelek'),
(152, 'külterület'),
(153, 'külterülete'),
(154, 'lakás'),
(155, 'lakások'),
(156, 'lakóház'),
(157, 'lakókert'),
(158, 'lakónegyed'),
(159, 'lakópark'),
(160, 'lakótelep'),
(161, 'laktanya'),
(162, 'legelő'),
(163, 'lejáró'),
(164, 'lejtő'),
(165, 'lépcső'),
(166, 'liget'),
(167, 'lovasiskola'),
(168, 'magánút'),
(169, 'major'),
(170, 'malom'),
(171, 'malomsor'),
(172, 'megálló'),
(173, 'mellékköz'),
(174, 'mező'),
(175, 'mélyút'),
(176, 'munkásszálló'),
(177, 'műút'),
(178, 'nagymajor'),
(179, 'nagyút'),
(180, 'nádgazdaság'),
(181, 'negyed'),
(182, 'nyaraló'),
(183, 'oldal'),
(184, 'országút'),
(185, 'otthon'),
(186, 'otthona'),
(187, 'öböl'),
(188, 'öregszőlők'),
(189, 'ösvény'),
(190, 'ötház'),
(191, 'övezet'),
(192, 'őrház'),
(193, 'őrházak'),
(194, 'pagony'),
(195, 'pallag'),
(196, 'palota'),
(197, 'park'),
(198, 'parkfalu'),
(199, 'parkja'),
(200, 'parkoló'),
(201, 'part'),
(202, 'pavilonsor'),
(203, 'pálya'),
(204, 'pályafenntartás'),
(205, 'pályaudvar'),
(206, 'piac'),
(207, 'pihenő'),
(208, 'pihenőhely'),
(209, 'pihenőpark'),
(210, 'pince'),
(211, 'pinceköz'),
(212, 'pincesor'),
(213, 'présházak'),
(214, 'puszta'),
(215, 'rakodó'),
(216, 'rakpart'),
(217, 'repülőtér'),
(218, 'rész'),
(219, 'rét'),
(220, 'rétek'),
(221, 'rév'),
(222, 'ring'),
(223, 'sarok'),
(224, 'sertéstelep'),
(225, 'sétatér'),
(226, 'sétány'),
(227, 'sikátor'),
(228, 'sor'),
(229, 'sora'),
(230, 'sportpálya'),
(231, 'sporttelep'),
(232, 'stadion'),
(233, 'strand'),
(234, 'strandfürdő'),
(235, 'sugárút'),
(236, 'szakiskola'),
(237, 'szállás'),
(238, 'szálló'),
(239, 'szárító'),
(240, 'szárnyasliget'),
(241, 'szektor'),
(242, 'szer'),
(243, 'szél'),
(244, 'széle'),
(245, 'sziget'),
(246, 'szigete'),
(247, 'szivattyútelep'),
(248, 'szög'),
(249, 'szőlő'),
(250, 'szőlőhegy'),
(251, 'szőlők'),
(252, 'szőlőkert'),
(253, 'szőlős'),
(254, 'szőlősor'),
(255, 'tag'),
(256, 'tanya'),
(257, 'tanyaközpont'),
(258, 'tanyák'),
(259, 'tavak'),
(260, 'tábor'),
(261, 'tároló'),
(262, 'társasház'),
(263, 'teherpályaudvar'),
(264, 'telek'),
(265, 'telep'),
(266, 'telepek'),
(267, 'település'),
(268, 'temető'),
(269, 'tere'),
(270, 'terményraktár'),
(271, 'terület'),
(272, 'teteje'),
(273, 'tető'),
(274, 'téglagyár'),
(275, 'tormás'),
(276, 'torony'),
(277, 'tó'),
(278, 'tópart'),
(279, 'tömb'),
(280, 'TSZ'),
(281, 'turistaház'),
(282, 'udvar'),
(283, 'udvara'),
(284, 'utcája'),
(285, 'újfalu'),
(286, 'újsor'),
(287, 'újtelep'),
(288, 'útfél'),
(289, 'útgyűrű'),
(290, 'útja'),
(291, 'üdülő'),
(292, 'üdülő központ'),
(293, 'üdülő park'),
(294, 'üdülők'),
(295, 'üdülőközpont'),
(296, 'üdülőpart'),
(297, 'üdülő-part'),
(298, 'üdülősor'),
(299, 'üdülő-sor'),
(300, 'üdülőtelep'),
(301, 'üdülő-telep'),
(302, 'üdülőterület'),
(303, 'üzem'),
(304, 'üzletház'),
(305, 'üzletsor'),
(306, 'V'),
(307, 'V.'),
(308, 'vadászház'),
(309, 'varroda'),
(310, 'vasútállomás'),
(311, 'vasúti megálló'),
(312, 'vasúti őrház'),
(313, 'vasútsor'),
(314, 'vám'),
(315, 'vár'),
(316, 'város'),
(317, 'vásártér'),
(318, 'vendéglő'),
(319, 'vég'),
(320, 'VI'),
(321, 'VI.'),
(322, 'VII'),
(323, 'VII.'),
(324, 'VIII'),
(325, 'VIII.'),
(326, 'villa'),
(327, 'villasor'),
(328, 'vízmű'),
(329, 'vízmű telep'),
(330, 'víztároló'),
(331, 'völgy'),
(332, 'X'),
(333, 'X.'),
(334, 'zsilip'),
(335, 'zug');

-- --------------------------------------------------------

--
-- Table structure for table `address_user`
--

CREATE TABLE `address_user` (
  `id` int(11) NOT NULL,
  `billing_detail_id` int(11) NOT NULL,
  `transport_detail_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `address_user`
--

INSERT INTO `address_user` (`id`, `billing_detail_id`, `transport_detail_id`, `user_id`) VALUES
(1, 1, 1, 1),
(2, 11, 5, 1),
(3, 2, 2, 5),
(4, 8, 1, 2),
(5, 6, 6, 5),
(6, 3, 9, 4),
(7, 10, 7, 2),
(8, 4, 8, 5),
(9, 7, 9, 2),
(10, 9, 10, 5),
(11, 5, 4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `billing_detail`
--

CREATE TABLE `billing_detail` (
  `id` int(11) NOT NULL,
  `post_code` int(4) NOT NULL,
  `town` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `address_type_id` int(11) NOT NULL,
  `house_number` int(3) NOT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `company_tax_number` int(11) DEFAULT NULL,
  `other` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `billing_detail`
--

INSERT INTO `billing_detail` (`id`, `post_code`, `town`, `address`, `address_type_id`, `house_number`, `company_name`, `company_tax_number`, `other`) VALUES
(1, 1000, 'a', 'a', 1, 1000, NULL, 1000, NULL),
(2, 1001, 'b', 'b', 2, 1001, NULL, NULL, NULL),
(3, 1002, 'c', 'c', 2, 1002, 'c', 1002, NULL),
(4, 1003, 'd', 'd', 2, 1003, NULL, NULL, NULL),
(5, 1004, 'e', 'e', 1, 1004, 'e', 1004, NULL),
(6, 1005, 'f', 'f', 2, 1005, NULL, NULL, NULL),
(7, 1006, 'g', 'g', 228, 1006, NULL, NULL, NULL),
(8, 1007, 'h', 'h', 2, 1007, NULL, NULL, NULL),
(9, 1008, 'i', 'i', 228, 1008, NULL, NULL, NULL),
(10, 1009, 'j', 'j', 2, 1009, NULL, NULL, NULL),
(11, 1010, 'k', 'k', 228, 1010, NULL, NULL, NULL);

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
(1, 'Jobi', 0, NULL),
(2, 'Honiton', 0, NULL),
(3, 'non', 0, NULL),
(4, 'Powerjet', 0, NULL),
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
  `last_modified_at` timestamp NULL DEFAULT NULL,
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
(10, 10, NULL, '2025-11-20 16:34:21'),
(11, 13, NULL, '2026-02-20 08:09:44'),
(12, 16, NULL, '2026-02-22 17:46:38'),
(13, 14, NULL, '2026-02-23 12:25:31'),
(14, 18, NULL, '2026-04-14 13:16:48'),
(15, 17, NULL, '2026-04-14 14:08:44'),
(16, 19, NULL, '2026-04-24 07:06:39'),
(17, 27, NULL, '2026-04-24 08:01:12');

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
  `amount` int(11) DEFAULT NULL,
  `is_deleted` tinyint(4) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cart_product`
--

INSERT INTO `cart_product` (`id`, `product_id`, `cart_id`, `created_at`, `last_modified_at`, `amount`, `is_deleted`, `deleted_at`) VALUES
(1, 1, 1, '2025-11-20 16:37:30', NULL, 1, 0, NULL),
(2, 3, 1, '2025-11-20 16:37:30', NULL, 2, 0, NULL),
(3, 5, 2, '2025-11-20 16:45:53', NULL, 1, 0, NULL),
(4, 2, 2, '2025-11-20 16:45:53', NULL, 1, 0, NULL),
(5, 5, 3, '2025-11-20 16:46:22', NULL, 1, 0, NULL),
(6, 2, 3, '2025-11-20 16:46:22', NULL, 1, 0, NULL),
(7, 5, 4, '2025-11-20 16:46:39', NULL, 1, 0, NULL),
(8, 2, 4, '2025-11-20 16:46:39', NULL, 1, 0, NULL),
(9, 5, 5, '2025-11-20 16:46:55', NULL, 1, 0, NULL),
(10, 2, 5, '2025-11-20 16:46:55', NULL, 1, 0, NULL),
(11, 5, 6, '2025-11-20 16:47:50', NULL, 1, 0, NULL),
(12, 2, 6, '2025-11-20 16:47:50', NULL, 1, 0, NULL),
(13, 9, 9, '2025-11-20 16:51:00', NULL, 1, 0, NULL),
(14, 9, 6, '2025-11-20 16:51:01', NULL, 1, 0, NULL),
(15, 106, 11, '2026-02-20 08:10:29', NULL, 12, 0, NULL),
(16, 106, 11, '2026-02-20 08:10:30', NULL, 1, 1, '2026-02-23 00:00:00'),
(17, 106, 11, '2026-02-20 08:10:30', NULL, 1, 0, NULL),
(18, 106, 11, '2026-02-20 08:10:31', NULL, 1, 0, NULL),
(19, 106, 11, '2026-02-20 08:10:33', NULL, 2, 0, NULL),
(20, 7, 11, '2026-02-20 08:10:57', NULL, 1, 0, NULL),
(21, 7, 11, '2026-02-20 08:10:57', NULL, 1, 0, NULL),
(22, 7, 11, '2026-02-20 08:10:57', NULL, 1, 0, NULL),
(23, 7, 11, '2026-02-20 08:10:57', NULL, 1, 0, NULL),
(24, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(25, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(26, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(27, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(28, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(29, 7, 11, '2026-02-20 08:10:58', NULL, 1, 0, NULL),
(30, 7, 11, '2026-02-20 08:10:59', NULL, 1, 0, NULL),
(31, 7, 11, '2026-02-20 08:10:59', NULL, 1, 0, NULL),
(32, 7, 11, '2026-02-20 08:10:59', NULL, 1, 0, NULL),
(33, 7, 11, '2026-02-20 08:50:56', NULL, 1, 0, NULL),
(34, 7, 11, '2026-02-20 08:50:58', NULL, 1, 0, NULL),
(35, 7, 11, '2026-02-20 08:50:58', NULL, 1, 0, NULL),
(36, 7, 11, '2026-02-20 08:50:58', NULL, 1, 0, NULL),
(37, 7, 11, '2026-02-20 08:50:58', NULL, 1, 0, NULL),
(38, 1, 11, '2026-02-22 17:20:28', NULL, 1, 0, NULL),
(39, 1, 11, '2026-02-22 17:20:29', NULL, 1, 0, NULL),
(40, 1, 11, '2026-02-22 17:20:30', NULL, 1, 0, NULL),
(41, 1, 11, '2026-02-22 17:20:30', NULL, 1, 0, NULL),
(42, 1, 11, '2026-02-22 17:20:30', NULL, 1, 0, NULL),
(43, 1, 11, '2026-02-22 17:20:40', NULL, 1, 0, NULL),
(44, 1, 11, '2026-02-22 17:20:41', NULL, 1, 0, NULL),
(45, 1, 11, '2026-02-22 17:21:03', NULL, 1, 0, NULL),
(46, 1, 11, '2026-02-22 17:21:03', NULL, 1, 0, NULL),
(47, 1, 11, '2026-02-22 17:21:04', NULL, 1, 0, NULL),
(48, 1, 11, '2026-02-22 17:21:04', NULL, 1, 0, NULL),
(49, 1, 11, '2026-02-22 17:21:04', NULL, 1, 0, NULL),
(50, 1, 11, '2026-02-22 17:21:05', NULL, 1, 0, NULL),
(51, 107, 11, '2026-02-22 17:21:21', NULL, 1, 0, NULL),
(52, 107, 11, '2026-02-22 17:21:24', NULL, 1, 0, NULL),
(53, 106, 11, '2026-02-22 17:21:38', NULL, 1, 0, NULL),
(54, 1, 11, '2026-02-23 09:50:23', NULL, 1, 0, NULL),
(55, 1, 11, '2026-02-23 09:50:25', NULL, 1, 0, NULL),
(56, 1, 11, '2026-02-23 09:50:25', NULL, 1, 0, NULL),
(57, 1, 11, '2026-02-23 09:50:25', NULL, 1, 0, NULL),
(58, 1, 11, '2026-02-23 09:50:25', NULL, 1, 0, NULL),
(59, 1, 11, '2026-02-23 09:50:27', NULL, 2, 0, NULL),
(60, 1, 11, '2026-02-23 09:50:27', NULL, 2, 0, NULL),
(61, 1, 11, '2026-02-23 09:50:28', NULL, 2, 0, NULL),
(62, 1, 11, '2026-02-23 09:50:28', NULL, 2, 0, NULL),
(63, 1, 11, '2026-02-23 09:50:28', NULL, 2, 0, NULL),
(64, 117, 14, '2026-04-14 13:50:34', NULL, 1, 0, NULL),
(65, 117, 14, '2026-04-14 13:50:36', NULL, 1, 0, NULL),
(66, 117, 14, '2026-04-14 13:50:36', NULL, 1, 0, NULL),
(67, 117, 14, '2026-04-14 13:50:37', NULL, 1, 0, NULL),
(68, 117, 14, '2026-04-14 13:50:37', NULL, 1, 0, NULL),
(69, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(70, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(71, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(72, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(73, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(74, 117, 14, '2026-04-14 13:50:39', NULL, 2, 0, NULL),
(75, 117, 14, '2026-04-14 13:50:40', NULL, 2, 0, NULL),
(76, 117, 14, '2026-04-14 13:50:40', NULL, 2, 0, NULL),
(77, 7, 15, '2026-04-14 14:08:59', NULL, 1, 0, NULL),
(78, 106, 15, '2026-04-14 14:10:52', NULL, 1, 0, NULL),
(79, 7, 15, '2026-04-14 15:02:54', NULL, 1, 0, NULL),
(80, 7, 15, '2026-04-14 15:02:54', NULL, 1, 0, NULL),
(81, 7, 15, '2026-04-14 15:02:54', NULL, 1, 0, NULL),
(82, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(83, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(84, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(85, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(86, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(87, 7, 15, '2026-04-14 15:02:55', NULL, 1, 0, NULL),
(88, 7, 15, '2026-04-14 15:02:56', NULL, 1, 0, NULL),
(89, 7, 15, '2026-04-14 15:02:56', NULL, 1, 0, NULL),
(90, 7, 15, '2026-04-14 15:02:56', NULL, 1, 0, NULL),
(91, 7, 15, '2026-04-14 15:02:56', NULL, 1, 0, NULL),
(92, 7, 15, '2026-04-14 15:02:56', NULL, 1, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` longtext NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `category_id`, `is_deleted`, `deleted_at`) VALUES
(1, 'Racsni', NULL, 0, NULL),
(2, 'Racsni toldók', 1, 0, NULL),
(3, 'Racsni adapter', 1, 0, NULL),
(4, 'Racsni csukló', 1, 0, NULL),
(5, 'Racsni fix hajtószár', 1, 0, NULL),
(6, 'Dugófejek', NULL, 0, NULL),
(7, 'Damilok', NULL, 0, NULL),
(8, 'Locsoló technika', NULL, 0, NULL),
(9, 'Kesztyűk', NULL, 0, NULL),
(10, 'Nyelek', NULL, 0, NULL),
(11, 'Korongok', NULL, 0, NULL),
(12, 'Kerti eszközök', NULL, 0, NULL),
(13, 'Beépített torxok', NULL, 0, NULL),
(14, 'Imbuszkulcsok', NULL, 0, NULL),
(15, 'Kulcsok', NULL, 0, NULL),
(16, 'Csillagvillás kulcs', 15, 0, NULL),
(17, 'Fékcsőkulcs', 15, 0, NULL),
(18, '\"T\" kulcs', 15, 0, NULL),
(19, 'Műanyagos damil', 7, 0, NULL),
(20, 'Alumíniumos damil', 7, 0, NULL),
(21, 'Racsnik', 1, 0, NULL),
(22, 'Gyorscsatlakozó', 8, 0, NULL),
(23, 'Összekötő', 8, 0, NULL),
(24, 'Csapcsatlakozó', 8, 0, NULL),
(25, 'Kuplung', 8, 0, NULL),
(26, '\"Y\" elágazó', 8, 0, NULL),
(27, 'Elosztó', 8, 0, NULL),
(28, 'Sugárcső', 8, 0, NULL),
(29, 'Öntöző pisztoly', 8, 0, NULL),
(30, 'Tömlő', 8, 0, NULL),
(31, 'Öntöző', 8, 0, NULL),
(32, 'Kerticsapok', 8, 0, NULL),
(33, '1/2\"', 30, 0, NULL),
(34, '3/4\"', 30, 0, NULL),
(35, 'Műanyag', 32, 0, NULL),
(36, 'Egyenes', 32, 0, NULL),
(37, 'Bőr', 9, 0, NULL),
(38, 'Poliészter', 9, 0, NULL),
(39, 'Dugófej 1/2\"', 6, 0, NULL),
(40, 'Dugófej 1/4\"', 6, 0, NULL),
(41, 'Dugófej 3/8\"', 6, 0, NULL),
(42, 'Dugófej 3/4\"', 6, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `details`
--

CREATE TABLE `details` (
  `id` int(11) NOT NULL,
  `size` varchar(20) DEFAULT NULL,
  `material` varchar(255) DEFAULT NULL,
  `weight` double DEFAULT NULL COMMENT 'kg-ban',
  `length` double DEFAULT NULL COMMENT 'cm',
  `height` double DEFAULT NULL COMMENT 'cm',
  `width` double DEFAULT NULL COMMENT 'cm',
  `is_set` tinyint(4) DEFAULT NULL COMMENT 'Szett-e (több dolog egyben)',
  `color` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `details`
--

INSERT INTO `details` (`id`, `size`, `material`, `weight`, `length`, `height`, `width`, `is_set`, `color`) VALUES
(1, '1/4\"', 'Króm', NULL, NULL, NULL, NULL, NULL, 'Króm'),
(2, '3/8\"', 'Króm', NULL, NULL, NULL, NULL, NULL, 'Króm'),
(3, '1/2\"', 'Króm', NULL, NULL, NULL, NULL, NULL, 'Króm'),
(4, '1/4\"', 'Króm, gumi', NULL, NULL, NULL, NULL, NULL, 'Fekete'),
(5, '3/8\"', 'Króm, gumi', NULL, NULL, NULL, NULL, NULL, 'Fekete'),
(6, '1/2\"', 'Króm, gumi', NULL, NULL, NULL, NULL, NULL, 'Fekete'),
(7, '1/4\"', 'Acél', NULL, 5.5, NULL, NULL, NULL, NULL),
(8, '1/4\"', 'Acél', NULL, 7.5, NULL, NULL, NULL, NULL),
(9, '1/4\"', 'Acél', NULL, 10, NULL, NULL, NULL, NULL),
(10, '1/4\"', 'Acél', NULL, 15, NULL, NULL, NULL, NULL),
(11, '1/4\"', 'Acél', NULL, 23, NULL, NULL, NULL, NULL),
(12, '3/8\"', 'Acél', NULL, 7.5, NULL, NULL, NULL, NULL),
(13, '3/8\"', 'Acél', NULL, 12.5, NULL, NULL, NULL, NULL),
(14, '3/8\"', 'Acél', NULL, 15, NULL, NULL, NULL, NULL),
(15, '3/8\"', 'Acél', NULL, 20, NULL, NULL, NULL, NULL),
(16, '1/2\"', 'Acél', NULL, 10, NULL, NULL, NULL, NULL),
(17, '1/2\"', 'Acél', NULL, 12.5, NULL, NULL, NULL, NULL),
(18, '1/2\"', 'Acél', NULL, 20, NULL, NULL, NULL, NULL),
(19, '3/4\"', 'Acél', NULL, 10, NULL, NULL, NULL, NULL),
(20, '3/4\"', 'Acél', NULL, 20, NULL, NULL, NULL, NULL),
(21, '3/4\"', 'Acél', NULL, 40, NULL, NULL, NULL, NULL),
(22, '1/4\"', 'Acél', NULL, NULL, NULL, NULL, NULL, NULL),
(23, '3/8\"', 'Acél', NULL, NULL, NULL, NULL, NULL, NULL),
(24, '1/2\"', 'Acél', NULL, 10, NULL, NULL, NULL, NULL),
(25, '1/2\"', 'Acél', NULL, 20, NULL, NULL, NULL, NULL),
(26, '3/4\"', 'Acél', NULL, NULL, NULL, NULL, NULL, NULL),
(27, 'T30', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(28, 'T40', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(29, 'T45', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(30, 'T50', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(31, 'T55', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(32, 'T60', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(33, 'T70', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(34, 'M12', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(35, 'M14', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(36, 'M16', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(37, 'M17', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(38, '4', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(39, '5', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(40, '6', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(41, '7', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(42, '8', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(43, '10', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(44, '12', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(45, '13', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(46, '14', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(47, '17', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(48, '19', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(49, '7', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(50, '8', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(51, '9', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(52, '10', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(53, '11', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(54, '12', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(55, '13', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(56, '14', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(57, '15', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(58, '16', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(59, '17', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(60, '18', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(61, '19', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(62, '21', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(63, '22', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(64, '24', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(65, '27', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(66, '30', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(67, '32', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(68, '36', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(69, '41', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(70, '46', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(71, '55', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(72, '60', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(73, '11', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(74, '14', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(75, '32', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(76, '30', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(77, '31', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(78, '33', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(79, '34', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(80, '35', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(81, '36', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(82, '37', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(83, '38', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(84, '39', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(85, '40', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(86, '41', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(87, '42', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(88, '43', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(89, '44', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(90, '45', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(91, '46', 'Fém, olcsóbb', NULL, NULL, NULL, NULL, NULL, NULL),
(92, '11', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(93, '12', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(94, '13', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(95, 'T kulcs', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(96, '1.3', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(97, '1.6', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(98, '2', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(99, '2.4', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(100, '2.7', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(101, '3', 'Műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(102, '2', 'Műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(103, '2.4', 'Műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(104, '2.7', 'Műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(105, '3', 'Műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(106, '1.6', 'Alumínium, műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(107, '2', 'Alumínium, műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(108, '2.4', 'Alumínium, műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(109, '2.7', 'Alumínium, műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(110, '3', 'Alumínium, műanyag', NULL, 1500, NULL, NULL, NULL, NULL),
(111, '2', 'Alumínium, műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(112, '2.4', 'Alumínium, műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(113, '2.7', 'Alumínium, műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(114, '3', 'Alumínium, műanyag', NULL, 5000, NULL, NULL, NULL, NULL),
(115, '1/4\"-6,3mm', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(116, '3/8\"-1/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(117, '1/4\"-3/8\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(118, '1/2\"-3/8\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(119, '3/8\"-1/2\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(120, '1/2\"-3/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(121, '3/4\"-1/2\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(122, '1\"-3/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(123, '1/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(124, '3/8\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(125, '1/2\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(126, '1/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(127, '3/8\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(128, '1/2\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(129, '1/4\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(130, '3/8\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(131, '1/2\"', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(132, '1/2\"', 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(133, '3/4\"', 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(134, '3/4\" vastag', 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(135, '1\" piros', 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(136, '1\"', 'Műanyag PowJet', NULL, NULL, NULL, NULL, NULL, NULL),
(137, '1/2\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(138, '3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(139, '1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(140, '1/2\"-3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(141, '3/4\"-1\" ', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(142, '1/2\"-3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(143, '3/4\"-1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(144, 'vastag 3/4\"-1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(145, '1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(146, '3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(147, 'vastag 3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 'Normál', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 'Vastag', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(150, '1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(151, '', 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(152, 'Normál', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(153, 'Vastag', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(154, 'Vastag vegyes', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(155, '1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(156, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(157, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(158, 'normál', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 'vastag', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(160, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(161, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(162, '1/2\"', NULL, NULL, 2000, NULL, NULL, NULL, NULL),
(163, '1/2\"', NULL, NULL, 5000, NULL, NULL, NULL, NULL),
(164, '3/4\"', NULL, NULL, 2000, NULL, NULL, NULL, NULL),
(165, '3/4\"', NULL, NULL, 5000, NULL, NULL, NULL, NULL),
(166, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(167, NULL, 'Műanyag', NULL, NULL, NULL, NULL, NULL, NULL),
(168, '1/2\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(169, '3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(170, '1/2\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(171, '3/4\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(172, '1\"', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(173, NULL, 'Gumi', NULL, NULL, NULL, NULL, NULL, NULL),
(174, NULL, 'Gumi', NULL, NULL, NULL, NULL, NULL, NULL),
(175, '8', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(176, '9', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(177, '10', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(178, '11', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(179, '12', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(180, '13', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(181, '14', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(182, '15', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(183, '16', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(184, '17', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(185, '18', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(186, '19', 'Fém', NULL, NULL, NULL, NULL, NULL, NULL),
(187, NULL, 'poliészter', NULL, NULL, NULL, NULL, NULL, 'fekete'),
(188, NULL, 'poliészter', NULL, NULL, NULL, NULL, NULL, 'fehér'),
(189, NULL, 'poliészter', NULL, NULL, NULL, NULL, NULL, 'narancssárga'),
(190, NULL, 'poliészter', NULL, NULL, NULL, NULL, NULL, 'zöld'),
(191, '10', 'Bőr', NULL, NULL, NULL, NULL, NULL, 'Fehér'),
(192, '10', 'Bőr', NULL, NULL, NULL, NULL, NULL, 'Barna'),
(193, '11', 'Bőr', NULL, NULL, NULL, NULL, NULL, 'fehér-piros'),
(194, '10', 'Bőr', NULL, NULL, NULL, NULL, NULL, 'fehér - piros'),
(195, '2.22', 'alumínium-oxidból', NULL, 12.5, 0.1, NULL, NULL, NULL),
(196, '2.22', 'Gyémánt', NULL, 12.5, NULL, NULL, NULL, NULL),
(197, '2.22', 'fém csiszolótárcsa', NULL, 12.5, 0.64, NULL, NULL, NULL),
(198, '2.22', 'Gyémánt', NULL, 12.5, 0.5, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `email` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `billing_detail_id` int(11) NOT NULL,
  `transport_detail_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `status_id` int(2) NOT NULL,
  `ordered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `canceled_at` timestamp NULL DEFAULT NULL,
  `is_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `canceler_user_id` int(11) DEFAULT NULL,
  `order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`id`, `first_name`, `last_name`, `phone`, `email`, `user_id`, `billing_detail_id`, `transport_detail_id`, `payment_method_id`, `status_id`, `ordered_at`, `canceled_at`, `is_canceled`, `canceler_user_id`, `order_id`) VALUES
(1, '', '', '', '', 1, 1, 1, 1, 7, '2025-11-11 19:29:51', NULL, 0, NULL, 0),
(2, '', '', '', '', 1, 1, 1, 1, 1, '2025-11-20 19:29:51', NULL, 0, NULL, 0),
(3, '', '', '', '', 1, 1, 1, 1, 6, '2025-11-21 19:29:51', NULL, 0, NULL, 0),
(4, '', '', '', '', 3, 1, 1, 1, 2, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(5, '', '', '', '', 1, 1, 1, 1, 5, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(6, '', '', '', '', 1, 1, 1, 1, 3, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(7, '', '', '', '', 1, 1, 1, 1, 3, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(8, '', '', '', '', 1, 1, 1, 1, 4, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(9, '', '', '', '', 1, 1, 1, 1, 7, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(10, '', '', '', '', 1, 1, 1, 1, 6, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(11, '', '', '', '', 1, 1, 1, 1, 6, '2026-04-07 18:29:51', NULL, 0, NULL, 0),
(12, '', '', '', '', 1, 1, 1, 1, 1, '2026-04-07 18:29:51', NULL, 0, NULL, 0);

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
  `name` varchar(1000) NOT NULL,
  `description` longtext NOT NULL,
  `price` int(7) NOT NULL,
  `discount` int(2) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `amount` int(100) NOT NULL,
  `detail_id` int(11) NOT NULL,
  `stock_keeping_unit` varchar(255) NOT NULL,
  `brand_id` int(11) DEFAULT '3',
  `category_id` int(11) NOT NULL,
  `view_count` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `discount`, `created_at`, `updated_at`, `deleted_at`, `is_deleted`, `amount`, `detail_id`, `stock_keeping_unit`, `brand_id`, `category_id`, `view_count`) VALUES
(1, '1/4\" Racsni Króm', '1/4\" Racsni Króm', 3000, 0, '2025-10-22 07:44:26', '2025-12-04 09:12:09', NULL, 0, 500, 1, '888888881', 3, 21, 6),
(2, '3/8\" Racsni Króm', '3/8\" Racsni Króm', 3200, 0, '2025-10-22 11:28:15', '2025-12-04 09:13:09', NULL, 0, 200000, 2, '888888882', 3, 21, 0),
(3, '1/2\" Racsni Króm', '1/2\" Racsni Króm', 3600, 0, '2025-10-22 11:58:03', '2025-12-04 09:15:33', NULL, 0, 10, 3, '888888883', 3, 21, 0),
(4, '1/4\" Racsni Króm, gumírozott markolattal', '1/4\" Racsni Króm, gumírozott markolattal', 1500, 0, '2025-11-19 09:07:05', '2025-12-04 09:34:05', NULL, 0, 100, 4, '888888884', 3, 21, 0),
(5, '3/8\" Racsni Króm, gumírozott markolattal', '3/8\" Racsni Króm, gumírozott markolattal', 2500, 0, '2025-11-19 09:07:05', '2025-12-04 09:34:05', NULL, 0, 2, 5, '888888885', 3, 21, 0),
(6, '1/2\" Racsni Króm, gumírozott markolattal', '1/2\" Racsni Króm, gumírozott markolattal', 3000, 0, '2025-11-19 09:09:07', '2025-12-04 09:34:05', NULL, 0, 300, 6, '888888886', 3, 21, 0),
(7, '1/4-es 5,5 cm-es racsnitoldó', '1/4-es racsni toldó 5,5 cm-es hosszal', 1350, 0, '2025-11-19 09:09:07', '2025-12-22 19:46:49', NULL, 0, 100, 7, '888888887', 3, 2, 11),
(8, '1/4\" 7.5 cm-es racsnitoldó', '1/4\"-es 7.5 cm-es racsnitoldó', 1500, 0, '2025-11-19 09:10:55', '2025-12-22 20:05:57', NULL, 0, 110, 8, '888888888', 3, 2, 20),
(9, '1/4\" 10 cm-es racsnitoldó', '1/4\" 10 cm-es racsnitoldó', 1700, 0, '2025-11-19 09:10:55', '2025-12-22 20:07:32', NULL, 0, 10, 9, '888888889', 3, 2, 0),
(10, '1/4\" 15 cm-es racsnitoldó', '1/4\" 15 cm-es racsnitoldó', 2100, 0, '2025-12-22 20:10:49', NULL, NULL, 0, 100, 10, '8888888810', 3, 2, 0),
(11, '1/4\" 23 cm-es racsnitoldó', '1/4\" 23 cm-es racsnitoldó', 2300, 0, '2025-12-22 20:10:49', NULL, NULL, 0, 100, 11, '8888888811', 3, 2, 0),
(12, '3/8\" 7.5 cm-es racsnitoldó', '3/8\" 7.5 cm-es racsnitoldó', 2100, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 12, '8888888812', 3, 2, 0),
(13, '3/8\" 12.5 cm-es racsnitoldó', '3/8\" 12.5 cm-es racsnitoldó', 2200, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 13, '8888888813', 3, 2, 0),
(14, '3/8\" 15 cm-es racsnitoldó', '3/8\" 15 cm-es racsnitoldó', 2400, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 14, '8888888814', 3, 2, 1),
(15, '3/8\" 20 cm-es racsnitoldó', '3/8\" 20 cm-es racsnitoldó', 2500, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 15, '8888888815', 3, 2, 0),
(16, '1/2\" 10 cm-es racsnitoldó', '1/2\" 10 cm-es racsnitoldó', 1800, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 16, '8888888816', 3, 2, 0),
(17, '1/2\" 12.5 cm-es racsnitoldó', '1/2\" 12.5 cm-es racsnitoldó', 2100, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 17, '8888888817', 3, 2, 0),
(18, '1/2\" 20 cm-es racsnitoldó', '1/2\" 20 cm-es racsnitoldó', 2800, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 18, '8888888818', 3, 2, 0),
(19, '3/4\" 10 cm-es racsnitoldó', '3/4\" 10 cm-es racsnitoldó', 5600, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 19, '8888888819', 3, 2, 0),
(20, '3/4\" 20 cm-es racsnitoldó', '3/4\" 20 cm-es racsnitoldó', 7500, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 20, '8888888820', 3, 2, 0),
(21, '3/4\" 40 cm-es racsnitoldó', '3/4\" 40 cm-es racsnitoldó', 9900, 0, '2025-12-23 19:03:35', '2025-12-23 18:51:18', NULL, 0, 100, 21, '8888888821', 3, 2, 0),
(22, '1/4\"  fixhajtószár', '1/4\"  fixhajtószár', 1000, 0, '2025-12-23 19:27:19', '2025-12-23 19:22:33', NULL, 0, 100, 22, '8888888822', 3, 5, 1),
(23, '3/8\"  fixhajtószár', '3/8\"  fixhajtószár', 2000, 0, '2025-12-23 19:27:19', '2025-12-23 19:22:33', NULL, 0, 100, 23, '8888888823', 3, 5, 1),
(24, '1/2\"  fixhajtószár rövid', '1/2\"  fixhajtószár rövid', 3200, 0, '2025-12-23 19:27:19', '2025-12-23 19:22:33', NULL, 0, 100, 24, '8888888824', 3, 5, 0),
(25, '1/2\"  fixhajtószár hosszú', '1/2\"  fixhajtószár hosszú', 3800, 0, '2025-12-23 19:27:19', '2025-12-23 19:22:33', NULL, 0, 100, 25, '8888888825', 3, 5, 0),
(26, '3/4\"  fixhajtószár', '3/4\"  fixhajtószár', 11500, 0, '2025-12-23 19:27:19', '2025-12-23 19:22:33', NULL, 0, 100, 26, '8888888826', 3, 5, 0),
(27, 'Beépített torx T30', '', 1600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 27, '8888888827', 3, 13, 0),
(28, 'Beépített torx T40', '', 1600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 28, '8888888828', 3, 13, 0),
(29, 'Beépített torx T45', '', 1600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 29, '8888888829', 3, 13, 0),
(30, 'Beépített torx T50', '', 1600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 30, '8888888830', 3, 13, 0),
(31, 'Beépített torx T55', '', 1700, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 31, '8888888831', 3, 13, 0),
(32, 'Beépített torx T60', '', 1700, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 32, '8888888832', 3, 13, 0),
(33, 'Beépített torx T70', '', 1900, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 33, '8888888833', 3, 13, 0),
(34, 'Beépített torx M12', '', 2100, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 34, '8888888834', 3, 13, 0),
(35, 'Beépített torx M14', '', 2600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 35, '8888888835', 3, 13, 0),
(36, 'Beépített torx M16', '', 2600, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 36, '8888888836', 3, 13, 0),
(37, 'Beépített torx M17', '', 2800, 0, '2026-01-26 12:28:16', NULL, NULL, 0, 100, 37, '8888888837', 3, 13, 0),
(38, 'Imbuszkulcs 4-es mértű', 'Imbuszkulcs 4-es mértű', 300, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 38, '8888888838', 3, 14, 0),
(39, 'Imbuszkulcs 5-ös', 'Imbuszkulcs 5-ös', 350, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 39, '8888888839', 3, 14, 0),
(40, 'Imbuszkulcs 6-os', 'Imbuszkulcs 6-os', 350, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 40, '8888888840', 3, 14, 0),
(41, 'Imbuszkulcs 7-es', 'Imbuszkulcs 7-es', 500, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 41, '8888888841', 3, 14, 0),
(42, 'Imbuszkulcs 8-as', 'Imbuskulcs 8-as', 700, 100, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 42, '8888888842', 3, 14, 0),
(43, 'Imbuszkulcs 10-es', 'Imbuszkulcs 10-es', 800, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 43, '8888888843', 3, 14, 0),
(44, 'Imbuszkulcs 12-es', 'Imbuszkulcs 12-es', 1200, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 44, '8888888844', 3, 14, 0),
(45, 'Imbuszkulcs 13', 'Imbuszkulcs 13', 1400, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 45, '8888888845', 3, 14, 0),
(46, 'Imbuszkulcs 14-es', 'Imbuszkulcs 14-es', 1700, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 46, '8888888846', 3, 14, 0),
(47, 'Imbuszkulcs 17-es', 'Imbuszkulcs 17-es', 3200, 0, '2026-01-29 09:00:12', NULL, NULL, 0, 100, 47, '8888888847', 3, 14, 0),
(48, 'Imbuszkulcs 19-es', 'Imbuszkulcs 19-es', 3500, 0, '2026-01-29 09:02:24', NULL, NULL, 0, 100, 48, '8888888848', 3, 14, 0),
(49, '7-es Csillagvillás kulcs', '7-es Csillagvillás kulcs', 500, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 49, '8888888849', 3, 16, 1),
(50, '8-as Csillagvillás kulcs', '8-as Csillagvillás kulcs', 500, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 50, '8888888850', 3, 16, 0),
(51, '9-es Csillagvillás kulcs', '9-es Csillagvillás kulcs', 500, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 51, '8888888851', 3, 16, 0),
(52, '10-es Csillagvillás kulcs', '10-es Csillagvillás kulcs', 600, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 52, '8888888852', 3, 16, 0),
(53, '11-es Csillagvillás kulcs', '11-es Csillagvillás kulcs', 600, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 53, '8888888853', 3, 16, 0),
(54, '12-es Csillagvillás kulcs', '12-es Csillagvillás kulcs', 700, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 54, '8888888854', 3, 16, 0),
(55, '13-as Csillagvillás kulcs', '13-as Csillagvillás kulcs', 800, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 55, '8888888855', 3, 16, 0),
(56, '14-es Csillagvillás kulcs', '14-es Csillagvillás kulcs', 800, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 56, '8888888856', 3, 16, 0),
(57, '15-ös Csillagvillás kulcs', '15-ös Csillagvillás kulcs', 1100, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 57, '8888888857', 3, 16, 0),
(58, '16-os Csillagvillás kulcs', '16-os Csillagvillás kulcs', 1100, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 58, '8888888858', 3, 16, 0),
(59, '17-es Csillagvillás kulcs', '17-es Csillagvillás kulcs', 1200, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 59, '8888888859', 3, 16, 0),
(60, '18-as Csillagvillás kulcs', '18-as Csillagvillás kulcs', 1200, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 60, '8888888860', 3, 16, 0),
(61, '19-es Csillagvillás kulcs', '19-es Csillagvillás kulcs', 1500, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 61, '8888888861', 3, 16, 0),
(62, '21-es Csillagvillás kulcs', '21-es Csillagvillás kulcs', 1600, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 62, '8888888862', 3, 16, 0),
(63, '22-es Csillagvillás kulcs', '22-es Csillagvillás kulcs', 1800, 0, '2026-01-29 10:16:39', NULL, NULL, 0, 100, 63, '8888888863', 3, 16, 0),
(64, '24-es csillagvillás kulcs', '24-es Csillagvillás kulcs', 2800, 0, '2026-01-29 10:29:59', NULL, NULL, 0, 100, 64, '8888888864\r\n', 3, 16, 0),
(65, '27-es Csillagvillás kulcs', '27-es Csillagvillás kulcs', 3800, 0, '2026-01-29 10:29:59', NULL, NULL, 0, 100, 65, '8888888865', 3, 16, 0),
(66, '30-as Csillagvillás kulcs', '30-as Csillagvillás kulcs', 4800, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 66, '8888888866', 3, 16, 0),
(67, '32-es Csillagvillás kulcs', '32-es Csillagvillás kulcs', 5300, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 67, '8888888867', 3, 16, 0),
(68, '36-os Csillagvillás kulcs', '36-os Csillagvillás kulcs', 7500, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 68, '8888888868', 3, 16, 0),
(69, '41-es Csillagvillás kulcs', '41-es Csillagvillás kulcs', 9400, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 69, '8888888869', 3, 16, 0),
(70, '46-os Csillagvillás kulcs', '46-os Csillagvillás kulcs', 10400, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 70, '8888888870', 3, 16, 0),
(71, '55-ös Csillagvillás kulcs', '55-ös Csillagvillás kulcs', 10800, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 71, '8888888871', 3, 16, 0),
(72, '60-as Csillagvillás kulcs', '60-as Csillagvillás kulcs', 12900, 0, '2026-01-29 10:47:42', NULL, NULL, 0, 100, 72, '8888888872', 3, 16, 0),
(73, 'Olcsó csillagvillás kulcs 11-es', '', 300, 0, '2026-02-02 09:49:53', NULL, NULL, 0, 100, 73, '8888888873', 3, 16, 0),
(74, 'Olcsó csillagvillás kulcs 14-es', 'Olcsó csillagvillás kulcs 14-es', 400, 0, '2026-02-02 09:49:53', NULL, NULL, 0, 100, 74, '8888888874', 3, 16, 0),
(75, 'Olcsó csillagvillás kulcs 32-es', 'Olcsó csillagvillás kulcs 32-es', 1800, 0, '2026-02-02 09:49:53', NULL, NULL, 0, 100, 75, '8888888875', 3, 16, 0),
(76, 'Olcsó csillagvillás kulcs 30-as', 'Olcsó csillagvillás kulcs 30-as', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 76, '8888888876', 3, 16, 0),
(77, 'Olcsó csillagvillás kulcs 31-es', 'Olcsó csillagvillás kulcs 31-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 77, '8888888877', 3, 16, 0),
(78, 'Olcsó csillagvillás kulcs 33-as', 'Olcsó csillagvillás kulcs 33-as', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 78, '8888888878', 3, 16, 0),
(79, 'Olcsó csillagvillás kulcs 34-es', 'Olcsó csillagvillás kulcs 34-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 79, '8888888879', 3, 16, 0),
(80, 'Olcsó csillagvillás kulcs 35-ös', 'Olcsó csillagvillás kulcs 35-ös', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 80, '8888888880', 3, 16, 0),
(81, 'Olcsó csillagvillás kulcs 36-os', 'Olcsó csillagvillás kulcs 36-os', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 81, '8888888881', 3, 16, 0),
(82, 'Olcsó csillagvillás kulcs 37-es', 'Olcsó csillagvillás kulcs 37-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 82, '8888888882', 3, 16, 0),
(83, 'Olcsó csillagvillás kulcs 38-as', 'Olcsó csillagvillás kulcs 38-as', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 83, '8888888883', 3, 16, 0),
(84, 'Olcsó csillagvillás kulcs 39-es', 'Olcsó csillagvillás kulcs 39-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 84, '8888888884', 3, 16, 0),
(85, 'Olcsó csillagvillás kulcs 40-as', 'Olcsó csillagvillás kulcs 40-as', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 85, '8888888885', 3, 16, 0),
(86, 'Olcsó csillagvillás kulcs 41-es', 'Olcsó csillagvillás kulcs 41-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 86, '8888888886', 3, 16, 0),
(87, 'Olcsó csillagvillás kulcs 42-es', 'Olcsó csillagvillás kulcs 42-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 87, '8888888887', 3, 16, 0),
(88, 'Olcsó csillagvillás kulcs 43-as', 'Olcsó csillagvillás kulcs 43-as', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 88, '8888888888', 3, 16, 0),
(89, 'Olcsó csillagvillás kulcs 44-es', 'Olcsó csillagvillás kulcs 44-es', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 89, '8888888889', 3, 16, 0),
(90, 'Olcsó csillagvillás kulcs 45-ös', 'Olcsó csillagvillás kulcs 45-ös', 2500, 0, '2026-02-02 09:58:23', NULL, NULL, 0, 100, 90, '8888888890', 3, 16, 0),
(91, 'Olcsó Csillagvillás kulcs 46-os', 'Olcsó Csillagvillás kulcs 46-os', 2500, 0, '2026-02-02 10:04:49', NULL, NULL, 0, 100, 91, '8888888891', 3, 16, 0),
(92, 'Fékcsőkulcs 11-es', 'Fékcsőkulcs 11-es', 2200, 0, '2026-02-02 11:41:33', NULL, NULL, 0, 100, 92, '8888888892', 3, 17, 0),
(93, 'Fékcsőkulcs 12-es', 'Fékcsőkulcs 12-es', 2200, 0, '2026-02-02 11:41:33', NULL, NULL, 0, 100, 93, '8888888893', 3, 17, 0),
(94, 'Fékcsőkulcs 13-as', 'Fékcsőkulcs 13-as', 2200, 0, '2026-02-02 11:41:33', NULL, NULL, 0, 100, 94, '8888888894', 3, 17, 0),
(95, '\"T\" kulcs', '\"T\" kulcs', 800, 0, '2026-02-02 11:44:02', NULL, NULL, 0, 100, 95, '8888888895', 3, 18, 0),
(96, 'Fűnyíró damil 15 méteres műanyag 1.3mm-es  ', 'Fűnyíró damil 15 méteres műanyag 1.3mm-es  ', 400, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 96, '8888888896', 3, 19, 0),
(97, 'Fűnyíró damil 15 méteres műanyag 1.6mm-es  ', 'Fűnyíró damil 15 méteres műanyag 1.6mm-es  ', 500, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 97, '8888888897', 3, 19, 0),
(98, 'Fűnyíró damil 15 méteres műanyag 2mm-es  ', 'Fűnyíró damil 15 méteres műanyag 2mm-es  ', 700, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 98, '8888888898', 3, 19, 0),
(99, 'Fűnyíró damil 15 méteres műanyag 2.4mm-es  ', 'Fűnyíró damil 15 méteres műanyag 2.4mm-es  ', 900, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 99, '8888888899', 3, 19, 0),
(100, 'Fűnyíró damil 15 méteres műanyag 2.7mm-es  ', 'Fűnyíró damil 15 méteres műanyag 2.7mm-es  ', 1100, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 100, '88888888100', 3, 19, 0),
(101, 'Fűnyíró damil 15 méteres műanyag 3mm-es  ', 'Fűnyíró damil 15 méteres műanyag 3mm-es  ', 1300, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 101, '88888888101', 3, 19, 0),
(102, 'Fűnyíró damil 50 méteres műanyag 2mm-es  ', 'Fűnyíró damil 50 méteres műanyag 2mm-es  ', 1700, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 102, '88888888102', 3, 19, 0),
(103, 'Fűnyíró damil 50 méteres műanyag 2.4mm-es  ', 'Fűnyíró damil 50 méteres műanyag 2.4mm-es  ', 2300, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 103, '88888888103', 3, 19, 0),
(104, 'Fűnyíró damil 50 méteres műanyag 2.7mm-es  ', 'Fűnyíró damil 50 méteres műanyag 2.7mm-es  ', 2900, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 104, '88888888104', 3, 19, 0),
(105, 'Fűnyíró damil 50 méteres műanyag 3mm-es  ', 'Fűnyíró damil 50 méteres műanyag 3mm-es  ', 3400, 0, '2026-02-02 12:21:16', NULL, NULL, 0, 100, 105, '88888888104', 3, 19, 0),
(106, 'Fűnyíró damil alumíniumos 15 méteres 1.6mm-es  ', 'Fűnyíró damil alumíniumos 15 méteres 1.6mm-es  ', 700, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 101, 106, '88888888106', 3, 20, 12),
(107, 'Fűnyíró damil alumíniumos 15 méteres 2mm-es ', 'Fűnyíró damil alumíniumos 15 méteres 2mm-es ', 900, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 107, '88888888107', 3, 20, 2),
(108, 'Fűnyíró damil alumíniumos 15 méteres 2.4mm-es ', 'Fűnyíró damil alumíniumos 15 méteres 2.4mm-es ', 1200, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 108, '88888888108', 3, 20, 1),
(109, 'Fűnyíró damil alumíniumos 15 méteres 2.7mm-es ', 'Fűnyíró damil alumíniumos 15 méteres 2.7mm-es ', 1500, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 109, '88888888109', 3, 20, 0),
(110, 'Fűnyíró damil alumíniumos 15 méteres 3mm-es ', 'Fűnyíró damil alumíniumos 15 méteres 3mm-es ', 1700, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 110, '88888888110', 3, 20, 0),
(111, 'Fűnyíró damil alumíniumos 50 méteres 2mm-es ', 'Fűnyíró damil alumíniumos 50 méteres 2mm-es ', 2200, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 111, '88888888111', 3, 20, 0),
(112, 'Fűnyíró damil alumíniumos 50 méteres 2.4mm-es ', 'Fűnyíró damil alumíniumos 50 méteres 2.4mm-es ', 3000, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 112, '88888888112', 3, 20, 0),
(113, 'Fűnyíró damil alumíniumos 50 méteres 2.7mm-es ', 'Fűnyíró damil alumíniumos 50 méteres 2.7mm-es ', 3700, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 113, '88888888113', 3, 20, 0),
(114, 'Fűnyíró damil alumíniumos 50 méteres 3mm-es ', 'Fűnyíró damil alumíniumos 50 méteres 3mm-es ', 4500, 0, '2026-02-09 12:06:17', NULL, NULL, 0, 100, 114, '88888888114', 3, 20, 0),
(115, 'Adapter 1/4\" - 6,3mm ', 'Adapter 1/4\" - 6,3mm ', 500, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 115, '88888888115', 3, 3, 0),
(116, 'Adapter 3/8\" - 1/4\"', 'Adapter 3/8\" - 1/4\"', 750, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 116, '88888888116', 3, 3, 0),
(117, 'Adapter 1/4\" - 3/8\"', 'Adapter 1/4\" - 3/8\"', 750, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 117, '88888888117', 3, 3, 1),
(118, 'Adapter 1/2\" - 3/8\"', 'Adapter 1/2\" - 3/8\"', 850, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 118, '88888888118', 3, 3, 0),
(119, 'Adapter 3/8\" - 1/2\"', 'Adapter 3/8\" - 1/2\"', 850, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 119, '88888888119', 3, 3, 0),
(120, 'Adapter 1/2\" - 3/4\"', 'Adapter 1/2\" - 3/4\"', 2900, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 120, '88888888120', 3, 3, 0),
(121, 'Adapter 3/4\" - 1/2\"', 'Adapter 3/4\" - 1/2\"', 3600, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 121, '88888888121', 3, 3, 0),
(122, 'Adapter 1\" - 3/4\"', 'Adapter 1\" - 3/4\"', 7500, 0, '2026-02-23 09:24:41', NULL, NULL, 0, 100, 122, '88888888122', 3, 3, 0),
(123, 'Csuklo 1/4\"', 'Csuklo 1/4\"', 2000, 0, '2026-02-23 09:30:36', NULL, NULL, 0, 100, 123, '88888888123', 3, 4, 0),
(124, 'Csuklo 3/8\"', 'Csuklo 3/8\"', 2000, 0, '2026-02-23 09:30:36', NULL, NULL, 0, 0, 124, '88888888124', 3, 4, 0),
(125, 'Csuklo 1/2\"', 'Csuklo 1/2\"', 2000, 0, '2026-02-23 09:30:36', NULL, NULL, 0, 100, 125, '88888888125', 3, 4, 0),
(126, 'Jobi racsni 1/4\"', 'Jobi racsni 1/4\"', 4000, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 126, '88888888126', 1, 21, 0),
(127, 'Jobi racsni 3/8\"', 'Jobi racsni 3/8\"', 5000, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 127, '88888888127', 1, 21, 0),
(128, 'Jobi racsni 1/2\"', 'Jobi racsni 1/2\"', 6000, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 128, '88888888128', 1, 21, 0),
(129, 'Honiton racsni 1/4\"', 'Honiton racsni 1/4\"', 4500, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 129, '88888888129', 2, 21, 0),
(130, 'Honiton racsni 3/8\"', 'Honiton racsni 3/8\"', 6500, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 130, '88888888130', 2, 21, 0),
(131, 'Honiton racsni 1/2\"', 'Honiton racsni 1/2\"', 7500, 0, '2026-02-23 10:13:07', NULL, NULL, 0, 100, 131, '88888888131', 2, 21, 0),
(132, 'Gyorscsatlakozó 1/2\"', 'Gyorscsatlakozó 1/2\"', 600, 0, '2026-02-24 10:59:54', NULL, NULL, 0, 100, 132, '88888888132', 3, 22, 0),
(133, 'Gyorscsatlakozó 3/4\"', 'Gyorscsatlakozó 3/4\"', 600, 0, '2026-02-24 10:59:54', NULL, NULL, 0, 100, 133, '88888888133', 3, 22, 0),
(134, 'Gyorscsatlakozó vastag 3/4\"', 'Gyorscsatlakozó vastag 3/4\"', 1200, 0, '2026-02-24 10:59:54', NULL, NULL, 0, 100, 134, '88888888134', 3, 22, 0),
(135, 'Gyorscsatlakozó piros 1\"', 'Gyorscsatlakozó piros 1\"', 1600, 0, '2026-02-24 10:59:54', NULL, NULL, 0, 100, 135, '88888888135', 3, 22, 0),
(136, 'Gyorscsatlakozó Powerjet 1\"', 'Gyorscsatlakozó Powerjet 1\"', 1700, 0, '2026-02-24 10:59:54', NULL, NULL, 0, 100, 136, '88888888136', 4, 22, 0),
(137, 'Összekötő 1/2\"', 'Összekötő 1/2\"', 600, 0, '2026-02-24 11:13:18', NULL, NULL, 0, 100, 137, '88888888137', 3, 23, 0),
(138, 'Összekötő 3/4\"', 'Összekötő 3/4\"', 600, 0, '2026-02-24 11:13:18', NULL, NULL, 0, 100, 138, '88888888138', 3, 23, 0),
(139, 'Összekötő 1\"', 'Összekötő 1\"', 1400, 0, '2026-02-24 11:13:18', NULL, NULL, 0, 100, 139, '888888888139', 3, 23, 0),
(140, 'Összekötő 1/2\"-3/4\"', 'Összekötő 1/2\"-3/4\"', 550, 0, '2026-02-24 11:13:18', NULL, NULL, 0, 100, 140, '88888888140', 3, 23, 0),
(141, 'Összekötő 3/4\"-1\"', 'Összekötő 3/4\"-1\"', 1400, 0, '2026-02-24 11:13:18', NULL, NULL, 0, 100, 141, '88888888141', 3, 23, 0),
(142, 'Csapcsatlakozó 1/2\"-3/4\"', 'Csapcsatlakozó 1/2\"-3/4\"', 400, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 142, '88888888142', 3, 24, 0),
(143, 'Csapcsatlakozó 3/4\"-1\"', 'Csapcsatlakozó 3/4\"-1\"', 400, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 143, '88888888143', 3, 24, 0),
(144, 'Csapcsatlakozó vastag 3/4\"-1\"', 'Csapcsatlakozó vastag 3/4\"-1\"', 800, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 144, '88888888144', 3, 24, 0),
(145, 'Csapcsatlakozó elzárható', 'Csapcsatlakozó elzárható', 800, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 145, '88888888145', 3, 24, 0),
(146, 'Csapcsatlakozó külsőmenetes 3/4\"', 'Csapcsatlakozó külsőmenetes 3/4\"', 300, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 146, '88888888146', 3, 24, 0),
(147, 'Csapcsatlakozó külsőmenetes vastag 3/4\"', 'Csapcsatlakozó külsőmenetes vastag 3/4\"', 400, 0, '2026-02-24 11:44:29', NULL, NULL, 0, 100, 147, '88888888147', 3, 24, 0),
(148, 'Kuplung normál', 'Kuplung normál', 300, 0, '2026-02-24 12:12:33', NULL, NULL, 0, 100, 148, '88888888148', 3, 25, 0),
(149, 'Kuplung vastag', 'Kuplung vastag', 450, 0, '2026-02-24 12:12:33', NULL, NULL, 0, 100, 149, '88888888149', 3, 25, 0),
(150, 'Kuplung 1\"', 'Kuplung 1\"', 600, 0, '2026-02-24 12:12:33', NULL, NULL, 0, 100, 150, '88888888150', 3, 25, 0),
(151, 'Kuplung elzárható', 'Kuplung elzárható', 800, 0, '2026-02-24 12:12:33', NULL, NULL, 0, 100, 151, '88888888151', 3, 25, 0),
(152, ',,Y\" elágazó normál ', ',,Y\" elágazó normál ', 400, 0, '2026-03-02 09:10:49', NULL, NULL, 0, 100, 152, '88888888152', 3, 26, 0),
(153, ',,Y\" elágazó vastag', ',,Y\" elágazó vastag', 450, 0, '2026-03-02 09:10:49', NULL, NULL, 0, 100, 153, '88888888153', 3, 26, 0),
(154, ',,Y\" elágazó vastag vegyes', ',,Y\" elágazó vastag vegyes', 450, 0, '2026-03-02 09:10:49', NULL, NULL, 0, 100, 154, '88888888154', 3, 26, 0),
(155, ',,Y\" elágazó 1\"', ',,Y\" elágazó 1\"', 900, 0, '2026-03-02 09:10:49', NULL, NULL, 0, 100, 155, '88888888155', 3, 26, 0),
(156, ',,Y\" elágazó elzárható', ',,Y\" elágazó elzárható', 2200, 0, '2026-03-02 09:10:49', NULL, NULL, 0, 100, 156, '88888888156', 3, 26, 0),
(157, 'Elosztó 4-es', 'Elosztó 4-es', 4200, 0, '2026-03-02 09:14:45', NULL, NULL, 0, 100, 157, '88888888157', 3, 27, 0),
(158, 'Sugárcső normál', 'Sugárcső normál', 550, 0, '2026-03-02 09:20:57', NULL, NULL, 0, 100, 158, '88888888158', 3, 28, 0),
(159, 'Sugárcső vastag', 'Sugárcső vastag', 1200, 0, '2026-03-02 09:20:57', NULL, NULL, 0, 100, 159, '88888888159', 3, 28, 0),
(160, 'Öntöző pisztoly 8 funkciós', 'Öntöző pisztoly 8 funkciós', 1950, 0, '2026-03-02 09:24:10', NULL, NULL, 0, 100, 160, '88888888160', 3, 29, 0),
(161, 'Öntöző pisztoly sugár', 'Öntöző pisztoly sugár', 1500, 0, '2026-03-02 09:24:10', NULL, NULL, 0, 100, 161, '88888888161', 3, 29, 0),
(162, 'Tömlő 1/2\" 20m', 'Tömlő 1/2\" 20m', 4900, 0, '2026-03-02 09:32:40', NULL, NULL, 0, 100, 162, '88888888162', 3, 33, 0),
(163, 'Tömlő 1/2\" 50m', 'Tömlő 1/2\" 50m', 12500, 0, '2026-03-02 09:32:40', NULL, NULL, 0, 100, 163, '88888888163', 3, 33, 0),
(164, 'Tömlő 3/4\" 25m', 'Tömlő 3/4\" 25m', 12500, 0, '2026-03-02 09:32:40', NULL, NULL, 0, 100, 164, '88888888164', 3, 34, 0),
(165, 'Tömlő 3/4\" 50m', 'Tömlő 3/4\" 50m', 24000, 0, '2026-03-02 09:32:40', NULL, NULL, 0, 100, 165, '88888888165', 3, 34, 0),
(166, 'Öntöző Helikopteres', 'Öntöző Helikopteres', 2200, 0, '2026-03-02 09:36:08', NULL, NULL, 0, 100, 166, '88888888166', 3, 31, 0),
(167, 'Öntöző Szektoros', 'Öntöző Szektoros', 1600, 0, '2026-03-02 09:36:08', NULL, NULL, 0, 100, 167, '88888888167', 3, 31, 0),
(168, 'Kerticsapok Műanyag 1/2\"', 'Kerticsapok Műanyag 1/2\"', 1350, 0, '2026-03-02 09:41:50', NULL, NULL, 0, 100, 168, '88888888168', 3, 35, 0),
(169, 'Kerticsapok Műanyag 3/4\"', 'Kerticsapok Műanyag 3/4\"', 1350, 0, '2026-03-02 09:41:50', NULL, NULL, 0, 100, 169, '88888888169', 3, 35, 0),
(170, 'Kerticsapok Egyenes 1/2\"', 'Kerticsapok Egyenes 1/2\"', 900, 0, '2026-03-02 09:41:50', NULL, NULL, 0, 100, 170, '88888888170', 3, 36, 0),
(171, 'Kerticsapok Egyenes 3/4\"', 'Kerticsapok Egyenes 3/4\"', 1000, 0, '2026-03-02 09:41:50', NULL, NULL, 0, 100, 171, '88888888171', 3, 36, 0),
(172, 'Kerticsapok Egyenes 1\"', 'Kerticsapok Egyenes 1\"', 1400, 0, '2026-03-02 09:41:50', NULL, NULL, 0, 100, 172, '88888888172', 3, 36, 0),
(173, 'Tömítés klt.', 'Tömítés klt.', 350, 0, '2026-03-02 09:45:46', NULL, NULL, 0, 100, 173, '88888888173', 3, 32, 0),
(174, '\"O\" gyűrű', '\"O\" gyűrű', 80, 0, '2026-03-02 09:45:46', NULL, NULL, 0, 10000, 174, '88888888174', 3, 32, 0),
(175, 'Dugófej 1/2\" 6 lapos 8-as', 'Dugófej 1/2\" 6 lapos 8-as', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 175, '88888888175', 3, 39, 0),
(176, 'Dugófej 1/2\" 6 lapos 9-es', 'Dugófej 1/2\" 6 lapos 9-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 176, '88888888176', 3, 39, 0),
(177, 'Dugófej 1/2\" 6 lapos 10-es', 'Dugófej 1/2\" 6 lapos 10-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 177, '88888888177', 3, 39, 0),
(178, 'Dugófej 1/2\" 6 lapos 11-es', 'Dugófej 1/2\" 6 lapos 11-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 178, '88888888178', 3, 39, 0),
(179, 'Dugófej 1/2\" 6 lapos 12-es', 'Dugófej 1/2\" 6 lapos 12-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 179, '88888888179', 3, 39, 0),
(180, 'Dugófej 1/2\" 6 lapos 13-as', 'Dugófej 1/2\" 6 lapos 13-as', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 180, '88888888180', 3, 39, 0),
(181, 'Dugófej 1/2\" 6 lapos 14-es', 'Dugófej 1/2\" 6 lapos 14-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 181, '88888888181', 3, 39, 0),
(182, 'Dugófej 1/2\" 6 lapos 15-ös', 'Dugófej 1/2\" 6 lapos 15-ös', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 182, '88888888182', 3, 39, 0),
(183, 'Dugófej 1/2\" 6 lapos 16-os', 'Dugófej 1/2\" 6 lapos 16-os', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 183, '88888888183', 3, 39, 0),
(184, 'Dugófej 1/2\" 6 lapos 17-es', 'Dugófej 1/2\" 6 lapos 17-es', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 184, '88888888184', 3, 39, 0),
(185, 'Dugófej 1/2\" 6 lapos 18-as', 'Dugófej 1/2\" 6 lapos 18-as', 900, 0, '2026-04-03 07:32:11', NULL, NULL, 0, 100, 185, '88888888185', 3, 39, 0),
(186, 'Védőkesztyű 11 PURE BLACK PRO', 'Poliuretán (PU) bevonatú kesztyű.\r\nKötött poliészterből készült PVC pöttyökkel.\r\nPoliészter kötöttáruból készült - 13-as öltés\r\n. Vágás- és szakadásálló.', 1200, 0, '2026-04-27 11:20:29', NULL, NULL, 0, 100, 187, '88888888187', 3, 38, 0),
(187, 'Védőkesztyű 9 NITROX WHITE', 'Védőkesztyű 9 NITROX WHITE', 1200, 0, '2026-04-27 11:20:29', NULL, NULL, 0, 100, 188, '88888888188', 3, 38, 0),
(188, 'Védőkesztyű 10 WINTER FOX', 'Védőkesztyű 10 WINTER FOX, latex, vastag', 1400, 0, '2026-04-27 11:20:29', NULL, NULL, 0, 100, 189, '88888888189', 3, 38, 0),
(189, 'Védőkesztyű 9 TERMO GRIP GREEN', 'Védőkesztyű 9 TERMO GRIP GREEN', 1100, 0, '2026-04-27 11:20:29', NULL, NULL, 0, 100, 190, '88888888190', 3, 38, 0),
(190, 'Bőr védőkesztyű 10\"', 'Bőr védőkesztyű 10\" WHITE CE EN 420', 2300, 0, '2026-04-27 11:27:48', NULL, NULL, 0, 100, 191, '88888888191', 3, 37, 0),
(191, 'Védőkesztyű, kecskebőr ', 'Védőkesztyű, kecskebőr CORK TERMO10,5, thermo béléssel', 3000, 0, '2026-04-27 11:27:48', NULL, NULL, 0, 100, 192, '88888888192', 3, 37, 0),
(192, 'Kecskebőr védőkesztyű 11-es ', 'Kecskebőr védőkesztyű 11-es méret WHITEBIRD CORE *A', 2500, 0, '2026-04-27 11:27:48', NULL, NULL, 0, 100, 193, '88888888193', 3, 37, 0),
(193, 'Kecskebőr védőkesztyű 10\"', 'Kecskebőr védőkesztyű 10\" RED CE EN 388', 2500, 0, '2026-04-27 11:27:48', NULL, NULL, 0, 100, 194, '88888888194', 3, 37, 0),
(194, 'Fémvágókorong 125x1,0mmx22,2mm CATA', 'A CATA korongok a rendkívül kopásálló szemcséknek köszönhetően biztosítják a magas minőséget.\r\n\r\nalumínium-oxidból készült. A nagy vágási teljesítmény biztosítása érdekében a CATA tárcsák üvegszálas szövettel vannak megerősítve.\r\n\r\nszintetikus gyanta kötőanyagként, amely megköti a korong csiszolóanyagát. Lapos acél vágókorong. Vágásra tervezték:\r\n\r\nkemény és lágy acél, öntöttvas, acélöntvények, alumínium rudak, szelvények, csövek, lemezek, vékony profilok és lemezek formájában,\r\n\r\nfémrudak és huzalok keresztmetszetű vágása.', 160, 0, '2026-04-27 11:51:15', NULL, NULL, 0, 100, 195, '88888888195', 3, 11, 0),
(195, 'Szegmenses csiszolótárcsa betonhoz 125 mm/22,2 mm szimpla Z-alak', 'Speciális, nagyon nagy gyémánttal ellátott gyémántcsiszolókorong, amelyet beton, látszóbeton, tégla, térkő, klinker, pórusbeton és kerámialapok felületeinek tisztítására és egyenetlenségeinek csiszolására használnak.\r\n\r\n• A 125 mm átmérőjű gyémánt csiszolókorong betonfelületek sarokcsiszolóval történő csiszolására szolgál.\r\n\r\n• A gyémánt fazékkorong hosszú élettartamát kiváló műszaki paraméterek biztosítják.\r\n\r\n• A modern hőkezelési eljárások és a speciális felületkezelés csökkentik a tárcsa kopását és javítják a tartósságot.\r\n\r\n• Az 5 mm magas gyémánt lehetővé teszi a korong hosszú távú használatát anélkül, hogy újra kellene cserélni.\r\n\r\n• A korong ideális egyenetlenségek eltávolítására, nagy betonfelületek alakítására és csiszolására.', 4000, 0, '2026-04-27 11:51:15', NULL, NULL, 0, 100, 196, '88888888196', 3, 11, 0),
(196, 'Csiszoló korong 125x6.4mm RAPID', '- fém csiszolótárcsa\r\n- tárcsa külső átmérője: 125 mm\r\n- furat átmérője: 22,2 mm\r\n- tárcsa vastagsága: 6,4 mm\r\n- alkalmazás: kemény szénacél köszörülés, ideális fémlemez csiszolására', 450, 0, '2026-04-27 11:51:15', NULL, NULL, 0, 100, 197, '88888888197', 3, 11, 0),
(197, 'Gyémántcsiszoló korong 125x5x22,2 (Turbo, menet nélküli) Marpol', 'Gyémánt kés turbó betoncsiszoláshoz.\r\n- a tárcsa külső átmérője: 125mm\r\n- gyémánt magasság: 5mm', 4000, 0, '2026-04-27 11:51:15', NULL, NULL, 0, 100, 198, '88888888198', 3, 11, 0);

-- --------------------------------------------------------

--
-- Table structure for table `product_image`
--

CREATE TABLE `product_image` (
  `id` int(11) NOT NULL,
  `image_path` longtext NOT NULL,
  `placement` int(2) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product_image`
--

INSERT INTO `product_image` (`id`, `image_path`, `placement`, `product_id`) VALUES
(1, 'http://localhost:8080/images/products/racsni_1.4.jpg', 1, 1),
(2, 'http://localhost:8080/images/products/racsni_3.8.jpg', 1, 2),
(3, 'http://localhost:8080/images/products/racsni_1.2.jpg', 1, 3),
(4, 'http://localhost:8080/images/products/racsni_1.4.jpg', 1, 4),
(5, 'http://localhost:8080/images/products/racsni_3.8_gumi.jpg', 1, 5),
(6, 'http://localhost:8080/images/products/racsni_1.2_gumi.jpg', 1, 6),
(7, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 7),
(8, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 8),
(9, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 9),
(10, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 9),
(11, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 11),
(12, 'http://localhost:8080/images/products/racsni_toldo2.jpg', 1, 12),
(13, 'http://localhost:8080/images/products/racsni_toldo2.jpg', 1, 13),
(14, 'http://localhost:8080/images/products/racsni_toldo2.jpg', 1, 14),
(15, 'http://localhost:8080/images/products/racsni_toldo2.jpg', 1, 15),
(16, 'http://localhost:8080/images/products/racsni_toldo3.jpg', 1, 16),
(17, 'http://localhost:8080/images/products/racsni_toldo3.jpg', 1, 17),
(18, 'http://localhost:8080/images/products/racsni_toldo3.jpg', 1, 18),
(19, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 19),
(20, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 20),
(21, 'http://localhost:8080/images/products/racsni_toldo1.jpg', 1, 21),
(22, 'http://localhost:8080/images/products/racsni_fix-hajtoszar1.jpg', 1, 22),
(23, 'http://localhost:8080/images/products/racsni_fix-hajtoszar1.jpg', 1, 23),
(24, 'http://localhost:8080/images/products/racsni_fix-hajtoszar3.jpg', 1, 24),
(25, 'http://localhost:8080/images/products/racsni_fix-hajtoszar2.jpg', 1, 25),
(26, 'http://localhost:8080/images/products/racsni_fix-hajtoszar1.jpg', 1, 26),
(27, 'http://localhost:8080/images/products/racsni_adapter1.jpg', 1, 115),
(28, 'http://localhost:8080/images/products/racsni_adapter2.jpg', 1, 116),
(29, 'http://localhost:8080/images/products/racsni_adapter3.jpg', 1, 117),
(30, 'http://localhost:8080/images/products/racsni_adapter1.jpg', 1, 118),
(31, 'http://localhost:8080/images/products/racsni_adapter2.jpg', 1, 119),
(32, 'http://localhost:8080/images/products/racsni_adapter3.jpg', 1, 120),
(33, 'http://localhost:8080/images/products/racsni_adapter1.jpg', 1, 121),
(34, 'http://localhost:8080/images/products/racsni_adapter2.jpg', 1, 122),
(35, 'http://localhost:8080/images/products/racsni_csuklo1.jpg', 1, 123),
(36, 'http://localhost:8080/images/products/racsni_csuklo2.jpg', 1, 124),
(37, 'http://localhost:8080/images/products/racsni_csuklo3.jpg', 1, 125),
(38, 'http://localhost:8080/images/products/racsni_1.4.jpg', 1, 126),
(39, 'http://localhost:8080/images/products/racsni_3.8_gumi.jpg', 1, 127),
(40, 'http://localhost:8080/images/products/racsni_1.2_gumi.jpg', 1, 128),
(41, 'http://localhost:8080/images/products/racsni_1.4.jpg', 1, 129),
(42, 'http://localhost:8080/images/products/racsni_3.8_gumi.jpg', 1, 130),
(43, 'http://localhost:8080/images/products/racsni_1.2_gumi.jpg', 1, 131);

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `review_text` longtext NOT NULL,
  `rate` int(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id`, `product_id`, `user_id`, `review_text`, `rate`, `created_at`, `deleted_at`, `is_deleted`, `updated_at`) VALUES
(1, 1, 1, 'Megint át lesz írva', 3, '2025-11-19 09:55:32', NULL, 0, '2025-11-20 20:01:24'),
(2, 2, 2, '(Teszt2)', 4, '2025-11-19 09:55:32', NULL, 0, NULL),
(3, 3, 3, '(Teszt3)', 5, '2025-11-19 09:56:03', NULL, 0, NULL),
(4, 4, 4, '(Teszt4)', 3, '2025-11-19 09:56:03', NULL, 0, NULL),
(5, 5, 5, '(Teszt5)', 5, '2025-11-19 09:56:35', NULL, 0, NULL),
(6, 6, 6, '(Teszt6)', 4, '2025-11-19 09:56:35', NULL, 0, NULL),
(7, 7, 7, '(Teszt7)', 5, '2025-11-19 09:58:38', NULL, 0, NULL),
(8, 8, 8, '(Teszt8)', 3, '2025-11-19 09:58:38', NULL, 0, NULL),
(9, 9, 9, '(Teszt9)', 5, '2025-11-19 09:59:34', NULL, 0, NULL),
(10, 9, 14, '(Teszt10)', 5, '2025-11-19 09:59:34', NULL, 0, NULL),
(11, 3, 8, 'tessszt', 5, '2025-11-20 11:25:21', NULL, 0, NULL),
(12, 106, 13, 'Teszt ', 4, '2026-02-22 17:22:15', NULL, 0, NULL),
(13, 106, 16, 'lalalala', 3, '2026-02-22 17:47:10', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`id`, `name`) VALUES
(1, 'ROLE_user'),
(2, 'ROLE_admin');

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
-- Table structure for table `transport_detail`
--

CREATE TABLE `transport_detail` (
  `id` int(11) NOT NULL,
  `post_code` int(4) NOT NULL,
  `town` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `address_type_id` int(11) NOT NULL,
  `house_number` int(3) NOT NULL,
  `other` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `transport_detail`
--

INSERT INTO `transport_detail` (`id`, `post_code`, `town`, `address`, `address_type_id`, `house_number`, `other`) VALUES
(1, 2000, 'asd', 'asdasd', 222, 222, ''),
(2, 1001, 'b', 'b', 24, 1001, NULL),
(3, 1002, 'c', 'c', 15, 1002, NULL),
(4, 1003, 'd', 'd', 214, 1001, NULL),
(5, 1002, 'e', 'e', 115, 1002, NULL),
(6, 1003, 'd', 'd', 214, 1003, NULL),
(7, 1004, 'e', 'e', 115, 1004, NULL),
(8, 1005, 'f', 'f', 21, 1005, NULL),
(9, 1006, 'g', 'g', 11, 1006, NULL),
(10, 1007, 'h', 'h', 281, 1007, NULL),
(11, 1008, 'i', 'i', 101, 1008, NULL),
(12, 1009, 'j', 'j', 181, 1009, NULL),
(13, 1010, 'k', 'k', 121, 1010, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` longtext NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone_number` varchar(30) DEFAULT NULL,
  `pfp_path` longtext NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT '1',
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `register_finished_at` timestamp NULL DEFAULT NULL,
  `v_code` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `first_name`, `last_name`, `phone_number`, `pfp_path`, `role_id`, `is_deleted`, `deleted_at`, `last_login`, `register_finished_at`, `v_code`) VALUES
(1, 'TesztElek@gmail.com', 'alma5678', 'Teszt', 'Elek', NULL, 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(2, 'JánosTesztel@gmail.com', 'alma5678', 'Teszt', 'János', NULL, 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(3, 'Email1@gmail.com', 'alma5678', 'Teszt1', 'Teszt1', '+11111111111', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', '2025-11-23 18:50:57', NULL, NULL),
(4, 'Email2@gmail.com', 'alma5678', 'Teszt2', 'Teszt2', '+11111111112', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(5, 'Email3@gmail.com', 'alma5678', 'Teszt3', 'Teszt3', '+11111111113', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(6, 'Email4@gmail.com', 'alma5678', 'Teszt4', 'Teszt4', '+11111111114', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(7, 'Email5@gmail.com', 'alma5678', 'Teszt5', 'Teszt5', '+11111111115', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(8, 'Email6@gmail.com', 'alma5678', 'Teszt6', 'Teszt6', '+11111111116', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:56:27', NULL, NULL, NULL),
(9, 'Email7@gmail.com', 'alma5678', 'Teszt7', 'Teszt7', '+11111111117', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:58:14', NULL, NULL, NULL),
(10, 'Email8@gmail.com', 'alma5678', 'Teszt8', 'Teszt8', '+11111111118', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:58:14', NULL, NULL, NULL),
(11, 'Email9@gmail.com', 'alma5678', 'Teszt9', 'Teszt9', '+11111111119', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:58:14', NULL, NULL, NULL),
(12, 'Email10@gmail.com', 'alma5678', 'Teszt10', 'Teszt10', '+11111111110', 'http://localhost:8080/pfp/default.png', 1, 1, '2026-03-02 11:58:14', NULL, NULL, NULL),
(13, 'asdadasad@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$ojdkmaYKQNEw75vyk4Azlg$gTqHjf8YOMxUS8etGkpbOThqEslHT4oC1vqpX97ecaA', 'adadadasd', 'asdadsa', '-', 'http://localhost:8080/pfp/default.png', 1, 0, NULL, '2026-02-23 12:24:25', NULL, NULL),
(14, 'test@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$AlmRO5ZErc7T8cCdEge4VQ$Dcnfht4865P16+AY+i0bYh+uYnYiTbqFB/UhjsGKY7g', 'testUpdate', 'test', '06706285232', 'http://localhost:8080/pfp/14464639745_1052396210015983_856568762032357262_n.jpg', 1, 0, NULL, '2026-03-14 14:55:38', NULL, NULL),
(15, 'test2@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$ohREETSjVyYm+Rf48odKFA$6YuNM79joGYzr9nxAhYx88LFuiOzlTc6vj9xmemcXzU', 'test2U', 'test2', NULL, 'http://localhost:8080/pfp/15464639745_1052396210015983_856568762032357262_n.jpg', 2, 0, NULL, '2026-04-07 18:29:58', NULL, NULL),
(16, 'lalala@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$cc9rixcvbHAmCVQnUcyw2w$ABFHiZsUcEDHaw3e2Ge8OxDpPZCf5uaOv4D7Kjd+9dE', 'Teszt', 'lalala', NULL, 'assets/pfp/default.png', 1, 0, NULL, '2026-02-22 17:46:53', NULL, NULL),
(17, 'asd1@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$1uX4hdH8FJtHFxj1ymEHJw$NOPftVu6YUoQFwdSsOcTAX0AgzWwW2d4lJccYkHWluc', 'qewqweqeasdadasd', 'qeqweqweqwqeqwe', NULL, 'assets/pfp/default.png', 1, 0, NULL, '2026-04-14 15:02:52', NULL, NULL),
(18, 'EngedjBe1234567@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$60Da5W9NbGXlXFCtqEOKXA$Cpp6UqruejIb6aUtvZt3/SyRqxytNmsnMAXxriznw7E', 'Be1234567.', 'Engedj', NULL, 'http://localhost:8080/pfp/default.png', 2, 0, NULL, '2026-04-24 06:58:55', NULL, NULL),
(19, 'TesztNev1234@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$tW7R8UCbsO0U5x6aEOG+rw$0qCoPXu7p7XkE0ltRSqSySUDyIxDbdk52Cknh9QlRX0', 'Név1234.', 'Teszt', NULL, 'http://localhost:8080/pfp/default.png', 1, 0, NULL, NULL, NULL, NULL),
(27, 'NagyRoland1234@gmail.com', '$argon2id$v=19$m=4096,t=3,p=1$cRPu9WxG0+nip38wiW0z/g$vzH9Pb6XKXju9og7qLnH0lcMCunVzG985M8IDok+hGY', 'Roland', 'Nagy', NULL, 'http://localhost:8080/pfp/default.png', 1, 0, NULL, '2026-04-24 08:01:23', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address_type`
--
ALTER TABLE `address_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `address_user`
--
ALTER TABLE `address_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `address_id` (`billing_detail_id`) USING BTREE,
  ADD KEY `user_id` (`user_id`),
  ADD KEY `ad_transport` (`transport_detail_id`);

--
-- Indexes for table `billing_detail`
--
ALTER TABLE `billing_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `a_type` (`address_type_id`);

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
-- Indexes for table `order_history`
--
ALTER TABLE `order_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payment_method` (`payment_method_id`),
  ADD KEY `status` (`status_id`),
  ADD KEY `order_user` (`user_id`),
  ADD KEY `history_billing` (`billing_detail_id`),
  ADD KEY `history_transport` (`transport_detail_id`);

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
  ADD KEY `brand` (`brand_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_image`
--
ALTER TABLE `product_image`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_image` (`product_id`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transport_detail`
--
ALTER TABLE `transport_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `a_type2` (`address_type_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address_type`
--
ALTER TABLE `address_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=336;

--
-- AUTO_INCREMENT for table `address_user`
--
ALTER TABLE `address_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `billing_detail`
--
ALTER TABLE `billing_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `brand`
--
ALTER TABLE `brand`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `cart_product`
--
ALTER TABLE `cart_product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `details`
--
ALTER TABLE `details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=199;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=198;

--
-- AUTO_INCREMENT for table `product_image`
--
ALTER TABLE `product_image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `transport_detail`
--
ALTER TABLE `transport_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address_user`
--
ALTER TABLE `address_user`
  ADD CONSTRAINT `ad_billing` FOREIGN KEY (`billing_detail_id`) REFERENCES `billing_detail` (`id`),
  ADD CONSTRAINT `ad_transport` FOREIGN KEY (`transport_detail_id`) REFERENCES `transport_detail` (`id`),
  ADD CONSTRAINT `ad_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `billing_detail`
--
ALTER TABLE `billing_detail`
  ADD CONSTRAINT `a_type` FOREIGN KEY (`address_type_id`) REFERENCES `address_type` (`id`);

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
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `cat` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);

--
-- Constraints for table `order_history`
--
ALTER TABLE `order_history`
  ADD CONSTRAINT `history_billing` FOREIGN KEY (`billing_detail_id`) REFERENCES `billing_detail` (`id`),
  ADD CONSTRAINT `history_transport` FOREIGN KEY (`transport_detail_id`) REFERENCES `transport_detail` (`id`),
  ADD CONSTRAINT `order_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `payment_method` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`id`),
  ADD CONSTRAINT `status` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`);

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order` FOREIGN KEY (`order_id`) REFERENCES `order_history` (`id`),
  ADD CONSTRAINT `order_product_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`),
  ADD CONSTRAINT `category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `detail` FOREIGN KEY (`detail_id`) REFERENCES `details` (`id`);

--
-- Constraints for table `product_image`
--
ALTER TABLE `product_image`
  ADD CONSTRAINT `product_image` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

--
-- Constraints for table `transport_detail`
--
ALTER TABLE `transport_detail`
  ADD CONSTRAINT `a_type2` FOREIGN KEY (`address_type_id`) REFERENCES `address_type` (`id`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
