# Reto-14-Respondiendo-preguntas-con-T-SQL

# Análisis de Datos Empresariales con T-SQL

Este repositorio contiene ejemplos de consultas en T-SQL utilizadas para responder preguntas de negocio en el contexto de análisis de datos empresariales. Se abordan una serie de preguntas cruciales utilizando diversas funciones y metodologías de T-SQL para obtener insights valiosos a partir de conjuntos de datos proporcionados.

## Contenido del Repositorio

- [Consultas T-SQL](#consultas-t-sql): Ejemplos de consultas T-SQL utilizadas para resolver preguntas específicas de negocio.
- [Conclusiones](#conclusiones): Resumen de las principales conclusiones y aprendizajes del análisis.

## Consultas T-SQL

### 1. Precio Medio del Gasoil de Grado 2 en Todas las Provincias
![1](https://github.com/vicente2121/Reto-14-Respondiendo-preguntas-con-T-SQL/assets/72566296/3feca07a-4164-42ac-91af-e13a6e31c3ab)

Para calcular el precio medio del gasoil de grado 2 en todas las provincias, utilizamos la siguiente consulta:

sql
 Consulta para calcular el precio medio del gasoil de grado 2 en todas las provincias
SELECT AVG(b.precio) AS Precio, a.Producto, c.Provincia
FROM Tabla_Hechos AS b
LEFT JOIN Dim_Producto AS a 
ON a.Id_Producto = b.Id_Producto
LEFT JOIN Dim_Ubicacion AS c
ON b.Id_Ubicacion = c.Id_Ubicacion

### 2. Empresa con Mayores Ventas Totales por Ciudad
![2](https://github.com/vicente2121/Reto-14-Respondiendo-preguntas-con-T-SQL/assets/72566296/913543fd-8a4a-4f88-a3ea-3a3823e2bec2)

Para identificar la empresa con mayores ventas totales por ciudad, utilizamos la siguiente consulta:

-- Consulta para identificar la empresa con mayores ventas totales por ciudad
SELECT d.Posicion, d.Provincia, d.Empresa
FROM (
    SELECT c.Provincia, b.Empresa, SUM(a.Precio) AS total_ventas,
           ROW_NUMBER() OVER(PARTITION BY c.provincia ORDER BY SUM(a.precio) asc) AS Posicion
    FROM Tabla_Hechos AS a
    LEFT JOIN Dim_Empresa AS b
    ON a.Id_Empresa = b.Id_Empresa
    LEFT JOIN Dim_Ubicacion AS c
    ON a.Id_Ubicacion = c.Id_Ubicacion
    GROUP BY c.Provincia, b.Empresa
) AS d
WHERE d.Posicion = 1 AND d.Provincia IS NOT NULL
### 3. Variación de Precio de Petrol Premium - 95 Octanos
![3](https://github.com/vicente2121/Reto-14-Respondiendo-preguntas-con-T-SQL/assets/72566296/28dc35e9-9e9b-4b03-926f-ce6d0f346d2e)

Para analizar la variación de precios de Petrol Premium - 95 Octanos entre septiembre de 2022 y octubre de 2023, utilizamos la siguiente consulta:

sql
Copy code
-- Consulta para analizar la variación de precios de Petrol Premium - 95 Octanos
SELECT a.fecha_actual, a.costo_actual, b.Producto,
    LAG(a.fecha_actual) OVER (ORDER BY a.fecha_actual) AS fecha_anterior,
    LAG(a.costo_actual) OVER (ORDER BY a.fecha_actual) AS costo_anterior,
    LAG(a.costo_actual) OVER (ORDER BY a.fecha_actual) - a.costo_actual AS Variacion
FROM (
    SELECT fecha AS fecha_actual, SUM(precio) AS costo_actual, Id_Producto 
    FROM Tabla_Hechos
    WHERE fecha BETWEEN '2022-09-01' AND '2023-10-01'
    GROUP BY fecha, Id_Producto
) AS a
LEFT JOIN Dim_Producto AS b
ON a.Id_Producto = b.Id_Producto
WHERE b.Producto = 'Nafta (premium) de más de 95 Ron'
### 4. Región con Precio Medio Más Alto del Gas Natural Comprimido
Para determinar la región con el precio medio más alto del Gas Natural Comprimido, utilizamos la siguiente consulta:

sql
Copy code
-- Consulta para determinar la región con el precio medio más alto del Gas Natural Comprimido
SELECT AVG(a.Precio) AS precio, b.Producto
FROM Tabla_Hechos AS a
LEFT JOIN Dim_Producto AS b
ON a.Id_Producto = b.Id_Producto
WHERE b.Producto = 'GNC'
GROUP BY b.Producto
Conclusiones
El análisis de datos empresariales con T-SQL nos permitió obtener insights valiosos para la toma de decisiones estratégicas. Algunas conclusiones destacadas incluyen:

Funciones de Agregación: Utilizamos funciones como AVG() para calcular métricas estadísticas.
Funciones de Ventana: Empleamos funciones como ROW_NUMBER() y LAG() para análisis comparativos y de tendencias.
Left Join: Utilizamos left join para combinar datos de diferentes tablas según condiciones específicas.
Metodología de Análisis: Seguimos una metodología estructurada para abordar cada pregunta de negocio, desde la identificación hasta la interpretación de los resultados.
Este repositorio es un recurso útil para aquellos interesados en aprender sobre el uso de T-SQL en el análisis de datos empresariales.
