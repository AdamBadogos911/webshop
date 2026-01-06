-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 06, 2026 at 12:53 PM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProductXcategories` ()   BEGIN
	SELECT *from `product_categories`
    WHERE `product_categories`.`is_deleted`=0
    ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllReview` ()   BEGIN
	
    SELECT * FROM `review`
    
    WHERE`review`.`is_deleted`=0;
    
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
(1, 'Racsni', NULL, 0, NULL),
(2, 'Racsni toldók', 1, 0, NULL),
(3, 'Racsni adapter', 1, 0, NULL),
(4, 'Racsni csukló', 1, 0, NULL),
(5, 'Racsni fix hajtószár', 1, 0, NULL),
(6, 'Dugófejek', NULL, 0, NULL),
(7, 'Damilok', NULL, 0, NULL),
(8, 'Locsoló technika', NULL, 0, NULL),
(9, 'Keztyűk', NULL, 0, NULL),
(10, 'Nyelek', NULL, 0, NULL),
(11, 'Korongok', NULL, 0, NULL),
(12, 'Kerti eszközök', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `details`
--

CREATE TABLE `details` (
  `id` int(11) NOT NULL,
  `weight` double DEFAULT NULL COMMENT 'kg-ban',
  `material` varchar(255) DEFAULT NULL,
  `length` double DEFAULT NULL COMMENT 'cm',
  `height` double DEFAULT NULL COMMENT 'cm',
  `width` double DEFAULT NULL COMMENT 'cm',
  `size` varchar(11) DEFAULT NULL,
  `is_set` tinyint(4) DEFAULT NULL COMMENT 'Szett-e (több dolog egyben)',
  `color` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `details`
--

INSERT INTO `details` (`id`, `weight`, `material`, `length`, `height`, `width`, `size`, `is_set`, `color`) VALUES
(1, NULL, 'Króm', NULL, NULL, NULL, '1/4\"', NULL, 'Króm'),
(2, NULL, 'Króm', NULL, NULL, NULL, '3/8\"', NULL, 'Króm'),
(3, NULL, 'Króm', NULL, NULL, NULL, '1/2\"', NULL, 'Króm'),
(4, NULL, 'Króm, gumi', NULL, NULL, NULL, '1/4\"', NULL, 'Fekete'),
(5, NULL, 'Króm, gumi', NULL, NULL, NULL, '3/8\"', NULL, 'Fekete'),
(6, NULL, 'Króm, gumi', NULL, NULL, NULL, '1/2\"', NULL, 'Fekete'),
(7, NULL, 'Acél', 5.5, NULL, NULL, '1/4\"', NULL, NULL),
(8, NULL, 'Acél', 7.5, NULL, NULL, '1/4\"', NULL, NULL),
(9, NULL, 'Acél', 10, NULL, NULL, '1/4\"', NULL, NULL),
(10, NULL, 'Acél', 15, NULL, NULL, '1/4\"', NULL, NULL),
(11, NULL, 'Acél', 23, NULL, NULL, '1/4\"', NULL, NULL),
(12, NULL, 'Acél', 7.5, NULL, NULL, '3/8\"', NULL, NULL),
(13, NULL, 'Acél', 12.5, NULL, NULL, '3/8\"', NULL, NULL),
(14, NULL, 'Acél', 15, NULL, NULL, '3/8\"', NULL, NULL),
(15, NULL, 'Acél', 20, NULL, NULL, '3/8\"', NULL, NULL),
(16, NULL, 'Acél', 10, NULL, NULL, '1/2\"', NULL, NULL),
(17, NULL, 'Acél', 12.5, NULL, NULL, '1/2\"', NULL, NULL),
(18, NULL, 'Acél', 20, NULL, NULL, '1/2\"', NULL, NULL),
(19, NULL, 'Acél', 10, NULL, NULL, '3/4\"', NULL, NULL),
(20, NULL, 'Acél', 20, NULL, NULL, '3/4\"', NULL, NULL),
(21, NULL, 'Acél', 40, NULL, NULL, '3/4\"', NULL, NULL),
(22, NULL, 'Acél', NULL, NULL, NULL, '1/4\"', NULL, NULL),
(23, NULL, 'Acél', NULL, NULL, NULL, '3/8\"', NULL, NULL),
(24, NULL, 'Acél', 10, NULL, NULL, '1/2\"', NULL, NULL),
(25, NULL, 'Acél', 20, NULL, NULL, '1/2\"', NULL, NULL),
(26, NULL, 'Acél', NULL, NULL, NULL, '3/4\"', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `billing_detail_id` int(11) NOT NULL,
  `transport_detail_id` int(11) NOT NULL,
  `payment_method_id` int(11) NOT NULL,
  `status_id` int(2) NOT NULL,
  `ordered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `canceled_at` datetime DEFAULT NULL,
  `is_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `canceler_user_id` int(11) DEFAULT NULL,
  `order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`id`, `first_name`, `last_name`, `phone`, `email`, `user_id`, `billing_detail_id`, `transport_detail_id`, `payment_method_id`, `status_id`, `ordered_at`, `canceled_at`, `is_canceled`, `canceler_user_id`, `order_id`) VALUES
(1, '', '', '', '', 1, 1, 1, 1, 7, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(2, '', '', '', '', 1, 1, 1, 1, 1, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(3, '', '', '', '', 1, 1, 1, 1, 6, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(4, '', '', '', '', 3, 1, 1, 1, 2, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(5, '', '', '', '', 1, 1, 1, 1, 5, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(6, '', '', '', '', 1, 1, 1, 1, 3, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(7, '', '', '', '', 1, 1, 1, 1, 3, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(8, '', '', '', '', 1, 1, 1, 1, 4, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(9, '', '', '', '', 1, 1, 1, 1, 7, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(10, '', '', '', '', 1, 1, 1, 1, 6, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(11, '', '', '', '', 1, 1, 1, 1, 6, '2025-11-21 12:22:28', NULL, 0, NULL, 0),
(12, '', '', '', '', 1, 1, 1, 1, 1, '2025-11-21 12:22:28', NULL, 0, NULL, 0);

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
  `discount` int(2) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `amount` int(100) NOT NULL,
  `detail_id` int(11) NOT NULL,
  `stock_keeping_unit` varchar(255) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `discount`, `created_at`, `updated_at`, `deleted_at`, `is_deleted`, `amount`, `detail_id`, `stock_keeping_unit`, `brand_id`, `category_id`) VALUES
(1, '1/4\" Racsni Króm', 'Pontos leírás a tárgyról amiről semmi információm nincs, ezért csak gépelek, és majd másolok :)', 3000, 0, '2025-10-22 09:44:26', '2025-12-04 10:12:09', NULL, 0, 500, 1, '888888881', NULL, 1),
(2, '3/8\" Racsni Króm', '3/8\" Racsni Króm', 3200, 0, '2025-10-22 13:28:15', '2025-12-04 10:13:09', NULL, 0, 200000, 2, '888888882', NULL, 1),
(3, '1/2\" Racsni Króm', '1/2\" Racsni Króm', 3600, 0, '2025-10-22 13:58:03', '2025-12-04 10:15:33', NULL, 0, 10, 3, '888888883', NULL, 1),
(4, '1/4\" Racsni Króm, gumírozott markolattal', '1/4\" Racsni Króm, gumírozott markolattal', 1500, 0, '2025-11-19 10:07:05', '2025-12-04 10:34:05', NULL, 0, 100, 4, '888888884', NULL, 1),
(5, '3/8\" Racsni Króm, gumírozott markolattal', '3/8\" Racsni Króm, gumírozott markolattal', 2500, 0, '2025-11-19 10:07:05', '2025-12-04 10:34:05', NULL, 0, 2, 5, '888888885', NULL, 1),
(6, '1/2\" Racsni Króm, gumírozott markolattal', '1/2\" Racsni Króm, gumírozott markolattal', 3000, 0, '2025-11-19 10:09:07', '2025-12-04 10:34:05', NULL, 0, 300, 6, '888888886', NULL, 1),
(7, '1/4-es 5,5 cm-es racsnitoldó', '1/4-es racsni toldó 5,5 cm-es hosszal', 1350, 0, '2025-11-19 10:09:07', '2025-12-22 20:46:49', NULL, 0, 100, 7, '888888887', NULL, 2),
(8, '1/4\" 7.5 cm-es racsnitoldó', '1/4\"-es 7.5 cm-es racsnitoldó', 1500, 0, '2025-11-19 10:10:55', '2025-12-22 21:05:57', NULL, 0, 110, 8, '888888888', NULL, 2),
(9, '1/4\" 10 cm-es racsnitoldó', '1/4\" 10 cm-es racsnitoldó', 1700, 0, '2025-11-19 10:10:55', '2025-12-22 21:07:32', NULL, 0, 10, 9, '888888889', NULL, 2),
(10, '1/4\" 15 cm-es racsnitoldó', '1/4\" 15 cm-es racsnitoldó', 2100, 0, '2025-12-22 21:10:49', NULL, NULL, 0, 100, 10, '8888888810', NULL, 2),
(11, '1/4\" 23 cm-es racsnitoldó', '1/4\" 23 cm-es racsnitoldó', 2300, 0, '2025-12-22 21:10:49', NULL, NULL, 0, 100, 11, '8888888811', NULL, 2),
(12, '3/8\" 7.5 cm-es racsnitoldó', '3/8\" 7.5 cm-es racsnitoldó', 2100, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 12, '8888888812', NULL, 2),
(13, '3/8\" 12.5 cm-es racsnitoldó', '3/8\" 12.5 cm-es racsnitoldó', 2200, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 13, '8888888813', NULL, 2),
(14, '3/8\" 15 cm-es racsnitoldó', '3/8\" 15 cm-es racsnitoldó', 2400, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 14, '8888888814', NULL, 2),
(15, '3/8\" 20 cm-es racsnitoldó', '3/8\" 20 cm-es racsnitoldó', 2500, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 15, '8888888815', NULL, 2),
(16, '1/2\" 10 cm-es racsnitoldó', '1/2\" 10 cm-es racsnitoldó', 1800, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 16, '8888888816', NULL, 2),
(17, '1/2\" 12.5 cm-es racsnitoldó', '1/2\" 12.5 cm-es racsnitoldó', 2100, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 17, '8888888817', NULL, 2),
(18, '1/2\" 20 cm-es racsnitoldó', '1/2\" 20 cm-es racsnitoldó', 2800, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 18, '8888888818', NULL, 2),
(19, '3/4\" 10 cm-es racsnitoldó', '3/4\" 10 cm-es racsnitoldó', 5600, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 19, '8888888819', NULL, 2),
(20, '3/4\" 20 cm-es racsnitoldó', '3/4\" 20 cm-es racsnitoldó', 7500, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 20, '8888888820', NULL, 2),
(21, '3/4\" 40 cm-es racsnitoldó', '3/4\" 40 cm-es racsnitoldó', 9900, 0, '2025-12-23 20:03:35', '2025-12-23 19:51:18', NULL, 0, 100, 21, '8888888821', NULL, 2),
(22, '1/4\"  fixhajtószár', '1/4\"  fixhajtószár', 1000, 0, '2025-12-23 20:27:19', '2025-12-23 20:22:33', NULL, 0, 100, 22, '8888888822', NULL, 5),
(23, '3/8\"  fixhajtószár', '3/8\"  fixhajtószár', 2000, 0, '2025-12-23 20:27:19', '2025-12-23 20:22:33', NULL, 0, 100, 23, '8888888823', NULL, 5),
(24, '1/2\"  fixhajtószár rövid', '1/2\"  fixhajtószár rövid', 3200, 0, '2025-12-23 20:27:19', '2025-12-23 20:22:33', NULL, 0, 100, 24, '8888888824', NULL, 5),
(25, '1/2\"  fixhajtószár hosszú', '1/2\"  fixhajtószár hosszú', 3800, 0, '2025-12-23 20:27:19', '2025-12-23 20:22:33', NULL, 0, 100, 25, '8888888825', NULL, 5),
(26, '3/4\"  fixhajtószár', '3/4\"  fixhajtószár', 11500, 0, '2025-12-23 20:27:19', '2025-12-23 20:22:33', NULL, 0, 100, 26, '', NULL, 5);

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
(1, '', 1, 1),
(2, '', 99, 2),
(3, '', 2, 3),
(4, '', 3, 4),
(5, '', 4, 5),
(6, '', 5, 6),
(7, '', 6, 7),
(8, '', 7, 8),
(9, '', 8, 9),
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
  `rate` int(1) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id`, `product_id`, `user_id`, `review_text`, `rate`, `created_at`, `deleted_at`, `is_deleted`, `updated_at`) VALUES
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
(1, 'user'),
(2, 'admin');

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
  `deleted_at` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `register_finished_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `first_name`, `last_name`, `phone_number`, `pfp_path`, `role_id`, `is_deleted`, `deleted_at`, `last_login`, `register_finished_at`) VALUES
(1, 'TesztElek@gmail.com', 'alma5678', 'Teszt', 'Elek', NULL, '', 1, 0, NULL, NULL, NULL),
(2, 'JánosTesztel@gmail.com', 'alma5678', 'Teszt', 'János', NULL, '', 1, 0, NULL, NULL, NULL),
(3, 'Email1@gmail.com', 'alma5678', 'Teszt1', 'Teszt1', '+11111111111', '', 1, 0, NULL, '2025-11-23 19:50:57', NULL),
(4, 'Email2@gmail.com', 'alma5678', 'Teszt2', 'Teszt2', '+11111111112', '', 1, 0, NULL, NULL, NULL),
(5, 'Email3@gmail.com', 'alma5678', 'Teszt3', 'Teszt3', '+11111111113', '', 1, 0, NULL, NULL, NULL),
(6, 'Email4@gmail.com', 'alma5678', 'Teszt4', 'Teszt4', '+11111111114', '', 1, 0, NULL, NULL, NULL),
(7, 'Email5@gmail.com', 'alma5678', 'Teszt5', 'Teszt5', '+11111111115', '', 1, 0, NULL, NULL, NULL),
(8, 'Email6@gmail.com', 'alma5678', 'Teszt6', 'Teszt6', '+11111111116', '', 1, 0, NULL, NULL, NULL),
(9, 'Email7@gmail.com', 'alma5678', 'Teszt7', 'Teszt7', '+11111111117', '', 1, 0, NULL, NULL, NULL),
(10, 'Email8@gmail.com', 'alma5678', 'Teszt8', 'Teszt8', '+11111111118', '', 1, 0, NULL, NULL, NULL),
(11, 'Email9@gmail.com', 'alma5678', 'Teszt9', 'Teszt9', '+11111111119', '', 1, 0, NULL, NULL, NULL),
(12, 'Email10@gmail.com', 'alma5678', 'Teszt10', 'Teszt10', '+11111111110', '', 1, 0, NULL, NULL, NULL);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `product_image`
--
ALTER TABLE `product_image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

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
