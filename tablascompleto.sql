create table pais(
  id_pais serial primary key,
  pais varchar(50),
  codigo_pais varchar(5),
  abreviatura varchar(4)
);

create table hospital(
  id_hospital serial primary key,
  hospital varchar(100),
  direccion varchar(100),
  lat numeric(16,12),
  lng numeric(16,12),
  latlng GEOMETRY(Point, 4326),
  id_pais integer references pais(id_pais)
);

create table usuario(
  id_usuario serial primary key,
  correo varchar(100),
  clave varchar(50),
  nombres varchar(50),
  apellidos varchar(50),
  dni varchar(20),
  direccion varchar(100),
  id_pais integer references pais(id_pais)
);
########################################
create table tipotelefono(
  id_tipotelefono serial primary key,
  tipotelefono varchar(10)
);
#########################################
create table cargo(
  id_cargo serial primary key,
  cargo varchar(20)
);

create table hospital_tipotelefono(
  numero varchar(20),
  nombres_contacto varchar(50),
  apellidos_contacto varchar(50),
  id_hospital integer references hospital(id_hospital),
  id_tipotelefono integer references tipotelefono(id_tipotelefono),
  id_cargo integer references cargo(id_cargo)
);
############################################
create table relacionfamiliar(
  id_relacionfamiliar serial primary key,
  relacionfamiliar varchar(20)
);

create table usuario_tipotelefono(
  numero varchar(20),
  nombres_contacto varchar(50),
  apellidos_contacto varchar(50),
  id_usuario integer references usuario(id_usuario),
  id_tipotelefono integer references tipotelefono(id_tipotelefono),
  id_relacionfamiliar integer references relacionfamiliar(id_relacionfamiliar)
);
############################################
create table marca(
  id_marca serial primary key,
  marca varchar(100)
);

create table auto(
  id_auto serial primary key,
  placa varchar(30),
  activo boolean,
  fechapago timestamp,
  id_marca integer references marca(id_marca),
  id_usuario integer references usuario(id_usuario),
  id_pais integer references pais(id_pais)
);

create table pago(
  id_pago serial primary key,
  fechahora timestamp,
  monto decimal(6,2),
  id_auto integer references auto(id_auto)
);
##################################################
create table operador(
  id_operador serial primary key,
  correo varchar(100),
  clave varchar(50),
  nombres varchar(50),
  apellidos varchar(50),
  dni varchar(20),
  celular varchar(20),
  activo boolean,
  natenciones integer,
  id_pais integer references pais(id_pais)
);

create table emergencia(
  id_emergencia serial primary key,
  lat numeric(16,12),
  lng numeric(16,12),
  nivel integer,
  fechahora timestamp,
  emergencia_vista boolean,
  emergencia_sms boolean,
  observacion text,
  id_auto integer references auto(id_auto),
  id_operador integer references operador(id_operador),
  id_hospital integer references hospital(id_hospital)
);


create table historial(
  id_historial serial primary key,
  lat numeric(16,12),
  lng numeric(16,12),
  nivel integer,
  fechahora timestamp,
  fechacompletado timestamp,
  observacion text,
  id_auto integer,
  id_operador integer,
  id_hospital integer
);
###############################
CREATE INDEX hospital_latlng_gis
  ON hospital 
  USING GIST (latlng);

insert into pais(pais,codigo_pais,abreviatura) values('Peru','+51','PE');

INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital de Mollendo','Av. Mariscal Castilla',-17.019825261701833,-72.0149677991867,ST_GeomFromText('POINT(-17.019825261701833 -72.0149677991867)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Centro de Salud Cocachacra','Av. Libertad',-17.090096122837846,-71.7609116435051,ST_GeomFromText('POINT(-17.090096122837846 -71.7609116435051)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital Goyeneche','Av. Goyeneche',-16.40192829486294,-71.528200507164,ST_GeomFromText('POINT(-16.40192829486294 -71.528200507164)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital General','Av. Alcides Carrión',-16.415637049556295,-71.53294801712036,ST_GeomFromText('POINT(-16.415637049556295 -71.53294801712036)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Clinica Arequipa','Av. Ejercito',-16.392237928192063,-71.53998076915741,ST_GeomFromText('POINT(-16.392237928192063 -71.53998076915741)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital Yanahuara EsSalud','Calle Emmel',-16.396576266680803,-71.54505014419556,ST_GeomFromText('POINT(-16.396576266680803 -71.54505014419556)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital Edmundo Escomel EsSalud','Av Industrial Cayro',-16.417077853555007,-71.50873303413391,ST_GeomFromText('POINT(-16.417077853555007 -71.50873303413391)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Hospital de Apoyo de Camana','Av. Lima',-16.618386529197547,-72.70820617675781,ST_GeomFromText('POINT(-16.618386529197547 -72.70820617675781)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Seguro Social De Salud Corire','AV J.P. Vizcardo Y Guzman 439',-16.21965042355482,-72.47067511081696,ST_GeomFromText('POINT(-16.21965042355482 -72.47067511081696)', 4326),1);
INSERT INTO hospital(hospital,direccion,lat,lng,latlng,id_pais) VALUES('Seguro Social De Salud Aplao','AV M.Castilla S/N',-16.072470374990314,-72.49060392379761,ST_GeomFromText('POINT(-16.072470374990314 -72.49060392379761)', 4326),1);

insert into usuario(correo,clave,nombres,apellidos,dni,direccion,id_pais) values('usuario@gmail.com',MD5('usuario'),'Martin','Fernandez Zamora','12345678','Av. Ejercito 143',1);

insert into cargo(cargo) values('Médico');
insert into cargo(cargo) values('Administrativo');
insert into cargo(cargo) values('Director');
insert into cargo(cargo) values('Enfermero');

insert into relacionfamiliar(relacionfamiliar) values('Propio');
insert into relacionfamiliar(relacionfamiliar) values('Cónyugue');
insert into relacionfamiliar(relacionfamiliar) values('Padre');
insert into relacionfamiliar(relacionfamiliar) values('Madre');
insert into relacionfamiliar(relacionfamiliar) values('Hijo');
insert into relacionfamiliar(relacionfamiliar) values('Hija');
insert into relacionfamiliar(relacionfamiliar) values('Hermano');
insert into relacionfamiliar(relacionfamiliar) values('Hermana');

insert into tipotelefono(tipotelefono) values('Trabajo');
insert into tipotelefono(tipotelefono) values('Casa');
insert into tipotelefono(tipotelefono) values('Movil');

insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54532081','Oscar','Valdivia Mamani',1,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54552074','Mirella','Casapia Carpio',2,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54202467','Lucia','Sacedo Miranda',3,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54232192','Orlandini','Fuentes Linares',4,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54579401','Diego','Torres Cardenas',5,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54270089','Pablo','Calizaya Mamani',6,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54460712','Carlos','Velasquez Obando',7,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54571604','Maria','Mamani Mamani',8,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54471174','Marleni','Murillo Ballon',9,1,2);
insert into hospital_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_hospital,id_tipotelefono,id_cargo) values('54472151','Carmen','Fernandez Rojo',10,1,2);

insert into usuario_tipotelefono(numero,nombres_contacto,apellidos_contacto,id_usuario,id_tipotelefono,id_relacionfamiliar) values('123456789','Mauricio','Fernandez Zamora',1,3,7);

insert into marca(marca) values('Hyundai');

insert into auto(placa,activo,fechapago,id_marca,id_usuario,id_pais) values('BDA-12',TRUE,'2020-10-1',1,1,1);

insert into operador(correo,clave,nombres,apellidos,dni,celular,activo,natenciones,id_pais) values('operador@gmail.com',MD5('operador'),'Jaison','Torres Chana','12345678','986260792','t',0,1);
