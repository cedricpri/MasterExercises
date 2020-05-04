--Ejercicio hecho por Cedric Prieels sobre consultas en SQL

-- Pregunta 1: Mostrar los datos de los pedidos realizados entre octubre y noviembre de 2018
SELECT ped.* FROM Pedidos ped WHERE ped.fechaHoraPedido BETWEEN '2018-10-01 00:00' AND '2018-11-30 00:00';

-- Pregunta 2: Devolver el id, nombre, apellido1, apellido2, fecha de alta y fecha de baja de todos los miembros del personal que no estén de baja, ordenados descendentemente por fecha de alta y ascendentemente por nombre
SELECT per.idpersonal, per.nombre || ' ' || per.apellido1  || ' ' || per.apellido2, per.fechaAlta, per.fechaBaja FROM Personal per WHERE per.fechaBaja IS NULL ORDER BY per.fechaAlta DESC, per.nombre ASC;

--Pregunta 3: Retornar los datos de todos los clientes cuyo nombre comience por G o J y que además tengan observaciones
SELECT cl.* FROM Clientes cl WHERE (cl.nombre LIKE ('G%') OR cl.nombre LIKE ('J%')) AND cl.observaciones IS NOT NULL;

--Pregunta 4: Devolver el id e importe de las pizzas junto con el id y descripción de todos sus ingredientes, siempre que el importe de estas pizzas sea mayor de 3
SELECT piz.idpizza, piz.importeBase, ingpiz.idingrediente, ing.descripcion FROM Pizzas piz INNER JOIN IngredienteDePizza ingpiz ON piz.idpizza = ingpiz.idpizza INNER JOIN Ingredientes ing ON ingpiz.idingrediente = ing.idingrediente WHERE piz.importeBase > 3;

-- Pregunta 5: Mostrar los datos de todas las pizzas que no hayan sido nunca pedidas, ordenados por id ascendentemente
SELECT piz.* FROM Pizzas piz WHERE NOT EXISTS (SELECT * FROM LineasPedidos linped WHERE piz.idpizza = linped.idpizza) ORDER BY piz.idpizza ASC;

-- Pregunta 6: Devolver los datos de las bases, junto con los datos de las pizzas en las que están presentes, incluyendo los datos de las bases que no están en ninguna pizza
SELECT bas.*, piz.* FROM Bases bas LEFT JOIN Pizzas piz ON bas.idbase = piz.idbase;

-- Pregunta 7: Retornar los datos de los pedidos realizados por el cliente con id 1, junto con los datos de sus líneas y de las pizzas pedidas, siempre que el precio unitario en la línea sea menor que el importe base de la pizza
--SELECT ped.*, cl.* FROM Pedidos ped INNER JOIN Clientes cl ON ped.idcliente = cl.idcliente WHERE ped.idcliente = 1;
SELECT ped.*, linped.*, piz.* FROM Pedidos ped INNER JOIN LineasPedidos linped ON ped.idpedido = linped.idpedido INNER JOIN Pizzas piz ON linped.idpizza = piz.idpizza WHERE ped.idcliente = 1 AND linped.precioUnidad < piz.importeBase;

-- Pregunta 8: Mostrar el id y nif de todos los clientes, junto con el número total de pedidos realizados
SELECT cl.idcliente, cl.nif, COUNT(*) numeroPedidos FROM Pedidos ped INNER JOIN Clientes cl ON ped.idcliente = cl.idcliente GROUP BY cl.idcliente HAVING COUNT(*) > 1;

-- Pregunta 9: Sumar 0.5 al importe base de todas las pizzas que contengan el ingrediente con id ‘JAM’
--SELECT piz.idpizza, piz.importeBase, ingpiz.idingrediente, ing.descripcion FROM Pizzas piz INNER JOIN IngredienteDePizza ingpiz ON piz.idpizza = ingpiz.idpizza INNER JOIN Ingredientes ing ON ingpiz.idingrediente = ing.idingrediente WHERE ing.idingrediente IS 'JAM';
UPDATE Pizzas SET importeBase = importeBase + 0.5 WHERE idpizza IN (SELECT piz.idpizza FROM Pizzas piz INNER JOIN IngredienteDePizza ingpiz ON piz.idpizza = ingpiz.idpizza INNER JOIN Ingredientes ing ON ingpiz.idingrediente = ing.idingrediente WHERE ing.idingrediente IS 'JAM');
--SELECT piz.idpizza, piz.importeBase, ingpiz.idingrediente, ing.descripcion FROM Pizzas piz INNER JOIN IngredienteDePizza ingpiz ON piz.idpizza = ingpiz.idpizza INNER JOIN Ingredientes ing ON ingpiz.idingrediente = ing.idingrediente WHERE ing.idingrediente IS 'JAM'; --Se puede usar para comprobar el resultado

-- Pregunta 10: Eliminar las líneas de los pedidos anteriores a 2018
--SELECT ped.idpedido, ped.fechaHoraPedido FROM Pedidos ped INNER JOIN LineasPedidos linped ON ped.idpedido = linped.idpedido WHERE ped.fechaHoraPedido < '2018-01-01 00:00';
DELETE FROM LineasPedidos WHERE idpedido IN (SELECT ped.idpedido FROM Pedidos ped INNER JOIN LineasPedidos linped ON ped.idpedido = linped.idpedido WHERE ped.fechaHoraPedido < '2018-01-01 00:00'); --Necesario para evitar problemas de foreign key constraint

-- Pregunta 11: Realizar una consulta que devuelva el número de pizzas totales pedidas por cada cliente. En la consulta deberán aparecer el id y nif de los clientes, además de su nombre y apellidos concatenados
SELECT COUNT(*) numPizzas, cl.idcliente, cl.nif, cl.nombre || ' ' || cl.apellido1 || ' ' || cl.apellido2 FROM Pedidos ped INNER JOIN Clientes cl ON ped.idcliente = cl.idcliente GROUP BY ped.idcliente;

-- Pregunta 12: Retornar los datos de todos los clientes cuyo nombre de calle comience por G o J. Pista: dado que las calles empiezan siempre con el valor “Calle “, este ha de ser tenido en cuenta para poder coger la primera letra del nombre de la calle. 
SELECT cl.* FROM Clientes cl WHERE cl.calle LIKE 'Calle G%' OR cl.calle LIKE 'Calle J%';