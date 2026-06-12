/* ============================================================
   SCRIPT FINAL CORREGIDO - EmpresaSQL
   FUNCIÓN: Crear una base de datos completa con tablas,
   relaciones, restricciones, datos, actualizaciones y consultas.
============================================================ */

USE master;
GO

IF DB_ID('EmpresaSQL') IS NOT NULL
BEGIN
    ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmpresaSQL;
END;
GO

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

/* ============================================================
   PARTE I - CREACIÓN DE TABLAS
   FUNCIÓN: CREATE TABLE
   CUMPLE: Crea tablas con PK, FK, UNIQUE, CHECK y DEFAULT.
============================================================ */

CREATE TABLE TDepartamento (
    nDepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreDepartamento VARCHAR(80) NOT NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TDepartamento_Nombre UNIQUE (cNombreDepartamento)
);
GO

CREATE TABLE TCargo (
    nCargoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreCargo VARCHAR(80) NOT NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TCargo_Nombre UNIQUE (cNombreCargo)
);
GO

CREATE TABLE TSucursal (
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal VARCHAR(100) NOT NULL,
    cDireccion VARCHAR(150) NULL,
    cTelefono VARCHAR(20) NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TSucursal_Nombre UNIQUE (cNombreSucursal)
);
GO

CREATE TABLE TEmpleado (
    nEmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    cNIF VARCHAR(20) NOT NULL,
    cNombre VARCHAR(100) NOT NULL,
    cApellido VARCHAR(100) NOT NULL,
    nDepartamentoID INT NOT NULL,
    nCargoID INT NOT NULL,
    nSucursalID INT NULL,
    dFechaContratacion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    nSalario DECIMAL(10,2) NOT NULL,
    cEmail VARCHAR(100) NULL,
    cTelefono VARCHAR(20) NULL,
    nEdad INT NULL,
    cGenero CHAR(1) NULL,
    dFechaNacimiento DATE NULL,
    bActivo BIT NOT NULL DEFAULT 1,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TEmpleado_NIF UNIQUE (cNIF),
    CONSTRAINT CK_TEmpleado_Salario CHECK (nSalario > 300),
    CONSTRAINT CK_TEmpleado_Edad CHECK (nEdad IS NULL OR nEdad BETWEEN 18 AND 65),
    CONSTRAINT CK_TEmpleado_Genero CHECK (cGenero IS NULL OR cGenero IN ('M', 'F')),
    CONSTRAINT FK_TEmpleado_TDepartamento FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamento(nDepartamentoID),
    CONSTRAINT FK_TEmpleado_TCargo FOREIGN KEY (nCargoID) REFERENCES TCargo(nCargoID),
    CONSTRAINT FK_TEmpleado_TSucursal FOREIGN KEY (nSucursalID) REFERENCES TSucursal(nSucursalID)
);
GO

/* FUNCIÓN: Índice único filtrado
   CUMPLE: Evita correos repetidos, pero permite varios NULL. */
CREATE UNIQUE INDEX UQ_TEmpleado_Email
ON TEmpleado(cEmail)
WHERE cEmail IS NOT NULL;
GO

CREATE TABLE TProyecto (
    nProyectoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreProyecto VARCHAR(100) NOT NULL,
    dFechaInicio DATE NOT NULL,
    dFechaFinalizacion DATE NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TProyecto_Nombre UNIQUE (cNombreProyecto),
    CONSTRAINT CK_TProyecto_Fechas CHECK (dFechaFinalizacion IS NULL OR dFechaFinalizacion >= dFechaInicio)
);
GO

CREATE TABLE TEmpleadoProyecto (
    nEmpleadoProyectoID INT IDENTITY(1,1) PRIMARY KEY,
    nEmpleadoID INT NOT NULL,
    nProyectoID INT NOT NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT FK_TEmpleadoProyecto_TEmpleado FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    CONSTRAINT FK_TEmpleadoProyecto_TProyecto FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);
GO

/* FUNCIÓN: Índice único activo
   CUMPLE: Evita duplicar el mismo empleado en el mismo proyecto activo. */
CREATE UNIQUE INDEX UQ_TEmpleadoProyecto_Activo
ON TEmpleadoProyecto(nEmpleadoID, nProyectoID)
WHERE inuse = 1;
GO

CREATE TABLE TCliente (
    nClienteID INT IDENTITY(1,1) PRIMARY KEY,
    cNIF VARCHAR(20) NOT NULL,
    cNombre VARCHAR(100) NOT NULL,
    cApellido VARCHAR(100) NOT NULL,
    cTelefono VARCHAR(20) NULL,
    cEmail VARCHAR(100) NULL,
    cDireccion VARCHAR(150) NULL,
    dFechaRegistro DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    nEdad INT NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT UQ_TCliente_NIF UNIQUE (cNIF),
    CONSTRAINT CK_TCliente_Edad CHECK (nEdad IS NULL OR nEdad >= 18)
);
GO

CREATE UNIQUE INDEX UQ_TCliente_Email
ON TCliente(cEmail)
WHERE cEmail IS NOT NULL;
GO

CREATE TABLE TVenta (
    nVentaID INT IDENTITY(1,1) PRIMARY KEY,
    nClienteID INT NOT NULL,
    nSucursalID INT NOT NULL,
    dFechaVenta DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    nMonto DECIMAL(10,2) NOT NULL,
    cMetodoPago VARCHAR(30) NOT NULL,
    inuse BIT NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    deleted_at DATETIME NULL,
    CONSTRAINT CK_TVenta_Monto CHECK (nMonto > 0),
    CONSTRAINT CK_TVenta_MetodoPago CHECK (cMetodoPago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    CONSTRAINT FK_TVenta_TCliente FOREIGN KEY (nClienteID) REFERENCES TCliente(nClienteID),
    CONSTRAINT FK_TVenta_TSucursal FOREIGN KEY (nSucursalID) REFERENCES TSucursal(nSucursalID)
);
GO

/* ============================================================
   PARTE II - TRIGGERS
   FUNCIÓN: AFTER UPDATE
   CUMPLE: Actualiza updated_at automáticamente al modificar registros.
============================================================ */

CREATE TRIGGER TR_TDepartamento_UpdatedAt ON TDepartamento
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE D SET updated_at = GETDATE()
    FROM TDepartamento D
    INNER JOIN inserted I ON D.nDepartamentoID = I.nDepartamentoID;
END;
GO

CREATE TRIGGER TR_TCargo_UpdatedAt ON TCargo
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE C SET updated_at = GETDATE()
    FROM TCargo C
    INNER JOIN inserted I ON C.nCargoID = I.nCargoID;
END;
GO

CREATE TRIGGER TR_TSucursal_UpdatedAt ON TSucursal
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE S SET updated_at = GETDATE()
    FROM TSucursal S
    INNER JOIN inserted I ON S.nSucursalID = I.nSucursalID;
END;
GO

CREATE TRIGGER TR_TEmpleado_UpdatedAt ON TEmpleado
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE E SET updated_at = GETDATE()
    FROM TEmpleado E
    INNER JOIN inserted I ON E.nEmpleadoID = I.nEmpleadoID;
END;
GO

CREATE TRIGGER TR_TProyecto_UpdatedAt ON TProyecto
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE P SET updated_at = GETDATE()
    FROM TProyecto P
    INNER JOIN inserted I ON P.nProyectoID = I.nProyectoID;
END;
GO

CREATE TRIGGER TR_TEmpleadoProyecto_UpdatedAt ON TEmpleadoProyecto
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE EP SET updated_at = GETDATE()
    FROM TEmpleadoProyecto EP
    INNER JOIN inserted I ON EP.nEmpleadoProyectoID = I.nEmpleadoProyectoID;
END;
GO

CREATE TRIGGER TR_TCliente_UpdatedAt ON TCliente
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE C SET updated_at = GETDATE()
    FROM TCliente C
    INNER JOIN inserted I ON C.nClienteID = I.nClienteID;
END;
GO

CREATE TRIGGER TR_TVenta_UpdatedAt ON TVenta
AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF TRIGGER_NESTLEVEL() > 1 RETURN;
    UPDATE V SET updated_at = GETDATE()
    FROM TVenta V
    INNER JOIN inserted I ON V.nVentaID = I.nVentaID;
END;
GO

/* ============================================================
   PARTE III - ALTER TABLE
   FUNCIÓN: ALTER TABLE
   CUMPLE: Demuestra cómo agregar y eliminar una columna.
============================================================ */

ALTER TABLE TEmpleado ADD cDireccionTemporal VARCHAR(150) NULL;
GO

ALTER TABLE TEmpleado DROP COLUMN cDireccionTemporal;
GO

/* ============================================================
   PARTE IV - INSERT
   FUNCIÓN: INSERT INTO
   CUMPLE: Inserta datos de prueba respetando las claves foráneas.
============================================================ */

INSERT INTO TDepartamento (cNombreDepartamento)
VALUES
('Recursos Humanos'),
('Contabilidad'),
('Ventas'),
('Tecnología'),
('Administración');
GO

INSERT INTO TCargo (cNombreCargo)
VALUES
('Gerente'),
('Contador'),
('Vendedor'),
('Programador'),
('Asistente');
GO

INSERT INTO TSucursal (cNombreSucursal, cDireccion, cTelefono)
VALUES
('Sucursal Central', 'Managua', '22220000'),
('Sucursal León', 'León', '23110000'),
('Sucursal Granada', 'Granada', '25520000');
GO

INSERT INTO TEmpleado
(cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSucursalID, dFechaContratacion, nSalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento)
VALUES
('001-010101-0001A', 'Carlos', 'González', 1, 1, 1, '2024-01-15', 1200, 'carlos.gonzalez@empresa.com', '88881111', 35, 'M', '1989-04-10'),
('001-020202-0002B', 'María', 'López', 2, 2, 1, '2024-02-10', 950, 'maria.lopez@empresa.com', '88882222', 30, 'F', '1994-06-20'),
('001-030303-0003C', 'José', 'García', 3, 3, 2, '2024-03-05', 700, 'jose.garcia@empresa.com', '88883333', 28, 'M', '1996-08-12'),
('001-040404-0004D', 'Ana', 'Martínez', 4, 4, 1, '2024-04-12', 1500, 'ana.martinez@empresa.com', '88884444', 27, 'F', '1997-01-25'),
('001-050505-0005E', 'Luis', 'Pérez', 5, 5, 3, '2024-05-18', 600, 'luis.perez@empresa.com', '88885555', 40, 'M', '1984-03-14'),
('001-060606-0006F', 'Sofía', 'Ramírez', 1, 5, 2, '2024-06-21', 550, 'sofia.ramirez@empresa.com', '88886666', 26, 'F', '1998-09-09'),
('001-070707-0007G', 'Miguel', 'Castro', 2, 2, 3, '2024-07-11', 800, 'miguel.castro@empresa.com', '88887777', 33, 'M', '1991-11-30'),
('001-080808-0008H', 'Laura', 'Gómez', 3, 3, 1, '2024-08-19', 720, 'laura.gomez@empresa.com', '88888888', 29, 'F', '1995-05-18'),
('001-090909-0009I', 'Pedro', 'Herrera', 4, 4, 2, '2024-09-25', 1600, 'pedro.herrera@empresa.com', '88889999', 31, 'M', '1993-12-01'),
('001-101010-0010J', 'Elena', 'Mendoza', 5, 1, 3, '2024-10-30', 1300, 'elena.mendoza@empresa.com', '88880000', 38, 'F', '1986-07-07'),
('001-111111-0011K', 'Mario', 'Ruiz', 1, 5, 1, DEFAULT, 500, 'mario.ruiz@empresa.com', '88771111', 24, 'M', '2000-01-15'),
('001-121212-0012L', 'Karla', 'Navarro', 2, 2, 2, DEFAULT, 900, 'karla.navarro@empresa.com', '88772222', 32, 'F', '1992-10-10');
GO

INSERT INTO TProyecto (cNombreProyecto, dFechaInicio, dFechaFinalizacion)
VALUES
('Sistema de Inventario', '2024-01-01', NULL),
('Página Web Empresarial', '2024-02-01', NULL),
('Aplicación de Ventas', '2024-03-01', NULL);
GO

INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID)
VALUES
(1,1), (2,1), (3,2), (4,2), (5,3),
(6,3), (7,1), (8,2), (9,3), (10,1), (1,3);
GO

INSERT INTO TCliente
(cNIF, cNombre, cApellido, cTelefono, cEmail, cDireccion, nEdad)
VALUES
('C001', 'Andrés', 'Gutiérrez', '88880001', 'andres@correo.com', 'Managua', 28),
('C002', 'Beatriz', 'Rivas', '88880002', 'beatriz@correo.com', 'León', 35),
('C003', 'Camila', 'Flores', '88880003', 'camila@correo.com', 'Granada', 22),
('C004', 'Daniel', 'Morales', '88880004', 'daniel@correo.com', 'Masaya', 41),
('C005', 'Esther', 'Reyes', '88880005', 'esther@correo.com', 'Chinandega', 30),
('C006', 'Fernando', 'Cruz', '88880006', 'fernando@correo.com', 'Managua', 27),
('C007', 'Gabriela', 'Vega', '88880007', 'gabriela@correo.com', 'León', 24),
('C008', 'Héctor', 'Pineda', '88880008', 'hector@correo.com', 'Rivas', 39),
('C009', 'Isabel', 'Molina', '88880009', 'isabel@correo.com', 'Estelí', 33),
('C010', 'Javier', 'Santos', '88880010', 'javier@correo.com', 'Jinotepe', 45),
('C011', 'Karla', 'Duarte', '88880011', 'karla2@correo.com', 'Managua', 25),
('C012', 'Leonardo', 'Campos', '88880012', 'leonardo@correo.com', 'Masaya', 37),
('C013', 'Mónica', 'Aguilar', '88880013', 'monica@correo.com', 'Granada', 29),
('C014', 'Nelson', 'Ortiz', '88880014', 'nelson@correo.com', 'León', 31),
('C015', 'Olga', 'Mejía', '88880015', 'olga@correo.com', 'Managua', 36),
('C016', 'Pablo', 'Romero', '88880016', 'pablo@correo.com', 'Rivas', 42),
('C017', 'Rosa', 'Silva', '88880017', 'rosa@correo.com', 'Estelí', 26),
('C018', 'Samuel', 'Castillo', '88880018', 'samuel@correo.com', 'Boaco', 34),
('C019', 'Teresa', 'Lara', '88880019', 'teresa@correo.com', 'Carazo', 38),
('C020', 'Víctor', 'Núñez', '88880020', 'victor@correo.com', 'Managua', 40);
GO

INSERT INTO TVenta (nClienteID, nSucursalID, dFechaVenta, nMonto, cMetodoPago)
VALUES
(1,1,'2024-01-05',250,'Efectivo'),
(2,1,'2024-01-08',500,'Tarjeta'),
(3,2,'2024-01-10',350,'Transferencia'),
(4,3,'2024-02-02',900,'Efectivo'),
(5,1,'2024-02-05',1200,'Tarjeta'),
(6,2,'2024-02-10',700,'Transferencia'),
(7,3,'2024-03-01',450,'Efectivo'),
(8,1,'2024-03-05',800,'Tarjeta'),
(9,2,'2024-03-10',300,'Efectivo'),
(10,3,'2024-03-15',1500,'Transferencia'),
(11,1,'2024-04-01',600,'Tarjeta'),
(12,2,'2024-04-05',750,'Efectivo'),
(13,3,'2024-04-10',400,'Transferencia'),
(14,1,'2024-04-15',1000,'Tarjeta'),
(15,2,'2024-05-01',850,'Efectivo'),
(16,3,'2024-05-03',1100,'Tarjeta'),
(17,1,'2024-05-08',650,'Transferencia'),
(18,2,'2024-05-12',950,'Efectivo'),
(19,3,'2024-06-01',500,'Tarjeta'),
(20,1,'2024-06-05',1300,'Transferencia');
GO

/* ============================================================
   PARTE V - UPDATE Y BAJA LÓGICA
   FUNCIÓN: UPDATE
   CUMPLE: Modifica datos y marca registros como inactivos sin borrarlos.
============================================================ */

UPDATE TEmpleado
SET nSalario = nSalario * 1.10
WHERE inuse = 1;
GO

UPDATE TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 4
  AND inuse = 1;
GO

UPDATE TEmpleado
SET cEmail = 'carlos.actualizado@empresa.com'
WHERE nEmpleadoID = 1;
GO

UPDATE TEmpleado
SET nCargoID = 1
WHERE nEmpleadoID = 3;
GO

UPDATE TEmpleado
SET nDepartamentoID = 3
WHERE nEmpleadoID IN (6, 7);
GO

UPDATE TProyecto
SET dFechaFinalizacion = '2024-12-15'
WHERE nProyectoID = 1;
GO

UPDATE TVenta
SET nMonto = nMonto * 1.05
WHERE nMonto > 1000;
GO

UPDATE TEmpleado
SET inuse = 0,
    bActivo = 0,
    deleted_at = GETDATE()
WHERE cNIF = '001-121212-0012L';
GO

UPDATE TProyecto
SET inuse = 0,
    deleted_at = GETDATE()
WHERE nProyectoID = 2;
GO

UPDATE TEmpleadoProyecto
SET inuse = 0,
    deleted_at = GETDATE()
WHERE nEmpleadoID = 5;
GO

/* ============================================================
   PARTE VI - CONSULTAS DE VERIFICACIÓN
   FUNCIÓN: SELECT
   CUMPLE: Consulta datos activos, relaciones y totales.
============================================================ */

SELECT nEmpleadoID, cNombre, cApellido, nSalario, cEmail, inuse, created_at, updated_at, deleted_at
FROM TEmpleado
WHERE inuse = 1
ORDER BY cApellido;
GO

SELECT E.cNombre, E.cApellido, D.cNombreDepartamento, C.cNombreCargo, S.cNombreSucursal
FROM TEmpleado E
INNER JOIN TDepartamento D ON E.nDepartamentoID = D.nDepartamentoID
INNER JOIN TCargo C ON E.nCargoID = C.nCargoID
LEFT JOIN TSucursal S ON E.nSucursalID = S.nSucursalID
WHERE E.inuse = 1;
GO

SELECT E.cNombre, E.cApellido, P.cNombreProyecto
FROM TEmpleadoProyecto EP
INNER JOIN TEmpleado E ON EP.nEmpleadoID = E.nEmpleadoID
INNER JOIN TProyecto P ON EP.nProyectoID = P.nProyectoID
WHERE EP.inuse = 1
  AND E.inuse = 1
  AND P.inuse = 1;
GO

SELECT D.cNombreDepartamento, COUNT(E.nEmpleadoID) AS CantidadEmpleados
FROM TDepartamento D
LEFT JOIN TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID AND E.inuse = 1
WHERE D.inuse = 1
GROUP BY D.cNombreDepartamento;
GO

SELECT D.cNombreDepartamento, AVG(E.nSalario) AS SalarioPromedio
FROM TDepartamento D
INNER JOIN TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID
WHERE E.inuse = 1
GROUP BY D.cNombreDepartamento;
GO

SELECT TOP 3 cNombre, cApellido, nSalario
FROM TEmpleado
WHERE inuse = 1
ORDER BY nSalario DESC;
GO

SELECT COUNT(*) AS TotalEmpleadosActivos
FROM TEmpleado
WHERE bActivo = 1
  AND inuse = 1;
GO

SELECT S.cNombreSucursal, SUM(V.nMonto) AS TotalVentas
FROM TVenta V
INNER JOIN TSucursal S ON V.nSucursalID = S.nSucursalID
WHERE V.inuse = 1
GROUP BY S.cNombreSucursal
ORDER BY TotalVentas DESC;
GO

SELECT TOP 5 C.cNombre, C.cApellido, SUM(V.nMonto) AS TotalCompras
FROM TCliente C
INNER JOIN TVenta V ON C.nClienteID = V.nClienteID
WHERE C.inuse = 1
  AND V.inuse = 1
GROUP BY C.cNombre, C.cApellido
ORDER BY TotalCompras DESC;
GO

SELECT MONTH(dFechaVenta) AS Mes, SUM(nMonto) AS TotalVentas
FROM TVenta
WHERE inuse = 1
GROUP BY MONTH(dFechaVenta)
ORDER BY Mes;
GO

/* ============================================================
   PARTE VII - ELIMINACIÓN OPCIONAL
   FUNCIÓN: DROP TABLE / DROP DATABASE
   CUMPLE: Borra objetos si el profesor lo solicita.
============================================================ */

/*
USE EmpresaSQL;
GO

DROP TABLE IF EXISTS TEmpleadoProyecto;
DROP TABLE IF EXISTS TVenta;
DROP TABLE IF EXISTS TProyecto;
DROP TABLE IF EXISTS TEmpleado;
DROP TABLE IF EXISTS TCliente;
DROP TABLE IF EXISTS TSucursal;
DROP TABLE IF EXISTS TCargo;
DROP TABLE IF EXISTS TDepartamento;
GO

USE master;
GO

ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE EmpresaSQL;
GO
*/
