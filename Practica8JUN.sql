
/* DROP de SEGURIDAD */
use master
go

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'EmpresaSQL')
    DROP DATABASE EmpresaSQL;
GO


-- Creacion de base de datos
create database EmpresaSQL
go

use EmpresaSQL
go

/* Parte I: Creacion de Base de Datos y Tablas (DDL) */

-- Creacion de tablas
create table TDepartamento(
	nDepartamentoID int identity(1,1) primary key,
	cNombreDepartamento varchar(50) unique not null,
	created_at 
);
go

create table TCargo(
	nCargoID int identity(1,1) primary key,
	cNombreCargo varchar(50) unique not null
);
go

create table TEmpleado(
	nEmpleado int identity(1,1) primary key,
	cNIF int unique not null,
	cNombre varchar(50) not null,
	cApellido varchar(50) not null,
	nDepartamentoID int,
	nCargoID int,
	dFechaContratacion date not null default getdate(),
	nSalario decimal(10, 2) not null
);
go

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TDepartamento
FOREIGN KEY (nDepartamentoID)
REFERENCES TDepartamento(nDepartamentoID);

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TCargo
FOREIGN KEY (nCargoID)
REFERENCES TCargo(nCargoID);

create table TProyecto (
    nProyectoID int identity (1,1) primary key,
    cNombreProyecto varchar(100) NOT NULL,
    dFechaInicio date NOT NULL,
    dFechaFin date
);
go

create table TEmpleadoProyecto (
    nEmpleadoID int,
    nProyectoID int,
    primary key (nEmpleadoID, nProyectoID),

    foreign key (nEmpleadoID) references TEmpleado(nEmpleadoID),
    foreign key (nProyectoID) references TProyecto(nProyectoID)
);
go

/* Parte II: Modificacion de Estructuras (ALTER) */

/* Parte III: Insercion de Datos (INSERT) */

/* Parte IV: Actualizacion de Datos (UPDATE) */

/* Parte V: Eliminacion de Datos (DELETE) */

/* Parte VI: Consultas de Verificacion */

/* Parte VII: Administracion de Objetos */

/* Desafios Adicionales */

