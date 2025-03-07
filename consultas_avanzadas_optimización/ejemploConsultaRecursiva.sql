WITH RECURSIVE organigrama AS (
    ---ancla
    SELECT employee_id, manager_id, full_name, 1 as nivel
    FROM employee
    WHERE manager_id is null
    --- fin de ancla
    UNION
    SELECT e1.employee_id, e1.manager_id, e1.full_name, nivel + 1
    FROM employee e1
    INNER JOIN organigrama o
    ON e1.employee_id = o.manager_id
)
---llamado 
---niveles del 1 al 3
SELECT *
FROM organigrama o
WHERE o.nivel IN (1,3) 