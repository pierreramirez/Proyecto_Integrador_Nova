-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 29-09-2025 a las 08:08:02
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `transportesinterprovincial`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bus`
--

CREATE TABLE `bus` (
  `idBus` int(11) NOT NULL,
  `placa` varchar(20) DEFAULT NULL,
  `capacidadAsientos` int(11) DEFAULT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `bus`
--

INSERT INTO `bus` (`idBus`, `placa`, `capacidadAsientos`, `tipo`, `descripcion`, `creador`, `fechaCreacion`, `estado`) VALUES
(1, 'ABC-123', 40, NULL, 'Bus interprovincial de 40 asientos', 1, '2025-08-31 22:37:22', 1),
(2, 'XYZ-456', 30, NULL, 'Bus turístico de 30 asientos', 1, '2025-08-31 22:37:22', 1),
(3, 'ABZ-321', 20, 'BUS', 'Bus interprovincial de 40 asientos', 1, '2025-08-31 22:37:54', 1),
(4, 'XYZ-654', 30, 'BUS', 'Bus turístico de 30 asientos', 1, '2025-08-31 22:37:54', 1),
(5, 'BUS-005', 45, 'BUS', 'Bus interprovincial de 45 asientos', 1, '2025-09-02 12:00:00', 1),
(6, 'BUS-006', 40, 'BUS', 'Bus interprovincial de 40 asientos', 1, '2025-09-02 12:00:01', 1),
(7, 'MIN-007', 28, 'MINIBUS', 'Minibus para turismo de 28 asientos', 1, '2025-09-02 12:00:02', 1),
(8, 'MIN-008', 25, 'MINIBUS', 'Minibus urbano de 25 asientos', 1, '2025-09-02 12:00:03', 1),
(9, 'COA-009', 30, 'COASTER', 'Coaster de 30 asientos', 1, '2025-09-02 12:00:04', 1),
(10, 'COA-010', 32, 'COASTER', 'Coaster de 32 asientos', 1, '2025-09-02 12:00:05', 1),
(11, 'BUS-011', 50, 'BUS', 'Bus cama de 50 asientos', 1, '2025-09-02 12:00:06', 1),
(12, 'BUS-012', 48, 'BUS', 'Bus interprovincial de 48 asientos', 1, '2025-09-02 12:00:07', 1),
(13, 'MIC-013', 20, 'MICROBUS', 'Microbus de 20 asientos', 1, '2025-09-02 12:00:08', 1),
(14, 'MIC-014', 22, 'MICROBUS', 'Microbus de 22 asientos', 1, '2025-09-02 12:00:09', 1),
(15, 'BUS-015', 40, 'BUS', 'Bus interprovincial de 40 asientos', 1, '2025-09-02 12:00:10', 1),
(16, 'BUS-016', 42, 'BUS', 'Bus interprovincial de 42 asientos', 1, '2025-09-02 12:00:11', 1),
(17, 'MIN-017', 29, 'MINIBUS', 'Minibus ejecutivo de 29 asientos', 1, '2025-09-02 12:00:12', 1),
(18, 'MIN-018', 27, 'MINIBUS', 'Minibus para rutas cortas 27 asientos', 1, '2025-09-02 12:00:13', 1),
(19, 'COA-019', 34, 'COASTER', 'Coaster turístico 34 asientos', 1, '2025-09-02 12:00:14', 1),
(20, 'COA-020', 33, 'COASTER', 'Coaster interprovincial 33 asientos', 1, '2025-09-02 12:00:15', 1),
(21, 'BUS-021', 44, 'BUS', 'Bus turístico 44 asientos', 1, '2025-09-02 12:00:16', 1),
(22, 'BUS-022', 41, 'BUS', 'Bus interprovincial 41 asientos', 1, '2025-09-02 12:00:17', 1),
(23, 'MIC-023', 18, 'MICROBUS', 'Microbus escolar 18 asientos', 1, '2025-09-02 12:00:18', 1),
(24, 'MIC-024', 19, 'MICROBUS', 'Microbus urbano 19 asientos', 1, '2025-09-02 12:00:19', 1),
(25, 'BUS-025', 46, 'BUS', 'Bus ejecutivo 46 asientos', 1, '2025-09-02 12:00:20', 1),
(26, 'BUS-026', 39, 'BUS', 'Bus interprovincial 39 asientos', 1, '2025-09-02 12:00:21', 1),
(27, 'MIN-027', 24, 'MINIBUS', 'Minibus turístico 24 asientos', 1, '2025-09-02 12:00:22', 1),
(28, 'MIN-028', 26, 'MINIBUS', 'Minibus corto 26 asientos', 1, '2025-09-02 12:00:23', 1),
(29, 'COA-029', 31, 'COASTER', 'Coaster interprovincial 31 asientos', 1, '2025-09-02 12:00:24', 1),
(30, 'COA-030', 35, 'COASTER', 'Coaster turístico 35 asientos', 1, '2025-09-02 12:00:25', 1),
(31, 'BUS-031', 47, 'BUS', 'Bus cama ejecutivo 47 asientos', 1, '2025-09-02 12:00:26', 1),
(32, 'BUS-032', 36, 'BUS', 'Bus interprovincial 36 asientos', 1, '2025-09-02 12:00:27', 1),
(33, 'MIC-033', 21, 'MICROBUS', 'Microbus de 21 asientos', 1, '2025-09-02 12:00:28', 1),
(34, 'MIC-034', 23, 'MICROBUS', 'Microbus 23 asientos', 1, '2025-09-02 12:00:29', 1),
(35, 'BUS-035', 43, 'BUS', 'Bus interprovincial 43 asientos', 1, '2025-09-02 12:00:30', 1),
(36, 'BUS-036', 49, 'BUS', 'Bus turístico 49 asientos', 1, '2025-09-02 12:00:31', 1),
(37, 'MIN-037', 29, 'MINIBUS', 'Minibus ejecutivo 29 asientos', 1, '2025-09-02 12:00:32', 1),
(38, 'MIN-038', 28, 'MINIBUS', 'Minibus urbano 28 asientos', 1, '2025-09-02 12:00:33', 1),
(39, 'COA-039', 30, 'COASTER', 'Coaster 30 asientos', 1, '2025-09-02 12:00:34', 1),
(40, 'COA-040', 32, 'COASTER', 'Coaster 32 asientos', 1, '2025-09-02 12:00:35', 1),
(41, 'BUS-041', 45, 'BUS', 'Bus interprovincial 45 asientos', 1, '2025-09-02 12:00:36', 1),
(42, 'BUS-042', 40, 'BUS', 'Bus 40 asientos', 1, '2025-09-02 12:00:37', 1),
(43, 'MIC-043', 20, 'MICROBUS', 'Microbus 20 asientos', 1, '2025-09-02 12:00:38', 1),
(44, 'MIC-044', 22, 'MICROBUS', 'Microbus 22 asientos', 1, '2025-09-02 12:00:39', 1),
(45, 'BUS-045', 38, 'BUS', 'Bus interprovincial 38 asientos', 1, '2025-09-02 12:00:40', 1),
(46, 'BUS-046', 44, 'BUS', 'Bus 44 asientos', 1, '2025-09-02 12:00:41', 1),
(47, 'MIN-047', 27, 'MINIBUS', 'Minibus 27 asientos', 1, '2025-09-02 12:00:42', 1),
(48, 'MIN-048', 26, 'MINIBUS', 'Minibus 26 asientos', 1, '2025-09-02 12:00:43', 1),
(49, 'COA-049', 34, 'COASTER', 'Coaster 34 asientos', 1, '2025-09-02 12:00:44', 1),
(50, 'COA-050', 33, 'COASTER', 'Coaster 33 asientos', 1, '2025-09-02 12:00:45', 1),
(51, 'BUS-051', 41, 'BUS', 'Bus 41 asientos', 1, '2025-09-02 12:00:46', 1),
(52, 'BUS-052', 37, 'BUS', 'Bus 37 asientos', 1, '2025-09-02 12:00:47', 1),
(53, 'MIC-053', 18, 'MICROBUS', 'Microbus 18 asientos', 1, '2025-09-02 12:00:48', 1),
(54, 'MIC-054', 24, 'MICROBUS', 'Microbus 24 asientos', 1, '2025-09-02 12:00:49', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chofer`
--

CREATE TABLE `chofer` (
  `idChofer` int(11) NOT NULL,
  `appat` varchar(250) DEFAULT NULL,
  `apmat` varchar(250) DEFAULT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `dni` int(11) DEFAULT NULL,
  `licenciaConducir` varchar(9) DEFAULT NULL,
  `fechaContratacion` datetime DEFAULT NULL,
  `fechaVencimientoLicencia` date DEFAULT NULL,
  `telefono` int(11) DEFAULT NULL,
  `disponibilidad` int(11) DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `chofer`
--

INSERT INTO `chofer` (`idChofer`, `appat`, `apmat`, `nombre`, `dni`, `licenciaConducir`, `fechaContratacion`, `fechaVencimientoLicencia`, `telefono`, `disponibilidad`, `creador`, `fechaCreacion`, `estado`) VALUES
(1, 'Ramírez', 'Huamán', 'José', 44556677, 'LIC123456', '2025-08-31 22:37:22', '2026-08-20', 999111222, 1, 1, '2025-08-31 22:37:22', 1),
(2, 'Torres', 'Mendoza', 'Luis', 77889900, 'LIC987654', '2025-08-31 22:37:22', '2027-01-15', 988222333, 1, 1, '2025-08-31 22:37:22', 1),
(3, 'Ramírez', 'Huamán', 'José', 44556677, 'LIC123456', '2025-08-31 22:37:54', '2026-08-20', 999111222, 1, 1, '2025-08-31 22:37:54', 1),
(4, 'Torres', 'Mendoza', 'Luis', 77889900, 'LIC987654', '2025-08-31 22:37:54', '2027-01-15', 988222333, 1, 1, '2025-08-31 22:37:54', 1),
(5, 'García', 'Sánchez', 'Diego', 70000001, 'LIC200001', '2023-03-15 08:00:00', '2027-03-14', 910000001, 1, 1, '2025-09-02 12:01:00', 1),
(6, 'Pérez', 'Díaz', 'Ana', 70000002, 'LIC200002', '2022-07-10 09:00:00', '2026-07-09', 910000002, 1, 1, '2025-09-02 12:01:01', 1),
(7, 'López', 'Torres', 'Marcos', 70000003, 'LIC200003', '2021-11-05 08:30:00', '2026-11-04', 910000003, 1, 1, '2025-09-02 12:01:02', 1),
(8, 'Torres', 'Flores', 'Lucía', 70000004, 'LIC200004', '2024-01-20 08:00:00', '2028-01-19', 910000004, 1, 1, '2025-09-02 12:01:03', 1),
(9, 'Sánchez', 'Morales', 'Jorge', 70000005, 'LIC200005', '2020-06-12 07:45:00', '2025-06-11', 910000005, 1, 1, '2025-09-02 12:01:04', 1),
(10, 'Díaz', 'Herrera', 'Sofía', 70000006, 'LIC200006', '2019-12-01 09:15:00', '2024-11-30', 910000006, 1, 1, '2025-09-02 12:01:05', 1),
(11, 'Flores', 'Castro', 'Miguel', 70000007, 'LIC200007', '2022-05-03 08:20:00', '2026-05-02', 910000007, 1, 1, '2025-09-02 12:01:06', 1),
(12, 'Morales', 'Rojas', 'Carla', 70000008, 'LIC200008', '2023-09-17 08:00:00', '2027-09-16', 910000008, 1, 1, '2025-09-02 12:01:07', 1),
(13, 'Herrera', 'Vega', 'Andrés', 70000009, 'LIC200009', '2021-02-11 07:30:00', '2025-02-10', 910000009, 1, 1, '2025-09-02 12:01:08', 1),
(14, 'Castro', 'Salazar', 'Paola', 70000010, 'LIC200010', '2024-08-22 09:00:00', '2028-08-21', 910000010, 1, 1, '2025-09-02 12:01:09', 1),
(15, 'Rojas', 'Paredes', 'Raúl', 70000011, 'LIC200011', '2020-10-30 08:00:00', '2025-10-29', 910000011, 1, 1, '2025-09-02 12:01:10', 1),
(16, 'Vega', 'Guzmán', 'Elena', 70000012, 'LIC200012', '2018-04-18 08:00:00', '2023-04-17', 910000012, 1, 1, '2025-09-02 12:01:11', 1),
(17, 'Salazar', 'Huamán', 'Héctor', 70000013, 'LIC200013', '2019-09-05 08:00:00', '2024-09-04', 910000013, 1, 1, '2025-09-02 12:01:12', 1),
(18, 'Paredes', 'Ramírez', 'Diana', 70000014, 'LIC200014', '2023-06-14 08:00:00', '2027-06-13', 910000014, 1, 1, '2025-09-02 12:01:13', 1),
(19, 'Guzmán', 'Mendoza', 'Carlos', 70000015, 'LIC200015', '2021-01-09 08:00:00', '2025-01-08', 910000015, 1, 1, '2025-09-02 12:01:14', 1),
(20, 'Huamán', 'Ortiz', 'Isabel', 70000016, 'LIC200016', '2020-03-03 08:00:00', '2024-03-02', 910000016, 1, 1, '2025-09-02 12:01:15', 1),
(21, 'Ramírez', 'Chávez', 'Marco', 70000017, 'LIC200017', '2017-12-12 08:00:00', '2022-12-11', 910000017, 1, 1, '2025-09-02 12:01:16', 1),
(22, 'Mendoza', 'Suárez', 'Valeria', 70000018, 'LIC200018', '2022-11-21 09:00:00', '2026-11-20', 910000018, 1, 1, '2025-09-02 12:01:17', 1),
(23, 'Ortiz', 'Silva', 'Fernando', 70000019, 'LIC200019', '2021-07-07 08:00:00', '2025-07-06', 910000019, 1, 1, '2025-09-02 12:01:18', 1),
(24, 'Chávez', 'Suárez', 'Natalia', 70000020, 'LIC200020', '2024-02-02 08:00:00', '2028-02-01', 910000020, 1, 1, '2025-09-02 12:01:19', 1),
(25, 'Suárez', 'Vargas', 'Alberto', 70000021, 'LIC200021', '2020-05-05 08:00:00', '2024-05-04', 910000021, 1, 1, '2025-09-02 12:01:20', 1),
(26, 'Silva', 'Cruz', 'Camila', 70000022, 'LIC200022', '2023-10-10 08:00:00', '2027-10-09', 910000022, 1, 1, '2025-09-02 12:01:21', 1),
(27, 'Vargas', 'Ramos', 'Ricardo', 70000023, 'LIC200023', '2019-08-08 08:00:00', '2024-08-07', 910000023, 1, 1, '2025-09-02 12:01:22', 1),
(28, 'Cruz', 'Lopez', 'Paula', 70000024, 'LIC200024', '2022-04-04 08:00:00', '2026-04-03', 910000024, 1, 1, '2025-09-02 12:01:23', 1),
(29, 'Ramos', 'Paz', 'Roberto', 70000025, 'LIC200025', '2021-09-09 08:00:00', '2025-09-08', 910000025, 1, 1, '2025-09-02 12:01:24', 1),
(30, 'Lopez', 'Castillo', 'Clara', 70000026, 'LIC200026', '2020-01-15 08:00:00', '2024-01-14', 910000026, 1, 1, '2025-09-02 12:01:25', 1),
(31, 'Paz', 'Molina', 'Eduardo', 70000027, 'LIC200027', '2018-06-20 08:00:00', '2023-06-19', 910000027, 1, 1, '2025-09-02 12:01:26', 1),
(32, 'Castillo', 'Arias', 'Sonia', 70000028, 'LIC200028', '2019-11-11 08:00:00', '2024-11-10', 910000028, 1, 1, '2025-09-02 12:01:27', 1),
(33, 'Molina', 'Tapia', 'Luis', 70000029, 'LIC200029', '2022-12-01 08:00:00', '2026-11-30', 910000029, 1, 1, '2025-09-02 12:01:28', 1),
(34, 'Arias', 'Pinto', 'Marta', 70000030, 'LIC200030', '2023-01-05 08:00:00', '2027-01-04', 910000030, 1, 1, '2025-09-02 12:01:29', 1),
(35, 'Tapia', 'Reyes', 'Iván', 70000031, 'LIC200031', '2021-03-03 08:00:00', '2025-03-02', 910000031, 1, 1, '2025-09-02 12:01:30', 1),
(36, 'Pinto', 'Galvez', 'Daniela', 70000032, 'LIC200032', '2020-09-09 08:00:00', '2024-09-08', 910000032, 1, 1, '2025-09-02 12:01:31', 1),
(37, 'Reyes', 'Núñez', 'Javier', 70000033, 'LIC200033', '2017-05-05 08:00:00', '2022-05-04', 910000033, 1, 1, '2025-09-02 12:01:32', 1),
(38, 'Galvez', 'Mora', 'Mónica', 70000034, 'LIC200034', '2018-10-10 08:00:00', '2023-10-09', 910000034, 1, 1, '2025-09-02 12:01:33', 1),
(39, 'Núñez', 'León', 'Óscar', 70000035, 'LIC200035', '2019-02-02 08:00:00', '2024-02-01', 910000035, 1, 1, '2025-09-02 12:01:34', 1),
(40, 'Mora', 'Alvarado', 'Rocío', 70000036, 'LIC200036', '2024-05-20 08:00:00', '2028-05-19', 910000036, 1, 1, '2025-09-02 12:01:35', 1),
(41, 'León', 'Bravo', 'Pablo', 70000037, 'LIC200037', '2021-08-08 08:00:00', '2025-08-07', 910000037, 1, 1, '2025-09-02 12:01:36', 1),
(42, 'Alvarado', 'Soto', 'Gabriela', 70000038, 'LIC200038', '2022-02-14 08:00:00', '2026-02-13', 910000038, 1, 1, '2025-09-02 12:01:37', 1),
(43, 'Bravo', 'Paredes', 'Ramón', 70000039, 'LIC200039', '2020-06-10 08:00:00', '2024-06-09', 910000039, 1, 1, '2025-09-02 12:01:38', 1),
(44, 'Soto', 'Cabrera', 'Verónica', 70000040, 'LIC200040', '2019-07-07 08:00:00', '2024-07-06', 910000040, 1, 1, '2025-09-02 12:01:39', 1),
(45, 'Paredes', 'Romero', 'Sergio', 70000041, 'LIC200041', '2018-01-01 08:00:00', '2023-12-31', 910000041, 1, 1, '2025-09-02 12:01:40', 1),
(46, 'Cabrera', 'Salas', 'Adriana', 70000042, 'LIC200042', '2023-04-04 08:00:00', '2027-04-03', 910000042, 1, 1, '2025-09-02 12:01:41', 1),
(47, 'Romero', 'Villar', 'César', 70000043, 'LIC200043', '2021-06-06 08:00:00', '2025-06-05', 910000043, 1, 1, '2025-09-02 12:01:42', 1),
(48, 'Salas', 'Sarmiento', 'Lorena', 70000044, 'LIC200044', '2022-09-09 08:00:00', '2026-09-08', 910000044, 1, 1, '2025-09-02 12:01:43', 1),
(49, 'Villar', 'Ponce', 'Víctor', 70000045, 'LIC200045', '2020-12-12 08:00:00', '2024-12-11', 910000045, 1, 1, '2025-09-02 12:01:44', 1),
(50, 'Sarmiento', 'Córdova', 'Bianca', 70000046, 'LIC200046', '2019-03-03 08:00:00', '2024-03-02', 910000046, 1, 1, '2025-09-02 12:01:45', 1),
(51, 'Ponce', 'Márquez', 'Rubén', 70000047, 'LIC200047', '2023-08-08 08:00:00', '2027-08-07', 910000047, 1, 1, '2025-09-02 12:01:46', 1),
(52, 'Córdova', 'Salcedo', 'Mariana', 70000048, 'LIC200048', '2021-10-10 08:00:00', '2025-10-09', 910000048, 1, 1, '2025-09-02 12:01:47', 1),
(53, 'Márquez', 'Bustos', 'Francisco', 70000049, 'LIC200049', '2020-11-11 08:00:00', '2024-11-10', 910000049, 1, 1, '2025-09-02 12:01:48', 1),
(54, 'Salcedo', 'Cevallos', 'Yolanda', 70000050, 'LIC200050', '2022-03-03 08:00:00', '2026-03-02', 910000050, 1, 1, '2025-09-02 12:01:49', 1),
(55, 'Acuña', 'Ñoño', 'Juan', 23454564, 'Q72741307', '2004-04-20 00:00:00', '2020-04-20', 922640415, 1, NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `appat` varchar(250) DEFAULT NULL,
  `apmat` varchar(250) DEFAULT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `dni` int(11) DEFAULT NULL,
  `fechaNacimiento` date DEFAULT NULL,
  `telefono` int(11) DEFAULT NULL,
  `genero` varchar(1) DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`idCliente`, `appat`, `apmat`, `nombre`, `dni`, `fechaNacimiento`, `telefono`, `genero`, `creador`, `fechaCreacion`) VALUES
(1, 'García', 'López', 'María', 87654321, '1995-05-12', 987654321, 'F', 1, '2025-08-31 22:37:22'),
(2, 'Pérez', 'Torres', 'Carlos', 65432198, '1990-09-23', 912345678, 'M', 1, '2025-08-31 22:37:22'),
(3, 'García', 'López', 'María', 87654321, '1995-05-12', 987654321, 'F', 1, '2025-08-31 22:37:54'),
(4, 'Pérez', 'Torres', 'Carlos', 65432198, '1990-09-23', 912345678, 'M', 1, '2025-08-31 22:37:54'),
(5, 'Gómez', 'Luna', 'Nicolás', 71000001, '1992-02-14', 920000001, 'M', 1, '2025-09-02 12:02:00'),
(6, 'Alvarado', 'Vega', 'Mariana', 71000002, '1988-07-03', 920000002, 'F', 1, '2025-09-02 12:02:01'),
(7, 'Ruiz', 'Santos', 'Javier', 71000003, '1979-11-21', 920000003, 'M', 1, '2025-09-02 12:02:02'),
(8, 'Medina', 'Paz', 'Lucía', 71000004, '1995-05-12', 920000004, 'F', 1, '2025-09-02 12:02:03'),
(9, 'Vargas', 'Román', 'Diego', 71000005, '1985-01-30', 920000005, 'M', 1, '2025-09-02 12:02:04'),
(10, 'Campos', 'Rojas', 'Carla', 71000006, '1999-09-09', 920000006, 'F', 1, '2025-09-02 12:02:05'),
(11, 'Herrera', 'Mora', 'Pablo', 71000007, '1990-12-01', 920000007, 'M', 1, '2025-09-02 12:02:06'),
(12, 'Salinas', 'Reyna', 'Isabel', 71000008, '1975-03-22', 920000008, 'F', 1, '2025-09-02 12:02:07'),
(13, 'Peña', 'Delgado', 'Andrés', 71000009, '1983-06-17', 920000009, 'M', 1, '2025-09-02 12:02:08'),
(14, 'Paredes', 'Nieto', 'Valeria', 71000010, '1996-08-25', 920000010, 'F', 1, '2025-09-02 12:02:09'),
(15, 'Cárdenas', 'Galarza', 'Ricardo', 71000011, '1981-04-14', 920000011, 'M', 1, '2025-09-02 12:02:10'),
(16, 'Lozano', 'Meza', 'Paula', 71000012, '1993-10-30', 920000012, 'F', 1, '2025-09-02 12:02:11'),
(17, 'Ortega', 'Salgado', 'Roberto', 71000013, '1972-09-05', 920000013, 'M', 1, '2025-09-02 12:02:12'),
(18, 'Mendoza', 'Pineda', 'Clara', 71000014, '2000-01-20', 920000014, 'F', 1, '2025-09-02 12:02:13'),
(19, 'Salazar', 'Benítez', 'Eduardo', 71000015, '1987-11-11', 920000015, 'M', 1, '2025-09-02 12:02:14'),
(20, 'Sosa', 'Torres', 'Sonia', 71000016, '1994-02-02', 920000016, 'F', 1, '2025-09-02 12:02:15'),
(21, 'Guerra', 'Céspedes', 'Luis', 71000017, '1989-05-06', 920000017, 'M', 1, '2025-09-02 12:02:16'),
(22, 'Cruz', 'Del Carpio', 'Marta', 71000018, '1978-07-27', 920000018, 'F', 1, '2025-09-02 12:02:17'),
(23, 'Rincon', 'Vargas', 'Iván', 71000019, '1991-03-03', 920000019, 'M', 1, '2025-09-02 12:02:18'),
(24, 'Barrera', 'Pinto', 'Daniela', 71000020, '1997-06-18', 920000020, 'F', 1, '2025-09-02 12:02:19'),
(25, 'Tapia', 'Navarro', 'Javier', 71000021, '1984-10-10', 920000021, 'M', 1, '2025-09-02 12:02:20'),
(26, 'Acuña', 'Carrillo', 'Mónica', 71000022, '1998-12-12', 920000022, 'F', 1, '2025-09-02 12:02:21'),
(27, 'Roldán', 'Aguirre', 'Óscar', 71000023, '1976-08-08', 920000023, 'M', 1, '2025-09-02 12:02:22'),
(28, 'Ponce', 'Valdez', 'Rocío', 71000024, '1992-04-04', 920000024, 'F', 1, '2025-09-02 12:02:23'),
(29, 'Vásquez', 'Leiva', 'Pablo', 71000025, '1986-09-29', 920000025, 'M', 1, '2025-09-02 12:02:24'),
(30, 'Mora', 'Herrera', 'Gabriela', 71000026, '1990-07-07', 920000026, 'F', 1, '2025-09-02 12:02:25'),
(31, 'Bravo', 'Lara', 'Ramón', 71000027, '1982-11-02', 920000027, 'M', 1, '2025-09-02 12:02:26'),
(32, 'Salcedo', 'Quispe', 'Verónica', 71000028, '1999-03-12', 920000028, 'F', 1, '2025-09-02 12:02:27'),
(33, 'Ugarte', 'Zamora', 'Sergio', 71000029, '1974-05-21', 920000029, 'M', 1, '2025-09-02 12:02:28'),
(34, 'Quinteros', 'Bermúdez', 'Adriana', 71000030, '1996-08-08', 920000030, 'F', 1, '2025-09-02 12:02:29'),
(35, 'Delgado', 'Cáceres', 'César', 71000031, '1980-01-17', 920000031, 'M', 1, '2025-09-02 12:02:30'),
(36, 'Vega', 'Rentería', 'Lorena', 71000032, '1993-02-28', 920000032, 'F', 1, '2025-09-02 12:02:31'),
(37, 'Salgado', 'Aponte', 'Víctor', 71000033, '1988-06-06', 920000033, 'M', 1, '2025-09-02 12:02:32'),
(38, 'Márquez', 'Terán', 'Bianca', 71000034, '2001-09-19', 920000034, 'F', 1, '2025-09-02 12:02:33'),
(39, 'Céspedes', 'Farías', 'Rubén', 71000035, '1977-12-12', 920000035, 'M', 1, '2025-09-02 12:02:34'),
(40, 'Salas', 'Paredes', 'Mariana', 71000036, '1994-10-10', 920000036, 'F', 1, '2025-09-02 12:02:35'),
(41, 'Bustos', 'Peña', 'Francisco', 71000037, '1983-03-03', 920000037, 'M', 1, '2025-09-02 12:02:36'),
(42, 'Córdova', 'Rey', 'Yolanda', 71000038, '1969-07-07', 920000038, 'F', 1, '2025-09-02 12:02:37'),
(43, 'Sierra', 'Ocampo', 'Nicolás', 71000039, '1991-11-11', 920000039, 'M', 1, '2025-09-02 12:02:38'),
(44, 'Pizarro', 'Ureta', 'María', 71000040, '1985-05-05', 920000040, 'F', 1, '2025-09-02 12:02:39'),
(45, 'Rojas', 'Cabrera', 'Carlos', 71000041, '1990-09-09', 920000041, 'M', 1, '2025-09-02 12:02:40'),
(46, 'Alfaro', 'López', 'Isabel', 71000042, '1997-04-04', 920000042, 'F', 1, '2025-09-02 12:02:41'),
(47, 'Chávez', 'Mendoza', 'Hugo', 71000043, '1986-02-02', 920000043, 'M', 1, '2025-09-02 12:02:42'),
(48, 'Vásquez', 'Gonzáles', 'Paula', 71000044, '1998-08-08', 920000044, 'F', 1, '2025-09-02 12:02:43'),
(49, 'Herrera', 'Peña', 'Ramiro', 71000045, '1973-06-06', 920000045, 'M', 1, '2025-09-02 12:02:44'),
(50, 'Ramos', 'Duarte', 'Alejandra', 71000046, '1995-01-01', 920000046, 'F', 1, '2025-09-02 12:02:45'),
(51, 'Flores', 'García', 'Nadia', 71000047, '1992-12-12', 920000047, 'F', 1, '2025-09-02 12:02:46'),
(52, 'Muñoz', 'Paz', 'Raúl', 71000048, '1984-03-03', 920000048, 'M', 1, '2025-09-02 12:02:47'),
(53, 'Cardozo', 'Sierra', 'Mara', 71000049, '1999-07-07', 920000049, 'F', 1, '2025-09-02 12:02:48'),
(54, 'Gutiérrez', 'Lima', 'Nicolás', 71000050, '1982-10-10', 920000050, 'M', 1, '2025-09-02 12:02:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lugares`
--

CREATE TABLE `lugares` (
  `idLugar` int(11) NOT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `lugares`
--

INSERT INTO `lugares` (`idLugar`, `nombre`, `estado`) VALUES
(1, 'Lima', 1),
(2, 'Arequipa', 1),
(3, 'Cusco', 1),
(4, 'Lima', 1),
(5, 'Arequipa', 1),
(6, 'Cusco', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ruta_viaje`
--

CREATE TABLE `ruta_viaje` (
  `idViaje` int(11) NOT NULL,
  `idBus` int(11) DEFAULT NULL,
  `idChofer` int(11) DEFAULT NULL,
  `fechaSalida` date DEFAULT NULL,
  `horaSalida` time DEFAULT NULL,
  `fechaLlegada` date DEFAULT NULL,
  `horaLlegada` time DEFAULT NULL,
  `origen` int(11) DEFAULT NULL,
  `destino` int(11) DEFAULT NULL,
  `precio` decimal(6,2) DEFAULT NULL,
  `boletosRestantes` int(11) DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ruta_viaje`
--

INSERT INTO `ruta_viaje` (`idViaje`, `idBus`, `idChofer`, `fechaSalida`, `horaSalida`, `fechaLlegada`, `horaLlegada`, `origen`, `destino`, `precio`, `boletosRestantes`, `creador`, `fechaCreacion`, `estado`) VALUES
(1, 1, 1, '2025-08-25', '08:00:00', '2025-08-25', '20:00:00', 1, 2, 120.50, 40, 1, '2025-08-31 22:37:22', 1),
(2, 1, 1, '2025-08-25', '08:00:00', '2025-08-25', '20:00:00', 1, 2, 120.50, 40, 1, '2025-08-31 22:37:54', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `appat` varchar(250) DEFAULT NULL,
  `apmat` varchar(250) DEFAULT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `dni` int(11) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `contraseña` varchar(255) NOT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `appat`, `apmat`, `nombre`, `dni`, `email`, `contraseña`, `creador`, `fechaCreacion`, `estado`) VALUES
(53, 'Ramirez', 'Carrera', 'Pierre Luiggi', 72741307, 'pierrehc2004@gmail.com', '$2a$12$FODUjYtvmXwolr2F5oeSyOIFeBOlnamHZylkb.tPTo.ZnJFCkyR/e', 1, '2025-09-28 23:15:58', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_pasaje`
--

CREATE TABLE `venta_pasaje` (
  `idPasaje` int(11) NOT NULL,
  `idViaje` int(11) DEFAULT NULL,
  `idCliente` int(11) DEFAULT NULL,
  `asiento` int(11) DEFAULT NULL,
  `fechaCompra` datetime DEFAULT NULL,
  `creador` int(11) DEFAULT NULL,
  `fechaCreacion` datetime DEFAULT NULL,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `venta_pasaje`
--

INSERT INTO `venta_pasaje` (`idPasaje`, `idViaje`, `idCliente`, `asiento`, `fechaCompra`, `creador`, `fechaCreacion`, `estado`) VALUES
(1, 1, 1, 5, '2025-08-31 22:37:22', 1, '2025-08-31 22:37:22', 1),
(2, 1, 2, 10, '2025-08-31 22:37:22', 1, '2025-08-31 22:37:22', 1),
(3, 1, 1, 5, '2025-08-31 22:37:54', 1, '2025-08-31 22:37:54', 1),
(4, 1, 2, 10, '2025-08-31 22:37:54', 1, '2025-08-31 22:37:54', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bus`
--
ALTER TABLE `bus`
  ADD PRIMARY KEY (`idBus`);

--
-- Indices de la tabla `chofer`
--
ALTER TABLE `chofer`
  ADD PRIMARY KEY (`idChofer`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`);

--
-- Indices de la tabla `lugares`
--
ALTER TABLE `lugares`
  ADD PRIMARY KEY (`idLugar`);

--
-- Indices de la tabla `ruta_viaje`
--
ALTER TABLE `ruta_viaje`
  ADD PRIMARY KEY (`idViaje`),
  ADD KEY `fk_ruta_bus` (`idBus`),
  ADD KEY `fk_ruta_chofer` (`idChofer`),
  ADD KEY `fk_ruta_origen` (`origen`),
  ADD KEY `fk_ruta_destino` (`destino`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`);

--
-- Indices de la tabla `venta_pasaje`
--
ALTER TABLE `venta_pasaje`
  ADD PRIMARY KEY (`idPasaje`),
  ADD KEY `fk_pasaje_viaje` (`idViaje`),
  ADD KEY `fk_pasaje_cliente` (`idCliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bus`
--
ALTER TABLE `bus`
  MODIFY `idBus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `chofer`
--
ALTER TABLE `chofer`
  MODIFY `idChofer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `lugares`
--
ALTER TABLE `lugares`
  MODIFY `idLugar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `ruta_viaje`
--
ALTER TABLE `ruta_viaje`
  MODIFY `idViaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `venta_pasaje`
--
ALTER TABLE `venta_pasaje`
  MODIFY `idPasaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ruta_viaje`
--
ALTER TABLE `ruta_viaje`
  ADD CONSTRAINT `fk_ruta_bus` FOREIGN KEY (`idBus`) REFERENCES `bus` (`idBus`),
  ADD CONSTRAINT `fk_ruta_chofer` FOREIGN KEY (`idChofer`) REFERENCES `chofer` (`idChofer`),
  ADD CONSTRAINT `fk_ruta_destino` FOREIGN KEY (`destino`) REFERENCES `lugares` (`idLugar`),
  ADD CONSTRAINT `fk_ruta_origen` FOREIGN KEY (`origen`) REFERENCES `lugares` (`idLugar`);

--
-- Filtros para la tabla `venta_pasaje`
--
ALTER TABLE `venta_pasaje`
  ADD CONSTRAINT `fk_pasaje_cliente` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  ADD CONSTRAINT `fk_pasaje_viaje` FOREIGN KEY (`idViaje`) REFERENCES `ruta_viaje` (`idViaje`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
