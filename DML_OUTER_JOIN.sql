--- OUTER JOIN

SET SCHEMA DB2MOVIES;

SELECT STUDIONAME, TITLE, STARNAME
FROM MOVIE , STARSIN
WHERE TITLE = MOVIETITLE AND YEAR = MOVIEYEAR
AND LENGTH > 130
ORDER BY title;

SELECT STUDIONAME, TITLE, STARNAME
FROM MOVIE JOIN STARSIN
ON TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
WHERE LENGTH > 130
ORDER BY title;

SELECT STUDIONAME, TITLE, STARNAME
FROM MOVIE LEFT JOIN STARSIN
ON TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
WHERE LENGTH > 130
ORDER BY title;

SELECT STUDIONAME, TITLE, STARNAME
FROM MOVIE RIGHT JOIN STARSIN
ON TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
WHERE LENGTH > 130
ORDER BY title;

SELECT STUDIONAME, TITLE, STARNAME
FROM MOVIE FULL JOIN STARSIN
ON TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
WHERE LENGTH > 130
ORDER BY title;

SELECT DISTINCT M1.TITLE, M1.YEAR
FROM MOVIE M1 JOIN MOVIE M2
ON M1.STUDIONAME=M2.STUDIONAME
WHERE M1.YEAR < M2.YEAR
AND UPPER(M2.TITLE) LIKE '%WAR%';

SELECT STARNAME, BIRTHDATE, STUDIONAME
FROM MOVIE JOIN STARSIN
ON TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
JOIN MOVIESTAR ON NAME=STARNAME
WHERE LENGTH > 130
ORDER BY title;


-- Задача 1
-- Напишете заявка, която извежда името на продуцента и имената на филмите,
-- продуцирани от продуцента на ‘Star Wars’
SELECT T.NAME, M.TITLE
FROM MOVIE AS M,
(SELECT ME.CERT#, ME.NAME
FROM MOVIE AS M JOIN MOVIEEXEC AS ME
ON M.PRODUCERC# = ME.CERT#
WHERE M.TITLE = 'Star Wars') AS T
WHERE M.PRODUCERC# = T.CERT#
AND M.TITLE != 'Star Wars';

-- Задача 2
-- Напишете заявка, която извежда имената на продуцентите на филмите на
-- ‘Harrison Ford’
SELECT ME.NAME, M.TITLE
FROM MOVIEEXEC AS ME JOIN MOVIE AS M
ON ME.CERT# = M.PRODUCERC#
JOIN STARSIN AS S
ON M.TITLE = S.MOVIETITLE AND M.YEAR = S.MOVIEYEAR
WHERE S.STARNAME = 'Harrison Ford';

-- Задача 3
-- Напишете заявка, която извежда името на студиото и имената на актьорите
-- участвали във филми произведени от това студио, подредени по име на студио.
SELECT M.STUDIONAME, S.STARNAME, ME.NAME AS PRODUCERNAME
FROM MOVIEEXEC AS ME JOIN MOVIE AS M
ON ME.CERT# = M.PRODUCERC#
JOIN STARSIN AS S
ON M.TITLE = S.MOVIETITLE AND M.YEAR = S.MOVIEYEAR
ORDER BY STUDIONAME;

-- Задача 4
-- Напишете заявка, която извежда имената на актьора (актьорите) участвали във
-- филми на най-голяма стойност
SELECT DISTINCT S.STARNAME
FROM MOVIE AS M JOIN MOVIEEXEC AS ME
ON M.PRODUCERC# = ME.CERT#
JOIN STARSIN AS S
ON M.YEAR = S.MOVIEYEAR AND M.TITLE = S.MOVIETITLE
WHERE ME.NETWORTH >= ALL(SELECT NETWORTH
                        FROM MOVIEEXEC);

-- Задача 5
-- Напишете заявка, която извежда имената на актьорите не участвали в нито един
-- филм. (Използвайте съединение!)
SELECT NAME
FROM MOVIESTAR AS MS LEFT JOIN STARSIN AS S
ON MS.NAME = S.STARNAME
WHERE MOVIETITLE IS NULL;

---------------------------------------------------------------------------------------------------------------

SET SCHEMA DB2SHIPS;

-- Задача 1
-- Напишете заявка, която извежда цялата налична информация за всеки кораб,
-- включително и данните за неговия клас. В резултата не трябва да се включват
-- тези класове, които нямат кораби.
SELECT *
FROM SHIPS AS S JOIN CLASSES C
ON S.CLASS = C.CLASS;

-- Задача 2
-- Повторете горната заявка като този път включите в резултата и класовете, които
-- нямат кораби, но съществуват кораби със същото име като тяхното.
SELECT C.CLASS
FROM CLASSES AS C LEFT JOIN SHIPS S
on C.CLASS = S.CLASS
WHERE EXISTS(SELECT *
            FROM SHIPS
            WHERE NAME = C.CLASS)
AND S.NAME IS NULL;

-- Задача 3
-- За всяка страна изведете имената на корабите, които никога не са участвали в
-- битка.
SELECT C.COUNTRY, S.NAME
FROM CLASSES AS C LEFT JOIN SHIPS S on C.CLASS = S.CLASS
LEFT JOIN OUTCOMES O on S.NAME = O.SHIP
WHERE O.BATTLE IS NULL
OR S.NAME IS NULL;
