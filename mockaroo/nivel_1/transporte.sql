-- *********************
-- CURSO POSTGRESQL
-- *********************

-- CREAR TABLA PASAJEROS
CREATE TABLE pasajeros(
	id serial,
	nombre character varying(100),
	direccion_residencia character varying,
	fecha_nacimiento date,
	CONSTRAINT pasajero_pkey PRIMARY KEY (id)
)

-- CREAR TABLA TRENES
CREATE TABLE trenes(
	id serial,
	modelo character varying(30),
	capacidad integer,
	CONSTRAINT tren_pkey PRIMARY KEY (id)
)

-- CREAR TABLA ESTACIONES
CREATE TABLE estaciones(
	id serial,
	nombre character varying(30),
	direccion character varying(100),
	CONSTRAINT estacion_pkey PRIMARY KEY (id)
)

-- para saber formato de fecha
select current_date

-- insertar data
INSERT INTO public.pasajeros(
	id, nombre, direccion_residencia, fecha_nacimiento)
	VALUES (1, 'Primer Pasajero', 'Direccion X', '2023-11-15');


-- CREAR TABLA TRAYECTO
CREATE TABLE trayectos(
	id serial,
	trenes_id integer,
	estaciones_id integer,
	CONSTRAINT trayecto_pkey PRIMARY KEY (id),
	-- FOREIGN KEY (trenes_id) REFERENCES estaciones(id),
	-- FOREIGN KEY (estaciones_id) REFERENCES trenes(id),
)

-- AGREGAR COLUMNA NUEVA
ALTER TABLE IF EXISTS public.trayectos
ADD COLUMN nombres character varying;

-- CREAR TABLA VIAJES
CREATE TABLE viajes(
	id serial,
	pasajeros_id integer,
	trayectos_id integer,
	inicio date,
	fin date,
	CONSTRAINT viaje_pkey PRIMARY KEY (id),
	-- FOREIGN KEY (pasajeros_id) REFERENCES pasajeros (id),
	-- FOREIGN KEY (trayectos_id) REFERENCES trayectos (id)
)

-- AGREGANDO LLAVES FORANEAS (pasajeros_id)
ALTER TABLE viaje 
-- agregamos un nombre a la restriccion y a que campo hace referencia
ADD CONSTRAINT viajes_pasajeros_fkey FOREIGN KEY (pasajeros_id)
-- ahora referenciamos el campo de la otra tabla que proviene la referencia
REFERENCES public.pasajeros (id) MATCH SIMPLE
ON UPDATE CASCADE
ON DELETE CASCADE;

-- AGREGANDO LLAVES FORANEAS (trayectos_id)
ALTER TABLE viaje 
ADD CONSTRAINT viajes_trayectos_fkey FOREIGN KEY (trayectos_id)
REFERENCES public.trayectos (id) MATCH SIMPLE
ON UPDATE CASCADE
ON DELETE CASCADE;

-- CREANDO PARTICION
-- NO ES POSIBLE LA CREACION DE PK EN TABLAS PARTICIONADAS
CREATE TABLE public.bitacoras_viajes
(
    id serial,
    viajes_id integer,
    fecha date
) PARTITION BY RANGE (fecha);

-- CREANDO TABLA PARA LA PARTICION
CREATE TABLE bitacoras_viajes201001 PARTITION OF bitacoras_viajes
FOR VALUES FROM ('2010-01-01') TO ('2010-01-31')

-- INSERTANDO EN PARTICION
INSERT INTO public.bitacoras_viajes(
	viajes_id, fecha)
	VALUES (1, '2010-01-01');

-- *******************************
-- TODO DESDE CONSOLA 	
-- *******************************

-- CREAR ROL(se actualizo a llamarse USER)
CREATE ROLE usuario_consulta;

-- LISTAR ROLES
\dg

-- PARA QUE EL ROL PUEDA HACER LOGIN
ALTER ROLE usuario_consulta WITH LOGIN;

-- PARA QUE EL ROL PUEDA SER UN SUPERUSUARIO
ALTER ROLE usuario_consulta WITH SUPERUSER;

-- PARA QUE SE LOGEE EL NUEVO USUARIO, SE NECESITA UNA CONTRASENA
ALTER ROLE usuario_consulta WITH PASSWORD '123456';

-- ELIMINAR EL USUARIO (LO DEBES REALIZAR DESDE EL USUARIO POSTGRESQL)
DROP ROLE usuario_consulta;