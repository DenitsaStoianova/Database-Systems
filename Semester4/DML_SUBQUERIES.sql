-- SUBQUERIES

SET SCHEMA DB2MOVIES;

SELECT *
FROM STARSIN
WHERE STARNAME = (SELECT NAME
                  FROM MOVIESTAR
                  WHERE GENDER = 'F'
                    AND NAME LIKE 'S%');

SELECT *
FROM STARSIN
WHERE STARNAME IN (SELECT NAME
                   FROM MOVIESTAR
                   WHERE GENDER = 'F');

SELECT DISTINCT M1.TITLE, M1.YEAR
FROM MOVIE M1
WHERE M1.STUDIONAME IN (SELECT M2.STUDIONAME
                        FROM MOVIE M2
                        WHERE UPPER(M2.TITLE)
                            LIKE '%WAR%'
                          AND M1.YEAR < M2.YEAR);

SELECT MOVIETITLE, S.STARNAME, T.BIRTHDATE
FROM STARSIN AS S,
     (SELECT NAME, BIRTHDATE
      FROM MOVIESTAR
      WHERE GENDER = 'M') AS T
WHERE S.STARNAME = T.NAME;

SELECT SUM(LENGTH) AS SUM_LEN,
       AVG(LENGTH) AS AVG_LEN
FROM MOVIE
WHERE UPPER(TITLE) LIKE '%STAR%';


----------------------------------------------------------------------------------------------------------------
-- Задача 1
-- Напишете заявка, която извежда имената на актрисите, които са също и
-- продуценти с нетна стойност по-голяма от 10 милиона.
SELECT NAME
FROM MOVIESTAR
WHERE NAME IN (SELECT NAME
               FROM MOVIEEXEC
               WHERE NETWORTH > 10000000)
AND GENDER = 'F';

-- Задача 2
-- Напишете заявка, която извежда имената на тези актьори (мъже и жени), които
-- не са продуценти.
SELECT NAME
FROM MOVIEEXEC
WHERE NAME NOT IN (SELECT NAME
                   FROM MOVIESTAR);

-- Задача 3
-- Напишете заявка, която извежда имената на всички филми с дължина по-голяма
-- от дължината на филма ‘Gone With the Wind’
SELECT TITLE, LENGTH
FROM MOVIE
WHERE LENGTH > ALL (SELECT LENGTH
                     FROM MOVIE
                     WHERE TITLE = 'Gone With the Wind');

-- Задача 4
-- Напишете заявка, която извежда имената на продуцентите и имената на
-- продукциите за които стойността им е по-голяма от продукциите на продуценти
-- ‘Merv Griffin’
SELECT T.NAME, T.NETWORTH, M.TITLE
FROM MOVIE AS M,
(SELECT CERT#, NAME, NETWORTH
FROM MOVIEEXEC
WHERE NETWORTH > ALL (SELECT NETWORTH
                      FROM MOVIEEXEC
                      WHERE NAME = 'Merv Griffin')) AS T
WHERE M.PRODUCERC# = T.CERT#;

-- Задача 5
-- Напишете заявка, която извежда името на филмите с най-голяма дължина по
-- студио.
SELECT M.TITLE, M.LENGTH
FROM MOVIE M
WHERE M.LENGTH >= ALL (SELECT LENGTH
                       FROM MOVIE AS M1
                       WHERE M1.STUDIONAME = M.STUDIONAME);

-----------------------------------------------------------------------------------------------------------------

SET SCHEMA DB2SHIPS;

-- Задача 1
-- Напишете заявка, която извежда страните, чиито кораби са с най-голям брой
-- оръжия
SELECT DISTINCT COUNTRY, NUMGUNS
FROM CLASSES
WHERE NUMGUNS >= ALL (SELECT NUMGUNS
                      FROM CLASSES);

-- Задача 2
-- Напишете заявка, която извежда класовете и името на битката, за които поне един от корабите им е
-- потънал в битка.
SELECT S.CLASS, T.BATTLE
FROM SHIPS AS S,
(SELECT SHIP, BATTLE
               FROM OUTCOMES
               WHERE RESULT = 'sunk') AS T
WHERE S.NAME = T.SHIP;

-- Задача 3
-- Напишете заявка, която извежда имената на корабите с 16 инчови оръдия (bore).
SELECT NAME
FROM SHIPS
WHERE CLASS IN (SELECT CLASS
                FROM CLASSES
                WHERE BORE = 16);

-- Напишете заявка, която извежда имената, COUNTRY and BATTLE на корабите с 16 инчови оръдия (bore),
SELECT S.NAME, T.COUNTRY, O.BATTLE
FROM SHIPS AS S,
     OUTCOMES AS O,
(SELECT CLASS, COUNTRY
                FROM CLASSES
                WHERE BORE = 16) AS T
WHERE S.CLASS = T.CLASS
AND S.NAME = O.SHIP;

-- Задача 4
-- Напишете заявка, която извежда имената на битките, в които са участвали
-- кораби от клас ‘Kongo’.
SELECT BATTLE
FROM OUTCOMES
WHERE SHIP IN (SELECT NAME
               FROM SHIPS
               WHERE CLASS = 'Kongo');

-- Задача 5
-- Напишете заявка, която извежда иманата на корабите, чиито брой оръдия е най-голям
-- в сравнение с корабите със същия калибър оръдия (bore).
SELECT C1.CLASS, S.NAME
FROM CLASSES AS C1 JOIN SHIPS AS S
ON C1.CLASS = S.CLASS
WHERE C1.NUMGUNS >= ALL (SELECT C2.NUMGUNS
                         FROM CLASSES AS C2
                         WHERE C1.BORE = C2.BORE);
