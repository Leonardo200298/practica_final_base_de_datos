---Ejercicio nro 1 practico nro 6

---forma declarativa 

--C. Cada palabra puede aparecer como máximo en 10 artículos.
-- buscar las palabras que aparecen en más de 10 articulos
-- TIPO - TABLA

ALTER TABLE p5p2e3_contiene
   ADD CONSTRAINT ck_cantpalabra_articulo
   CHECK ( NOT EXISTS (
             SELECT 1
             FROM p5p2e3_contiene
             GROUP BY idioma, cod_palabra
             HAVING COUNT(*) > 10));

--C. Cada palabra puede aparecer como máximo en 10 artículos.
-- buscar las palabras que aparecen en más de 10 articulos
-- TIPO - TABLA


CREATE OR REPLACE FUNCTION FN_MAXIMO_PALABRA_EN_CINCO_ARTICULOS()   
RETURNS TRIGGER AS $$  
DECLARE   
   cantidadPalabrasEnArticulo INTEGER;  
BEGIN  
   SELECT COUNT(*) INTO cantidadPalabrasEnArticulo  
   FROM p5p1e1_contiene  
   WHERE idioma = NEW.idioma AND cod_palabra = NEW.cod_palabra;  

   IF (cantidadPalabrasEnArticulo > 10) THEN  
      RAISE EXCEPTION 'Superó el número total de palabras por artículo: %', cantidadPalabrasEnArticulo;  
   END IF;  

   RETURN NEW;   
END;  
$$ LANGUAGE plpgsql;  

CREATE TRIGGER TR_MAX_PALABRAS_x_ARTICULO  
BEFORE INSERT OR UPDATE  
ON p5p1e1_contiene   
FOR EACH ROW  
EXECUTE PROCEDURE FN_MAXIMO_PALABRA_EN_CINCO_ARTICULOS();


---INSERTS para trigger 

INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (3, 'Título del Artículo 3', 'Autor 1', '2023-01-01', 'España');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (4, 'Título del Artículo 4', 'Autor 2', '2023-02-01', 'México');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (5, 'Título del Artículo 5', 'Autor 3', '2023-03-01', 'Argentina');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (6, 'Título del Artículo 6', 'Autor 4', '2023-04-01', 'Colombia');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (7, 'Título del Artículo 7', 'Autor 5', '2023-05-01', 'Perú');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (8, 'Título del Artículo 8', 'Autor 6', '2023-06-01', 'Chile');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (9, 'Título del Artículo 9', 'Autor 7', '2023-07-01', 'Venezuela');  
INSERT INTO P5P2E3_ARTICULO (id_articulo, titulo, autor, fecha_publicacion, nacionalidad) VALUES (10, 'Título del Artículo 10', 'Autor 8', '2023-08-01', 'Uruguay');

INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('ES', 2, 'Español');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('EN', 3, 'English');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('FR', 4, 'Français');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('DE', 5, 'Deutsch');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('IT', 6, 'Italiano');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('PT', 7, 'Português');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('RU', 8, 'Русский');  
INSERT INTO P5P2E3_PALABRA (idioma, cod_palabra, descripcion) VALUES ('ZH', 9, '中文');

INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (3, 'ES', 2);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (3, 'EN', 3);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (4, 'FR', 4);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (4, 'DE', 5);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (5, 'IT', 6);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (6, 'PT', 7);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (7, 'RU', 8);  
INSERT INTO P5P2E3_CONTIENE (id_articulo, idioma, cod_palabra) VALUES (8, 'ZH', 9);