USE master
GO

/*DROP DATABASE Hamburgueseria
GO*/

CREATE DATABASE Hamburgueseria
ON PRIMARY
(NAME =  Hamburgueseria_Dat, FILENAME='D:\MisDatos\Hamburgueseria.mdf', 
 SIZE = 5MB, MAXSIZE = 200, FILEGROWTH = 1 )
LOG ON
(NAME = Hamburgueseria_Log, FILENAME ='D:\MisDatos\Hamburgueseria_Log.ldf',
 SIZE = 1MB, MAXSIZE = 200, FILEGROWTH= 1MB)
GO

--DROP TABLE IF EXISTS CLIENTE, CAJERO,PEDIDO,REPARTIDOR,TIENDA_HAMBURGUESA,TIENDA,COCINERO_HAMBURGUESA,COCINERO,DETALLE_FACTURA,FACTURA,HAMBURGUESA_INGREDIENTE,INGREDIENTE,PROVEEDOR,HAMBURGUESA;

USE Hamburgueseria
go

-- CREAR TABLA CLIENTES
CREATE TABLE CLIENTE (
       IdCliente				int			NOT NULL,
       ApeCliente				varchar(30) NOT NULL,
       NomCliente				varchar(30) NOT NULL,
	   EmailCliente				varchar(100) NOT NULL,
	   CONSTRAINT EmailUnico	UNIQUE (EmailCliente),
       TelCliente				varchar(12) NULL,
	   DirCliente				varchar(50) NULL
)
go

ALTER TABLE CLIENTE
       ADD PRIMARY KEY (IdCliente)
go

-- CREAR TABLA CAJERO
CREATE TABLE CAJERO (
       IdCajero				int			NOT NULL,
       ApeCajero            varchar(30) NOT NULL,
       NomCajero            varchar(30) NOT NULL,
       TelCajero            varchar(12) NULL,
	   DirCajero			varchar(50) NULL
)
go

ALTER TABLE CAJERO
       ADD PRIMARY KEY (IdCajero)
go

-- CREAR TABLA PEDIDO
CREATE TABLE PEDIDO (
       CodPedido			int IDENTITY,
	   IdCliente			int NOT NULL,
	   IdRepartidor			int NOT NULL,
	   MetPagoPedido		varchar(20) NOT NULL,
       TipPedido            varchar(30) NOT NULL,
	   CantiHamPedido		int NOT NULL,
	   FechaPedido			datetime NOT NULL,
       TermEntrePedido      varchar(60) NOT NULL,
       TermPagoPedido       varchar(60) NULL
)
go

/*DROP TABLE PEDIDO
GO*/

ALTER TABLE PEDIDO
       ADD PRIMARY KEY (CodPedido)
go

-- CREAR TABLA REPARTIDOR
CREATE TABLE REPARTIDOR (
       IdRepartidor			int NOT NULL,
	   CodTienda			int NOT NULL,
       ApeRepartidor        varchar(30) NOT NULL,
       NomRepartidor        varchar(30) NOT NULL,
	   VehiRepartidor		varchar(30) NULL,
	   TelRepartidor		varchar(12) NOT NULL
)
go

/*DROP TABLE REPARTIDOR
GO*/

ALTER TABLE REPARTIDOR
       ADD PRIMARY KEY (IdRepartidor)
go

--CREAR TABLA TIENDA_HAMBURGUESA
CREATE TABLE TIENDA_HAMBURGUESA (
       CodTienda			int NOT NULL,
	   IdHamburguesa		varchar(6) NOT NULL,
	   ValorHamburguesa		varchar(20) NULL
)
go

ALTER TABLE TIENDA_HAMBURGUESA
      ADD PRIMARY KEY (CodTienda, IdHamburguesa)
go

--CREAR TABLA TIENDA
CREATE TABLE TIENDA (
       CodTienda			int NOT NULL,
	   TelTienda			varchar(12) NULL,
	   DirTienda			varchar(50) NOT NULL
)
go

/*DROP TABLE TIENDA
GO*/

ALTER TABLE TIENDA
       ADD PRIMARY KEY (CodTienda)
go

--CREAR TABLA COCINERO_HAMBURGUESA
CREATE TABLE COCINERO_HAMBURGUESA (
	   IdHamburguesa		varchar(6) NOT NULL,
	   IdCocinero			int NOT NULL,
	   ExperCocinero		varchar(20)
)
go

--CREANDO EL CONSTRAINT DEFAULT
ALTER TABLE COCINERO_HAMBURGUESA 
ADD CONSTRAINT ExperDef 
DEFAULT 'Novato' FOR ExperCocinero
GO

ALTER TABLE COCINERO_HAMBURGUESA
       ADD PRIMARY KEY (IdHamburguesa, IdCocinero)
go

--CREAR TABLA COCINERO
CREATE TABLE COCINERO (
	   IdCocinero			int NOT NULL,
	   NomCocinero			varchar(50) NOT NULL,
	   ApeCocinero			varchar(50) NOT NULL,
	   TelCocinero			varchar(12) NULL,
	   DirCocinero			varchar(50) NULL
)
go

ALTER TABLE COCINERO
       ADD PRIMARY KEY (IdCocinero)
go

--CREAR TABLA DETALLE_FACTURA
CREATE TABLE DETALLE_FACTURA (
		NroFactura						int NOT NULL,
		IdHamburguesa					varchar(6) NOT NULL,
		PrecioUnitHamburguesa			money NOT NULL,
		CantidadHamburguesaFactura		smallint NOT NULL
)
go

ALTER TABLE DETALLE_FACTURA
       ADD PRIMARY KEY (NroFactura, IdHamburguesa)
go

-- CREANDO UNA RESTRICCION DEL PRECIO: CHECK
ALTER TABLE DETALLE_FACTURA 
ADD CONSTRAINT RangoPre
CHECK (PrecioUnitHamburguesa BETWEEN 10 AND 20)
GO

--CREAR TABLA FACTURA
CREATE TABLE FACTURA (
	   NroFactura			int NOT NULL,
	   IdCliente			int NOT NULL,--FK
	   IdCajero				int NOT NULL,--FK
	   FechaFactura			datetime NULL,
	   DescripFactura		varchar(60) NULL
)
go

ALTER TABLE FACTURA
       ADD PRIMARY KEY (NroFactura)
go

--CREAR TABLA HAMBURGUESA_INGREDIENTE
CREATE TABLE HAMBURGUESA_INGREDIENTE (
	   CodIngrediente			int NOT NULL,
	   IdHamburguesa			varchar(6) NOT NULL,
	   CantidadIngredientes		varchar(40) NOT NULL
)
go

ALTER TABLE HAMBURGUESA_INGREDIENTE
       ADD PRIMARY KEY (CodIngrediente, IdHamburguesa)
go

/*DROP TABLE HAMBURGUESA_INGREDIENTE
GO*/

--CREAR TABLA INGREDIENTE
CREATE TABLE INGREDIENTE (
	   CodIngrediente			int NOT NULL,
	   IdProveedor				int NOT NULL,--FK
	   NomIngrediente			varchar(50) NOT NULL,
	   ProcIngrediente			varchar(50) NOT NULL,
	   TiempConIngrediente		varchar(35) NOT NULL
)
go

ALTER TABLE INGREDIENTE
       ADD PRIMARY KEY (CodIngrediente)
go

--CREAR TABLA PROVEEDOR
CREATE TABLE PROVEEDOR (
	   IdProveedor			int NOT NULL,
	   NomProveedor			varchar(30) NOT NULL,
	   ApeProveedor			varchar(30) NOT NULL,
	   TelProveedor			varchar(12) NULL,
	   DirProveedor			varchar(50) NULL
)
go

ALTER TABLE PROVEEDOR
       ADD PRIMARY KEY (IdProveedor)
go

--CREAR TABLA HAMBURGUESA
CREATE TABLE HAMBURGUESA (
	   IdHamburguesa			varchar(6) NOT NULL,
	   NomHamburguesa			varchar(40) NOT NULL,
	   TamañoHamburguesa		varchar(30) NOT NULL
)
go

ALTER TABLE HAMBURGUESA
       ADD PRIMARY KEY (IdHamburguesa)
go

--CREACION DE CLAVES FORANEAS:
--FK 

ALTER TABLE PEDIDO
       ADD FOREIGN KEY (IdRepartidor)
                             REFERENCES REPARTIDOR
go

ALTER TABLE REPARTIDOR
       ADD FOREIGN KEY (CodTienda)
                             REFERENCES TIENDA
go

ALTER TABLE PEDIDO
       ADD FOREIGN KEY (IdCliente)
                             REFERENCES CLIENTE
go

ALTER TABLE TIENDA_HAMBURGUESA
       ADD FOREIGN KEY (CodTienda)
                             REFERENCES TIENDA
go

ALTER TABLE TIENDA_HAMBURGUESA
       ADD FOREIGN KEY (IdHamburguesa)
                             REFERENCES HAMBURGUESA
go

ALTER TABLE COCINERO_HAMBURGUESA
       ADD FOREIGN KEY (IdHamburguesa)
                             REFERENCES HAMBURGUESA
go

ALTER TABLE COCINERO_HAMBURGUESA
       ADD FOREIGN KEY (IdCocinero)
                             REFERENCES COCINERO
go

ALTER TABLE HAMBURGUESA_INGREDIENTE
       ADD FOREIGN KEY (CodIngrediente)
                             REFERENCES INGREDIENTE
go

ALTER TABLE HAMBURGUESA_INGREDIENTE
       ADD FOREIGN KEY (IdHamburguesa)
                             REFERENCES HAMBURGUESA
go

ALTER TABLE DETALLE_FACTURA
       ADD FOREIGN KEY (NroFactura)
                             REFERENCES FACTURA
go

ALTER TABLE DETALLE_FACTURA
       ADD FOREIGN KEY (IdHamburguesa)
                             REFERENCES HAMBURGUESA
go


ALTER TABLE FACTURA
       ADD FOREIGN KEY (IdCliente)
                             REFERENCES CLIENTE
go

ALTER TABLE FACTURA
       ADD FOREIGN KEY (IdCajero)
                             REFERENCES CAJERO
go

ALTER TABLE INGREDIENTE
       ADD FOREIGN KEY (IdProveedor)
                             REFERENCES PROVEEDOR
go