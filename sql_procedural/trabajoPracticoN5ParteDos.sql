---trabajo practico nro 5 parte 2

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
