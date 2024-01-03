USE master
GO

USE Hamburgueseria
Go

SELECT * FROM CAJERO
GO

SELECT * FROM CLIENTE
GO

SELECT * FROM PEDIDO
GO

SELECT * FROM REPARTIDOR
GO

SELECT * FROM TIENDA_HAMBURGUESA
GO

SELECT * FROM TIENDA
GO

SELECT * FROM COCINERO_HAMBURGUESA
GO

SELECT * FROM COCINERO
GO

SELECT * FROM DETALLE_FACTURA
GO

SELECT * FROM FACTURA
GO

SELECT * FROM HAMBURGUESA_INGREDIENTE
GO

SELECT * FROM INGREDIENTE
GO

SELECT * FROM PROVEEDOR
GO

SELECT * FROM HAMBURGUESA
GO

-- COMPROBACION DEL CHECK
INSERT INTO HAMBURGUESA(IdHamburguesa,NomHamburguesa,TamañoHamburguesa) Values('H-11', 'Hamburguesa Doble con Queso', 'Mediana')
INSERT INTO FACTURA(NroFactura,IdCliente,IdCajero,FechaFactura,DescripFactura) Values(10031, 130, 1010, '2023-02-01', 'Factura de compra de Hamburguesa con Jamon')
INSERT INTO DETALLE_FACTURA(NroFactura,IdHamburguesa,CantidadHamburguesaFactura,PrecioUnitHamburguesa) Values(10001, 'H-11', 2, 25)

-- COMPROBACION DEL DEFAULT
INSERT INTO COCINERO_HAMBURGUESA(IdHamburguesa,IdCocinero) Values('H-10', 4)

SELECT *
FROM COCINERO_HAMBURGUESA
WHERE IdCocinero = 4 AND IdHamburguesa = 'H-10';

-- COMPROBACION DEL UNIQUE
INSERT INTO CLIENTE(IdCliente,ApeCliente,NomCliente,EmailCliente,TelCliente,DirCliente) Values(146, 'Gómez', 'María','maria.gonzalez@gmail.com', '555-5678', 'Avenida Central 456')

SELECT *
FROM CLIENTE
WHERE IdCliente = 146;

-- ELIMINA EL DATO DEl CLIENTE NUMERO 128
DELETE FROM PEDIDO
WHERE IdCliente = 128;
DELETE FROM CLIENTE
WHERE IdCliente = 128;
DELETE FROM FACTURA
WHERE IdCliente = 128;

SELECT *
FROM CLIENTE
WHERE IdCliente = 128;

SELECT *
FROM PEDIDO
WHERE IdCliente = 128;

-- ACTUALIZA EL DATO DEl REPARTIDOR NUMERO 15
UPDATE REPARTIDOR
SET ApeRepartidor = 'Flores', NomRepartidor = 'Javier', VehiRepartidor = 'Moto', TelRepartidor = '998-671-945'
WHERE IdRepartidor = 15;

SELECT *
FROM REPARTIDOR
WHERE IdRepartidor = 15;

--1. ¿Cuantos pedidos realizo cada Repartidor?
--Nos muestra los pedidos pero no el repartidor 16
SELECT IdRepartidor, COUNT(*) AS PedidosRealizados
FROM PEDIDO
GROUP BY IdRepartidor;

SELECT Repartidor.IdRepartidor, Repartidor.NomRepartidor, Repartidor.ApeRepartidor, COUNT(Pedido.IdRepartidor) AS PedidosRealizados
FROM Repartidor
LEFT JOIN Pedido ON Repartidor.IdRepartidor = Pedido.IdRepartidor
GROUP BY Repartidor.IdRepartidor, Repartidor.NomRepartidor, Repartidor.ApeRepartidor;

--2. ¿Cuál es el precio total de cada factura?
SELECT NroFactura, SUM(PrecioUnitHamburguesa * CantidadHamburguesaFactura) AS PrecioTotal
FROM DETALLE_FACTURA
GROUP BY NroFactura;

--3. ¿Cuál fue el cliente que realizo mas pedidos?
SELECT TOP 1 CLIENTE.IdCliente, CLIENTE.NomCliente, CLIENTE.ApeCliente, COUNT(*) AS TotalPedidos
FROM PEDIDO
JOIN CLIENTE ON PEDIDO.IdCliente = CLIENTE.IdCliente
GROUP BY CLIENTE.IdCliente, CLIENTE.NomCliente, CLIENTE.ApeCliente
ORDER BY TotalPedidos DESC;

--4. ¿Cuales son los 5 ingredientes que mas se repiten en la receta de las hamburguesas?
SELECT TOP 5 HAMBURGUESA_INGREDIENTE.CodIngrediente, INGREDIENTE.NomIngrediente, COUNT(*) AS TotalRepeticiones
FROM HAMBURGUESA_INGREDIENTE
JOIN INGREDIENTE ON HAMBURGUESA_INGREDIENTE.CodIngrediente = INGREDIENTE.CodIngrediente
GROUP BY HAMBURGUESA_INGREDIENTE.CodIngrediente, INGREDIENTE.NomIngrediente
ORDER BY COUNT(*) DESC;

--5. ¿Cuantas facturas tramito cada cajero?
SELECT CAJERO.IdCajero, CAJERO.NomCajero, CAJERO.ApeCajero, CAJERO.TelCajero, COUNT(FACTURA.NroFactura) AS CantidadFacturas
FROM FACTURA
JOIN CAJERO ON FACTURA.IdCajero = CAJERO.IdCajero
GROUP BY CAJERO.IdCajero, CAJERO.NomCajero, CAJERO.ApeCajero, CAJERO.TelCajero;

--6. ¿Qué clientes viven en la Plaza Mayor?
SELECT IdCliente, ApeCliente, NomCliente, TelCliente, DirCliente
FROM CLIENTE
WHERE DirCliente LIKE '%Plaza Mayor%';

--7.¿Cuántos clientes pagaron el pedido en efectivo?
SELECT COUNT(DISTINCT IdCliente) AS ClientesEnEfectivo
FROM PEDIDO
WHERE MetPagoPedido = 'Efectivo';

--8.¿Qué clientes pagaron con tarjeta?
SELECT DISTINCT CLIENTE.IdCliente, CLIENTE.NomCliente, CLIENTE.ApeCliente
FROM PEDIDO
INNER JOIN CLIENTE ON PEDIDO.IdCliente = CLIENTE.IdCliente
WHERE PEDIDO.MetPagoPedido = 'Tarjeta';

--9.¿Que clientes solicitaron en terminos de entrega 'Entrega urgente' y/o 'Entrega prioritaria'?
SELECT DISTINCT CLIENTE.IdCliente, CLIENTE.NomCliente, CLIENTE.ApeCliente, PEDIDO.TermEntrePedido
FROM PEDIDO
INNER JOIN CLIENTE ON PEDIDO.IdCliente = CLIENTE.IdCliente
WHERE PEDIDO.TermEntrePedido IN ('Entrega urgente', 'Entrega prioritaria');

--10.¿Cuales son las 3 hamburguesas con mayor precio?
SELECT DISTINCT TOP 3 DETALLE_FACTURA.IdHamburguesa, DETALLE_FACTURA.PrecioUnitHamburguesa, HAMBURGUESA.NomHamburguesa
FROM DETALLE_FACTURA
JOIN HAMBURGUESA ON DETALLE_FACTURA.IdHamburguesa = HAMBURGUESA.IdHamburguesa
ORDER BY DETALLE_FACTURA.PrecioUnitHamburguesa DESC;

--11.¿Cual fue la hamburguesa mas solicitada de todas las facturas?
SELECT TOP 1 HAMBURGUESA.NomHamburguesa, DETALLE_FACTURA.CantidadHamburguesaFactura
FROM DETALLE_FACTURA
JOIN HAMBURGUESA ON DETALLE_FACTURA.IdHamburguesa = HAMBURGUESA.IdHamburguesa
ORDER BY DETALLE_FACTURA.CantidadHamburguesaFactura DESC;

--12.¿Cuál es la hamburguesa con mayor valorizacion de cada tienda?
SELECT TIENDA_HAMBURGUESA.CodTienda, HAMBURGUESA.NomHamburguesa, TIENDA_HAMBURGUESA.ValorHamburguesa
FROM (
    SELECT CodTienda, MAX(ValorHamburguesa) AS MaxValor
    FROM TIENDA_HAMBURGUESA
    GROUP BY CodTienda
) MaxValues
JOIN TIENDA_HAMBURGUESA ON MaxValues.CodTienda = TIENDA_HAMBURGUESA.CodTienda AND MaxValues.MaxValor = TIENDA_HAMBURGUESA.ValorHamburguesa
JOIN HAMBURGUESA ON TIENDA_HAMBURGUESA.IdHamburguesa = HAMBURGUESA.IdHamburguesa;

--13.¿Qué cliente tiene mas facturas?
SELECT TOP 1 CLIENTE.IdCliente, CLIENTE.ApeCliente, CLIENTE.NomCliente, COUNT(*) AS TotalFacturas
FROM CLIENTE
INNER JOIN FACTURA ON CLIENTE.IdCliente = FACTURA.IdCliente
GROUP BY CLIENTE.IdCliente, CLIENTE.ApeCliente, CLIENTE.NomCliente
ORDER BY COUNT(*) DESC;

--14.¿Qué ingredientes son importados?
SELECT NomIngrediente
FROM INGREDIENTE
WHERE ProcIngrediente = 'importado';

--15.¿Cuáles son los 2 proveedores que envian mas ingredientes?
SELECT TOP 2 PROVEEDOR.IdProveedor, PROVEEDOR.NomProveedor, PROVEEDOR.ApeProveedor, COUNT(*) AS TotalIngredientesEnviados
FROM INGREDIENTE
JOIN PROVEEDOR ON INGREDIENTE.IdProveedor = PROVEEDOR.IdProveedor
GROUP BY PROVEEDOR.IdProveedor, PROVEEDOR.NomProveedor, PROVEEDOR.ApeProveedor
ORDER BY TotalIngredientesEnviados DESC;

--16.¿Qué hamburguesas utilizan la unidad de medida en gramos?
SELECT DISTINCT HAMBURGUESA_INGREDIENTE.IdHamburguesa, HAMBURGUESA.NomHamburguesa
FROM HAMBURGUESA_INGREDIENTE
JOIN HAMBURGUESA ON HAMBURGUESA_INGREDIENTE.IdHamburguesa = HAMBURGUESA.IdHamburguesa
WHERE HAMBURGUESA_INGREDIENTE.CantidadIngredientes LIKE '%g%';

--17.Consulta sobre el vehiculo de los repartidores
SELECT *
FROM REPARTIDOR
WHERE VehiRepartidor = 'moto';

--18. Consulta del tamaño de las hamburguesas
SELECT *
FROM HAMBURGUESA
WHERE TamañoHamburguesa = 'mediana';

--19. Consulta de los novatos cocineros
SELECT TOP 1 COCINERO.IdCocinero, COCINERO.NomCocinero, COCINERO.ApeCocinero, COUNT(*) AS MayorExperiencia
FROM COCINERO_HAMBURGUESA
INNER JOIN COCINERO ON COCINERO_HAMBURGUESA.IdCocinero = COCINERO.IdCocinero
WHERE COCINERO_HAMBURGUESA.ExperCocinero = 'Experto'
GROUP BY COCINERO.IdCocinero, COCINERO.NomCocinero, COCINERO.ApeCocinero
ORDER BY COUNT(*) DESC;

--20. ¿Que pedidos se realizaron el mes de Enero?
SELECT *
FROM PEDIDO
WHERE MONTH(FechaPedido) = 1;

--21. ¿Que pedidos se realizaron el 18 de Febrero?
SELECT *
FROM PEDIDO
WHERE MONTH(FechaPedido) = 2 AND DAY(FechaPedido) = 18;

--Que cliente realizo menos pedidos?
SELECT TOP 1 IdCliente, COUNT(*) AS TotalPedidos
FROM PEDIDO
GROUP BY IdCliente
ORDER BY TotalPedidos ASC;