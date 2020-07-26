SET SCHEMA DB2MOVIES;

-- Задача 1
-- Напишете заявка, която извежда адресът на студио ‘MGM’
SELECT ADDRESS
FROM STUDIO
WHERE NAME = 'MGM';

-- Задача 2
-- Напишете заявка, която извежда рождената дата на актрисата Sandra Bullock
SELECT S.STARNAME, M.BIRTHDATE, S.MOVIETITLE
FROM MOVIESTAR AS M JOIN STARSIN AS S
ON M.NAME = S.STARNAME
WHERE M.NAME = 'Sandra Bullock';

-- Задача 3
-- Напишете заявка, която извежда имената на всички актьори, които са
-- участвали във филм през 1977 в заглавието на които има думата ‘Wars’
SELECT STARNAME
FROM STARSIN
WHERE MOVIETITLE LIKE '%Wars%'
AND MOVIEYEAR = 1977;

SET SCHEMA DB2SHIPS;

-- Задача 4
-- Напишете заявка, която извежда имената на корабите с име съвпадащо
-- с името на техния клас
SELECT NAME, CLASS
FROM SHIPS
WHERE NAME = CLASS;

-- Задача 5
-- Напишете заявка, която извежда имената на всички кораби започващи с
-- буквата R
SELECT NAME
FROM SHIPS
WHERE NAME LIKE 'R%';

-- Задача 6
-- Напишете заявка, която извежда имената на всички кораби, чието име е
-- съставено от точно две думи.
SELECT NAME
FROM SHIPS
WHERE NAME LIKE '% %'
AND NAME NOT LIKE '% % %';






