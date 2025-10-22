-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-06-2025 a las 01:22:52
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `home_clothing_tester`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_cambiar_estado_usuario` (IN `p_idUsuario` INT, IN `p_nuevoEstado` VARCHAR(20), IN `p_idAdmin` INT)   BEGIN
    -- Validar que quien llama es un administrador
    IF NOT EXISTS (
        SELECT 1 FROM administrador WHERE ID_ADMIN = p_idAdmin
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Acceso denegado: el ID introducido no pertenece a un administrador';
    END IF;

    -- Cambiar el estado del usuario
    UPDATE usuario
    SET ESTADO = p_nuevoEstado
    WHERE ID_USUARIO = p_idUsuario;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fun_total_gasto_usuario` (`p_idUsuario` INT, `p_idAdmin` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total DECIMAL(10,2);

    -- Validar usuario = admin
    IF NOT EXISTS (
        SELECT 1 FROM administrador WHERE ID_ADMIN = p_idAdmin
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Acceso denegado: el ID introducido no pertenece a un administrador';
    END IF;

    -- Total gastado por usuario
    SELECT IFNULL(SUM(TOTAL_COMPRA), 0) INTO total
    FROM compra
    WHERE ID_USUARIO = p_idUsuario;

    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador`
--

CREATE TABLE `administrador` (
  `ID_ADMIN` int(11) NOT NULL,
  `NOMBRE_ADMIN` varchar(120) DEFAULT NULL,
  `CORREO_ADMIN` varchar(100) NOT NULL,
  `PASSWORD` varchar(50) NOT NULL,
  `ROL` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `administrador`
--

INSERT INTO `administrador` (`ID_ADMIN`, `NOMBRE_ADMIN`, `CORREO_ADMIN`, `PASSWORD`, `ROL`) VALUES
(2, 'Javier', 'javier@uax.com', '', 'CATALOG_MANAGER'),
(7, 'Laura', 'laura@uax.com', '', 'SUPERADMIN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carritocompra`
--

CREATE TABLE `carritocompra` (
  `ID_CARRITO` int(11) NOT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  `FECHA_CREACION` datetime DEFAULT current_timestamp(),
  `ESTADO_CARRITO` enum('ABIERTO','PENDIENTE','COMPRADO','CANCELADO') DEFAULT 'ABIERTO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `carritocompra`
--

INSERT INTO `carritocompra` (`ID_CARRITO`, `ID_USUARIO`, `FECHA_CREACION`, `ESTADO_CARRITO`) VALUES
(1, 1, '2025-05-25 04:58:26', 'ABIERTO'),
(2, 2, '2025-05-25 04:58:26', 'ABIERTO'),
(3, 3, '2025-05-25 04:58:26', 'ABIERTO'),
(4, 4, '2025-05-25 04:58:26', 'ABIERTO'),
(5, 5, '2025-05-25 04:58:26', 'ABIERTO'),
(6, 6, '2025-05-25 04:58:26', 'ABIERTO'),
(7, 7, '2025-05-25 04:58:26', 'ABIERTO'),
(8, 8, '2025-05-25 04:58:26', 'ABIERTO'),
(9, 9, '2025-05-25 04:58:26', 'ABIERTO'),
(10, 10, '2025-05-25 04:58:26', 'ABIERTO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `ID_CATEGORIA` int(11) NOT NULL,
  `NOMBRE_CATEGORIA` varchar(100) NOT NULL,
  `DESCRIPCION` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`ID_CATEGORIA`, `NOMBRE_CATEGORIA`, `DESCRIPCION`) VALUES
(1, 'T‑Shirts', 'Camisetas y polos'),
(2, 'Jeans', 'Vaqueros y pantalones denim'),
(3, 'Shoes', 'Calzado casual'),
(4, 'Accessories', 'Gorras, cinturones y otros'),
(5, 'Jackets', 'Chaquetas, parkas y bombers'),
(6, 'Sweaters', 'Jerséis y sudaderas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentario`
--

CREATE TABLE `comentario` (
  `ID_COMENTARIO` int(11) NOT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  `ID_PRENDA` int(11) DEFAULT NULL,
  `CONTENIDO` text DEFAULT NULL,
  `CALIFICACION` int(11) DEFAULT NULL,
  `FECHA_COMENTARIO` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `comentario`
--

INSERT INTO `comentario` (`ID_COMENTARIO`, `ID_USUARIO`, `ID_PRENDA`, `CONTENIDO`, `CALIFICACION`, `FECHA_COMENTARIO`) VALUES
(1, 1, 1, 'Tela suave y buena relación calidad‑precio.', 5, '2025-05-25 05:02:31'),
(2, 2, 3, 'Talla un poco justa, pide una más.', 4, '2025-05-25 05:02:31'),
(3, 3, 5, 'Muy cómodas para correr.', 5, '2025-05-25 05:02:31'),
(4, 4, 8, 'El color pierde intensidad tras varios lavados.', 3, '2025-05-25 05:02:31'),
(5, 5, 9, 'Queda genial con casi todo.', 5, '2025-05-25 05:02:31'),
(6, 6, 4, 'Me llegó con una pequeña tara, pero bien.', 3, '2025-05-25 05:02:31'),
(7, 7, 11, 'Calienta bastante, ideal para invierno.', 4, '2025-05-25 05:02:31'),
(8, 8, 2, 'Estampado muy original.', 5, '2025-05-25 05:02:31'),
(9, 9, 6, 'Cordones algo cortos.', 4, '2025-05-25 05:02:31'),
(10, 10, 7, 'Buen acabado del cuero.', 5, '2025-05-25 05:02:31'),
(11, 1, 12, 'El tejido pica un poco.', 3, '2025-05-25 05:02:31'),
(12, 2, 10, 'Chaqueta ligera y cómoda.', 4, '2025-05-25 05:02:31'),
(13, 3, 3, 'El denim es grueso y resistente.', 5, '2025-05-25 05:02:31'),
(14, 4, 1, 'Mis camisetas favoritas.', 5, '2025-05-25 05:02:31'),
(15, 5, 5, 'Envío rápido y sin problemas.', 5, '2025-05-25 05:02:31'),
(16, 7, NULL, 'ADMIN7cambió estado de usuario 3a BLOQUEADO en 2025-05-25 05:57:30', NULL, '2025-05-25 05:57:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

CREATE TABLE `compra` (
  `ID_COMPRA` int(11) NOT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  `ID_METODOPAGO` int(11) DEFAULT NULL,
  `ID_TRANSACCION` int(11) DEFAULT NULL,
  `FECHA_COMPRA` datetime DEFAULT current_timestamp(),
  `TOTAL_COMPRA` double NOT NULL,
  `ESTADO_COMPRA` enum('PAGADA','PENDIENTE','CANCELADA') NOT NULL DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `compra`
--

INSERT INTO `compra` (`ID_COMPRA`, `ID_USUARIO`, `ID_METODOPAGO`, `ID_TRANSACCION`, `FECHA_COMPRA`, `TOTAL_COMPRA`, `ESTADO_COMPRA`) VALUES
(1, 1, 1, 2, '2025-05-25 05:10:49', 79.85, 'PAGADA'),
(2, 2, 2, 4, '2025-05-25 05:10:49', 129.8, 'PAGADA'),
(3, 3, 3, 5, '2025-05-25 05:10:49', 59.85, 'PENDIENTE'),
(4, 4, 1, 6, '2025-05-25 05:10:49', 104.8, 'PAGADA'),
(5, 5, 4, 7, '2025-05-25 05:10:49', 49.9, 'CANCELADA'),
(6, 6, 2, 9, '2025-05-25 05:10:49', 69.9, 'PAGADA'),
(7, 7, 3, 8, '2025-05-25 05:10:49', 176.3, 'PAGADA'),
(8, 8, 1, 10, '2025-05-25 05:10:49', 89, 'PENDIENTE'),
(9, 9, 2, 1, '2025-05-25 05:10:49', 42.4, 'PAGADA'),
(10, 10, 4, 3, '2025-05-25 05:10:49', 64.85, 'PAGADA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detallecompra`
--

CREATE TABLE `detallecompra` (
  `ID_DETALLECOMPRA` int(11) NOT NULL,
  `ID_COMPRA` int(11) DEFAULT NULL,
  `ID_PRENDA` int(11) DEFAULT NULL,
  `CANTIDAD` int(11) NOT NULL,
  `PRECIO_UNIDAD` double NOT NULL,
  `SUBTOTAL` double GENERATED ALWAYS AS (round(`CANTIDAD` * `PRECIO_UNIDAD`,2)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `detallecompra`
--

INSERT INTO `detallecompra` (`ID_DETALLECOMPRA`, `ID_COMPRA`, `ID_PRENDA`, `CANTIDAD`, `PRECIO_UNIDAD`) VALUES
(1, 1, 1, 12, 14.95),
(2, 1, 7, 32, 24.9),
(3, 2, 3, 23, 49.9),
(4, 2, 5, 11, 69.9),
(5, 3, 6, 15, 39.9),
(6, 3, 2, 12, 19.95),
(7, 4, 4, 26, 44.9),
(8, 4, 8, 11, 17.5),
(9, 5, 3, 19, 49.9),
(10, 6, 5, 18, 69.9),
(11, 7, 9, 18, 79),
(12, 7, 10, 11, 89),
(13, 7, 6, 12, 39.9),
(14, 7, 8, 17, 17.5),
(15, 8, 10, 14, 89),
(16, 9, 2, 24, 19.95),
(17, 9, 7, 14, 24.9),
(18, 10, 1, 31, 14.95),
(19, 10, 6, 14, 39.9),
(20, 2, 11, 14, 39.9),
(21, 2, 12, 17, 34.9),
(22, 3, 8, 27, 17.5),
(23, 4, 11, 18, 39.9),
(24, 5, 12, 18, 34.9),
(25, 6, 1, 20, 14.95),
(26, 6, 4, 10, 44.9),
(27, 8, 5, 10, 69.9),
(28, 9, 3, 10, 49.9),
(29, 10, 12, 13, 34.9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `favorito`
--

CREATE TABLE `favorito` (
  `ID_FAVORITO` int(11) NOT NULL,
  `ID_USUARIO` int(11) DEFAULT NULL,
  `ID_PRENDA` int(11) DEFAULT NULL,
  `FECHA_ADD` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `favorito`
--

INSERT INTO `favorito` (`ID_FAVORITO`, `ID_USUARIO`, `ID_PRENDA`, `FECHA_ADD`) VALUES
(1, 1, 5, '2025-05-25 05:01:20'),
(2, 1, 9, '2025-05-25 05:01:20'),
(3, 2, 2, '2025-05-25 05:01:20'),
(4, 2, 6, '2025-05-25 05:01:20'),
(5, 3, 1, '2025-05-25 05:01:20'),
(6, 4, 10, '2025-05-25 05:01:20'),
(7, 4, 3, '2025-05-25 05:01:20'),
(8, 5, 7, '2025-05-25 05:01:20'),
(9, 6, 4, '2025-05-25 05:01:20'),
(10, 6, 11, '2025-05-25 05:01:20'),
(11, 7, 8, '2025-05-25 05:01:20'),
(12, 8, 12, '2025-05-25 05:01:20'),
(13, 9, 6, '2025-05-25 05:01:20'),
(14, 9, 5, '2025-05-25 05:01:20'),
(15, 10, 2, '2025-05-25 05:01:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodopago`
--

CREATE TABLE `metodopago` (
  `ID_METODOPAGO` int(11) NOT NULL,
  `FORMA_PAGO` varchar(50) NOT NULL,
  `DETALLES` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `metodopago`
--

INSERT INTO `metodopago` (`ID_METODOPAGO`, `FORMA_PAGO`, `DETALLES`) VALUES
(1, 'Visa', '**** 4242'),
(2, 'MasterCard', '**** 5454'),
(3, 'PayPal', 'paypal@store.com'),
(4, 'Bizum', '+34‑600‑00‑00‑00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prenda`
--

CREATE TABLE `prenda` (
  `ID_PRENDA` int(11) NOT NULL,
  `ID_CATEGORIA` int(11) DEFAULT NULL,
  `ID_ADMIN` int(11) DEFAULT NULL,
  `NOMBRE` varchar(120) NOT NULL,
  `DESCRIPCION` text DEFAULT NULL,
  `PRECIO` double NOT NULL,
  `TALLA` varchar(5) DEFAULT NULL,
  `COLOR` varchar(30) DEFAULT NULL,
  `STOCKDISPONIBLE` int(11) DEFAULT 0,
  `ESTADO_PRENDA` enum('DISPONIBLE','RETIRADA','AGOTADA') DEFAULT 'DISPONIBLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `prenda`
--

INSERT INTO `prenda` (`ID_PRENDA`, `ID_CATEGORIA`, `ID_ADMIN`, `NOMBRE`, `DESCRIPCION`, `PRECIO`, `TALLA`, `COLOR`, `STOCKDISPONIBLE`, `ESTADO_PRENDA`) VALUES
(1, 1, 2, 'Basic Tee', 'Camiseta algodón 100 %', 14.95, 'M', 'Blanco', 99, 'DISPONIBLE'),
(2, 1, 7, 'Graphic Tee', 'Camiseta estampada skull', 19.95, 'L', 'Negro', 90, 'DISPONIBLE'),
(3, 2, 2, 'Slim Jeans', 'Vaquero slim fit', 49.9, '32', 'Indigo', 80, 'DISPONIBLE'),
(4, 2, 2, 'Relaxed Jeans', 'Vaquero corte relajado', 44.9, '34', 'Azul', 70, 'DISPONIBLE'),
(5, 3, 7, 'Running Sneakers', 'Zapatillas running', 69.9, '42', 'Gris', 60, 'DISPONIBLE'),
(6, 3, 2, 'Canvas Shoes', 'Zapatillas de lona', 39.9, '41', 'Rojo', 50, 'DISPONIBLE'),
(7, 4, 7, 'Leather Belt', 'Cinturón cuero vacuno', 24.9, '105', 'Marrón', 40, 'DISPONIBLE'),
(8, 4, 7, 'Baseball Cap', 'Gorra beisbol', 17.5, 'U', 'Azul', 35, 'DISPONIBLE'),
(9, 5, 2, 'Denim Jacket', 'Chaqueta vaquera', 79, 'M', 'Celeste', 30, 'DISPONIBLE'),
(10, 5, 7, 'Bomber Jacket', 'Bomber ligera', 89, 'L', 'Negro', 25, 'DISPONIBLE'),
(11, 6, 2, 'Hoodie Classic', 'Sudadera con capucha', 39.9, 'L', 'Caqui', 60, 'DISPONIBLE'),
(12, 6, 2, 'Crewneck Sweater', 'Jersey cuello redondo', 34.9, 'M', 'Beige', 55, 'DISPONIBLE');

--
-- Disparadores `prenda`
--
DELIMITER $$
CREATE TRIGGER `trigg_auto_estado_prenda_bi` BEFORE INSERT ON `prenda` FOR EACH ROW BEGIN
	IF NEW.STOCKDISPONIBLE = 0 THEN
       		SET NEW.ESTADO_PRENDA = 'AGOTADA';
	ELSE 
        		SET NEW.ESTADO_PRENDA = 'DISPONIBLE';
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trigg_auto_estado_prenda_bu` BEFORE UPDATE ON `prenda` FOR EACH ROW BEGIN
	IF NEW.STOCKDISPONIBLE <> OLD.STOCKDISPONIBLE THEN
		IF NEW.STOCKDISPONIBLE = 0 THEN
			SET NEW.ESTADO_PRENDA = 'AGOTADA';
		ELSE
			SET NEW.ESTADO_PRENDA = 'DISPONIBLE';
		END IF;
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sistemapago`
--

CREATE TABLE `sistemapago` (
  `ID_TRANSACCION` int(11) NOT NULL,
  `FECHA_TRANSACCION` datetime DEFAULT current_timestamp(),
  `ESTADO_TRANSACCION` enum('PENDIENTE','APROBADA','RECHAZADA') DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sistemapago`
--

INSERT INTO `sistemapago` (`ID_TRANSACCION`, `FECHA_TRANSACCION`, `ESTADO_TRANSACCION`) VALUES
(1, '2025-05-25 05:00:35', 'APROBADA'),
(2, '2025-05-25 05:00:35', 'APROBADA'),
(3, '2025-05-25 05:00:35', 'PENDIENTE'),
(4, '2025-05-25 05:00:35', 'APROBADA'),
(5, '2025-05-25 05:00:35', 'RECHAZADA'),
(6, '2025-05-25 05:00:35', 'APROBADA'),
(7, '2025-05-25 05:00:35', 'APROBADA'),
(8, '2025-05-25 05:00:35', 'PENDIENTE'),
(9, '2025-05-25 05:00:35', 'APROBADA'),
(10, '2025-05-25 05:00:35', 'APROBADA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sistema_ra`
--

CREATE TABLE `sistema_ra` (
  `ID_SISTEMARA` int(11) NOT NULL,
  `ID_USUARIO` int(11) NOT NULL,
  `ID_PRENDA` int(11) NOT NULL,
  `FECHA` datetime DEFAULT current_timestamp(),
  `RESULTADO` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sistema_ra`
--

INSERT INTO `sistema_ra` (`ID_SISTEMARA`, `ID_USUARIO`, `ID_PRENDA`, `FECHA`, `RESULTADO`) VALUES
(1, 1, 2, '2025-06-01 03:44:40', 'El ajuste es perfecto. Podrías combinar con accesorios negros.'),
(2, 3, 5, '2025-06-01 03:44:40', 'Tiene un estilo deportivo. Ideal para uso diario.'),
(3, 4, 9, '2025-06-01 03:44:40', 'El color combina bien con tu tono de piel.'),
(4, 7, 10, '2025-06-01 03:44:40', 'La talla parece algo grande. Prueba una talla menos.'),
(5, 2, 6, '2025-06-01 03:44:40', 'Estilo cómodo. Recomendado para días calurosos.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `ID_USUARIO` int(11) NOT NULL,
  `ID_ADMIN` int(11) DEFAULT NULL,
  `NOMBRE_USUARIO` varchar(120) DEFAULT NULL,
  `CORREO_USUARIO` varchar(100) NOT NULL,
  `PASSWORD` varchar(50) NOT NULL,
  `ESTADO` enum('ACTIVO','BLOQUEADO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`ID_USUARIO`, `ID_ADMIN`, `NOMBRE_USUARIO`, `CORREO_USUARIO`, `PASSWORD`, `ESTADO`) VALUES
(1, NULL, 'maria', 'maria@example.com', '626e3c805e77eeb472c42c6be607be2af7ac5c08fd7050f278', 'ACTIVO'),
(2, 2, 'javier', 'javier@example.com', '26ce13833bf9b1a34904d0b8ff10bc035178931c4ac6d8d02c', 'ACTIVO'),
(3, NULL, 'lucia', 'lucia@example.com', '5e96a6cf706c46feaeda94715b59ffa61c09f2d46c122ce745', 'BLOQUEADO'),
(4, NULL, 'diego', 'diego@example.com', 'd68089c77e65ee87eb9504f68212289f6dcb758fae1955a824', 'ACTIVO'),
(5, NULL, 'sofia', 'sofia@example.com', 'a3e1a8a3ccd08f006f9df0b36f7a83809aff603bcd0ad55048', 'BLOQUEADO'),
(6, NULL, 'pablo', 'pablo@example.com', 'c1761e6dff44a93b593ed7447d983c259a5aefdf3a11960b81', 'INACTIVO'),
(7, 7, 'laura', 'laura@example.com', '5a797e04dd084f9e9502d0e0e54d0a0996bc9d13e14fbf1613', 'ACTIVO'),
(8, NULL, 'raul', 'raul@example.com', '16f04c3e2876cf0054398f1093f0e6913ecb5064cb60ae6bee', 'INACTIVO'),
(9, NULL, 'ines', 'ines@example.com', '92add3e7f1fb5056a3cf930b5c727aa6a89b6d6b6f11f37108', 'BLOQUEADO'),
(10, NULL, 'sergio', 'sergio@example.com', 'e77cb994418f5bc0ec1007b6c137918d9aed4e7b0bde45d74a', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_catalogo_prendas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_catalogo_prendas` (
`ID_PRENDA` int(11)
,`NOMBRE` varchar(120)
,`DESCRIPCION` text
,`PRECIO` double
,`TALLA` varchar(5)
,`COLOR` varchar(30)
,`STOCKDISPONIBLE` int(11)
,`ESTADO_PRENDA` enum('DISPONIBLE','RETIRADA','AGOTADA')
,`NOMBRE_CATEGORIA` varchar(100)
,`CREADO_POR` varchar(120)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_estadisticas_comentarios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_estadisticas_comentarios` (
`ID_PRENDA` int(11)
,`NOMBRE` varchar(120)
,`TOTAL_COMENTARIOS` bigint(21)
,`NOTA_MEDIA` decimal(12,1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_estadisticas_usuarios`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_estadisticas_usuarios` (
`ID_USUARIO` int(11)
,`NOMBRE_USUARIO` varchar(120)
,`NUM_COMPRAS` bigint(21)
,`GASTO_TOTAL` double
,`NUM_FAVORITOS` bigint(21)
,`NUM_COMENTARIOS` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_favoritos_usuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_favoritos_usuario` (
`ID_USUARIO` int(11)
,`NOMBRE_USUARIO` varchar(120)
,`ID_PRENDA` int(11)
,`NOMBRE_PRENDA` varchar(120)
,`FECHA_ADD` datetime
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_historial_compras_usuario`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_historial_compras_usuario` (
`ID_COMPRA` int(11)
,`ID_USUARIO` int(11)
,`NOMBRE_USUARIO` varchar(120)
,`FECHA_COMPRA` datetime
,`TOTAL_COMPRA` double
,`ID_METODOPAGO` int(11)
,`ID_TRANSACCION` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_prendas_disponibles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_prendas_disponibles` (
`ID_PRENDA` int(11)
,`NOMBRE` varchar(120)
,`DESCRIPCION` text
,`PRECIO` double
,`TALLA` varchar(5)
,`COLOR` varchar(30)
,`STOCKDISPONIBLE` int(11)
,`ESTADO_PRENDA` enum('DISPONIBLE','RETIRADA','AGOTADA')
,`NOMBRE_CATEGORIA` varchar(100)
,`CREADO_POR` varchar(120)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_ranking_prendas_vendidas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_ranking_prendas_vendidas` (
`ID_PRENDA` int(11)
,`NOMBRE` varchar(120)
,`UNIDADES_VENDIDAS` decimal(32,0)
,`IMPORTE_TOTAL` double(19,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_usuarios_bloqueados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_usuarios_bloqueados` (
`ID_USUARIO` int(11)
,`NOMBRE_USUARIO` varchar(120)
,`CORREO_USUARIO` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_ventas_por_categoria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_ventas_por_categoria` (
`ID_CATEGORIA` int(11)
,`NOMBRE_CATEGORIA` varchar(100)
,`UNIDADES_VENDIDAS` decimal(32,0)
,`INGRESOS_TOTALES` double(19,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `view_catalogo_prendas`
--
DROP TABLE IF EXISTS `view_catalogo_prendas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_catalogo_prendas`  AS SELECT `p`.`ID_PRENDA` AS `ID_PRENDA`, `p`.`NOMBRE` AS `NOMBRE`, `p`.`DESCRIPCION` AS `DESCRIPCION`, `p`.`PRECIO` AS `PRECIO`, `p`.`TALLA` AS `TALLA`, `p`.`COLOR` AS `COLOR`, `p`.`STOCKDISPONIBLE` AS `STOCKDISPONIBLE`, `p`.`ESTADO_PRENDA` AS `ESTADO_PRENDA`, `c`.`NOMBRE_CATEGORIA` AS `NOMBRE_CATEGORIA`, `a`.`NOMBRE_ADMIN` AS `CREADO_POR` FROM ((`prenda` `p` left join `categoria` `c` on(`c`.`ID_CATEGORIA` = `p`.`ID_CATEGORIA`)) left join `administrador` `a` on(`a`.`ID_ADMIN` = `p`.`ID_ADMIN`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_estadisticas_comentarios`
--
DROP TABLE IF EXISTS `view_estadisticas_comentarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_estadisticas_comentarios`  AS SELECT `p`.`ID_PRENDA` AS `ID_PRENDA`, `p`.`NOMBRE` AS `NOMBRE`, count(`com`.`ID_COMENTARIO`) AS `TOTAL_COMENTARIOS`, round(avg(`com`.`CALIFICACION`),1) AS `NOTA_MEDIA` FROM (`prenda` `p` left join `comentario` `com` on(`com`.`ID_PRENDA` = `p`.`ID_PRENDA`)) GROUP BY `p`.`ID_PRENDA`, `p`.`NOMBRE` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_estadisticas_usuarios`
--
DROP TABLE IF EXISTS `view_estadisticas_usuarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_estadisticas_usuarios`  AS SELECT `u`.`ID_USUARIO` AS `ID_USUARIO`, `u`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`, count(distinct `c`.`ID_COMPRA`) AS `NUM_COMPRAS`, coalesce(sum(`c`.`TOTAL_COMPRA`),0) AS `GASTO_TOTAL`, count(distinct `f`.`ID_FAVORITO`) AS `NUM_FAVORITOS`, count(distinct `com`.`ID_COMENTARIO`) AS `NUM_COMENTARIOS` FROM (((`usuario` `u` left join `compra` `c` on(`c`.`ID_USUARIO` = `u`.`ID_USUARIO`)) left join `favorito` `f` on(`f`.`ID_USUARIO` = `u`.`ID_USUARIO`)) left join `comentario` `com` on(`com`.`ID_USUARIO` = `u`.`ID_USUARIO`)) GROUP BY `u`.`ID_USUARIO`, `u`.`NOMBRE_USUARIO` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_favoritos_usuario`
--
DROP TABLE IF EXISTS `view_favoritos_usuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_favoritos_usuario`  AS SELECT `f`.`ID_USUARIO` AS `ID_USUARIO`, `u`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`, `p`.`ID_PRENDA` AS `ID_PRENDA`, `p`.`NOMBRE` AS `NOMBRE_PRENDA`, `f`.`FECHA_ADD` AS `FECHA_ADD` FROM ((`favorito` `f` join `usuario` `u` on(`u`.`ID_USUARIO` = `f`.`ID_USUARIO`)) join `prenda` `p` on(`p`.`ID_PRENDA` = `f`.`ID_PRENDA`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_historial_compras_usuario`
--
DROP TABLE IF EXISTS `view_historial_compras_usuario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_historial_compras_usuario`  AS SELECT `c`.`ID_COMPRA` AS `ID_COMPRA`, `u`.`ID_USUARIO` AS `ID_USUARIO`, `u`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`, `c`.`FECHA_COMPRA` AS `FECHA_COMPRA`, `c`.`TOTAL_COMPRA` AS `TOTAL_COMPRA`, `c`.`ID_METODOPAGO` AS `ID_METODOPAGO`, `c`.`ID_TRANSACCION` AS `ID_TRANSACCION` FROM (`compra` `c` join `usuario` `u` on(`u`.`ID_USUARIO` = `c`.`ID_USUARIO`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_prendas_disponibles`
--
DROP TABLE IF EXISTS `view_prendas_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_prendas_disponibles`  AS SELECT `view_catalogo_prendas`.`ID_PRENDA` AS `ID_PRENDA`, `view_catalogo_prendas`.`NOMBRE` AS `NOMBRE`, `view_catalogo_prendas`.`DESCRIPCION` AS `DESCRIPCION`, `view_catalogo_prendas`.`PRECIO` AS `PRECIO`, `view_catalogo_prendas`.`TALLA` AS `TALLA`, `view_catalogo_prendas`.`COLOR` AS `COLOR`, `view_catalogo_prendas`.`STOCKDISPONIBLE` AS `STOCKDISPONIBLE`, `view_catalogo_prendas`.`ESTADO_PRENDA` AS `ESTADO_PRENDA`, `view_catalogo_prendas`.`NOMBRE_CATEGORIA` AS `NOMBRE_CATEGORIA`, `view_catalogo_prendas`.`CREADO_POR` AS `CREADO_POR` FROM `view_catalogo_prendas` WHERE `view_catalogo_prendas`.`STOCKDISPONIBLE` > 0 AND `view_catalogo_prendas`.`ESTADO_PRENDA` = 'DISPONIBLE' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_ranking_prendas_vendidas`
--
DROP TABLE IF EXISTS `view_ranking_prendas_vendidas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ranking_prendas_vendidas`  AS SELECT `p`.`ID_PRENDA` AS `ID_PRENDA`, `p`.`NOMBRE` AS `NOMBRE`, sum(`dc`.`CANTIDAD`) AS `UNIDADES_VENDIDAS`, round(sum(`dc`.`SUBTOTAL`),2) AS `IMPORTE_TOTAL` FROM (`detallecompra` `dc` join `prenda` `p` on(`p`.`ID_PRENDA` = `dc`.`ID_PRENDA`)) GROUP BY `p`.`ID_PRENDA`, `p`.`NOMBRE` ORDER BY sum(`dc`.`CANTIDAD`) DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_usuarios_bloqueados`
--
DROP TABLE IF EXISTS `view_usuarios_bloqueados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_usuarios_bloqueados`  AS SELECT `usuario`.`ID_USUARIO` AS `ID_USUARIO`, `usuario`.`NOMBRE_USUARIO` AS `NOMBRE_USUARIO`, `usuario`.`CORREO_USUARIO` AS `CORREO_USUARIO` FROM `usuario` WHERE `usuario`.`ESTADO` = 'BLOQUEADO' ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_ventas_por_categoria`
--
DROP TABLE IF EXISTS `view_ventas_por_categoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ventas_por_categoria`  AS SELECT `cat`.`ID_CATEGORIA` AS `ID_CATEGORIA`, `cat`.`NOMBRE_CATEGORIA` AS `NOMBRE_CATEGORIA`, sum(`dc`.`CANTIDAD`) AS `UNIDADES_VENDIDAS`, round(sum(`dc`.`SUBTOTAL`),2) AS `INGRESOS_TOTALES` FROM ((`detallecompra` `dc` join `prenda` `p` on(`p`.`ID_PRENDA` = `dc`.`ID_PRENDA`)) join `categoria` `cat` on(`cat`.`ID_CATEGORIA` = `p`.`ID_CATEGORIA`)) GROUP BY `cat`.`ID_CATEGORIA`, `cat`.`NOMBRE_CATEGORIA` ORDER BY round(sum(`dc`.`SUBTOTAL`),2) DESC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador`
--
ALTER TABLE `administrador`
  ADD PRIMARY KEY (`ID_ADMIN`),
  ADD UNIQUE KEY `CORREO_ADMIN` (`CORREO_ADMIN`);

--
-- Indices de la tabla `carritocompra`
--
ALTER TABLE `carritocompra`
  ADD PRIMARY KEY (`ID_CARRITO`),
  ADD KEY `ID_USUARIO` (`ID_USUARIO`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`ID_CATEGORIA`);

--
-- Indices de la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD PRIMARY KEY (`ID_COMENTARIO`),
  ADD KEY `ID_USUARIO` (`ID_USUARIO`),
  ADD KEY `ID_PRENDA` (`ID_PRENDA`);

--
-- Indices de la tabla `compra`
--
ALTER TABLE `compra`
  ADD PRIMARY KEY (`ID_COMPRA`),
  ADD UNIQUE KEY `ID_TRANSACCION` (`ID_TRANSACCION`),
  ADD KEY `ID_USUARIO` (`ID_USUARIO`),
  ADD KEY `ID_METODOPAGO` (`ID_METODOPAGO`);

--
-- Indices de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD PRIMARY KEY (`ID_DETALLECOMPRA`),
  ADD KEY `ID_COMPRA` (`ID_COMPRA`),
  ADD KEY `ID_PRENDA` (`ID_PRENDA`);

--
-- Indices de la tabla `favorito`
--
ALTER TABLE `favorito`
  ADD PRIMARY KEY (`ID_FAVORITO`),
  ADD KEY `ID_USUARIO` (`ID_USUARIO`),
  ADD KEY `ID_PRENDA` (`ID_PRENDA`);

--
-- Indices de la tabla `metodopago`
--
ALTER TABLE `metodopago`
  ADD PRIMARY KEY (`ID_METODOPAGO`);

--
-- Indices de la tabla `prenda`
--
ALTER TABLE `prenda`
  ADD PRIMARY KEY (`ID_PRENDA`),
  ADD KEY `ID_CATEGORIA` (`ID_CATEGORIA`),
  ADD KEY `ID_ADMIN` (`ID_ADMIN`);

--
-- Indices de la tabla `sistemapago`
--
ALTER TABLE `sistemapago`
  ADD PRIMARY KEY (`ID_TRANSACCION`);

--
-- Indices de la tabla `sistema_ra`
--
ALTER TABLE `sistema_ra`
  ADD PRIMARY KEY (`ID_SISTEMARA`),
  ADD KEY `ID_USUARIO` (`ID_USUARIO`),
  ADD KEY `ID_PRENDA` (`ID_PRENDA`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`ID_USUARIO`),
  ADD UNIQUE KEY `CORREO_USUARIO` (`CORREO_USUARIO`),
  ADD KEY `ID_ADMIN` (`ID_ADMIN`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `administrador`
--
ALTER TABLE `administrador`
  MODIFY `ID_ADMIN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `carritocompra`
--
ALTER TABLE `carritocompra`
  MODIFY `ID_CARRITO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `ID_CATEGORIA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `comentario`
--
ALTER TABLE `comentario`
  MODIFY `ID_COMENTARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `compra`
--
ALTER TABLE `compra`
  MODIFY `ID_COMPRA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  MODIFY `ID_DETALLECOMPRA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `favorito`
--
ALTER TABLE `favorito`
  MODIFY `ID_FAVORITO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `metodopago`
--
ALTER TABLE `metodopago`
  MODIFY `ID_METODOPAGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `prenda`
--
ALTER TABLE `prenda`
  MODIFY `ID_PRENDA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `sistemapago`
--
ALTER TABLE `sistemapago`
  MODIFY `ID_TRANSACCION` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `sistema_ra`
--
ALTER TABLE `sistema_ra`
  MODIFY `ID_SISTEMARA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `ID_USUARIO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `carritocompra`
--
ALTER TABLE `carritocompra`
  ADD CONSTRAINT `carritocompra_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`);

--
-- Filtros para la tabla `comentario`
--
ALTER TABLE `comentario`
  ADD CONSTRAINT `comentario_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`),
  ADD CONSTRAINT `comentario_ibfk_2` FOREIGN KEY (`ID_PRENDA`) REFERENCES `prenda` (`ID_PRENDA`);

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`),
  ADD CONSTRAINT `compra_ibfk_2` FOREIGN KEY (`ID_METODOPAGO`) REFERENCES `metodopago` (`ID_METODOPAGO`),
  ADD CONSTRAINT `compra_ibfk_3` FOREIGN KEY (`ID_TRANSACCION`) REFERENCES `sistemapago` (`ID_TRANSACCION`);

--
-- Filtros para la tabla `detallecompra`
--
ALTER TABLE `detallecompra`
  ADD CONSTRAINT `detallecompra_ibfk_1` FOREIGN KEY (`ID_COMPRA`) REFERENCES `compra` (`ID_COMPRA`),
  ADD CONSTRAINT `detallecompra_ibfk_2` FOREIGN KEY (`ID_PRENDA`) REFERENCES `prenda` (`ID_PRENDA`);

--
-- Filtros para la tabla `favorito`
--
ALTER TABLE `favorito`
  ADD CONSTRAINT `favorito_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`),
  ADD CONSTRAINT `favorito_ibfk_2` FOREIGN KEY (`ID_PRENDA`) REFERENCES `prenda` (`ID_PRENDA`);

--
-- Filtros para la tabla `prenda`
--
ALTER TABLE `prenda`
  ADD CONSTRAINT `prenda_ibfk_1` FOREIGN KEY (`ID_CATEGORIA`) REFERENCES `categoria` (`ID_CATEGORIA`),
  ADD CONSTRAINT `prenda_ibfk_2` FOREIGN KEY (`ID_ADMIN`) REFERENCES `administrador` (`ID_ADMIN`);

--
-- Filtros para la tabla `sistema_ra`
--
ALTER TABLE `sistema_ra`
  ADD CONSTRAINT `sistema_ra_ibfk_1` FOREIGN KEY (`ID_USUARIO`) REFERENCES `usuario` (`ID_USUARIO`),
  ADD CONSTRAINT `sistema_ra_ibfk_2` FOREIGN KEY (`ID_PRENDA`) REFERENCES `prenda` (`ID_PRENDA`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`ID_ADMIN`) REFERENCES `administrador` (`ID_ADMIN`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
