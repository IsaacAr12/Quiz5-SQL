# Quiz #5 – SQL · MiAutoPuntoCom

CE 2103 Algoritmos y Estructuras de Datos II – II Semestre 2026

## Archivos

| Archivo | Contenido |
|---|---|
| `01_DDL.sql` | Creación de la base de datos, las tablas (Vehiculos, Clientes, Vendedores, Ventas), las restricciones y los triggers |
| `02_DML.sql` | Datos de prueba: 12 vehículos, 6 clientes, 4 vendedores, 8 ventas |
| `03_Consultas.sql` | Las 8 consultas de la Parte 4 |

## Ejecución

Ejecutar los scripts en orden (en MySQL Workbench o en la terminal):

```bash
mysql -u root -p < 01_DDL.sql
mysql -u root -p < 02_DML.sql
mysql -u root -p < 03_Consultas.sql
```

## Notas de diseño

- **Año del vehículo ≤ año actual** y **vendedor ≥ 21 años**: MySQL no permite `CURDATE()` dentro de un `CHECK`, así que estas validaciones se hacen con triggers `BEFORE INSERT/UPDATE` que lanzan un error con `SIGNAL`. Además, el `CHECK chk_vendedores_edad` exige que el vendedor tuviera al menos 21 años en su fecha de contratación.
- `Ventas.id_vehiculo` es `UNIQUE`: un vehículo solo se puede vender una vez.
- Las 3 ventas más recientes usan fechas relativas a `CURDATE()`, por eso la consulta 5 ("vendidos en el último mes") siempre devuelve resultados.
- Las consultas 4 y 8 devuelven todos los resultados si hay empate.
