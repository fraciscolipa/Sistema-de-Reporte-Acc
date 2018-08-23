create table hospital(
  id_hospital serial primary key,
  hospital varchar(100),
  direccion varchar(100),
  lat numeric(16,12),
  lng numeric(16,12),
  latlng GEOMETRY(Point, 4326)
);

create table usuario(
  id_usuario serial primary key,
  correo varchar(100),
  nombres varchar(50),
  apellidos varchar(50),
  dni varchar(20),
  direccion varchar(100),
  departamento varchar(100),
  provincia varchar(100),
  distrito varchar(100)
);

create table usuario_telefono(
  id_usuario_telefono serial primary key,
  telefono varchar(20),
  nombres_contacto varchar(50),
  apellidos_contacto varchar(50),
  relacion varchar(50),
  id_usuario integer references usuario(id_usuario)
);

create table contacto_hospital(
  id_contacto_hospital serial primary key,
  telefono varchar(20),
  nombres_contacto varchar(50),
  apellidos_contacto varchar(50),
  cargo varchar(50),
  id_hospital integer references hospital(id_hospital)
);

create table operador(
  id_operador serial primary key,
  correo varchar(100),
  clave varchar(50),
  nombres varchar(50),
  apellidos varchar(50),
  dni varchar(20),
  celular varchar(20),
  activo boolean,
  natenciones integer
);

create table emergencia(
  id_emergencia serial primary key,
  lat numeric(16,12),
  lng numeric(16,12),
  nivel integer,
  fechahora timestamp,
  emergencia_vista boolean,
  observacion text,
  id_usuario integer references usuario(id_usuario),
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
  id_usuario integer references usuario(id_usuario),
  id_operador integer references operador(id_operador)
);

CREATE INDEX hospital_latlng_gis
  ON hospital 
  USING GIST (latlng);

INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital de Mollendo','Av. Mariscal Castilla',-17.019825261701833,-72.0149677991867,ST_GeomFromText('POINT(-17.019825261701833 -72.0149677991867)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Centro de Salud Cocachacra','Av. Libertad',-17.090096122837846,-71.7609116435051,ST_GeomFromText('POINT(-17.090096122837846 -71.7609116435051)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital Goyeneche','Av. Goyeneche',-16.40192829486294,-71.528200507164,ST_GeomFromText('POINT(-16.40192829486294 -71.528200507164)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital General','Av. Alcides Carrión',-16.415637049556295,-71.53294801712036,ST_GeomFromText('POINT(-16.415637049556295 -71.53294801712036)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Clinica Arequipa','Av. Ejercito',-16.392237928192063,-71.53998076915741,ST_GeomFromText('POINT(-16.392237928192063 -71.53998076915741)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital Yanahuara EsSalud','Calle Emmel',-16.396576266680803,-71.54505014419556,ST_GeomFromText('POINT(-16.396576266680803 -71.54505014419556)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital Edmundo Escomel EsSalud','Av Industrial Cayro',-16.417077853555007,-71.50873303413391,ST_GeomFromText('POINT(-16.417077853555007 -71.50873303413391)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Hospital de Apoyo de Camana','Av. Lima',-16.618386529197547,-72.70820617675781,ST_GeomFromText('POINT(-16.618386529197547 -72.70820617675781)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Seguro Social De Salud Corire','AV J.P. Vizcardo Y Guzman 439',-16.21965042355482,-72.47067511081696,ST_GeomFromText('POINT(-16.21965042355482 -72.47067511081696)', 4326));
INSERT INTO hospital(hospital,direccion,lat,lng,latlng) VALUES('Seguro Social De Salud Aplao','AV M.Castilla S/N',-16.072470374990314,-72.49060392379761,ST_GeomFromText('POINT(-16.072470374990314 -72.49060392379761)', 4326));

insert into usuario(correo,nombres,apellidos,dni,direccion,departamento,provincia,distrito) values('usuario@gmail.com','Martin','Fernandez Zamora','12345678','Av. Ejercito 143','Arequioa','Arequipa','Yanahuara');

insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('974545629','Oscar','Valdivia Mamani','Administrativo',1);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('934735485','Mirella','Casapia Carpio','Administrativo',2);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('935485684','Lucia','Sacedo Miranda','Administrativo',3);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('958365994','Orlandini','Fuentes Linares','Administrativo',4);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('976473926','Diego','Torres Cardenas','Administrativo',5);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('913648933','Pablo','Calizaya Mamani','Administrativo',6);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('944458324','Carlos','Velasquez Obando','Administrativo',7);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('964859635','Maria','Mamani Mamani','Administrativo',8);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('998473424','Carmen','Fernandez Rojo','Administrativo',10);
insert into contacto_hospital(telefono,nombres_contacto,apellidos_contacto,cargo,id_hospital) values('946842424','Marleni','Murillo Ballon','Administrativo',9);

insert into usuario_telefono(telefono,nombres_contacto,apellidos_contacto,relacion,id_usuario) values('923673432','Mauricio','Fernandez Zamora','Hermano',1);

insert into operador(correo,clave,nombres,apellidos,dni,celular,activo,natenciones) values('operador@gmail.com',MD5('operador'),'Pablo','Apellido','12345678','986260792','t',0);
