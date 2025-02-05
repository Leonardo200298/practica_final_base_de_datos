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