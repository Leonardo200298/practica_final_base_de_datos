--- 1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
---jefe) se encuentren en la Argentina.

SELECT DISTINCT id_jefe  
FROM empleado  
WHERE id_jefe IN (  
    SELECT d.jefe_departamento  
    FROM departamento d  
    INNER JOIN ciudad c ON d.id_ciudad = c.id_ciudad  
    INNER JOIN pais p ON c.id_pais = p.id_pais  
    WHERE p.nombre_pais = 'ARGENTINA'  
    ---validacion para ver si el jefe tiene empleados a cargo
    AND EXISTS (  
        SELECT 1  
        FROM empleado e  
        WHERE e.id_departamento = d.id_departamento  
        AND e.id_distribuidor = d.id_distribuidor  
        AND e.id_jefe = d.jefe_departamento  
    )  
);

---1.6. Liste el apellido y nombre de los empleados que pertenecen a aquellos
---departamentos de Argentina y donde el jefe de departamento posee una comisión de más
---del 10% de la que posee su empleado a cargo.

SELECT e.nombre, e.apellido  
FROM empleado e  
INNER JOIN departamento d ON e.id_departamento = d.id_departamento  
AND e.id_distribuidor = d.id_distribuidor  
INNER JOIN ciudad c ON d.id_ciudad = c.id_ciudad  
INNER JOIN pais p ON c.id_pais = p.id_pais  
WHERE p.nombre_pais = 'ARGENTINA'  
AND EXISTS (  
    SELECT 1  
    FROM empleado e2  
    WHERE e2.id_jefe = d.jefe_departamento  
    AND e2.porc_comision > e.porc_comision * 1.1   
);

---Parte del ejercicio que es con agrupacion
---1.7. Indicar la cantidad de películas entregadas a partir del 2010, por género.

SELECT p.genero, COUNT(*) AS cantidad_de_peliculas_por_anio
FROM pelicula p
INNER JOIN renglon_entrega r
ON r.codigo_pelicula = p.codigo_pelicula 
INNER JOIN entrega e
ON r.nro_entrega = e.nro_entrega
WHERE EXTRACT(YEAR FROM e.fecha_entrega) >= 2010
GROUP BY p.genero

---1.8. Realizar un resumen de entregas por día, indicando el video club al cual se le
---realizó la entrega y la cantidad entregada. Ordenar el resultado por fecha.

SELECT e.fecha_entrega AS diaEntrega, v.id_video AS videoclub,
COUNT(*) AS cantidadEntregada
FROM entrega e
INNER JOIN video v
ON e.id_video = v.id_video
GROUP BY e.fecha_entrega, v.id_video
ORDER BY e.fecha_entrega

---1.9. Listar, para cada ciudad, el nombre de la ciudad y la cantidad de empleados mayores de edad que desempeñan tareas en departamentos de la misma y que posean al
---menos 30 empleados.

SELECT c.nombre_ciudad, COUNT(*) AS cantidad_empleados_mayores_de_edad_con_menos_de_dicha_cantidad_de_empleados
FROM empleado e
INNER JOIN departamento d
ON e.id_departamento = d.id_departamento AND e.id_distribuidor = d.id_distribuidor
INNER JOIN ciudad c
ON d.id_ciudad = c.id_ciudad
---"filtro" por tabla
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.fecha_nacimiento) >= 18 
GROUP BY c.nombre_ciudad
---filtro por lo que se agrupa
HAVING COUNT(*) >= 30