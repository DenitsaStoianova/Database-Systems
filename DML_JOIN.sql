
-- JOIN

SET SCHEMA DB2MOVIES;

SELECT M1.TITLE, M1.YEAR
FROM MOVIE M1 , MOVIE M2
WHERE M1.STUDIONAME=M2.STUDIONAME
AND M1.YEAR < M2.YEAR
AND UPPER(M2.TITLE) LIKE '%WAR%';

SELECT STARNAME, BIRTHDATE, STUDIONAME
FROM MOVIE , STARSIN , MOVIESTAR
WHERE TITLE = MOVIETITLE
AND YEAR = MOVIEYEAR
AND NAME = STARNAME
AND LENGTH > 130
ORDER BY title;

-- Задача 1
-- Напишете заявка, която извежда имената на актьорите мъже участвали в ‘Terms
-- of Endearment’
SELECT S.STARNAME
FROM MOVIESTAR AS M JOIN STARSIN AS S
ON M.NAME = S.STARNAME
WHERE S.MOVIETITLE = 'Terms of Endearment'
AND M.GENDER = 'M';

-- Задача 2
-- Напишете заявка, която извежда имената на актьорите участвали във филми
-- продуцирани от ‘MGM’през 1995 г.
SELECT S.STARNAME
FROM STARSIN AS S JOIN MOVIE AS M
ON S.MOVIETITLE = M.TITLE AND S.MOVIEYEAR = M.YEAR
JOIN MOVIESTAR AS MS
ON S.STARNAME = MS.NAME
WHERE M.STUDIONAME = 'MGM'
AND M.YEAR = 1995
AND MS.GENDER = 'M';

-- Задача 3
-- Напишете заявка, която извежда името на producenta на ‘MGM’
SELECT DISTINCT ME.NAME
FROM MOVIEEXEC AS ME JOIN MOVIE AS M
ON ME.CERT# = M.PRODUCERC#
WHERE M.STUDIONAME = 'MGM';

-- Задача 4
-- Напишете заявка, която извежда имената на всички филми с дължина по-голяма
-- от дължината на филма ‘Gone With the Wind’
SELECT DISTINCT M1.TITLE
FROM MOVIE AS M1,MOVIE AS M2
WHERE M2.TITLE = 'Gone With the Wind'
AND M1.LENGTH > M2.LENGTH
AND M1.YEAR <> M2.YEAR
AND M1.TITLE <> M2.TITLE;

-- Задача 4
-- Напишете заявка, която извежда имената на тези продукции на стойност по-голяма от продукциите
-- на продуценти ‘Merv Griffin’
SELECT DISTINCT M1.TITLE
FROM MOVIE AS M1, MOVIEEXEC AS ME1,
     MOVIE AS M2, MOVIEEXEC AS ME2
WHERE M1.PRODUCERC# = ME1.CERT#
AND M2.PRODUCERC# = ME2.CERT#
AND ME2.NAME = 'Merv Griffin'
AND ME1.NETWORTH > ME2.NETWORTH;

----------------------------------------------------------------------------------------------------------------

SET SCHEMA DB2SHIPS;

-- Задача 1
-- Напишете заявка, която извежда името на корабите по-тежки от 35000
SELECT S.NAME
FROM CLASSES AS C JOIN SHIPS AS S
ON C.CLASS = S.CLASS
WHERE C.DISPLACEMENT > 35000;

-- Задача 2
-- Напишете заявка, която извежда имената, водоизместимостта и броя оръжия на
-- всички кораби участвали в битката при ‘Guadalcanal’
SELECT S.NAME AS SHIPNAME, C.DISPLACEMENT, C.NUMGUNS
FROM CLASSES AS C JOIN SHIPS AS S
ON C.CLASS = S.CLASS
JOIN OUTCOMES AS O
ON S.NAME = O.SHIP
WHERE O.BATTLE = 'Guadalcanal';

-- Задача 3
-- Напишете заявка, която извежда имената на тези държави, които имат кораби от
-- тип ‘bb’ и ‘bc’ едновременно
SELECT C1.COUNTRY
FROM CLASSES AS C1, CLASSES AS C2
WHERE C2.TYPE = 'bc'
AND C1.TYPE = 'bb'
AND C1.COUNTRY = C2.COUNTRY;

-- Задача 4
-- Напишете заявка, която извежда имената на тези битки с три кораби на една и
-- съща държава
SELECT DISTINCT O1.BATTLE
FROM OUTCOMES AS O1, SHIPS AS S1, CLASSES AS C1,
     OUTCOMES AS O2, SHIPS AS S2, CLASSES AS C2,
     OUTCOMES AS O3, SHIPS AS S3, CLASSES AS C3
WHERE O1.SHIP = S1.NAME AND S1.CLASS = C1.CLASS
  AND O2.SHIP = S2.NAME AND S2.CLASS = C2.CLASS
  AND O3.SHIP = S3.NAME AND S2.CLASS = C2.CLASS -- 9 tablici
AND C1.COUNTRY = C2.COUNTRY
AND C1.COUNTRY = C3.COUNTRY
AND O1.BATTLE = O2.BATTLE
AND O1.BATTLE = O3.BATTLE
AND S1.NAME <> S2.NAME
AND S1.NAME <> S3.NAME
AND S2.NAME <> S3.NAME;

-- Задача 5
-- Напишете заявка, която извежда имената на тези кораби, които са били
-- повредени в една битка, но по късно са участвали в друга битка
SELECT O1.SHIP
FROM BATTLES AS B1, OUTCOMES AS O1,
     BATTLES AS B2, OUTCOMES AS O2
WHERE B1.NAME = O1.BATTLE
  AND B2.NAME = O2.BATTLE
AND O1.SHIP = O2.SHIP
AND O2.RESULT = 'damaged'
AND B1.DATE > B2.DATE;
