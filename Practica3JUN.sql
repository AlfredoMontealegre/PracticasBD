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
	correo nvarchar(50) not null
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
	correo nvarchar(50) not null,
	salario decimal(10,2) not null,
	id_especialidad int
);
go

-- Tabla citas
create table citas(
	id_cita int identity(1,1) primary key,
	fecha datetime not null,
	id_paciente int,
	id_medico int
);
go

-- Tabla habitaciones
create table habitaciones(
	id_habitacion int identity(1,1) primary key,
	numero int not null,
	id_paciente int
);
go

-- Tabla tratamientos
create table tratamientos(
	id_tratamiento int identity(1,1) primary key,
	descripcion nvarchar(100) not null,
	id_paciente int
);
go

-- Tabla medicamentos
create table medicamentos(
	id_medicamento int identity(1,1) primary key,
	nombre nvarchar(50) not null,
	id_tratamiento int
);
go


