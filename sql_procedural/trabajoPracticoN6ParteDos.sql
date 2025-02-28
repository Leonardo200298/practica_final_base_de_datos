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
RETURNS TABLE(nro_registro integer, fecha timestamp, operacion varchar, usuario varchar) AS $$  
DECLARE  
    registro_count integer := 0;   
BEGIN  
   
    registro_count := registro_count + 1;  
    nro_registro := registro_count; 
    IF (TG_OP = 'INSERT') THEN  
        fecha := CURRENT_TIMESTAMP;  
        operacion := TG_OP;  
        usuario := CURRENT_USER;  
    ELSIF (TG_OP = 'UPDATE') THEN  
        fecha := CURRENT_TIMESTAMP;  
        operacion := TG_OP;  
        usuario := CURRENT_USER;  
    ELSIF (TG_OP = 'DELETE') THEN  
        fecha := CURRENT_TIMESTAMP;  
        operacion := TG_OP;  
        usuario := CURRENT_USER;   
    END IF;  

    RETURN NEXT;   
END;  
$$  
LANGUAGE plpgsql;  

CREATE TRIGGER TR_MODIFICACION_DE_TABLA_TAREA  
BEFORE INSERT OR UPDATE OR DELETE  
ON tareas  
FOR EACH STATEMENT   
EXECUTE PROCEDURE FN_CREAR_TABLA_HIS_TAREA();  