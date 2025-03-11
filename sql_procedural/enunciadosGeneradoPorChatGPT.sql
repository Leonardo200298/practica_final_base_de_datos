---enunciado 1
---Se desea registrar en una tabla denominada RESUMEN_PALABRAS la cantidad de artículos que contienen cada palabra en distintos idiomas. Esta tabla debe contener las columnas: ---codigo_palabra, idioma, descripcion, y cantidad_articulos.
---Implementar un procedimiento que recorra las palabras registradas en la base de datos y calcule cuántos artículos están asociados a cada una, almacenando los resultados en 

---RESUMEN_PALABRAS.
---tablas que vamos a usar
---p5p1e1_articulo
---p5p1e1_contiene
---p5p1e1_palabra

CREATE OR REPLACE FUNCTION RESUMEN_PALABRAS() RETURNS TABLE (codigo_palabra, idioma, descripcion, cantidad_articulos) AS $$
DECLARE
 var_r record;
 
BEGIN
 FOR var_r IN (
   SELECT 
   FROM p5p1e1_contiene c
   INNER JOIN p5p1e1_palabra p
   ON c.idioma = p.idioma AND
   c.cod_palabra = p.cod_palabra
   
 ) 
 LOOP
 
 RETURN NEXT;
 END LOOP;
 
END;

$$ 
/* Enunciado 2
Se requiere actualizar la columna nacional de la tabla ARTICULO con el valor 'Nacional' si el autor del artículo es de Argentina y 'Internacional' en caso contrario. Para ello, se dispone de una tabla denominada AUTORES con las columnas nombre_autor y pais. Implementar un procedimiento que realice esta actualización para todos los registros de la tabla ARTICULO.

 */