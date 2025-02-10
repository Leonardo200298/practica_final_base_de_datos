--- practico nro 5 parte 1 inciso a

ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT FK_P5P1E1_CONTIENE_PALABRA
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra (idioma, cod_palabra)
ON DELETE CASCADE



