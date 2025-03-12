---enunciado 1
---Se desea registrar en una tabla denominada RESUMEN_PALABRAS la cantidad de artículos que contienen cada palabra en distintos idiomas. Esta tabla debe contener las columnas: ---codigo_palabra, idioma, descripcion, y cantidad_articulos.
---Implementar un procedimiento que recorra las palabras registradas en la base de datos y calcule cuántos artículos están asociados a cada una, almacenando los resultados en 

---RESUMEN_PALABRAS.
---tablas que vamos a usar
---p5p1e1_articulo
---p5p1e1_contiene
---p5p1e1_palabra

CREATE OR REPLACE FUNCTION RESUMEN_PALABRAS() 
RETURNS TABLE (codigo_palabra NUMERIC, idioma VARCHAR, descripcion TEXT, cantidad_articulos INT) 
AS $$
BEGIN
    RETURN QUERY  
    SELECT 
        c.cod_palabra, 
        p.idioma, 
        p.descripcion, 
        COUNT(c.id_articulo) AS cantidad_articulos
    FROM p5p1e1_contiene c
    INNER JOIN p5p1e1_palabra p
        ON c.idioma = p.idioma 
        AND c.cod_palabra = p.cod_palabra
    GROUP BY c.cod_palabra, p.idioma, p.descripcion;
END;
$$ LANGUAGE plpgsql;

---Enunciado 2
---Se requiere actualizar la columna nacional de la tabla ARTICULO con el valor 'Charles Bukowski' si el autor del artículo es de Argentina y
--- 'Samid Baradeg' en caso contrario. Para ello, se dispone de una tabla denominada AUTORES con las columnas nombre_autor y pais. Implementar un procedimiento que realice esta ---actualización para todos los registros de la tabla ARTICULO.

CREATE TABLE autores (
nombre_autor VARCHAR(30),
pais VARCHAR(30)

)

CREATE OR REPLACE FUNCTION FN_ACTUALIZAR_TABLA_ARTICULO() RETURNS VOID AS $$
DECLARE
  var_r record;
BEGIN
  FOR var_r IN (
     SELECT 
     FROM p5p1e1_articulo a
     INNER autores au
     ON a.autor = au.autor
  )
  LOOP
     UPDATE p5p1e1_articulo
     SET autor = 
        CASE WHEN autor = 'Charles Bukowski'
            THEN 'Samid Baradeg'
            ELSE 'Charles Bukowski'
        END;
  END LOOP;
END;
$$
LANGUAGE plpgsql;