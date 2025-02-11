--- practico nro 5 parte 1 inciso a

ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra (idioma, cod_palabra)
ON DELETE CASCADE


---inserts de la tabla contiene 
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (1, 'ES', 1);
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (2, 'EN', 2);


--- inserts tabla palabra 
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion)
VALUES ('ES', 1, 'asdadsad');
INSERT INTO p5p1e1_palabra (idioma, cod_palabra, descripcion)
VALUES ('EN', 2, 'asdadsadsdasd'); 


---inserts tabla articulo
INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor)
VALUES (1, 'Las maravillas del doctor Calgary', 'Charles Bukowski');

INSERT INTO p5p1e1_articulo (id_articulo, titulo, autor)
VALUES (2, 'Los terneros y el yogurt greco romano', 'Samid Baradeg');


---segunda restriccion (esta mal, no era necesaria)
ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT fk_contiene_articulo
FOREIGN KEY (id_articulo)
REFERENCES p5p1e1_articulo (id_articulo)
ON DELETE CASCADE;

---eliminacion de una palabra
DELETE FROM p5p1e1_palabra
WHERE idioma = 'ES' AND cod_palabra = 1