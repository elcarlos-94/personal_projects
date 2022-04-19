-- 1. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre empiece con A.
SELECT employeeNumber, lastName, firstName FROM employees WHERE firstName LIKE "A%";

-- 2. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo apellido termina con on.
SELECT employeeNumber, lastName, firstName FROM employees WHERE lastName LIKE "%on";

-- 3. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre incluye la cadena on.
SELECT employeeNumber, lastName, firstName FROM employees WHERE firstName LIKE "%on%";

-- 4. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyos nombres tienen seis letras e inician con G.
SELECT employeeNumber, lastName, firstName FROM employees WHERE firstName LIKE "G_____";

-- 5. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre no inicia con B.
SELECT employeeNumber, lastName, firstName FROM employees WHERE firstName NOT LIKE 'B%';

-- 6. Dentro de la tabla products, obten el código de producto y nombre de los productos cuyo código incluye la cadena _20.
SELECT productCode, productName FROM products WHERE productCode LIKE "%20%";

-- 7. Dentro de la tabla orderdetails, obten el total de cada orden.
SELECT orderNumber, sum(priceEach*quantityOrdered) AS totalOrder FROM orderdetails GROUP BY orderNumber;

-- 8. Dentro de la tabla orders obten el número de órdenes por año.
SELECT EXTRACT(YEAR FROM orderDate) AS orderYear, count(*) AS totalOrders FROM orders GROUP BY orderYear;

-- 9. Obten el apellido y nombre de los empleados cuya oficina está ubicada en USA.
SELECT firstName, lastName FROM employees WHERE officeCode IN (SELECT officeCode FROM offices WHERE country = 'USA');

-- 10. Obten el número de cliente, número de cheque y cantidad del cliente que ha realizado el pago más alto.
SELECT customerNumber, checkNumber, max(amount) AS maxCustomer FROM payments GROUP BY customerNumber, checkNumber ORDER BY maxCustomer DESC LIMIT 1;

-- 11. Obten el número de cliente, número de cheque y cantidad de aquellos clientes cuyo pago es más alto que el promedio.
SELECT customerNumber, checkNumber, sum(amount) AS totalPayment FROM payments WHERE amount > (SELECT AVG(amount) FROM payments) GROUP BY customerNumber, checkNumber ORDER BY totalPayment desc;

-- 12. Obten el nombre de aquellos clientes que no han hecho ninguna orden.
SELECT customerName FROM customers WHERE customerNumber NOT IN (SELECT customerNumber from orders);

-- 13. Obten el máximo, mínimo y promedio del número de productos en las órdenes de venta.
SELECT max(quantityOrdered) AS maxOrder, min(quantityOrdered) AS minOrder, avg(quantityOrdered) AS avgOrder FROM orderdetails;

-- 14. Dentro de la tabla orders, obten el número de órdenes que hay por cada estado.
SELECT status, count(orderNumber) AS countOrders FROM orders GROUP BY status;