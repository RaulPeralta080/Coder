# Proyecto Integrador RetailPro — Data Analytics (Coderhouse)

**Analista:** Raúl Gerardo Peralta  
**Repositorio:** Análisis integral de ventas, clientes y productos para RetailPro (distribuidora de tecnología).

## Propósito del proyecto
Responder a la problemática de negocio definida en el Módulo 1: diagnosticar el desempeño de facturación, evolución mensual, comportamiento por canal (Online vs. Presencial) y rentabilidad por categoría/producto para respaldar decisiones de inventario y estrategia comercial.

## Arquitectura y Herramientas utilizadas
* **Modelado Relacional (SQL / PostgreSQL - pgAdmin 4):** Diseño en 3NF y consultas analíticas (JOINs, agregaciones y vistas base).
* **ETL y Limpieza (Power Query - Lenguaje M):** Eliminación de duplicados en claves primarias (`Dim_Clientes`, `Dim_Productos`), tratamiento de valores nulos (`"Sin dato"`, `"Sin categoría"`, precio `0` en revisión) y enriquecimiento de `Fact_Ventas` (50 transacciones, 12 productos, 4 categorías).
* **Modelado Estrella y DAX (Power BI Desktop):** Relación 1:N con tabla calendario (`Dim_Fechas`) vinculada mediante columna limpia `Fecha Pura`, y contenedor `_Medidas` con KPIs de inteligencia de tiempo (`Total Ventas`, `Ventas Online`, `Ventas YTD`, `Ventas LY` y `% Crecimiento Anual`).

## Cómo ejecutar los scripts SQL
1. Abrir **pgAdmin 4** (PostgreSQL) y crear una base de datos local llamada `ventas_tech_db`.
2. Ejecutar el script `ventas_tech_db.sql` para crear y poblar las 4 tablas del modelo (`categorias`, `clientes`, `productos`, `ventas`).
3. Correr los scripts `m4_consultas_negocio.sql` y `m5_consultas_joins.sql` sobre las tablas cargadas.
4. Para explorar el dashboard y las medidas DAX, abrir `Pipeline_ETL_Peralta_Raul.pbix` en Power BI Desktop.
