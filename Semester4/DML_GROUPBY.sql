-- GROUP BY

-- Можем да групираме по един или няколко атрибута или по израз
-- Когато групираме в SELECT може да стоят само атрибутите, по които групираме и/или агрегатни функции (AVG, SUM и др.)
-- Не можем, да имаме агрегатна функция в WHERE клаузата. В нея може да използваме само скаларни функции, като LENGTH, DAY и т.н.
-- Агрегатни функции може да изплзваме само в SELECT и HAVING клаузата

-- Ред на изпълнение на SELECT:
--5) SELECT {* | column | expression [alias],..}
--1) FROM table
--2) WHERE <condition>
--3) GROUP BY <column>
--4) HAVING <condition>
--6) ORDER BY <column>;

SET SCHEMA DB2MOVIES;

SELECT STUDIONAME, SUM(length) AS SUM_LEN
FROM MOVIE
GROUP BY STUDIONAME;

SELECT STUDIONAME, SUM(length) AS SUM_LEN
FROM MOVIE
GROUP BY STUDIONAME
HAVING SUM(length) > 200;

SELECT SUM(LENGTH) AS SUM_LEN,
       AVG(LENGTH) AS AVG_LEN
FROM MOVIE
GROUP BY STUDIONAME
HAVING SUM(LENGTH) > 300;

-----------------------------------------------------------------------------------------------------------------

-- Задача 1
-- За таблицата Movies, да се изведе номер на продуцент, брой на филми за този продуцент.
SELECT PRODUCERC#, COUNT(*) AS CNT_MOVIES
FROM MOVIE
GROUP BY PRODUCERC#;

-- Задача 2
-- Като задача 1, но искаме и име на продуцент и networth.
SELECT PRODUCERC#, ME.NAME, COUNT(M.TITLE) AS CNT_MOVIES, ME.NETWORTH
FROM MOVIE AS M JOIN MOVIEEXEC AS ME
ON M.PRODUCERC# = ME.CERT#
GROUP BY PRODUCERC#, ME.NAME, ME.NETWORTH;

-- Задача 3
-- Заявка, която ни връща име на актьор, рождена дата и броя на филмите, в които е участвал
SELECT STARNAME, MS.BIRTHDATE, COUNT(S.MOVIETITLE) AS CNT_MOVIES-- COUNT(*)
FROM STARSIN AS S JOIN MOVIESTAR AS MS
ON S.STARNAME = MS.NAME
GROUP BY S.STARNAME, BIRTHDATE
ORDER BY CNT_MOVIES DESC;

-- Задача 4
-- Заявка, която ни връща имената на актьорите, рождена дата и броя на филмите,
-- в които са участвали за тези актьори с най-много филми
SELECT STARNAME, MS.BIRTHDATE, COUNT(S.MOVIETITLE) AS CNT_MOVIES-- COUNT(*)
FROM STARSIN AS S JOIN MOVIESTAR AS MS
ON S.STARNAME = MS.NAME
GROUP BY S.STARNAME, BIRTHDATE
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
                        FROM STARSIN
                        GROUP BY STARNAME);

-- Задача 5
-- За Movies, име на продуцент, име на студио, и брой на филми за всики продуцент, според студиото.
SELECT ME.NAME, M.STUDIONAME, COUNT(*) AS CNT_MOVIES
FROM MOVIE AS M JOIN MOVIEEXEC AS ME
ON M.PRODUCERC# = ME.CERT#
GROUP BY M.PRODUCERC#, ME.NAME, M.STUDIONAME
ORDER BY CNT_MOVIES DESC;

-- Задача 6
-- Име на филм и име на най-възрастния актьор участвал във филма
SELECT STARNAME, MAX(YEAR(CURRENT_DATE ) - YEAR(BIRTHDATE)) AS MAX_YEAR
FROM STARSIN AS S JOIN MOVIESTAR AS MS
ON S.STARNAME = MS.NAME
GROUP BY MOVIETITLE, STARNAME
HAVING MAX(YEAR(CURRENT_DATE ) - YEAR(BIRTHDATE)) >= ALL(SELECT YEAR(CURRENT_DATE) - YEAR(BIRTHDATE)
                                                         FROM MOVIESTAR);

SELECT T1.*  FROM
                  (SELECT MOVIETITLE, MOVIEYEAR, STARNAME, ABS(YEAR(BIRTHDATE) - MOVIEYEAR) AS AGE
                   FROM STARSIN, MOVIESTAR
                   WHERE STARNAME=NAME) T1,
                   (SELECT MOVIETITLE, MOVIEYEAR, MAX(ABS(YEAR(BIRTHDATE) - MOVIEYEAR)) AS AGE
                    FROM STARSIN, MOVIESTAR
                    WHERE STARNAME = NAME
                    GROUP BY MOVIETITLE, MOVIEYEAR) T2
WHERE T1.MOVIETITLE = T2.MOVIETITLE
AND T1.MOVIEYEAR = T2.MOVIEYEAR
AND T1.AGE = T2.AGE;

-- Име на филм и години на най-възрастния и няй-младия актьор участвали във филма
SELECT MOVIETITLE, MIN(YEAR(CURRENT_DATE) - YEAR(BIRTHDATE)) AS MIN_YEAR,
                   MAX(YEAR(CURRENT_DATE ) - YEAR(BIRTHDATE)) AS MAX_YEAR
FROM STARSIN AS S JOIN MOVIESTAR AS MS
ON S.STARNAME = MS.NAME
GROUP BY MOVIETITLE;

-- Задача 7
-- Намира най-възрастният актьор участвал в филм
SELECT MOVIETITLE, MOVIEYEAR, NAME, ABS(YEAR(BIRTHDATE) - MOVIEYEAR) AS AGE
FROM MOVIESTAR,
     STARSIN
WHERE STARNAME = NAME
  AND ABS(YEAR(BIRTHDATE) - MOVIEYEAR) = (SELECT MAX(ABS(YEAR(BIRTHDATE) - MOVIEYEAR))
                                          FROM MOVIESTAR);






