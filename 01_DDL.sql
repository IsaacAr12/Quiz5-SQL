-- =====================================================================
-- QUIZ #5 - SQL | CE 2103 Algoritmos y Estructuras de Datos II
-- Script DDL: creación de la base de datos, tablas y restricciones
-- Base de datos: MiAutoPuntoCom (MySQL 8.0.16+)
-- =====================================================================

DROP DATABASE IF EXISTS MiAutoPuntoCom;
CREATE DATABASE MiAutoPuntoCom
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- Tabla: Vehiculos
-- ---------------------------------------------------------------------
CREATE TABLE Vehiculos (
    id_vehiculo   INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    vin           CHAR(17)       NOT NULL,
    marca         VARCHAR(50)    NOT NULL,
    modelo        VARCHAR(50)    NOT NULL,
    anio          SMALLINT       NOT NULL,
    color         VARCHAR(30)    NOT NULL,
    precio        DECIMAL(12,2)  NOT NULL,
    tipo          VARCHAR(20)    NOT NULL,
    estado        VARCHAR(10)    NOT NULL,

    CONSTRAINT pk_vehiculos         PRIMARY KEY (id_vehiculo),
    CONSTRAINT uq_vehiculos_vin     UNIQUE (vin),
    CONSTRAINT chk_vehiculos_vin    CHECK (CHAR_LENGTH(vin) = 17),
    -- Límite inferior del año. El límite superior (año actual) se valida
    -- con triggers, porque MySQL no permite CURDATE() dentro de un CHECK.
    CONSTRAINT chk_vehiculos_anio   CHECK (anio >= 1900),
    CONSTRAINT chk_vehiculos_precio CHECK (precio > 0),
    CONSTRAINT chk_vehiculos_tipo   CHECK (tipo IN ('Sedán', 'SUV', 'Camioneta', 'Hatchback',
                                                    'Coupé', 'Pickup', 'Convertible', 'Minivan')),
    CONSTRAINT chk_vehiculos_estado CHECK (estado IN ('Nuevo', 'Usado'))
);

-- ---------------------------------------------------------------------
-- Tabla: Clientes
-- ---------------------------------------------------------------------
CREATE TABLE Clientes (
    id_cliente    INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    cedula        VARCHAR(20)    NOT NULL,
    nombre        VARCHAR(50)    NOT NULL,
    apellido      VARCHAR(50)    NOT NULL,
    telefono      VARCHAR(20)    NOT NULL,
    email         VARCHAR(100)   NOT NULL,
    direccion     VARCHAR(200)   NOT NULL,

    CONSTRAINT pk_clientes          PRIMARY KEY (id_cliente),
    CONSTRAINT uq_clientes_cedula   UNIQUE (cedula),
    CONSTRAINT uq_clientes_email    UNIQUE (email),
    CONSTRAINT chk_clientes_email   CHECK (email LIKE '%_@_%._%')
);

-- ---------------------------------------------------------------------
-- Tabla: Vendedores
-- ---------------------------------------------------------------------
CREATE TABLE Vendedores (
    id_vendedor          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    cedula               VARCHAR(20)   NOT NULL,
    nombre               VARCHAR(50)   NOT NULL,
    apellido             VARCHAR(50)   NOT NULL,
    fecha_nacimiento     DATE          NOT NULL,
    fecha_contratacion   DATE          NOT NULL,
    comision             DECIMAL(5,2)  NOT NULL,   -- porcentaje: 5.00 = 5 %

    CONSTRAINT pk_vendedores           PRIMARY KEY (id_vendedor),
    CONSTRAINT uq_vendedores_cedula    UNIQUE (cedula),
    CONSTRAINT chk_vendedores_comision CHECK (comision BETWEEN 0 AND 20),
    -- Un vendedor debe tener al menos 21 años al ser contratado.
    -- (Como el vendedor solo envejece, también tiene >= 21 hoy.)
    CONSTRAINT chk_vendedores_edad     CHECK (fecha_contratacion >= fecha_nacimiento + INTERVAL 21 YEAR)
);

-- ---------------------------------------------------------------------
-- Tabla: Ventas (normalizada: referencia a las otras tres tablas)
-- ---------------------------------------------------------------------
CREATE TABLE Ventas (
    id_venta      INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    id_vehiculo   INT UNSIGNED   NOT NULL,
    id_cliente    INT UNSIGNED   NOT NULL,
    id_vendedor   INT UNSIGNED   NOT NULL,
    fecha_venta   DATE           NOT NULL,
    precio_final  DECIMAL(12,2)  NOT NULL,
    metodo_pago   VARCHAR(20)    NOT NULL,

    CONSTRAINT pk_ventas              PRIMARY KEY (id_venta),
    -- Un vehículo (identificado por su VIN) solo puede venderse una vez.
    CONSTRAINT uq_ventas_vehiculo     UNIQUE (id_vehiculo),
    CONSTRAINT fk_ventas_vehiculo     FOREIGN KEY (id_vehiculo)
        REFERENCES Vehiculos (id_vehiculo) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_cliente      FOREIGN KEY (id_cliente)
        REFERENCES Clientes (id_cliente)   ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_vendedor     FOREIGN KEY (id_vendedor)
        REFERENCES Vendedores (id_vendedor) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_ventas_precio      CHECK (precio_final > 0),
    CONSTRAINT chk_ventas_metodo_pago CHECK (metodo_pago IN ('Efectivo', 'Financiamiento', 'Tarjeta'))
);

-- Índices para acelerar las consultas por fecha y por vendedor
CREATE INDEX idx_ventas_fecha    ON Ventas (fecha_venta);
CREATE INDEX idx_vehiculos_marca ON Vehiculos (marca);

-- ---------------------------------------------------------------------
-- Triggers: validaciones que dependen de la fecha actual
-- (MySQL rechaza funciones no deterministas como CURDATE() en un CHECK)
-- ---------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER trg_vehiculos_anio_ins
BEFORE INSERT ON Vehiculos
FOR EACH ROW
BEGIN
    IF NEW.anio < 1900 OR NEW.anio > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El año del vehículo debe estar entre 1900 y el año actual';
    END IF;
END//

CREATE TRIGGER trg_vehiculos_anio_upd
BEFORE UPDATE ON Vehiculos
FOR EACH ROW
BEGIN
    IF NEW.anio < 1900 OR NEW.anio > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El año del vehículo debe estar entre 1900 y el año actual';
    END IF;
END//

CREATE TRIGGER trg_vendedores_edad_ins
BEFORE INSERT ON Vendedores
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE()) < 21 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vendedor no puede ser menor de 21 años';
    END IF;
END//

CREATE TRIGGER trg_vendedores_edad_upd
BEFORE UPDATE ON Vendedores
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE()) < 21 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El vendedor no puede ser menor de 21 años';
    END IF;
END//

DELIMITER ;
