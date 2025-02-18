---Ejercicio nro 1 practico nro 6

---forma declarativa 

--C. Cada palabra puede aparecer como máximo en 5 artículos.
-- buscar las palabras que aparecen en más de 5 articulos
-- TIPO - TABLA

ALTER TABLE p5p2e3_contiene
   ADD CONSTRAINT ck_cantpalabra_articulo
   CHECK ( NOT EXISTS (
             SELECT 1
             FROM p5p2e3_contiene
             GROUP BY idioma, cod_palabra
             HAVING COUNT(*) > 5));
