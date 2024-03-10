-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2024 at 08:31 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pusl2022_uptime`
--

-- --------------------------------------------------------

--
-- Table structure for table `sensordata`
--

CREATE TABLE `sensordata` (
  `logID` int(11) NOT NULL,
  `UID` int(11) DEFAULT NULL,
  `timeofdata` datetime DEFAULT NULL,
  `vibration` decimal(10,2) DEFAULT NULL,
  `temprature` decimal(10,2) DEFAULT NULL,
  `fuelLevel` decimal(10,2) DEFAULT NULL,
  `oilPressure` decimal(10,2) DEFAULT NULL,
  `current` decimal(10,2) DEFAULT NULL,
  `sound` decimal(10,2) DEFAULT NULL,
  `gas` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensordata`
--

INSERT INTO `sensordata` (`logID`, `UID`, `timeofdata`, `vibration`, `temprature`, `fuelLevel`, `oilPressure`, `current`, `sound`, `gas`) VALUES
(1, 1, '2024-03-10 13:01:28', '4.00', '23.00', '31.00', '0.00', '22.00', '63.00', '711.00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UID` int(11) NOT NULL,
  `Uname` varchar(500) NOT NULL,
  `Uemail` varchar(200) NOT NULL,
  `Upass` varchar(200) NOT NULL,
  `Uphone` varchar(10) NOT NULL,
  `GenName` varchar(500) NOT NULL,
  `GenLocation` varchar(1000) NOT NULL,
  `installationDate` date NOT NULL,
  `manufacturer` varchar(500) NOT NULL,
  `lastMaintenanceDate` date DEFAULT NULL,
  `operatingHours` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UID`, `Uname`, `Uemail`, `Upass`, `Uphone`, `GenName`, `GenLocation`, `installationDate`, `manufacturer`, `lastMaintenanceDate`, `operatingHours`) VALUES
(1, 'Ashen Abeysekara', 'ashendul@gmail.com', 'examplepassword123', '0778494082', 'PowerMax 5000', 'No.3 Samagi Mawatha, Depanama, Pannipitiya', '2023-12-15', 'GenCorp', NULL, 25),
(2, 'Johnson Corp', 'johnson@example.com', 'securepassword', '5559876543', 'UltraGen 200', 'Warehouse', '2024-01-23', 'SuperGen', NULL, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `sensordata`
--
ALTER TABLE `sensordata`
  ADD PRIMARY KEY (`logID`),
  ADD KEY `UID` (`UID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sensordata`
--
ALTER TABLE `sensordata`
  MODIFY `logID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `sensordata`
--
ALTER TABLE `sensordata`
  ADD CONSTRAINT `sensordata_ibfk_1` FOREIGN KEY (`UID`) REFERENCES `users` (`UID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
