--M4--
-- ------------------------------------------------------------------------------
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes.
-- ------------------------------------------------------------------------------
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes_venta,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes_venta;

-- ------------------------------------------------------------------------------
-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, mostrando unidades vendidas.
-- ------------------------------------------------------------------------------
SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;

-- ------------------------------------------------------------------------------
-- Consulta 3 — Clientes recurrentes
-- id_cliente con más de un pedido, mostrando cantidad de pedidos y total gastado.
-- ------------------------------------------------------------------------------
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY total_gastado DESC;

-- ------------------------------------------------------------------------------
-- Consulta 4 — Meses por encima/por debajo del promedio
-- Compara el total mensual contra el promedio mensual general usando CTEs.
-- ------------------------------------------------------------------------------
WITH TotalesMensuales AS (
    -- Primero calculamos el total facturado por cada mes
    SELECT 
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
PromedioGeneral AS (
    -- Luego calculamos el promedio de esos meses
    SELECT AVG(total_facturado) AS promedio_mensual
    FROM TotalesMensuales
)
-- Finalmente, comparamos cada mes contra el promedio general
SELECT 
    t.mes,
    t.total_facturado,
    CASE 
        WHEN t.total_facturado > p.promedio_mensual THEN 'Por encima'
        WHEN t.total_facturado < p.promedio_mensual THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS rendimiento_mensual
FROM TotalesMensuales t
CROSS JOIN PromedioGeneral p;


/*
HALLAZGOS CONCRETOS DE LA BASE DE DATOS:

1. Concentración de ingresos: El producto 1 (Laptop Pro 15) es el motor principal de ventas, generando $3,600. Esto representa más de la mitad de la facturación total ($6,444).
2. Tasa de recurrencia perfecta: El 100% de los clientes en la muestra son recurrentes. Los 5 clientes (ID 1 al 5) realizaron exactamente 2 pedidos cada uno durante el período registrado.
3. Ventas concentradas en un solo mes: Todas las transacciones (10 pedidos) ocurrieron exclusivamente durante el mes de marzo (mes 3), arrojando un ticket promedio general de $644.40 por pedido.
*/