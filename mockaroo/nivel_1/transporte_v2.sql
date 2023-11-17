-- INSERTANDO EN TABLA ESTACION
INSERT INTO public.estaciones(
	nombre, direccion)
	VALUES ('Estacion centro', 'St 1#12'
    

-- https://www.mockaroo.com/

-- LISTAR TODOS LOS PASAJEROS HAYAN O NO HAYAN TOMADO UN VIAJE
select * from pasajeros
inner join viajes on pasajeros.id = viajes.pasajeros_id
where pasajeros.id = 11


-- LISTAR PASAJEROS QUE AUN NO HAYAN TOMADO UN VIAJE (SIN VIAJE ASOCIADO)
select * from pasajeros
left join viajes on viajes.pasajeros_id = pasajeros.id
where viajes.id IS NULL

-- LISTAR TRENES QUE AUN NO HAYAN SIDO ASIGANDOS A UN TRAYECTO
SELECT * FROM TRENES
left JOIN TRAYECTOS ON TRAYECTOS.trenes_id = TRENES.id
where trayectos.id is NULL

-- INSERTAR Y QUE RETORNE EL VALOR INSERTADO RECIENTEMENTE
INSERT INTO public.estaciones(
nombre, direccion
)
values ('RET','RETDRI')
returning *;

-- BUSQUEDA RESPETANDO MAYUSCULAS Y MINUSCULAS
SELECT * FROM pasajeros
where nombre LIKE 'P%'

-- BUSQUEDA NO RESPETANDO MAYUSCULAS Y MINUSCULAS
SELECT * FROM pasajeros
where nombre ILIKE 'p%'

-- BUSQUEDA DE REGISTROS CON VALORES NULL
SELECT * FROM pasajeros
where nombre IS NULL

-- BUSQUEDA DE REGISTRO QUE NO SEAN NULL
SELECT * FROM pasajeros
where nombre IS NOT NULL

-- CUANDO EN UN REPORTE TE DICEN QUE ASIGNES UN VALOR A LOS CAMPOS NULL
SELECT id, COALESCE(nombre, '-') as nombres_, direccion_residencia, fecha_nacimiento 
FROM pasajeros

-- PL/SQL (CREACION DE Store Procedure) - CONTEO DE REGISTROS
CREATE FUNCTION importantePL()
	RETURNS void
AS 
$$
DECLARE
	rec record;
	contador integer := 0;
BEGIN
	FOR rec IN SELECT * FROM pasajeros LOOP
	RAISE NOTICE 'Un pasajero se llama %', rec.nombre;
	contador := contador + 1;
	END LOOP;
	RAISE NOTICE 'Conteo es %', contador;
END
$$
LANGUAGE PLPGSQL

-- LLAMADO DE UN Store Procedure
SELECT importantePL()

-- ELIMINAR Store Procedure
DROP function importantePL()


-- ***********************
-- CREACIÓN de Trigger
-- ***********************

-- (1) CREACION DE FUNCION 
CREATE OR REPLACE FUNCTION public.impl()
    RETURNS trigger
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	rec record;
	contador integer := 0;
BEGIN
	FOR rec IN SELECT * FROM pasajeros LOOP
		contador := contador + 1;
	END LOOP;
	-- insertamos en contadores_pasajeros, cada vez que se ejecute esta PL
	INSERT INTO contadores_pasajeros(total, tiempo)
	VALUES (contador, now());
	-- OLD: es lo que estaba antes del cambio
	-- NEW: es el cambio
	return NEW;
END
$BODY$;

/* 
(2) CREACION DE TRIGGER QUE AL ELIMINAR UN REGISTRO EN PASAJEROS, 
    TAMBIEN AGREGE UN REGISTRO DEL TOTAL EN LA TABLA contadores_pasajeros
*/
CREATE TRIGGER mitrigger
AFTER INSERT -- se va ejecutar despues de un INSERT
ON pasajeros -- en la tabla pasajeros
FOR EACH ROW -- para cada una de las filas
EXECUTE PROCEDURE impl() -- ejecutamos el procedimiento impl()

/* 
(3) CREACION DE TRIGGER QUE AL ELIMINAR UN REGISTRO EN PASAJEROS, 
    TAMBIEN AGREGE UN REGISTRO DEL TOTAL EN LA TABLA contadores_pasajeros
*/
CREATE TRIGGER mitrigger
AFTER DELETE -- se va ejecutar despues de un DELETE
ON pasajeros -- en la tabla pasajeros
FOR EACH ROW -- para cada una de las filas
EXECUTE PROCEDURE impl() -- ejecutamos el procedimiento impl()