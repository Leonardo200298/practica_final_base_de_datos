CREATE OR REPLACE FUNCTION limites_credito(limite_presupuesto integer) 
RETURNS TABLE(cliente  int, limite_credito int)
AS $$
DECLARE
	    var_r record;
BEGIN

  -- Resetear el limite de crédito de todos los clientes
  UPDATE cliente SET limite_credito = 0
  WHERE 1=1;

  FOR var_r IN (
     SELECT id_cliente,
	   SUM(precio * cantidad) total,
       ROUND(SUM(precio * cantidad) * 0.05) limite_credito
	   FROM renglon
	   JOIN factura USING (nro_factura)
	   WHERE estado = 'ENTREGADA'
	   GROUP BY id_cliente
	   ORDER BY total DESC)
  LOOP

    -- actualiza el limite de crédito para el cliente actual
    UPDATE
        cliente
    SET
        limite_credito =
            CASE WHEN limite_presupuesto > var_r.limite_credito
                        THEN var_r.limite_credito
                        ELSE limite_presupuesto
            END
    WHERE
    
    nro_cliente = var_r.id_cliente;
		
    -- retorno los valores en la tabla
	cliente := var_r.id_cliente;
	limite_credito := CASE WHEN limite_presupuesto > var_r.limite_credito
							THEN var_r.limite_credito
                            ELSE limite_presupuesto
					  END;
	
	--  reduce el limite_presupuesto a el limites_credito asignado
    limite_presupuesto := limite_presupuesto - var_r.limite_credito;
    RETURN NEXT;
    
	-- Chequea el limite_presupuesto
    EXIT WHEN limite_presupuesto <= 0;
  END LOOP;
END;
$$ LANGUAGE 'plpgsql';
