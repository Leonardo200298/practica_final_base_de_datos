---trabajo practico nro 5 parte 2

---Ejercicio 1

---A. No puede haber voluntarios de más de 70 años. Aquí como la edad es un dato que
---depende de la fecha actual lo deberíamos controlar de otra manera.
---A.Bis - Controlar que los voluntarios deben ser mayores a 18 años.
ALTER TABLE voluntario
ADD CONSTRAINT ck_voluntarios_menos_de_70_anios_mas_de_18_anios
CHECK((EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM fecha_nacimiento)<70)AND(EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM fecha_nacimiento) >  18))

—--B. Ningún voluntario puede aportar más horas que las de su coordinador.


ALTER TABLE voluntario
ADD CONSTRAINT ck_voluntario_tiene_que_tener_menos_horas_aportadas_que_coordinador
CHECK(NOT EXISTS(SELECT *
FROM voluntario v1
WHERE v1.horas_aportadas > (SELECT v2.horas_aportadas
                            FROM voluntario v2
                            WHERE v1.id_coordinador = v2.nro_voluntario)))


--- opción sider
ALTER TABLE voluntario
ADD CONSTRAINT ck_voluntario_tiene_que_tener_menos_horas_aportadas_que_coordinador
CHECK (NOT EXISTS (SELECT v1.*  
                   FROM voluntario v1  
                   INNER JOIN voluntario v2 ON v1.id_coordinador = v2.nro_voluntario  
                   WHERE v1.horas_aportadas > v2.horas_aportadas;))

---C. Las horas aportadas por los voluntarios deben estar dentro de los valores máximos y
---mínimos consignados en la tarea.

CREATE ASSERTION horas_aportadas_dentro_de_valores
CHECK(NOT EXISTS (SELECT *
FROM voluntario v
INNER JOIN tarea t
ON v.id_tarea = t.d_tarea
WHERE v.horas_aportadas BETWEEN t.min_horas AND t.max_horas
))

---D. Todos los voluntarios deben realizar la misma tarea que su coordinador.

CREATE ASSERTION ck_coordinadores_voluntarios_misma_tarea
CHECK(NOT EXISTS(SELECT *
FROM voluntario v1
INNER JOIN voluntario v2
ON v1.id_coordinador = v2.nro_voluntario
WHERE v1.id_tarea <> v2.id_tarea))

---E. Los voluntarios no pueden cambiar de institución más de tres veces al año.

CREATE ASSERTION ck_voluntario_institucion
CHECK(NOT EXISTS (SELECT i.id_institucion  
FROM voluntarios v  
INNER JOIN institucion i ON v.id_institucion = i.id_institucion   
WHERE EXTRACT(DAY FROM CURRENT_DATE) BETWEEN 0 AND 365  
GROUP BY i.id_institucion  
HAVING COUNT(v.id_institucion) > 3
));

---Ejercicio 2

---A. Para cada tarea el sueldo máximo debe ser mayor que el sueldo mínimo.

ALTER TABLE tareas
ADD CONSTRAINT CK_SUELDO_MAXIMO_MAYO_A_SUELDO_MINIMO
CHECK(NOT EXISTS (
SELECT id_tarea, sueldo_maximo, sueldo_minimo
FROM tareas
GROUP BY id_tarea, sueldo_maximo, sueldo_minimo
HAVING sueldo_maximo < sueldo_minimo))

---B. No puede haber más de 70 empleados en cada departamento.

---Ejercicio 3

---A. Controlar que las nacionalidades sean 'Argentina','Español', 'Inglés', 'Alemán' o 'Chilena'
ALTER TABLE p5p1e1_articulo
ADD CONSTRAINT ck_nacionalidades_especificas
CHECK(nacionalidad IN ('Argentina','Español', 'Inglés', 'Alemán', 'Chilena'))






