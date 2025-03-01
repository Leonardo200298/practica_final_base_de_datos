---ejercicio 1 tp nro 6 parte 2
---Para el esquema unc_voluntarios considere que se quiere mantener un registro de quién y
---cuándo realizó actualizaciones sobre la tabla TAREA en la tabla HIS_TAREA. Dicha tabla tiene la
---siguiente estructura:
---HIS_TAREA(nro_registro, fecha, operación, usuario)
---a) Provea el/los trigger/s necesario/s para mantener en forma automática la tabla HIS_TAREA
---cuando se realizan actualizaciones (insert, update o delete) en la tabla TAREA.
---b) Muestre los resultados de las tablas si se ejecuta la operación:

---DELETE FROM TAREA
---WHERE id_tarea like ‘AD%’;
---Según el o los triggers definidos sean FOR EACH ROW o FOR EACH STATEMENT.
---Evalúe la diferencia entre ambos tipos de granularidad.

---debo crear una tabla que se llame HIS_TAREA
CREATE OR REPLACE FUNCTION FN_CREAR_TABLA_HIS_TAREA()  
RETURNS TRIGGER AS $$  

BEGIN  
   
    IF (TG_OP = 'INSERT') THEN  
        INSERT INTO HIS_TAREA  (fecha, operacion, usuario)
        VALUES (CURRENT_TIMESTAMP, TG_OP, CURRENT_USER); 
    ELSIF (TG_OP = 'UPDATE') THEN  
        INSERT INTO HIS_TAREA  (fecha, operacion, usuario)
        VALUES (CURRENT_TIMESTAMP, TG_OP, CURRENT_USER);   
    ELSIF (TG_OP = 'DELETE') THEN  
        INSERT INTO HIS_TAREA  (fecha, operacion, usuario)
        VALUES (CURRENT_TIMESTAMP, TG_OP, CURRENT_USER);   
    END IF;  

    RETURN NULL;
END;  
$$  
LANGUAGE plpgsql;  

CREATE TRIGGER TR_MODIFICACION_DE_TABLA_TAREA  
BEFORE INSERT OR UPDATE OR DELETE  
ON tareas  
FOR EACH STATEMENT   
EXECUTE PROCEDURE FN_CREAR_TABLA_HIS_TAREA(); 

DELETE FROM tareas
WHERE id_tarea = '519';

UPDATE tareas
SET nombre_tarea = 'sin tarea'
WHERE id_tarea = '520';

/* Ejercicio 2
A partir del esquema unc_peliculas, realice procedimientos para:
c) Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas
más entregadas en los últimos seis meses desde la ejecución del procedimiento. Esta tabla
por lo menos debe tener las columnas código_pelicula, nombre, cantidad_de_entregas (en
caso de coincidir en cantidad de entrega ordenar por código de película).
d) Generar los datos para una tabla denominada SUELDOS, con los datos de los empleados
cuyas comisiones superen a la media del departamento en el que trabajan. Esta tabla debe
tener las columnas id_empleado, apellido, nombre, sueldo, porc_comision.
e) Cambiar el distribuidor de las entregas sucedidas a partir de una fecha dada, siendo que el
par de valores de distribuidor viejo y distribuidor nuevo es variable. */

---c) Completar una tabla denominada MAS_ENTREGADAS con los datos de las 20 películas
---más entregadas en los últimos seis meses desde la ejecución del procedimiento. Esta tabla
---por lo menos debe tener las columnas código_pelicula, nombre, cantidad_de_entregas (en
---caso de coincidir en cantidad de entrega ordenar por código de película).

/* crear funcion que devuelva tabla, ya que es mas facil al momento ded ejecucion de la funcion
saber las 20 peliculas mas entregadas */

