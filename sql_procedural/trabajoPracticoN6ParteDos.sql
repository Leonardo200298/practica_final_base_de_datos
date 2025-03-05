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


/* Consulta para crear cursor */

SELECT *
FROM pelicula p
INNER JOIN renglonentregapelicula r
ON p.codigo_pelicula = r.codigo_pelicula
ORDER BY r.cantidad, r.codigo_pelicula
LIMIT 20;

CREATE OR REPLACE FUNCTION MAS_ENTREGADAS()
RETURNS TABLE(codigo_pelicula NUMERIC, nombre VARCHAR, cantidad_de_entregas BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.codigo_pelicula, 
        p.titulo AS nombre, 
        COUNT(*) AS cantidad_de_entregas
    FROM pelicula p
    INNER JOIN renglonentregapelicula re ON p.codigo_pelicula = re.codigo_pelicula
    INNER JOIN entregapelicula e ON re.nro_entrega = e.nro_entrega
    WHERE e.fecha_entrega >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY p.codigo_pelicula, p.titulo
    ORDER BY cantidad_de_entregas DESC, p.codigo_pelicula ASC
    LIMIT 20;
END;
$$ LANGUAGE plpgsql;

---d) Generar los datos para una tabla denominada SUELDOS, con los datos de los empleados
---cuyas comisiones superen a la media del departamento en el que trabajan. Esta tabla debe
---tener las columnas id_empleado, apellido, nombre, sueldo, porc_comision.



CREATE OR REPLACE FUNCTION SUELDOS()  
RETURNS TABLE(id_empleado NUMERIC(6,0), apellido TEXT, nombre TEXT, sueldo NUMERIC, porc_comision NUMERIC) AS $$  
BEGIN  
    RETURN QUERY  
    SELECT   
        k.id_empleado,   
        k.apellido,   
        k.nombre,   
        k.sueldo,   
        k.porc_comision  
    FROM empleadosdepeliculas k  
    WHERE k.porc_comision > (  
        SELECT AVG(e.porc_comision)   
        FROM empleadosdepeliculas e  
        INNER JOIN departamentodepeliculas d ON e.id_departamento = d.id_departamento  
        AND e.id_distribuidor = d.id_distribuidor  
        WHERE d.id_departamento = k.id_departamento  
        AND d.id_distribuidor = k.id_distribuidor  
    );  
END;   
$$ LANGUAGE plpgsql;  

---e) Cambiar el distribuidor de las entregas sucedidas a partir de una fecha dada, siendo que el
---par de valores de distribuidor viejo y distribuidor nuevo es variable.

CREATE OR REPLACE FUNCTION FN_CAMBIO_DISTRIBUIDOR(  
    fecha_parametro DATE,  
    nuevo_id_distribuidor NUMERIC(5,0)
)  
RETURNS VOID AS $$  
BEGIN  
  UPDATE entregapelicula 
  SET id_distribuidor = nuevo_id_distribuidor  
  WHERE fecha_entrega >= fecha_parametro;  

END;  
$$ LANGUAGE plpgsql;  

---Ejercicio 3
---Para el esquema unc_voluntarios se desea conocer la cantidad de voluntarios que hay en cada
---tarea al inicio de cada mes y guardarla a lo largo de los meses. Para esto es necesario hacer un
---procedimiento que calcule la cantidad y la almacene en una tabla denominada
---CANT_VOLUNTARIOSXTAREA con la siguiente estructura:
---CANT_VOLUNTARIOSXTAREA (anio, mes, id_tarea, nombre_tarea, cant_voluntarios)

---creacion de tabla 
CREATE TABLE cant_voluntarios_por_tarea (
    anio INT,
    mes INT,
    id_tarea VARCHAR(10),
    nombre_tarea VARCHAR(40),
    cant_voluntarios INT
);


CREATE OR REPLACE FUNCTION FN_VOLUNTARIOS_X_TAREA() RETURNS TRIGGER AS $$  
DECLARE  
    cant_volun INTEGER;  
    reg_tarea RECORD;  
BEGIN  
    FOR reg_tarea IN (SELECT id_tarea, nombre_tarea FROM tarea) LOOP   
        SELECT COUNT(*) INTO cant_volun  
        FROM voluntarios  
        WHERE id_tarea = reg_tarea.id_tarea;  

        
        IF (EXTRACT(DAY FROM CURRENT_DATE) = 1) THEN  
            INSERT INTO cant_voluntarios_por_tarea (anio, mes, id_tarea, nombre_tarea, cant_voluntarios)  
            VALUES (EXTRACT(YEAR FROM CURRENT_DATE), EXTRACT(MONTH FROM CURRENT_DATE), reg_tarea.id_tarea, reg_tarea.nombre_tarea, cant_volun);  
        END IF;  
    END LOOP;  

    RETURN NEW;  
END;  
$$ LANGUAGE plpgsql;  

CREATE TRIGGER TR_VOLUNTARIOS_X_TAREA  
AFTER INSERT OR UPDATE OR DELETE ON voluntarios  
EXECUTE FUNCTION FN_VOLUNTARIOS_X_TAREA();  