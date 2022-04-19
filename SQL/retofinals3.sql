-- 1. Obtén la cantidad de productos de cada orden.
SELECT * from orders;
SELECT * from products;
SELECT * from orderdetails;
SELECT * from customers;
SELECT * from employees;

SELECT orderNumber AS numeroOrden, quantityOrdered AS cantidad 
FROM orderdetails o
INNER JOIN products p
	ON o.productCode = p.productCode;

-- 2. Obten el número de orden, estado y costo total de cada orden.
SELECT o.orderNumber AS numeroOrden, o.status AS estado, sum(p.amount) AS total
FROM orders o
INNER JOIN  payments p
	ON o.customerNumber = p.customerNumber
GROUP BY numeroOrden;

-- 3. Obten el número de orden, fecha de orden, línea de orden, nombre del producto, cantidad ordenada y precio de cada pieza.
SELECT o.orderNumber AS numeroOrden, 
o.orderDate AS fechaOrden, 
d.orderLineNumber AS lineaOrden, 
p.productName AS nombreProducto, 
d.quantityOrdered AS cantidadOrdenada,
p.buyPrice AS precioPieza
FROM orders o
INNER JOIN orderdetails d
	ON o.orderNumber = d.orderNumber
INNER JOIN products p
	ON d.ProductCode = p.productCode;

-- 4.Obtén el número de orden, nombre del producto, el precio sugerido de fábrica (msrp) y precio de cada pieza.
SELECT d.orderNumber AS numeroOrden,
p.productName AS nombreProducto,
p.MSRP AS precioFabrica,
p.buyPrice AS precioPieza
FROM orderdetails d
INNER JOIN products p
	ON d.productCode = p.productCode;

-- 5. Obtén el número de cliente, nombre de cliente, número de orden y estado de cada orden hecha por cada cliente. ¿De qué nos sirve hacer LEFT JOIN en lugar de JOIN?
SELECT c.customerNumber AS numeroCliente,
c.customerName AS nombreCliente,
o.orderNumber AS numeroOrden,
o.status AS estado
FROM customers c
LEFT JOIN orders o
	ON c.CustomerNumber = o.CustomerNumber;
/* RESPUESTA: Al hacer LEFT JOIN, nos indica qué clientes no han hecho una compra a partir de la union
de los datos que hay de customers y lo que coincida con orders, mostrando valores nulos. Si lo hacemos con
INNER JOIN, mostraria todos los que tienen una coincidencia con el numero de cliente de ambas tablas.*/

-- 6. Obtén los clientes que no tienen una orden asociada.
SELECT c.customerName AS nombreCliente
FROM customers c
LEFT JOIN orders o
	ON c.CustomerNumber = o.CustomerNumber
WHERE orderNumber IS NULL;

-- 7. Obtén el apellido de empleado, nombre de empleado, nombre de cliente, número de cheque y total, es decir, los clientes asociados a cada empleado.
SELECT e.lastName AS apellido,
e.firstName AS nombre,
c.customerName AS nombreCliente,
p.checkNumber AS numeroCheque,
p.amount AS total
FROM employees e
LEFT JOIN customers c
	ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN payments p
	ON c.customerNumber = p.customerNumber;

-- 8. Repite los ejercicios 5 a 7 usando RIGHT JOIN. ¿Representan lo mismo? Explica las diferencias en un comentario. Para poner comentarios usa --.
SELECT c.customerNumber AS numeroCliente,
c.customerName AS nombreCliente,
o.orderNumber AS numeroOrden,
o.status AS estado
FROM customers c
RIGHT JOIN orders o
	ON c.CustomerNumber = o.CustomerNumber;

-- La diferencia es que ya no muestra resultados nulos, solo las ordenes que están asociadas a un numero de cliente. 

SELECT c.customerName AS nombreCliente
FROM customers c
RIGHT JOIN orders o
	ON c.CustomerNumber = o.CustomerNumber
WHERE orderNumber IS NULL;

-- La diferencia es que no existen resultados, ya que no existen datos nulos con el numero de cliente (ya que es llave primaria).

SELECT e.lastName AS apellido,
e.firstName AS nombre,
c.customerName AS nombreCliente,
p.checkNumber AS numeroCheque,
p.amount AS total
FROM employees e
RIGHT JOIN customers c
	ON e.employeeNumber = c.salesRepEmployeeNumber
RIGHT JOIN payments p
	ON c.customerNumber = p.customerNumber;
    
-- La diferencia es que en la otra mostraban los empleados sin cliente, pero con el right join elimina los resultados nulos de aquellos empleados sin cliente. 

-- Escoge 3 consultas de los ejercicios anteriores, crea una vista y escribe una consulta para cada una.

CREATE VIEW carlos_069_view1 AS (
SELECT o.orderNumber AS numeroOrden, o.status AS estado, sum(p.amount) AS total
FROM orders o
INNER JOIN  payments p
	ON o.customerNumber = p.customerNumber
GROUP BY numeroOrden
);

SELECT * FROM carlos_069_view1;

CREATE VIEW carlos_069_view2 AS (
SELECT e.lastName AS apellido,
e.firstName AS nombre,
c.customerName AS nombreCliente,
p.checkNumber AS numeroCheque,
p.amount AS total
FROM employees e
LEFT JOIN customers c
	ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN payments p
	ON c.customerNumber = p.customerNumber
);

SELECT * FROM carlos_069_view2;

CREATE VIEW carlos_069_view3 AS (
SELECT e.lastName AS apellido,
e.firstName AS nombre,
c.customerName AS nombreCliente,
p.checkNumber AS numeroCheque,
p.amount AS total
FROM employees e
RIGHT JOIN customers c
	ON e.employeeNumber = c.salesRepEmployeeNumber
RIGHT JOIN payments p
	ON c.customerNumber = p.customerNumber
);

SELECT * FROM carlos_069_view3;


