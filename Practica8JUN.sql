-- Borrar la base de datos

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'EmpresaSQL')
    DROP DATABASE EmpresaSQL;
GO

/* Parte I: Creacion de Tablas */

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

CREATE TABLE TDepartamento(
    nDepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreDepartamento VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TCargo(
    nCargoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreCargo VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TEmpleado(
    nEmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    cNIF VARCHAR(20) UNIQUE,
    cNombre VARCHAR(50),
    cApellido VARCHAR(50),
    nDepartamentoID INT,
    nCargoID INT,
    dFechaContratacion DATE DEFAULT GETDATE(),
    nSalario DECIMAL(10,2) CHECK (nSalario > 300)
);

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TDepartamento
FOREIGN KEY (nDepartamentoID)
REFERENCES TDepartamento(nDepartamentoID);

ALTER TABLE TEmpleado
ADD CONSTRAINT FK_TEmpleado_TCargo
FOREIGN KEY (nCargoID)
REFERENCES TCargo(nCargoID);

CREATE TABLE TProyecto(
    nProyectoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreProyecto VARCHAR(100) NOT NULL,
    dFechaInicio DATE NOT NULL,
    dFechaFin DATE
);

CREATE TABLE TEmpleadoProyecto(
    nEmpleadoID INT,
    nProyectoID INT,
    PRIMARY KEY (nEmpleadoID, nProyectoID),

    FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);

/* Parte II: Uso de los Alters */

ALTER TABLE TEmpleado ADD cEmail VARCHAR(100);
ALTER TABLE TEmpleado ADD cTelefono VARCHAR(15);

ALTER TABLE TEmpleado ALTER COLUMN cNombre VARCHAR(100);
ALTER TABLE TEmpleado ALTER COLUMN cApellido VARCHAR(100);

ALTER TABLE TEmpleado ADD cDireccion VARCHAR(150);

ALTER TABLE TEmpleado ADD nEdad INT;

ALTER TABLE TEmpleado
ADD CONSTRAINT CHK_Edad CHECK (nEdad BETWEEN 18 AND 65);

ALTER TABLE TEmpleado
ADD CONSTRAINT UQ_Email UNIQUE (cEmail);

ALTER TABLE TEmpleado ADD bActivo BIT DEFAULT 1;

ALTER TABLE TEmpleado DROP COLUMN cDireccion;

ALTER TABLE TEmpleado ALTER COLUMN cTelefono VARCHAR(20);

ALTER TABLE TEmpleado ADD cGenero CHAR(1);

ALTER TABLE TEmpleado
ADD CONSTRAINT CHK_Genero CHECK (cGenero IN ('M','F'));

ALTER TABLE TEmpleado ADD dFechaNacimiento DATE;

CREATE TABLE TSucursal(
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal VARCHAR(100),
    cDireccion VARCHAR(150)
);

/* Parte III: Implicacion de los Inserts */

INSERT INTO TDepartamento (cNombreDepartamento) VALUES
('Chinandega'),
('Managua'),
('Matagalpa'),
('Masaya'),
('Leon');

-- Trabajos
INSERT INTO TCargo (cNombreCargo) VALUES
('Gerente'),
('Analista'),
('Desarrollador'),
('Contador'),
('Asistente');

-- Empleados de la empresa
INSERT INTO TEmpleado 
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario)
VALUES
('001','Alfredo','Montealegre',1,1,'2022-01-10',800),
('002','Christopher','Santana',2,2,'2023-02-15',900),
('003','Debora','Solis',3,3,'2021-03-20',1200),
('004','Juan','Romero',4,4,'2020-04-25',700),
('005','Duran','Garcia',5,5,'2022-05-30',650),
('006','Blanca','Zeledon',1,2,'2023-06-10',850),
('007','Pancho','Madrigal',2,3,'2021-07-12',1100),
('008','Bad','Bunny',3,4,'2022-08-18',950),
('009','Leo','Messi',4,5,'2020-09-22',600),
('010','Cristiano','Ronaldo',5,1,'2023-10-05',1300);

INSERT INTO TProyecto (cNombreProyecto, dFechaInicio, dFechaFin) VALUES
('Sistema Web','2023-01-01','2023-06-01'),
('App Movil','2023-02-01','2023-07-01'),
('Base de Datos','2023-03-01','2023-08-01');

-- Relacion empleados-proyectos
INSERT INTO TEmpleadoProyecto VALUES
(1,1),(2,1),(3,2),(4,2),(5,3),(6,1),(7,2),(8,3);

INSERT INTO TEmpleado 
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario)
VALUES ('011','Bigus','Gatonus',1,3,900);

INSERT INTO TEmpleado 
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail)
VALUES ('012','Gabriela','Lacalle',2,4,950,'galcal@gmail.com');

INSERT INTO TEmpleado 
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario)
VALUES ('013','Juanito','Chepesote',3,2,1000);

/* Parte IV: Updates y actualziacion de la base de datos */

-- 41
UPDATE TEmpleado
SET nSalario = nSalario * 1.10;

-- 42
UPDATE TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 1;

-- 43
UPDATE TEmpleado
SET cEmail = 'xXAlfcrack777Xx@email.com'
WHERE nEmpleadoID = 1;

-- 44
UPDATE TEmpleado
SET nCargoID = 2
WHERE nEmpleadoID = 1;

-- 45
UPDATE TEmpleado
SET nDepartamentoID = 3
WHERE nEmpleadoID IN (2,3);

-- 46
UPDATE TEmpleado
SET bActivo = 0
WHERE nSalario < 500;

-- 47
UPDATE TProyecto
SET dFechaFin = '2025-12-31'
WHERE nProyectoID = 1;

-- 48
INSERT INTO TEmpleadoProyecto VALUES (1,2);

/* Parte V: Deletes, todo lo q se debe borrar de la base de datos */

-- 49
DELETE FROM TEmpleado
WHERE cNIF = '001';

-- 50
DELETE FROM TEmpleado
WHERE bActivo = 0;

-- 51
DELETE FROM TProyecto
WHERE nProyectoID = 3;

-- 52
DELETE FROM TEmpleadoProyecto
WHERE nEmpleadoID = 2;

-- 53
DELETE FROM TDepartamento
WHERE nDepartamentoID NOT IN (
    SELECT nDepartamentoID FROM TEmpleado
);