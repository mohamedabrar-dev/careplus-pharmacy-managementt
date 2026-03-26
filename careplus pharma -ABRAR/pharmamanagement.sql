-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 26, 2026 at 07:37 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharmamanagement`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(4, 'Anti-Diabetics'),
(3, 'Antibiotics'),
(6, 'Cardiac / BP'),
(2, 'Cold & Cough'),
(9, 'Eye / Ear / Nasal'),
(5, 'Gastro / Stomach'),
(11, 'Injectables'),
(8, 'Ointments / Creams / Gels'),
(10, 'Others'),
(1, 'Pain / Fever'),
(7, 'Vitamins & Supplements');

-- --------------------------------------------------------

--
-- Table structure for table `category_supplier`
--

CREATE TABLE `category_supplier` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category_supplier`
--

INSERT INTO `category_supplier` (`id`, `category_id`, `supplier_id`) VALUES
(1, 1, 7),
(2, 2, 8),
(3, 3, 9),
(4, 4, 10),
(5, 5, 11),
(6, 6, 12),
(7, 7, 13),
(8, 8, 14),
(9, 9, 15),
(10, 10, 16),
(11, 11, 17);

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

CREATE TABLE `medicines` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `generic_name` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `batch_number` varchar(50) DEFAULT NULL,
  `shelf_location` varchar(50) DEFAULT NULL,
  `requires_prescription` tinyint(1) DEFAULT 0,
  `supplier_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medicines`
--

INSERT INTO `medicines` (`id`, `name`, `generic_name`, `category`, `manufacturer`, `price`, `stock`, `unit`, `expiry_date`, `batch_number`, `shelf_location`, `requires_prescription`, `supplier_id`) VALUES
(10, 'Dolo 650', 'Paracetamol', 'Pain / Fever', 'Micro Labs', 30.00, 174, 'Strip', '2027-05-01', 'DL650A1', 'A1', 0, 7),
(11, 'Crocin', 'Paracetamol', 'Pain / Fever', 'GSK', 28.00, 89, 'Strip', '2027-04-01', 'CR2025', 'A1', 0, 7),
(12, 'Vicks Action 500', 'Paracetamol + Caffeine', 'Cold & Cough', 'Procter & Gamble', 45.00, 33, 'Strip', '2026-11-01', 'VA500X', 'B2', 0, 8),
(13, 'Benadryl Syrup', 'Diphenhydramine', 'Cold & Cough', 'Johnson & Johnson', 110.00, 37, 'Bottle', '2026-09-01', 'BNDR22', 'B2', 0, 8),
(14, 'Azithral 500', 'Azithromycin', 'Antibiotics', 'Alembic', 120.00, 31, 'Strip', '2026-08-01', 'AZ500', 'C1', 1, 9),
(15, 'Amoxyclav 625', 'Amoxicillin + Clavulanic Acid', 'Antibiotics', 'Abbott', 210.00, 26, 'Strip', '2026-07-01', 'AMX625', 'C1', 1, 9),
(16, 'Glycomet 500', 'Metformin', 'Anti-Diabetics', 'USV', 35.00, 79, 'Strip', '2027-02-01', 'GLY500', 'D1', 1, 10),
(17, 'Ecosprin 75', 'Aspirin', 'Cardiac / BP', 'USV', 18.00, 149, 'Strip', '2027-01-01', 'ECO75', 'E1', 1, 12),
(18, 'Digene Gel', 'Magnesium Hydroxide', 'Gastro / Stomach', 'Abbott', 95.00, 54, 'Bottle', '2026-10-01', 'DG2024', 'F1', 0, 11),
(19, 'Becozinc', 'Multivitamins + Zinc', 'Vitamins & Supplements', 'Pfizer', 42.00, 107, 'Strip', '2027-06-01', 'BCZ2025', 'G1', 0, 13),
(20, 'Voveran Gel', 'Diclofenac', 'Ointments / Creams / Gels', 'Novartis', 85.00, 59, 'Tube', '2026-12-01', 'VVG22', 'H1', 0, 14),
(21, 'I-Kul Eye Drops', 'Carboxymethylcellulose', 'Eye / Ear / Nasal', 'Cipla', 95.00, 29, 'Bottle', '2026-06-01', 'IK2024', 'I1', 0, 15),
(22, 'ORS Powder', 'Oral Rehydration Salts', 'Others', 'FDC', 25.00, 99, 'Strip', '2027-05-31', 'OT001', 'J1', 0, 16),
(23, 'Dettol Liquid', 'Chloroxylenol', 'Others', 'Reckitt', 95.00, 39, 'Bottle', '2027-04-30', 'OT002', 'J1', 0, 16),
(24, 'Electral', 'Electrolytes', 'Others', 'FDC', 30.00, 70, 'Strip', '2027-03-31', 'OT003', 'J1', 0, 16),
(25, 'Savlon', 'Antiseptic', 'Others', 'ITC', 90.00, 33, 'Bottle', '2026-12-31', 'OT004', 'J1', 0, 16),
(26, 'Otrivin', 'Xylometazoline', 'Eye / Ear / Nasal', 'GSK', 65.00, 39, 'Bottle', '2026-08-31', 'EN001', 'I1', 0, 15),
(27, 'Ciplox Eye Drops', 'Ciprofloxacin', 'Eye / Ear / Nasal', 'Cipla', 55.00, 59, 'Bottle', '2026-09-30', 'EN002', 'I1', 1, 15),
(28, 'Refresh Tears', 'Carboxymethylcellulose', 'Eye / Ear / Nasal', 'Allergan', 120.00, 29, 'Bottle', '2027-01-31', 'EN003', 'I1', 0, 15),
(29, 'Earwel Drops', 'Chloramphenicol', 'Eye / Ear / Nasal', 'Abbott', 85.00, 44, 'Bottle', '2026-07-31', 'EN004', 'I1', 1, 15),
(30, 'Amlong 5', 'Amlodipine', 'Cardiac / BP', 'Micro Labs', 42.00, 87, 'Strip', '2027-01-31', 'CB001', 'G1', 1, 12),
(31, 'Ecosprin 75', 'Aspirin', 'Cardiac / BP', 'USV', 30.00, 109, 'Strip', '2027-05-31', 'CB002', 'G1', 0, 12),
(32, 'Telma 40', 'Telmisartan', 'Cardiac / BP', 'Glenmark', 65.00, 72, 'Strip', '2026-11-30', 'CB003', 'G1', 1, 12),
(33, 'Met XL 50', 'Metoprolol', 'Cardiac / BP', 'Cipla', 58.00, 77, 'Strip', '2026-12-31', 'CB004', 'G1', 1, 12),
(34, 'Volini Gel', 'Diclofenac Gel', 'Ointments / Creams / Gels', 'Sun Pharma', 85.00, 38, 'Tube', '2027-01-31', 'OG001', 'E1', 0, 14),
(35, 'Betnovate-N', 'Betamethasone + Neomycin', 'Ointments / Creams / Gels', 'GSK', 72.00, 30, 'Tube', '2026-09-30', 'OG002', 'E1', 1, 14),
(36, 'Soframycin', 'Framycetin', 'Ointments / Creams / Gels', 'Sanofi', 55.00, 48, 'Tube', '2026-12-31', 'OG003', 'E1', 0, 14),
(37, 'Burnol', 'Antiseptic Cream', 'Ointments / Creams / Gels', 'Morepen', 60.00, 41, 'Tube', '2027-03-31', 'OG004', 'E1', 0, 14),
(38, 'Glycomet 500', 'Metformin', 'Anti-Diabetics', 'USV', 45.00, 149, 'Strip', '2027-05-31', 'AD001', 'D1', 1, 10),
(39, 'Glimestar 2', 'Glimepiride', 'Anti-Diabetics', 'Mankind', 55.00, 89, 'Strip', '2026-10-31', 'AD002', 'D1', 1, 10),
(40, 'Janumet', 'Sitagliptin + Metformin', 'Anti-Diabetics', 'MSD', 220.00, 39, 'Strip', '2026-12-31', 'AD003', 'D1', 1, 10),
(41, 'Istavel', 'Sitagliptin', 'Anti-Diabetics', 'Sun Pharma', 180.00, 33, 'Strip', '2027-02-28', 'AD004', 'D1', 1, 10),
(42, 'Gelusil', 'Magnesium Hydroxide', 'Gastro / Stomach', 'Pfizer', 75.00, 59, 'Bottle', '2026-10-31', 'GS001', 'F1', 0, 11),
(43, 'Digene', 'Antacid', 'Gastro / Stomach', 'Abbott', 85.00, 49, 'Bottle', '2026-09-30', 'GS002', 'F1', 0, 11),
(44, 'Pan 40', 'Pantoprazole', 'Gastro / Stomach', 'Alkem', 95.00, 79, 'Strip', '2027-04-30', 'GS003', 'F1', 1, 11),
(45, 'Omez', 'Omeprazole', 'Gastro / Stomach', 'Dr Reddy’s', 88.00, 69, 'Strip', '2027-02-28', 'GS004', 'F1', 1, 11),
(46, 'Azithral 500', 'Azithromycin', 'Antibiotics', 'Alembic', 120.00, 49, 'Strip', '2027-01-31', 'AB001', 'C1', 1, 9),
(47, 'Amoxyclav 625', 'Amoxicillin + Clavulanate', 'Antibiotics', 'Abbott', 210.00, 41, 'Strip', '2026-12-31', 'AB002', 'C1', 1, 9),
(48, 'Ciplox 500', 'Ciprofloxacin', 'Antibiotics', 'Cipla', 95.00, 59, 'Strip', '2027-03-31', 'AB003', 'C1', 1, 9),
(49, 'Taxim-O', 'Cefixime', 'Antibiotics', 'Alkem', 160.00, 35, 'Strip', '2026-11-30', 'AB004', 'C1', 1, 9),
(51, 'Calpol 500', 'Paracetamol', 'Pain / Fever', 'GSK', 28.00, 99, 'Strip', '2027-04-30', 'PAF002', 'A1', 0, 7),
(52, 'Brufen 400', 'Ibuprofen', 'Pain / Fever', 'Abbott', 35.00, 87, 'Strip', '2026-12-31', 'PAF003', 'A1', 0, 7),
(53, 'Voveran', 'Diclofenac', 'Pain / Fever', 'Novartis', 42.00, 70, 'Strip', '2026-10-31', 'PAF004', 'A1', 1, 7),
(54, 'Zincovit', 'Multivitamin', 'Vitamins & Supplements', 'Apex', 110.00, 95, 'Strip', '2027-06-30', 'VS001', 'H1', 0, 13),
(55, 'Becosules', 'Vitamin B-Complex', 'Vitamins & Supplements', 'Pfizer', 95.00, 65, 'Strip', '2027-03-31', 'VS002', 'H1', 0, 13),
(56, 'Shelcal 500', 'Calcium + D3', 'Vitamins & Supplements', 'Torrent', 130.00, 52, 'Strip', '2027-02-28', 'VS003', 'H1', 0, 13),
(57, 'Revital H', 'Multivitamin', 'Vitamins & Supplements', 'Sun Pharma', 210.00, 39, 'Bottle', '2026-10-31', 'VS004', 'H1', 0, 13),
(58, 'cough lozenges', 'Dextromethorphan + Menthol', 'Cold & Cough', 'Glenmark Pharmaceuticals', 30.00, 109, 'strip', '2027-07-31', '0001', 'B4', 0, 8),
(59, 'NICIP', 'NIMESULIDE 100', 'Pain / Fever', 'CIPLA LTD', 45.00, 21, 'STRIPS', '2026-06-09', 'NI0001', 'B1', 1, 7),
(61, 'Ceftriaxone Injection', 'Ceftriaxone', 'Injectables', 'Cipla', 120.00, 24, 'Vial', '2027-12-31', 'INJ001', 'Rack-A1', 1, 17),
(62, 'Diclofenac Injection', 'Diclofenac Sodium', 'Injectables', 'Sun Pharma', 35.00, 48, 'Ampoule', '2027-08-31', 'INJ002', 'Rack-A2', 1, 17),
(63, 'Insulin Injection', 'Human Insulin', 'Injectables', 'Novo Nordisk', 280.00, 21, 'Vial', '2027-10-15', 'INJ003', 'Fridge-1', 1, 17),
(64, 'Vitamin B12 Injection', 'Cyanocobalamin', 'Injectables', 'Neuro Pharma', 60.00, 23, 'Ampoule', '2028-01-20', 'INJ004', 'Rack-B1', 1, 17),
(65, 'Pantoprazole Injection', 'Pantoprazole', 'Injectables', 'Dr Reddy', 95.00, 19, 'Vial', '2027-11-11', 'INJ005', 'Rack-C1', 1, 17),
(66, 'Dexamethasone Injection', 'Dexamethasone', 'Injectables', 'Zydus', 55.00, 34, 'Ampoule', '2027-09-09', 'INJ006', 'Rack-A3', 1, 17),
(67, 'Adrenaline Injection', 'Epinephrine', 'Injectables', 'Abbott', 150.00, 19, 'Ampoule', '2027-06-06', 'INJ007', 'Emergency-Box', 1, 17);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `purchase_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `invoice_number` varchar(50) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`purchase_id`, `supplier_id`, `invoice_number`, `purchase_date`, `total_amount`) VALUES
(1, 7, '001', '2026-02-11', 511.20),
(2, 7, '002', '2026-02-11', 322.00),
(3, 13, '003', '2026-02-13', 1120.00),
(4, 7, '002', '2026-02-17', 500.00),
(5, 9, '009', '2026-02-17', 264.00),
(6, 7, '007', '2026-02-17', 440.00),
(7, 15, '009', '2026-02-18', 600.00),
(8, 15, 'INV-008', '2026-02-19', 330.00),
(9, 17, '010', '2026-02-20', 1995.00),
(10, 17, 'INV-20260223115922', '2026-02-23', 2250.00),
(11, 15, 'INV-20260223122452', '2026-02-23', 250.00);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `medicine_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `purchase_price` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`id`, `purchase_id`, `medicine_id`, `quantity`, `purchase_price`, `subtotal`) VALUES
(1, 1, 59, 20, 25.56, 511.20),
(2, 2, 10, 23, 14.00, 322.00),
(3, 3, 54, 35, 32.00, 1120.00),
(4, 4, 59, 20, 25.00, 500.00),
(5, 5, 10, 12, 22.00, 264.00),
(6, 6, 10, 20, 22.00, 440.00),
(7, 7, 29, 20, 30.00, 600.00),
(8, 8, 27, 15, 22.00, 330.00),
(9, 9, 61, 21, 95.00, 1995.00),
(10, 10, 63, 15, 150.00, 2250.00),
(11, 11, 27, 10, 25.00, 250.00);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `sale_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `customer_name`, `customer_phone`, `total_amount`, `sale_date`) VALUES
(1, 'ABRAR', '1234567890', 89.25, '2026-01-28 07:13:36'),
(5, 'israr', '4354316789', 89.25, '2026-02-02 06:17:00'),
(9, 'brian', '1110162026', 321.30, '2026-02-06 05:40:48'),
(10, 'rohith', '1357924680', 661.50, '2026-02-06 05:55:54'),
(11, 'reehan', '0806040201', 446.25, '2026-02-06 06:05:21'),
(12, 'syed', '0209202652', 458.85, '2026-02-09 06:22:37'),
(13, 'AJAY', '7676463834', 521.85, '2026-02-10 05:49:50'),
(14, 'nayaab', '3890480239', 388.50, '2026-02-11 06:40:15'),
(15, 'saud', '3244578642', 285.60, '2026-02-11 07:42:20'),
(16, 'dj', '4521289566', 315.00, '2026-02-13 05:38:10'),
(17, 'manjunath', '8893579052', 1086.75, '2026-02-13 06:31:42'),
(18, 'hhgj', '', 490.35, '2026-02-16 13:43:24'),
(19, 'dkslhlhd', '4254335', 446.25, '2026-02-17 05:59:37'),
(20, 'msd', '467897680', 971.25, '2026-02-18 05:55:29'),
(21, 'john', '3234567890', 1953.00, '2026-02-19 06:05:13'),
(22, 'kumar', '9000000012', 2084.25, '2026-02-20 07:27:17'),
(23, 'Surya', '9000000001', 648.90, '2026-02-23 06:07:53'),
(24, 'jaffer', '900000003', 346.50, '2026-02-26 05:51:28'),
(25, 'Abrar', '9000000003', 4857.30, '2026-02-26 06:16:28');

-- --------------------------------------------------------

--
-- Table structure for table `sales_items`
--

CREATE TABLE `sales_items` (
  `item_id` int(11) NOT NULL,
  `sale_id` int(11) DEFAULT NULL,
  `medicine_id` int(11) DEFAULT NULL,
  `medicine_name` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_items`
--

INSERT INTO `sales_items` (`item_id`, `sale_id`, `medicine_id`, `medicine_name`, `quantity`, `price`) VALUES
(1, 9, 32, 'Telma 40', 2, 65.00),
(2, 9, 33, 'Met XL 50', 2, 58.00),
(3, 9, 37, 'Burnol', 1, 60.00),
(4, 10, 12, 'Vicks Action 500', 14, 45.00),
(5, 11, 43, 'Digene', 5, 85.00),
(6, 12, 14, 'Azithral 500', 2, 120.00),
(7, 12, 52, 'Brufen 400', 1, 35.00),
(8, 12, 35, 'Betnovate-N', 1, 72.00),
(9, 12, 24, 'Electral', 3, 30.00),
(10, 13, 15, 'Amoxyclav 625', 1, 210.00),
(11, 13, 35, 'Betnovate-N', 1, 72.00),
(12, 13, 34, 'Volini Gel', 1, 85.00),
(13, 13, 56, 'Shelcal 500', 1, 130.00),
(14, 14, 12, 'Vicks Action 500', 1, 45.00),
(15, 14, 13, 'Benadryl Syrup', 1, 110.00),
(16, 14, 52, 'Brufen 400', 1, 35.00),
(17, 14, 24, 'Electral', 6, 30.00),
(18, 15, 36, 'Soframycin', 1, 55.00),
(19, 15, 20, 'Voveran Gel', 1, 85.00),
(20, 15, 37, 'Burnol', 1, 60.00),
(21, 15, 35, 'Betnovate-N', 1, 72.00),
(22, 16, 55, 'Becosules', 2, 95.00),
(23, 16, 13, 'Benadryl Syrup', 1, 110.00),
(24, 17, 59, 'NICIP', 23, 45.00),
(25, 18, 47, 'Amoxyclav 625', 1, 210.00),
(26, 18, 55, 'Becosules', 1, 95.00),
(27, 18, 35, 'Betnovate-N', 1, 72.00),
(28, 18, 25, 'Savlon', 1, 90.00),
(29, 19, 14, 'Azithral 500', 1, 120.00),
(30, 19, 47, 'Amoxyclav 625', 1, 210.00),
(31, 19, 55, 'Becosules', 1, 95.00),
(32, 20, 65, 'Pantoprazole Injection', 1, 95.00),
(33, 20, 67, 'Adrenaline Injection', 1, 150.00),
(34, 20, 61, 'Ceftriaxone Injection', 1, 120.00),
(35, 20, 63, 'Insulin Injection', 2, 280.00),
(36, 21, 37, 'Burnol', 1, 60.00),
(37, 21, 61, 'Ceftriaxone Injection', 15, 120.00),
(38, 22, 47, 'Amoxyclav 625', 1, 210.00),
(39, 22, 62, 'Diclofenac Injection', 1, 35.00),
(40, 22, 64, 'Vitamin B12 Injection', 1, 60.00),
(41, 22, 63, 'Insulin Injection', 6, 280.00),
(42, 23, 67, 'Adrenaline Injection', 3, 150.00),
(43, 23, 30, 'Amlong 5', 2, 42.00),
(44, 23, 19, 'Becozinc', 2, 42.00),
(45, 24, 67, 'Adrenaline Injection', 1, 150.00),
(46, 24, 41, 'Istavel', 1, 180.00),
(47, 25, 67, 'Adrenaline Injection', 1, 150.00),
(48, 25, 30, 'Amlong 5', 1, 42.00),
(49, 25, 47, 'Amoxyclav 625', 1, 210.00),
(50, 25, 15, 'Amoxyclav 625', 1, 210.00),
(51, 25, 14, 'Azithral 500', 1, 120.00),
(52, 25, 46, 'Azithral 500', 1, 120.00),
(53, 25, 55, 'Becosules', 1, 95.00),
(54, 25, 19, 'Becozinc', 1, 42.00),
(55, 25, 13, 'Benadryl Syrup', 1, 110.00),
(56, 25, 35, 'Betnovate-N', 1, 72.00),
(57, 25, 52, 'Brufen 400', 1, 35.00),
(58, 25, 37, 'Burnol', 1, 60.00),
(59, 25, 51, 'Calpol 500', 1, 28.00),
(60, 25, 61, 'Ceftriaxone Injection', 1, 120.00),
(61, 25, 48, 'Ciplox 500', 1, 95.00),
(62, 25, 27, 'Ciplox Eye Drops', 1, 55.00),
(63, 25, 58, 'cough lozenges', 1, 30.00),
(64, 25, 11, 'Crocin', 1, 28.00),
(65, 25, 23, 'Dettol Liquid', 1, 95.00),
(66, 25, 66, 'Dexamethasone Injection', 1, 55.00),
(67, 25, 62, 'Diclofenac Injection', 1, 35.00),
(68, 25, 43, 'Digene', 1, 85.00),
(69, 25, 18, 'Digene Gel', 1, 95.00),
(70, 25, 10, 'Dolo 650', 1, 30.00),
(71, 25, 29, 'Earwel Drops', 1, 85.00),
(72, 25, 17, 'Ecosprin 75', 1, 18.00),
(73, 25, 31, 'Ecosprin 75', 1, 30.00),
(74, 25, 24, 'Electral', 1, 30.00),
(75, 25, 42, 'Gelusil', 1, 75.00),
(76, 25, 39, 'Glimestar 2', 1, 55.00),
(77, 25, 16, 'Glycomet 500', 1, 35.00),
(78, 25, 38, 'Glycomet 500', 1, 45.00),
(79, 25, 21, 'I-Kul Eye Drops', 1, 95.00),
(80, 25, 63, 'Insulin Injection', 1, 280.00),
(81, 25, 41, 'Istavel', 1, 180.00),
(82, 25, 40, 'Janumet', 1, 220.00),
(83, 25, 33, 'Met XL 50', 1, 58.00),
(84, 25, 59, 'NICIP', 1, 45.00),
(85, 25, 45, 'Omez', 1, 88.00),
(86, 25, 22, 'ORS Powder', 1, 25.00),
(87, 25, 26, 'Otrivin', 1, 65.00),
(88, 25, 44, 'Pan 40', 1, 95.00),
(89, 25, 65, 'Pantoprazole Injection', 1, 95.00),
(90, 25, 28, 'Refresh Tears', 1, 120.00),
(91, 25, 57, 'Revital H', 1, 210.00),
(92, 25, 25, 'Savlon', 1, 90.00),
(93, 25, 56, 'Shelcal 500', 2, 130.00),
(94, 25, 36, 'Soframycin', 1, 55.00),
(95, 25, 32, 'Telma 40', 1, 65.00),
(96, 25, 12, 'Vicks Action 500', 1, 45.00),
(97, 25, 64, 'Vitamin B12 Injection', 1, 60.00),
(98, 25, 34, 'Volini Gel', 1, 85.00);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(100) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `supplier_name`, `contact_person`, `phone`, `email`, `address`, `created_at`) VALUES
(7, 'PainCare Pharma', 'Arun', '9000000001', 'paincare@gmail.com', 'Chennai', '2026-02-09 07:13:01'),
(8, 'ColdCure Distributors', 'Rahim', '9000000002', 'coldcure@gmail.com', 'Coimbatore', '2026-02-09 07:13:01'),
(9, 'Antibiotic Life Pvt Ltd', 'John', '9000000003', 'antibiotic@gmail.com', 'Madurai', '2026-02-09 07:13:01'),
(10, 'Diabetic Health Supplies', 'Suresh', '9000000004', 'diabetic@gmail.com', 'Trichy', '2026-02-09 07:13:01'),
(11, 'GastroMed Agencies', 'Kumar', '9000000005', 'gastro@gmail.com', 'Salem', '2026-02-09 07:13:01'),
(12, 'CardioCare Pharma', 'Vijay', '9000000006', 'cardio@gmail.com', 'Chennai', '2026-02-09 07:13:01'),
(13, 'Vitamin World Distributors', 'Priya', '9000000007', 'vitamin@gmail.com', 'Erode', '2026-02-09 07:13:01'),
(14, 'SkinCare Ointments Ltd', 'Anil', '9000000008', 'skincare@gmail.com', 'Tirunelveli', '2026-02-09 07:13:01'),
(15, 'EyeEar Health Suppliers', 'Manoj', '9000000009', 'eyeear@gmail.com', 'Vellore', '2026-02-09 07:13:01'),
(16, 'General Medical Traders', 'Imran', '9000000010', 'general@gmail.com', 'Karur', '2026-02-09 07:13:01'),
(17, 'Injectables', 'Bharath', '4932054234', 'injectables@gmail.com', 'banglore', '2026-02-19 06:39:49');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `fullname`, `role`, `password`) VALUES
(1, 'admin', 'System Administrator', 'admin', 'admin123'),
(2, 'ABRAR', 'MOHAMED ABRAR', 'staff', '2004'),
(5, 'mohamed', 'Mohamed Abrar', 'admin', '1909');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `category_supplier`
--
ALTER TABLE `category_supplier`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `medicines`
--
ALTER TABLE `medicines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_supplier` (`supplier_id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`purchase_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_id` (`purchase_id`),
  ADD KEY `medicine_id` (`medicine_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `sale_id` (`sale_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `category_supplier`
--
ALTER TABLE `category_supplier`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `medicines`
--
ALTER TABLE `medicines`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `sales_items`
--
ALTER TABLE `sales_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `category_supplier`
--
ALTER TABLE `category_supplier`
  ADD CONSTRAINT `category_supplier_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `category_supplier_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `medicines`
--
ALTER TABLE `medicines`
  ADD CONSTRAINT `fk_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE SET NULL;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD CONSTRAINT `purchase_items_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`purchase_id`),
  ADD CONSTRAINT `purchase_items_ibfk_2` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`);

--
-- Constraints for table `sales_items`
--
ALTER TABLE `sales_items`
  ADD CONSTRAINT `sales_items_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
