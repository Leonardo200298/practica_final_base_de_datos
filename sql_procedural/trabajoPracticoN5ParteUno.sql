--- practico nro 5 parte 1 inciso a

ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra (idioma, cod_palabra)
ON DELETE CASCADE


---inserts de la tabla contiene 
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (1, 'ES', 1)
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (2, 'ES', 1)
INSERT INTO p5p1e1_contiene (id_articulo, idioma, cod_palabra)
VALUES (1, 'ES', 2)

--- faltan los de la tabla palabra y articulo 

