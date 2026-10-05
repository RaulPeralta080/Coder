
-- ------------------------------------------------------------------------------
-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Combina ventas con clientes, productos y categorías en una sola vista.
-- ------------------------------------------------------------------------------
SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.ciudad AS ciudad_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- ------------------------------------------------------------------------------
-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Identifica clientes registrados que aún no han realizado compras.
-- ------------------------------------------------------------------------------
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- ------------------------------------------------------------------------------
-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Identifica productos del catálogo que no tienen ventas registradas.
-- ------------------------------------------------------------------------------
SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- ------------------------------------------------------------------------------
-- Consulta 4 — Consolidado por canal (UNION ALL)
-- Simula la separación de ventas por un criterio (ej. cantidad) 
-- y luego agrupa para obtener el total facturado por este 'canal' creado.
-- ------------------------------------------------------------------------------
WITH ConsolidadoCanales AS (
    -- Bloque 1: Simulamos compras mayoristas (Canal B2B)
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Mayorista (B2B)' AS canal
    FROM ventas
    WHERE cantidad >= 3
    
    UNION ALL
    
    -- Bloque 2: Simulamos compras minoristas (Canal B2C)
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Minorista (B2C)' AS canal
    FROM ventas
    WHERE cantidad < 3
)
-- Agrupamos el resultado del UNION ALL para ver la métrica final
SELECT 
    canal,
    SUM(total) AS total_facturado
FROM ConsolidadoCanales
GROUP BY canal;