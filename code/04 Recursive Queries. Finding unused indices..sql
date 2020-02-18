DATABASE tutorial;

SELECT CustomerName, StoreId
FROM Customer, SalesTransaction;

SELECT c.CustomerName, s.StoreId
FROM Customer c
JOIN SalesTransaction s
ON c.CustomerId = s.customerid;

-- Recoger estadisticas (se genera en tablas de sistema)
COLLECT STATISTICS
ON tutorial.salestransaction COLUMN(customerid);

HELP STATISTICS tutorial.salestransaction;
SHOW STATISTICS ON tutorial.salestransaction;


DIAGNOSTIC HELPSTATS ON FOR SESSION;

SELECT Sum(noofitems)
FROM tutorial.salestransaction sales
LEFT JOIN tutorial.soldvia sold
ON sales.tid = sold.tid;

COLLECT STATISTICS
USING SYSTEM SAMPLE
COLUMN productprice
ON tutorial.Product;

SHOW STATS ON tutorial.Product

-- Ver el resumen de estadisticas
SHOW SUMMARY STATS VALUES ON tutorial.Product

-- Buscar los JOIN indices
SELECT *
FROM dbc.indices 
WHERE indextype = 'J'
AND databasename LIKE 'tutorial%'

-- Frequencias de uso de un objeto
SELECT * 
FROM dbc.dbqlobjtbl
WHERE objecttablename = 'salestransaction'

-- EJERCICIO: Unir estas dos para encontrar indices que no se usan.

SELECT * FROM sys_calendar.CALENDAR;

-- RECURSIVE QUERIES
CREATE VOLATILE TABLE flights (
origin CHAR(3) NOT NULL,
destination CHAR(3) NOT NULL, cost INT)
ON COMMIT PRESERVE ROWS;

INSERT INTO flights VALUES ('CDMX', 'MLM', 300);
INSERT INTO flights VALUES ('CDMX', 'MTY', 100);
INSERT INTO flights VALUES ('CDMX', 'TIJ', 275);
INSERT INTO flights VALUES ('TIJ', 'NY', 180);
INSERT INTO flights VALUES ('NY', 'YYZ', 250);
INSERT INTO flights VALUES ('MLM', 'CUN', 140);

SELECT * FROM flights

-- 0 escalas
SELECT *
FROM flights 
WHERE origin = 'CDM';

-- 1 escala
SELECT o.origin, d.origin AS escala, d.destination, o.cost + d.cost AS total_cost
FROM flights o
JOIN flights d
ON d.origin = o.destination
WHERE o.origin = 'CDM';

-- 2 escalas
WITH one_stop AS (
	SELECT o.origin, d.origin AS escala, d.destination, o.cost + d.cost AS total_cost
	FROM flights o
	JOIN flights d
	ON d.origin = o.destination
	)
	SELECT o.origin, o.escala AS primera_escala, d.origin AS segunda_escala, d.destination, o.total_cost + d.cost AS total_cost
	FROM one_stop o
	JOIN flights d
	ON d.origin = o.destination
	WHERE o.origin = 'CDM'
	;

WITH one_stop AS (
	SELECT o.origin, d.origin AS escala, d.destination, o.cost + d.cost AS total_cost
	FROM flights o
	JOIN flights d
	ON d.origin = o.destination
	)
	SELECT * FROM one_stop
	
-- 	Query recursiva
WITH RECURSIVE All_Trips
(Origin,
Destination,
Cost,
Depth) AS
(
SELECT Origin, Destination, Cost, 0
FROM Flights
WHERE origin = 'CDM'
UNION ALL
SELECT All_Trips.Origin,
Flights.Destination,
All_Trips.Cost + Flights.Cost,
All_Trips.Depth + 1
FROM All_Trips INNER JOIN Flights
ON All_Trips.Destination = Flights.Origin
AND All_Trips.Origin = 'CDM'
WHERE Depth < 2 ) -- IMPORTANTE: Esta condicion en 'depth' detiene el contador
SELECT * FROM All_Trips 
WHERE depth = 2;
