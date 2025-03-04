---Trabajo practico nro 7

---Ejercicio 1
---Considere las siguientes sentencias de creación de vistas en el esquema de Películas:
---Nota: el planteo es sólo teórico porque no podrá insertar registros en unc_esq_peliculas por
---los permisos

CREATE VIEW Distribuidor_200 AS
SELECT id_distribuidor, nombre, tipo
FROM unc_esq_peliculas.distribuidor
WHERE id_distribuidor > 200;

CREATE VIEW Departamento_dist_200 AS
SELECT id_departamento, nombre, id_ciudad, jefe_departamento
FROM unc_esq_peliculas.departamento
WHERE id_distribuidor > 200;

---a. Discuta si las vistas son actualizables o no y justifique.
---segunda vista incumple la regla 1 que tiene que tener la pk de la tabla, le falta una de las pk

---nueva vista

CREATE VIEW Distribuidor_1000 AS
SELECT *
FROM unc_esq_peliculas.distribuidor d
WHERE id_distribuidor &gt; 1000;

---Indique y justifique la opción correcta:
---A. Falla porque la vista no es actualizable.
---B. Falla porque si bien la vista es actualizable viola una restricción de foreign key.
---C. Falla porque si bien la vista es actualizable viola una restricción de primary key.
---D. Procede exitosamente.

---A falla porque la vista no es actualizable ya que no posee la/las pk de la tabla del from

---Ejercicio 4
---Para el esquema de la figura que corresponde Trabajo Práctico 5 Parte 2 cuyo script de
---creación de tablas lo podes descargar de aquí    

---Transformar en actualizables para PostgreSQL las siguientes vistas:

CREATE VIEW V1
AS SELECT id_articulo
FROM p5p2e3_contiene
WHERE id_articulo IN 
    (SELECT id_articulo
    FROM p5p2e3_articulo
    WHERE EXTRACT(year from fecha_publicacion) > 2015;
    );  

CREATE VIEW V2
AS SELECT idioma, cod_palabra
FROM p5p2e3_contiene
WHERE idioma, cod_palabra IN (SELECT idioma, cod_palabra
FROM p5p2e3_palabra
WHERE lower(descripcion) like '%bases de datos%')

