use master
go

-- Eliminacion de Base de datos por si ya existe
if exists (select * from sys.databases where name = 'hospital_db')
	drop database hospital_db
go

create database hospital_db
go

use hospital_db
go

-- Modulo 1, creacion de la base de datos.

-- Tabla pacientes
create table pacientes(
	id_paciente int identity(1,1) primary key,
	nombre_paciente nvarchar(60) not null,
	genero bit not null,
	correo nvarchar(50) not null unique
);
go

-- Tabla especialidades 
create table especialidades(
	id_especialidad int identity(1,1) primary key,
	nombre nvarchar(50) not null
);
go

-- Tabla medicos
create table medicos(
	id_medico int identity(1,1) primary key,
	nombre_medico nvarchar(60) not null,
	correo nvarchar(50) not null unique,
	salario decimal(10,2) not null check (salario > 0), -- No hay q ser mala nota, deben ganar salario.
	id_especialidad int not null
);
go

-- Tabla citas
create table citas(
	id_cita int identity(1,1) primary key,
	fecha datetime not null default getdate(),
	id_paciente int not null,
	id_medico int not null
);
go

-- Tabla habitaciones
create table habitaciones(
	id_habitacion int identity(1,1) primary key,
	numero int not null,
	id_paciente int null
);
go

-- Tabla tratamientos
create table tratamientos(
	id_tratamiento int identity(1,1) primary key,
	descripcion nvarchar(100) not null,
	id_paciente int not null
);
go

-- Tabla medicamentos
create table medicamentos(
	id_medicamento int identity(1,1) primary key,
	nombre nvarchar(50) not null,
	id_tratamiento int not null
);
go

/* El modulo 2 viene como alter para dejar en claro que se hizo, de lo contrario
bien se pueden poner restricciones en el modulo 1 de manera normal
como en la Linea 38 */

-- Modulo 2, restricciones para la base de datos
-- (usando alter tables pq es otro modulo)

alter table pacientes
add constraint ck_pacientes_genero check (genero in (0,1));

alter table medicos
add constraint fk_medicos_especialidades
foreign key (id_especialidad) references especialidades(id_especialidad);

alter table citas
add constraint fk_citas_pacientes
foreign key (id_paciente) references pacientes(id_paciente);

alter table citas
add constraint fk_citas_medicos
foreign key (id_medico) references medicos(id_medico);

alter table tratamientos
add constraint fk_tratamientos_pacientes
foreign key (id_paciente) references pacientes(id_paciente);

alter table medicamentos
add constraint fk_medicamentos_tratamientos
foreign key (id_tratamiento) references tratamientos(id_tratamiento);

alter table habitaciones
add constraint fk_habitaciones_pacientes
foreign key (id_paciente) references pacientes(id_paciente);
go

-- Modulo 3, alter
-- (modificaciones que se hacen cuando las tablas ya se hicieron)

alter table pacientes add telefono nvarchar(15);
alter table pacientes add direccion nvarchar(100);
alter table pacientes add tipo_sangre nvarchar(5);
alter table pacientes add fecha_nacimiento date;

alter table pacientes alter column nombre_paciente nvarchar(100);
alter table pacientes alter column direccion nvarchar(150);

alter table medicos add experiencia int;
alter table medicos add turno nvarchar(20);

alter table citas add estado nvarchar(20);
alter table citas add costo_consulta decimal(10,2);

alter table citas alter column costo_consulta decimal(12,2);

alter table habitaciones add disponibilidad bit;
go

-- Modulo 4, drop
-- (esto borra una columna)

alter table pacientes add observaciones nvarchar(100);
alter table pacientes drop column observaciones;
go

-- Modulo 5, inserciones de datos pa la tabla.

insert into especialidades (nombre) values
('Cardiologia'),
('Pediatria'),
('Neurologia'),
('Dermatologia'),
('Oftalmologia');

-- Los fabulosos y increibles pacientes
insert into pacientes (nombre_paciente, genero, correo) values
('Alfredo',1,'alf@gmail.com'),
('Juanita',0,'jau@gmail.com'),
('Messi',1,'messi@gmail.com'),
('Laura',0,'lau@gmail.com'),
('Ronaldo',1,'cr7@gmail.com'),
('Carlota',0,'carlot@gmail.com'),
('Esper',1,'esund@gmail.com'),
('Ximena',0,'xim@gmail.com'),
('Duran',1,'duran@gmail.com'),
('Kennia',0,'das0@gmail.com'),
('Chorrote',1,'chas@gmail.com'),
('Juanita la Secuela',0,'jau2@gmail.com'),
('MarioBros',1,'mario@gmail.com'),
('Peach',0,'peah@gmail.com'),
('Luigi',1,'mamamia@gmail.com'),
('Daisy',0,'daiy@gmail.com'),
('Leo',1,'nardo@gmail.com'),
('KoKa',0,'kdao@gmail.com'),
('Sir Mozart',1,'amadeus@gmail.com'),
('Juanasitana',0,'jafua@gmail.com');

-- Y los fabulosos doctores
insert into medicos (nombre_medico, correo, salario, id_especialidad) values
('Dr Mario','91iiia1@gmail.com',1200,1),
('Dr Lopez','mads0@gmail.com',1300,2),
('Dr Cuadra','faso9@gmail.com',1400,3),
('Dra Kiloi','19adsi@gmail.com',1500,4),
('Dra Papaya','m9ads9@gmail.com',1600,5),
('Dr Ion','moaf@gmail.com',1700,1),
('Dra Mamatote','gads@gmail.com',1800,2),
('Dr Juan','godju@gmail.com',1900,3),
('Dra Tronchatoro','dras@gmail.com',2000,4),
('Dra Ope','moap@gmail.com',2100,5);

insert into citas (id_paciente, id_medico) values
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10),
(11,1),(12,2),(13,3),(14,4),(15,5);

insert into tratamientos (descripcion, id_paciente) values
('tratamiento1',1),
('tratamiento2',2),
('tratamiento3',3),
('tratamiento4',4),
('tratamiento5',5),
('tratamiento6',6),
('tratamiento7',7),
('tratamiento8',8),
('tratamiento9',9),
('tratamiento10',10);

insert into medicamentos (nombre, id_tratamiento) values
('Paracetamol',1),('Paracetamol Noche',1),
('Virogrip',2),('Virogrip Dia',2),
('Tabsin',3),('Tabsin Noche',3),
('Pepto',4),('Bismol',4),
('Zorritone',5),('Zorriton Dulce',5),
('Kolacola',6),('Te Verde',6),
('Parche',7),('Manzanilla',7),
('Cerebrofos',8),('Super Cerebrofos',8),
('Vitaflenaco',9),('AdioDolor',9),
('Curacura',10),('Nutricon',10);

insert into habitaciones (numero, id_paciente, disponibilidad) values
(101,1,0),
(102,2,0),
(103,3,0),
(104,4,0),
(105,5,0),
(106,null,1),
(107,null,1),
(108,null,1),
(109,null,1),
(110,null,1);

-- Luego de las insercciones de los datos vamos a insertar lo datos q ya tenemos

-- Inserccion de pacientes en todos los campos:

-- Pacientes en todos los campos medicos anteriores.
insert into pacientes 
(nombre_paciente, genero, correo, telefono, direccion, tipo_sangre, fecha_nacimiento)
values
('Debora Solis',1,'debsol@gmail.com','4199121','Managua','O+','2000-01-01'),
('Juan Roman',0,'juanroam@gmail.com','69311952','Leon','A+','1998-05-10');

-- Medicos Especialistas (agregamos)
insert into medicos (nombre_medico, correo, salario, id_especialidad, experiencia, turno)
values
('Dr Especialista Cacao 1','espcaco@gmail.com',2500,1,10,'mañana'),
('Dra Especialista Quesillo 2','espques@gmail.com',2600,2,8,'tarde');

--	Citas con la fecha actual (getdate())
insert into citas (id_paciente, id_medico, fecha, estado, costo_consulta)
values
(1,1,getdate(),'realizada',500),
(2,2,getdate(),'realizada',600);

-- Citas para el Futuro
insert into citas (id_paciente, id_medico, fecha, estado, costo_consulta)
values
(3,3,dateadd(day,5,getdate()),'pendiente',700),
(4,4,dateadd(day,10,getdate()),'pendiente',800);

-- Habitaciones Ocupadas (disponib es 0)
insert into habitaciones (numero, id_paciente, disponibilidad)
values
(201,1,0),
(202,2,0);

-- Habitaciones Disponibles (dispon es 1)
insert into habitaciones (numero, id_paciente, disponibilidad)
values
(203,null,1),
(204,null,1);

-- Tratamientos Activos
insert into tratamientos (descripcion, id_paciente)
values
('tratamiento activo',3),
('tratamiento activo',4);

-- Los Tratamientos Finalizados
insert into tratamientos (descripcion, id_paciente)
values
('tratamiento finalizado',5),
('tratamiento finalizado',6);

/* Modulo VI: Update de los modulos medicos anteriores */

-- Actualizacion del telefono de un paciente
