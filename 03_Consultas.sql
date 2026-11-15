-- =====================================================================
-- QUIZ #5 - SQL | CE 2103 Algoritmos y Estructuras de Datos II
-- Script de consultas (Parte 4)
-- Ejecutar después de 01_DDL.sql y 02_DML.sql
-- =====================================================================

USE MiAutoPuntoCom;

-- ---------------------------------------------------------------------
-- 1. Listar todos los vehículos disponibles (no vendidos)
--    ordenados por precio descendente
-- ---------------------------------------------------------------------
SELECT v.id_vehiculo, v.vin, v.marca, v.modelo, v.anio, v.color,
       v.tipo, v.estado, v.precio
FROM Vehiculos v
WHERE NOT EXISTS (SELECT 1 FROM Ventas vt WHERE vt.id_vehiculo = v.id_vehiculo)
ORDER BY v.precio DESC;

-- ---------------------------------------------------------------------
-- 2. Total de ventas realizadas por cada vendedor
--    (LEFT JOIN para incluir vendedores con 0 ventas)
-- ---------------------------------------------------------------------
SELECT ve.id_vendedor,
       CONCAT(ve.nombre, ' ', ve.apellido) AS vendedor,
       COUNT(vt.id_venta)                 AS cantidad_ventas
FROM Vendedores ve
LEFT JOIN Ventas vt ON vt.id_vendedor = ve.id_vendedor
GROUP BY ve.id_vendedor, ve.nombre, ve.apellido
ORDER BY cantidad_ventas DESC, vendedor;

-- ---------------------------------------------------------------------
-- 3. Ingreso total generado por cada vendedor
-- ---------------------------------------------------------------------
SELECT ve.id_vendedor,
       CONCAT(ve.nombre, ' ', ve.apellido)   AS vendedor,
       COALESCE(SUM(vt.precio_final), 0)    AS ingreso_total
FROM Vendedores ve
LEFT JOIN Ventas vt ON vt.id_vendedor = ve.id_vendedor
GROUP BY ve.id_vendedor, ve.nombre, ve.apellido
ORDER BY ingreso_total DESC;

-- ---------------------------------------------------------------------
-- 4. Cliente que ha realizado la compra más costosa
--    (se usa MAX en subconsulta para devolver todos en caso de empate)
-- ---------------------------------------------------------------------
SELECT c.id_cliente,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       c.cedula, c.email,
       v.marca, v.modelo, vt.fecha_venta,
       vt.precio_final                  AS monto_compra
FROM Ventas vt
JOIN Clientes  c ON c.id_cliente  = vt.id_cliente
JOIN Vehiculos v ON v.id_vehiculo = vt.id_vehiculo
WHERE vt.precio_final = (SELECT MAX(precio_final) FROM Ventas);

-- ---------------------------------------------------------------------
-- 5. Vehículos vendidos en el último mes con información del cliente
-- ---------------------------------------------------------------------
SELECT vt.fecha_venta,
       v.vin, v.marca, v.modelo, v.anio, v.tipo,
       vt.precio_final,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       c.cedula, c.telefono, c.email
FROM Ventas vt
JOIN Vehiculos v ON v.id_vehiculo = vt.id_vehiculo
JOIN Clientes  c ON c.id_cliente  = vt.id_cliente
WHERE vt.fecha_venta >= CURDATE() - INTERVAL 1 MONTH
  AND vt.fecha_venta <= CURDATE()
ORDER BY vt.fecha_venta DESC;

-- ---------------------------------------------------------------------
-- 6. Comisión ganada por cada vendedor basada en sus ventas
--    comisión = suma(precio_final) * porcentaje / 100
-- ---------------------------------------------------------------------
SELECT ve.id_vendedor,
       CONCAT(ve.nombre, ' ', ve.apellido)                         AS vendedor,
       ve.comision                                                 AS porcentaje_comision,
       COALESCE(SUM(vt.precio_final), 0)                          AS total_vendido,
       ROUND(COALESCE(SUM(vt.precio_final), 0) * ve.comision / 100, 2) AS comision_ganada
FROM Vendedores ve
LEFT JOIN Ventas vt ON vt.id_vendedor = ve.id_vendedor
GROUP BY ve.id_vendedor, ve.nombre, ve.apellido, ve.comision
ORDER BY comision_ganada DESC;

-- ---------------------------------------------------------------------
-- 7. Promedio de precios de vehículos vendidos agrupados por tipo
--    (se usa el precio final de venta)
-- ---------------------------------------------------------------------
SELECT v.tipo,
       COUNT(*)                          AS vehiculos_vendidos,
       ROUND(AVG(vt.precio_final), 2)    AS precio_promedio_venta
FROM Ventas vt
JOIN Vehiculos v ON v.id_vehiculo = vt.id_vehiculo
GROUP BY v.tipo
ORDER BY precio_promedio_venta DESC;

-- ---------------------------------------------------------------------
-- 8. Marca de vehículo que se ha vendido más veces
--    (HAVING con subconsulta para devolver todas en caso de empate)
-- ---------------------------------------------------------------------
SELECT v.marca, COUNT(*) AS veces_vendida
FROM Ventas vt
JOIN Vehiculos v ON v.id_vehiculo = vt.id_vehiculo
GROUP BY v.marca
HAVING COUNT(*) = (
    SELECT MAX(conteo)
    FROM (SELECT COUNT(*) AS conteo
          FROM Ventas vt2
          JOIN Vehiculos v2 ON v2.id_vehiculo = vt2.id_vehiculo
          GROUP BY v2.marca) AS t
);
