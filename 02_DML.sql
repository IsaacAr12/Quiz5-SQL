-- =====================================================================
-- QUIZ #5 - SQL | CE 2103 Algoritmos y Estructuras de Datos II
-- Script DML: inserción de datos de prueba
-- Ejecutar después de 01_DDL.sql
-- =====================================================================

USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- 12 vehículos (variedad de marcas, modelos, tipos y estados)
-- ---------------------------------------------------------------------
INSERT INTO Vehiculos (vin, marca, modelo, anio, color, precio, tipo, estado) VALUES
('JTDBR32E720123451', 'Toyota',     'Corolla',  2024, 'Blanco', 18500000.00, 'Sedán',     'Nuevo'),
('JTMBFREV5HJ123452', 'Toyota',     'RAV4',     2023, 'Gris',   24900000.00, 'SUV',       'Nuevo'),
('MR0FZ29G601123453', 'Toyota',     'Hilux',    2019, 'Negro',  19800000.00, 'Pickup',    'Usado'),
('KMHD841CBMU123454', 'Hyundai',    'Elantra',  2021, 'Azul',   12300000.00, 'Sedán',     'Usado'),
('KM8J33A49LU123455', 'Hyundai',    'Tucson',   2025, 'Rojo',   23700000.00, 'SUV',       'Nuevo'),
('3N1AB8CV3NY123456', 'Nissan',     'Sentra',   2022, 'Plata',  13900000.00, 'Sedán',     'Usado'),
('1N6ED1EK0NN123457', 'Nissan',     'Frontier', 2024, 'Blanco', 27500000.00, 'Pickup',    'Nuevo'),
('MHKA6GJ6XNJ123458', 'Suzuki',     'Swift',    2023, 'Amarillo',9800000.00, 'Hatchback', 'Nuevo'),
('JM3KFBDM1N0123459', 'Mazda',      'CX-5',     2020, 'Rojo',   16400000.00, 'SUV',       'Usado'),
('WBA8E9C51JA123460', 'BMW',        '330i',     2018, 'Negro',  17900000.00, 'Sedán',     'Usado'),
('1FTFW1E58MF123461', 'Ford',       'F-150',    2025, 'Azul',   38500000.00, 'Pickup',    'Nuevo'),
('9BWDB45U2ST123462', 'Volkswagen', 'Amarok',   2017, 'Gris',   15200000.00, 'Camioneta', 'Usado');

-- ---------------------------------------------------------------------
-- 6 clientes
-- ---------------------------------------------------------------------
INSERT INTO Clientes (cedula, nombre, apellido, telefono, email, direccion) VALUES
('1-1234-0567', 'María',     'Rodríguez', '8812-3456', 'maria.rodriguez@correo.com', 'San José, Escazú, San Rafael'),
('2-0456-0789', 'José',      'Vargas',    '8723-4567', 'jose.vargas@correo.com',     'Alajuela, Centro, Calle 4'),
('3-0789-0123', 'Ana',       'Jiménez',   '8634-5678', 'ana.jimenez@correo.com',     'Cartago, Paraíso, Llanos de Santa Lucía'),
('4-0321-0654', 'Carlos',    'Mora',      '8545-6789', 'carlos.mora@correo.com',     'Heredia, Santo Domingo, Santa Rosa'),
('1-1500-0987', 'Lucía',     'Solano',    '8456-7890', 'lucia.solano@correo.com',    'San José, Curridabat, Granadilla'),
('5-0222-0333', 'Fernando',  'Castro',    '8367-8901', 'fernando.castro@correo.com', 'Guanacaste, Liberia, Barrio Los Ángeles');

-- ---------------------------------------------------------------------
-- 4 vendedores (todos con 21 años o más al ser contratados)
-- ---------------------------------------------------------------------
INSERT INTO Vendedores (cedula, nombre, apellido, fecha_nacimiento, fecha_contratacion, comision) VALUES
('1-0987-0654', 'Andrés',   'Quesada',  '1985-03-14', '2015-06-01',  5.00),
('2-0654-0321', 'Gabriela', 'Chaves',   '1990-11-02', '2018-02-15',  7.50),
('3-0111-0222', 'Ricardo',  'Méndez',   '1978-07-23', '2010-09-10', 10.00),
('1-1888-0999', 'Daniela',  'Rojas',    '2001-05-30', '2024-01-08',  3.00);

-- ---------------------------------------------------------------------
-- 8 ventas
--   * Andrés (1) tiene 3 ventas y Gabriela (2) tiene 3 ventas.
--   * Algunas ventas usan fechas relativas a CURDATE() para que la
--     consulta 5 ("vendidos en el último mes") siempre devuelva datos.
--   * Quedan 4 vehículos sin vender (ids 6, 7, 9, 12).
-- ---------------------------------------------------------------------
INSERT INTO Ventas (id_vehiculo, id_cliente, id_vendedor, fecha_venta, precio_final, metodo_pago) VALUES
( 1, 1, 1, '2026-03-12',                     18200000.00, 'Financiamiento'),
( 3, 2, 1, '2026-05-20',                     19000000.00, 'Efectivo'),
( 4, 3, 2, '2026-06-08',                     12000000.00, 'Tarjeta'),
( 5, 4, 2, '2026-08-17',                     23500000.00, 'Financiamiento'),
( 2, 5, 3, '2026-09-25',                     24500000.00, 'Efectivo'),
(11, 6, 1, CURDATE() - INTERVAL 20 DAY,      37800000.00, 'Financiamiento'),
( 8, 1, 2, CURDATE() - INTERVAL 10 DAY,       9600000.00, 'Tarjeta'),
(10, 2, 4, CURDATE() - INTERVAL 3 DAY,       17500000.00, 'Efectivo');
