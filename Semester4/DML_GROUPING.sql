-- GROUPING

-- Задача 1
--Напишете заявка, която извежда броя на класовете кораби
SELECT COUNT(*) AS CNT_CLASSES
FROM CLASSES;

-- Задача 2
-- Напишете заявка, която извежда средния брой на оръжия, според класа на
-- кораба
SELECT CLASS, AVG(NUMGUNS) AS AVG_NUMGUNS
FROM CLASSES
GROUP BY CLASS;

-- Задача 3
-- Напишете заявка, която извежда средния брой на оръжия за всички кораби
SELECT AVG(NUMGUNS)
FROM CLASSES AS C JOIN SHIPS S on C.CLASS = S.CLASS;

-- Задача 4
-- Напишете заявка, която извежда за всеки клас първата и последната година, в
-- която кораб от съответния клас е пуснат на вода
SELECT C.CLASS, MIN(LAUNCHED) AS MIN_YEAR, MAX(LAUNCHED) AS MAX_YEAR
FROM CLASSES AS C JOIN SHIPS S on C.CLASS = S.CLASS
GROUP BY C.CLASS;

-- Задача 5
-- Напишете заявка, която извежда броя на корабите потънали в битка според
-- класа
SELECT S.CLASS, COUNT(*) AS CNT
FROM SHIPS AS S JOIN OUTCOMES O on S.NAME = O.SHIP
WHERE O.RESULT = 'sunk'
GROUP BY S.CLASS;

-- Задача 6
-- Напишете заявка, която извежда броя на корабите потънали в битка според
-- класа, за тези класове с повече от 2 кораба
SELECT S.CLASS, COUNT(*) AS CNT
FROM SHIPS AS S JOIN OUTCOMES O on S.NAME = O.SHIP
WHERE O.RESULT = 'sunk'
GROUP BY S.CLASS
HAVING COUNT(*) >= 2;

-- Задача 7
-- Напишете заявка, която извежда средното тегло на корабите, за всяка страна.
SELECT COUNTRY, AVG(DISPLACEMENT)
FROM CLASSES
GROUP BY COUNTRY;
