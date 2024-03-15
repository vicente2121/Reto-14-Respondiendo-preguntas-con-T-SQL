--Respondiendo las preguntas de negocio 1. 
--¿Cuál es el precio medio del gasoil de grado 2 en todas las provincias?

select AVG(b.precio) AS Precio, a.Producto, c.Provincia
from Tabla_Hechos as b
left join Dim_Producto as a 
on a.Id_Producto=b.Id_Producto

left join Dim_Ubicacion as c
on b.Id_Ubicacion=c.Id_Ubicacion

--Nos vamos a la segunda pregunta de negocios
--Por ciudades, ¿cuál es la empresa con mayores ventas totales? 


select d.Posicion,d.Provincia,d.Empresa
from (SELECT c.Provincia,b.Empresa, SUM(a.Precio) AS total_ventas,
       ROW_NUMBER() OVER(PARTITION BY c.provincia ORDER BY SUM(a.precio) asc) AS Posicion
FROM Tabla_Hechos as a
left join Dim_Empresa as b
on a.Id_Empresa=b.Id_Empresa
left join Dim_Ubicacion as c
on a.Id_Ubicacion=c.Id_Ubicacion
group by c.Provincia,b.Empresa
)  as d
where d.Posicion=1 and d.Provincia is not null

--3. ¿Cómo ha variado el precio de Petrol Premium - 95 Octanos de septiembre de 2022 a octubre de 2023?


select     a.fecha_actual,a.costo_actual,b.Producto,
    LAG(a.fecha_actual) OVER (ORDER BY a.fecha_actual) AS fecha_anterior,
    LAG(a.costo_actual) OVER (ORDER BY a.fecha_actual) AS costo_anterior,
	LAG(a.costo_actual) OVER (ORDER BY a.fecha_actual)-a.costo_actual as Variacion
FROM (
    SELECT fecha AS fecha_actual,SUM(precio) AS costo_actual
 , Id_Producto FROM Tabla_Hechos
    WHERE fecha BETWEEN '2022-09-01' AND '2023-10-01'
    GROUP BY fecha,Id_Producto
) AS a
left join Dim_Producto as b
on a.Id_Producto=b.Id_Producto
where b.Producto= 'Nafta (premium) de más de 95 Ron'

--¿Qué región tiene el precio medio más alto del Gas Natural Comprimido?

select AVG(a.Precio) as precio,b.Producto from Tabla_Hechos as a
left join Dim_Producto as b
on a.Id_Producto=b.Id_Producto
where b.Producto='GNC'
group by b.Producto





