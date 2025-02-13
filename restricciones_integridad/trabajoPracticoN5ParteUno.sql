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

---ejercicio 1 inciso b

---borro la primera restriccio  para probar otra 
ALTER TABLE p5p1e1_contiene
DROP CONSTRAINT fk_p5p1e1_contiene_palabra

---nueva restriccion con set null para DELETE y UPDATE
ALTER TABLE p5p1e1_contiene
ADD CONSTRAINT fk_contiene_palabra
FOREIGN KEY (idioma, cod_palabra)
REFERENCES p5p1e1_palabra
ON DELETE SET NULL
ON UPDATE SET NULL

---borrado y editado
DELETE FROM p5p1e1_palabra
WHERE idioma = 'EN' AND cod_palabra = 2

---sentencia aunque tampoco se podria ya que la tabla contiene no puede tener en null esos campos

---ejercicio 2 inciso a trabajo practico 5 parte 1

---b.1
--- se borra ya que no hay proyecto con el mismo id en la tabla trabaja en
delete from tp5_p1_ej2_proyecto where id_proyecto = 3;

---b.2 
--- pasa exactamente lo mismo, nada mas que aca es editar en vez de borrar,
--- no importa si se edita si en la tabla trabaje en no hay ningun proyecto relacionado
update tp5_p1_ej2_proyecto set id_proyecto = 7 where id_proyecto = 3;

---b.3
---Aca en la restriccion de integridad tenemos un accion referencial para borrado en RESTRICT,
---por eso rechaza la consulta
delete from tp5_p1_ej2_proyecto where id_proyecto = 1;

---b.4 
--- Es eliminado con exito su accion referencial para el DELETE es CASACADE
delete from tp5_p1_ej2_empleado where tipo_empleado = 'A' and nro_empleado = 2;

---b.5
---se puede ya que para el UPDATE la accion referencial en restriccion de integridad es CASCADE
update tp5_p1_ej2_trabaja_en set id_proyecto = 3 where id_proyecto =1;

---b.6
---en la tabla auspicio hay restriccion de integridad referencial con una accion referencial
---para hacer UPDATE, si hay algun proyecto en auspicio no se puede modificar
update tp5_p1_ej2_proyecto set id_proyecto = 5 where id_proyecto = 2;


---ejercicio 2 inciso b trabajo practico 5 parte 1
---CONSULTA:

update auspicio set id_proyecto= 66, nro_empleado = 10
where id_proyecto = 22
and tipo_empleado = 'A'
and nro_empleado = 5;

---solucion
---v. no permite en ningún caso la actualización debido a la modalidad de la restricción entre la
---tabla empleado y auspicio.







