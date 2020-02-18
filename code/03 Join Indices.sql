DATABASE tutorial;

-- Query a evaluar
SELECT s.regionid, Count(st.customerid)
FROM salestransaction st 
JOIN store s
ON s.storeid = st.storeid
GROUP BY s.regionid;

-- 1. JOIN Index y ver el EXPLAIN plan
CREATE JOIN INDEX CustomersPerRegion_JI AS 
SELECT s.regionid, Count(st.customerid) AS Total
FROM salestransaction st 
JOIN store s
ON s.storeid = st.storeid
GROUP BY s.regionid
PRIMARY INDEX(regionid);

SELECT s.regionid, Count(st.customerid)
FROM salestransaction st 
JOIN store s
ON s.storeid = st.storeid
GROUP BY s.regionid
WHERE regionid = 'C'


-- 2. Agregar un SECONDARY INDEX en storeid en la tabla salestransaction
CREATE INDEX (storeid) ON salestransaction; -- Indice secundario en salestransaction

SELECT s.regionid, Count(st.customerid)
FROM salestransaction st 
JOIN store s
ON s.storeid = st.storeid
GROUP BY s.regionid;

-- 3. Hacer copia de la tabla y cambiar los indices

-- 4. Usar un PPI (CASE_N)



