---Ejercicio nro 1 practico nro 6 parte 1

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
   ---probable uso de GROUP BY
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

INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (3, 'Título del Artículo 3', 'Autor 1');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (4, 'Título del Artículo 4', 'Autor 2');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (5, 'Título del Artículo 5', 'Autor 3');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (6, 'Título del Artículo 6', 'Autor 4');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (7, 'Título del Artículo 7', 'Autor 5');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (8, 'Título del Artículo 8', 'Autor 6');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (9, 'Título del Artículo 9', 'Autor 7');  
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (10, 'Título del Artículo 10', 'Autor 8'); 
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor) VALUES (11, 'Título del Artículo 11', 'Autor 9'); 

INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('ES', 2, 'Español');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('EN', 3, 'English');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('FR', 4, 'Français');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('DE', 5, 'Deutsch');  
INSERT INTO p5p1e1_palabra(idioma, cod_palabra, descripcion) VALUES ('IT', 6, 'Italiano');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('PT', 7, 'Português');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('RU', 8, 'Русский');  
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('ZH', 9, '中文');
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('GE', 10, 'Gerengoso');
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion) VALUES ('GU', 11, 'Ñamenbu');

INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (3, 'ES', 2);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (3, 'EN', 3);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (4, 'FR', 4);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (4, 'DE', 5);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (5, 'IT', 6);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (6, 'PT', 7);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (7, 'RU', 8);  
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (8, 'ZH', 9);
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (10, 'GE', 10);
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra) VALUES (3, 'GU', 11);

---D. Sólo los autores argentinos pueden publicar artículos que contengan más de 10 palabras
---claves, pero con un tope de 15 palabras, el resto de los autores sólo pueden publicar
---artículos que contengan hasta 10 palabras claves.

---declarativa
CREATE ASSERTION CK_CANTIDAD_PALABRAS
   CHECK (NOT EXISTS (
            SELECT id_articulo
            FROM p5p2e3_articulo
            WHERE (nacionalidad LIKE 'ARG' AND
                  id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 5) ) OR
                  (nacionalidad NOT LIKE 'ARG' AND
                    id_articulo IN (SELECT id_articulo
                                  FROM p5p2e3_contiene
                                  GROUP BY id_articulo
                                    HAVING COUNT(*) > 3) )));


CREATE OR REPLACE FUNCTION FN_CONTROL_DE_ARTICULOS_NACIONALES_Y_NO_NACIONALES() 
RETURNS TRIGGER AS $$
DECLARE 
   cantArticulos INTEGER;
   tipoNacionalidad p5p1e1_articulo.nacionalidad%TYPE;

BEGIN
   SELECT COUNT(*) INTO cantArticulos
   FROM p5p1e1_articulo
   WHERE id_articulo = NEW.id_articulo;

   SELECT nacionalidad INTO tipoNacionalidad
   FROM p5p1e1_articulo
   WHERE id_articulo = NEW.id_articulo;   

   IF ((cantArticulos > 10 AND tipoNacionalidad = 'ARG') OR (cantArticulos > 15 AND tipoNacionalidad != 'ARG')) THEN
      RAISE EXCEPTION 'De 10 a 15 palabaras para autores argentinos y mas de 15 autores distintos a los argentinos'
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TR_MAXIMO_PALABRAS_X_NACIONAL_O_NO_NACIONAL_CONTIENE
BEFORE INSERT OR UPDATE
ON p5p1e1_contiene
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_DE_ARTICULOS_NACIONALES_Y_NO_NACIONALES();

CREATE OR REPLACE FUNCTION FN_CONTROL_NACIONALIDAD_PARA_ARTICULO()
RETURNS TRIGGER AS $$
DECLARE 
   cantArticulos INTEGER;
   tipoNacionalidad := NEW.nacionalidad%TYPE;
BEGIN
   SELECT COUNT(*) INTO cantArticulos
   FROM p5p1e1_articulo
   WHERE id_articulo = NEW.id_articulo;

   IF ((cantArticulos > 10 AND tipoNacionalidad = 'ARG') OR (cantArticulos > 15 AND tipoNacionalidad != 'ARG')) THEN
      RAISE EXCEPTION 'De 10 a 15 palabaras para autores argentinos y mas de 15 autores distintos a los argentinos'
   END IF;
   RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_CONTROL_NACIONALIDAD_CANT_ARTICULOS_TL_ART
BEFORE UPDATE 
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_NACIONALIDAD_PARA_ARTICULO();

---Ejercicio nro 2 practico nro 6 parte 1

--- B. Cada imagen no debe tener más de 5 procesamientos.

CREATE OR REPLACE FUNCTION FN_CONTROL_DE_IMAGEN_POR_PROCESAMIENTO()
RETURNS TRIGGER AS $$
DECLARE
   cant INTEGER;
BEGIN
   SELECT COUNT(*) INTO cant
   FROM p5p2e4_procesamiento
   WHERE id_paciente = NEW.id_paciente AND id_imagen = NEW.id_imagen;

   IF (cant > 5) THEN
      RAISE EXCEPTION 'solo se pueden 5 imagenes por procesamiento';
   END IF;
   RETURN NEW;
END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_IMAGEN_POR_PROCESAMIENTO_PROC
BEFORE INSERT OR UPDATE
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_DE_IMAGEN_POR_PROCESAMIENTO();

---D. Cada paciente sólo puede realizar dos FLUOROSCOPIA anuales.
CREATE OR REPLACE FUNCTION FN_CONTROL_DE_ESTUDIO_DOS_X_ANIO()
RETURNS TRIGGER AS $$
DECLARE
   cantFluo INTEGER;
BEGIN
   SELECT COUNT(*) INTO cantFluo
   FROM p5p2e4_imagen_medica
   WHERE modalidad = 'FLUOROSCOPIA' AND id_paciente = NEW.id_paciente AND id_imagen = NEW.id_imagen
   GROUP BY id_paciente, extract(year from fecha_img)
   HAVING COUNT(*) > 2 

   IF (cantFluo > 2) THEN
      RAISE EXCEPTION 'supero el numero de fluoroscopias por año'
   END IF;
   RETURN NEW; 


END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_fluorosocopia_cant
BEFORE INSERT OR UPDATE OF id_paciente, id_imagen, modalidad ON p5p2e4_imagen_medica
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_DE_ESTUDIO_DOS_X_ANIO();


---E. No se pueden aplicar algoritmos de costo computacional “O(n)” a imágenes de FLUOROSCOPIA
CREATE OR REPLACE FUNCTION FN_CONTROL_PROCESAMIENTO()
RETURNS TRIGGER AS $$
DECLARE 
   c_computacional p5p2e4_procesamiento.costo_computacional%TYPE;
   modalidad p5p2e4_imagen_medica.modalidad%TYPE;
BEGIN
   SELECT costo_computacional INTO c_computacional
   FROM p5p2e4_algoritmo
   WHERE id_algoritmo = NEW.id_algoritmo

   SELECT modalidad INTO modalidad
   FROM p5p2e4_imagen_medica
   WHERE id_paciente = NEW.id_paciente AND id_imagen = NEW.id_imagen

   IF (modalidad = 'FLUOROSCOPIA' AND costo_computacional = 'O(n)') THEN
      RAISE EXCEPTION 'No se puede';
   END IF;
   RETURN NEW;
END;

$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_PROCESAMIENTO
BEFORE INSERT OR UPDATE OF id_paciente, id_imagen, id_algoritmo
ON p5p2e4_procesamiento
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_PROCESAMIENTO();

CREATE OR REPLACE FUNCTION FN_CONTROL_IMAGEN_MEDICA()
RETURNS TRIGGER AS $$
DECLARE 
   cost_computacional p5p2e4_algoritmo.costo_computacional%TYPE;
BEGIN
   SELECT cost_computacional INTO costo_computacional
   FROM p5p2e4_algoritmo
   INNER JOIN p5p2e4_procesamiento
   USING(id_algoritmo)
   WHERE id_paciente = NEW.id_paciente AND id_imagen = NEW.id_imagen;

   IF (cost_computacional = 'O(n)' AND NEW.modalidad = 'FLUOROSCOPIA') THEN
      RAISE EXCEPTION 'No se puede';
   END IF;
   RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER_IMAGEN_MEDICA
BEFORE UPDATE OF id_paciente, id_imagen, modalidad
ON p5p2e4_imagen_medica
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_IMAGEN_MEDICA();

CREATE OR REPLACE FUNCTION FN_CONTROL_ALGORITMO()
RETURNS TRIGGER AS $$
DECLARE  
   mod p5p2e4_imagen_medica.modalidad%TYPE;

BEGIN
   SELECT modalidad INTO mod
   FROM p5p2e4_imagen_medica
   INNER JOIN p5p2e4_procesamiento 
   USING(id_paciente,id_imagen)
   WHERE id_algoritmo = NEW.id_algoritmo;

   IF (mod = 'FLUOROSCOPIA' AND NEW.costo_computacional = 'O(n)') THEN
      RAISE EXCEPTION 'No se puede';
   IF END;
   RETURN NEW;

END;

$$
LANGUAGE plpgsql

CREATE TRIGGER TR_ALGORITMO
BEFORE UPDATE OF id_algoritmo, costo_computacional
ON p5p2e4_algoritmo
FOR EACH ROW
EXECUTE PROCEDURE FN_CONTROL_ALGORITMO();







