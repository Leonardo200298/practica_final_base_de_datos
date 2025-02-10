---trabajo practico nro 4 parte 1
---2. Seleccione el identificador de distribuidor, identificador de departamento y nombre de todos
---los departamentos.(P)

---SELECT id_departamento, id_distribuidor, nombre
---FROM departamento

---3. Muestre el nombre, apellido y el teléfono de todos los empleados cuyo id_tarea sea 7231,
---ordenados por apellido y nombre.(P)
---SELECT nombre, apellido, telefono, id_tarea
---FROM empleado
---WHERE id_tarea = '7231'
---ORDER BY apellido, nombre

---4. Muestre el apellido e identificador de todos los empleados que no cobran porcentaje de
---comisión.(P)
---SELECT nombre, apellido, porc_comision
---FROM empleado
---WHERE porc_comision IS NULL

---6. Muestre los datos de los distribuidores internacionales que no tienen registrado teléfono.
---(P)

---SELECT *
---FROM distribuidor
---WHERE (tipo = 'I') 
---AND
---(telefono IS NULL)


---7. Muestre los apellidos, nombres y mails de los empleados con cuentas de gmail y cuyo
---sueldo sea superior a $ 1000. (P)

---SELECT apellido,nombre,e_mail, sueldo
---FROM empleado
---WHERE (e_mail LIKE '%gmail%') AND (sueldo > 1000.00)

---8. Seleccione los diferentes identificadores de tareas que se utilizan en la tabla empleado. (P)

---SELECT DISTINCT id_tarea
---FROM empleado

---10. Hacer un listado de los cumpleaños de todos los empleados donde se muestre el nombre y
---el apellido (concatenados y separados por una coma) y su fecha de cumpleaños (solo el
---día y el mes), ordenado de acuerdo al mes y día de cumpleaños en forma ascendente. (P)

---SELECT 'Nombre: ' || nombre || ', apellido: ' || apellido || 'fecha de cumpleaños' || EXTRACT(DAY FROM fecha_nacimiento) || '/' || EXTRACT(MONTH FROM fecha_nacimiento) AS nombre_apellido_fecha_con_dia_y_mes
---FROM empleado
---ORDER BY EXTRACT(DAY FROM fecha_nacimiento), EXTRACT(MONTH FROM fecha_nacimiento) ASC

---12. Listar la cantidad de películas que hay por cada idioma. (P)
---SELECT idioma,COUNT(*) AS cantidad_de_peliculas_por_idioma
---FROM pelicula
---GROUP BY idioma

---13. Calcular la cantidad de empleados por departamento. (P)
---SELECT id_departamento, COUNT(*) AS cantidad_de_empleados_x_departamento
---FROM empleado
---GROUP BY id_departamento

---14. Mostrar los códigos de películas que han recibido entre 3 y 5 entregas. (veces entregadas,
---NO cantidad de películas entregadas).

---SELECT codigo_pelicula, COUNT(*) AS cantidadCodigoDePeliculas
---FROM renglon_entrega
---GROUP BY codigo_pelicula
---HAVING COUNT(*) BETWEEN 3 AND 5

---17. ¿Cuáles son los id de ciudades que tienen más de un departamento?

---SELECT id_ciudad, COUNT(*) as cantidad_de_departamentos
---FROM departamento
---GROUP BY id_ciudad
---HAVING COUNT(*) > 1


/*--------------------------------------------------*/
/*--------------------------------------------------*/
/*--------------------------------------------------*/
/*--------------------------------------------------*/


---para trabajar con esquema voluntario

---practica para final de base de datos

---cuantos voluntarios tiene cada institucion?

---SELECT id_institucion, COUNT(*) AS cant_intituciones_voluntario
---FROM voluntario
---GROUP BY id_institucion

---determine los porcentajes promedio de los
---voluntarios por institución.

---SELECT AVG(porcentaje) AS porcentaje_pro_vol_por_institucion

---FROM voluntario

---GROUP BY id_institucion;

---coordinadores con mas de 7 voluntarios

---SELECT id_coordinador, COUNT(*) AS coordinadores_con_mas_de_siete_voluntarios
---FROM voluntario
---GROUP BY id_coordinador
---HAVING COUNT(*) > 7

---trabajo practico nro 4 parte 1
---1. Seleccione el identificador y nombre de todas las instituciones que son Fundaciones.(V)
---SELECT *
---FROM institucion
---WHERE nombre_institucion LIKE 'FUNDACION %';

---5. Muestre el apellido y el identificador de la tarea de todos los voluntarios que no tienen
---coordinador.(V)

---SELECT apellido, id_tarea  
---FROM voluntario  
---WHERE id_coordinador IS NULL;


---9. Muestre el apellido, nombre y mail de todos los voluntarios cuyo teléfono comienza con
---+51. Coloque el encabezado de las columnas de los títulos , Apellido y Nombre y Dirección
---de mail. (V)

---SELECT nombre, apellido, e_mail
---FROM voluntario
---WHERE telefono LIKE '+51%'

---11. Recupere la cantidad mínima, máxima y promedio de horas aportadas por los voluntarios
---nacidos desde 1990. (V)

---SELECT 
---MIN(horas_aportadas) AS cantidad_minima_de_horas_aportadas,
---MAX(horas_aportadas) AS cantidad_maxima_de_horas_aportadas,
---AVG(horas_aportadas) AS cantidad_promedio_de_horas_aportadas 
---FROM voluntario
---WHERE EXTRACT(YEAR FROM fecha_nacimiento) >= 1990


---15. ¿Cuántos cumpleaños de voluntarios hay cada mes?
---SELECT EXTRACT(MONTH FROM fecha_nacimiento) AS mes, COUNT(*) AS cantidad_de_cumpleanios_voluntario_por_cada_mes
---FROM voluntario
---GROUP BY mes
---ORDER BY mes;

---16. ¿Cuáles son las 2 instituciones que más voluntarios tienen?
---SELECT COUNT(*) AS cantidadDeVoluntarios
---FROM voluntario
---GROUP BY id_institucion
---ORDER BY cantidadDeVoluntarios DESC
---LIMIT 2

/*--------------------------------------------------*/
/*--------------------------------------------------*/

