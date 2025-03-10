---Seleccionar el identificador y nombre de aquellos
---empleados donde la fecha de nacimiento supere el 1/1/1980

SELECT id_empleado, nombre
FROM empleado
WHERE fecha_nacimiento > to_date('1/1/1980', 'dd/MM/yyyy');

---con indice mejora la consulta 
CREATE INDEX I_Empleado_Fecha_Nacimiento ON
EMPLEADO(fecha_nacimiento DESC);