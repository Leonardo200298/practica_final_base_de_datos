--- 1.5. Determinar los jefes que poseen personal a cargo y cuyos departamentos (los del
---jefe) se encuentren en la Argentina.

SELECT DISTINCT id_jefe  
FROM empleado  
WHERE id_jefe IN (  
    SELECT d.jefe_departamento  
    FROM departamento d  
    INNER JOIN ciudad c ON d.id_ciudad = c.id_ciudad  
    INNER JOIN pais p ON c.id_pais = p.id_pais  
    WHERE p.nombre_pais = 'Argentina'  
    ---validacion para ver si el jefe tiene empleados a cargo
    AND EXISTS (  
        SELECT 1  
        FROM empleado e  
        WHERE e.id_departamento = d.id_departamento  
        AND e.id_distribuidor = d.id_distribuidor  
        AND e.id_jefe = d.jefe_departamento  
    )  
);