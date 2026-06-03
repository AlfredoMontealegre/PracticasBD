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
	salario decimal(10,2) not null check (salario > 0),
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

