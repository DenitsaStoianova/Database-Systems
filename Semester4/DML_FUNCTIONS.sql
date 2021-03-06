-- FUNCTIONS

-- Скаларни функции
-- За всеки ред от таблицата връщат една стойност
-- Прилагат се върху колони или изрази върху колни
-- Character Functions -> LOWER, UPPER, LENGTH, SUBSTR, REPLACE, TRIM, CONCAT
-- Numeric Functions -> ROUND, DECIMAL
-- Date Functions -> CURRENT_DATE, YEAR
-- Conversion Functions 
-- General Functions -> COALESCE (expr1, expr2, expr3, …)

-- Агрегатни функции
-- Прилагат се върху колони и действат за множество от редове от таблицата като връщат една стойност
-- Всички агрегатни функции игнорират NULL стойностите
-- AVG, SUM, MIN, MAX, COUNT

SET SCHEMA DB2MOVIES;

SELECT UPPER(TITLE)  AS TITLE,
       LENGTH(TITLE) AS LEN_TITLE
FROM MOVIE
WHERE SUBSTR(STUDIONAME, 1, 3) = 'MGM';


SELECT LENGTH / 60                  AS LEN_INT,
       ROUND(LENGTH / 60.0)         AS LEN_RND,
       DECIMAL(LENGTH / 60.0, 9, 2) AS LEN_DEC
FROM MOVIE
WHERE SUBSTR(STUDIONAME, 1, 3) = 'MGM';


SELECT NAME, YEAR(CURRENT_DATE) - YEAR(BIRTHDATE) AS AGE
FROM MOVIESTAR
WHERE YEAR(CURRENT_DATE) - YEAR(BIRTHDATE) <= 41;

--------------------------------------------------------------------------------------------------------------

SET SCHEMA DB2MOVIES;

SELECT UPPER(TITLE)  AS TITLE,
       LENGTH(TITLE) AS LEN_TITLE,
       STUDIONAME
FROM MOVIE
WHERE SUBSTR(STUDIONAME, 1, 3) = 'MGM';


SELECT *
FROM MOVIE;

SELECT LENGTH                       AS LEN_MIN,
       LENGTH / 60                  AS LEN_INT,
       ROUND(LENGTH / 60.0)         AS LEN_RND,
       DECIMAL(LENGTH / 60.0, 9, 2) AS LEN_DEC
FROM MOVIE
WHERE SUBSTR(STUDIONAME, 1, 3) = 'MGM';

SELECT NAME, YEAR(CURRENT_DATE) - YEAR(BIRTHDATE) AS AGE
FROM MOVIESTAR
WHERE YEAR(CURRENT_DATE) - YEAR(BIRTHDATE) <= 41;

SELECT LENGTH, COALESCE(LENGTH, 0)
FROM MOVIE
WHERE LENGTH(TITLE) < 12
ORDER BY LENGTH;

SELECT SUM(LENGTH) AS SUM_LEN,
       AVG(LENGTH) AS AVG_LEN
FROM MOVIE
WHERE UPPER(TITLE) LIKE '%STAR%';


SELECT MIN(LENGTH) AS MIN_LEN,
       MAX(LENGTH) AS MAX_LEN
FROM MOVIE
WHERE UPPER(TITLE) LIKE '%STAR%';


SELECT COUNT(*)                   AS ALL_ROWS,
       COUNT(DISTINCT STUDIONAME) AS STUDIOS,
       COUNT(LENGTH)              AS CNT_NOT_NULL_VALUES
FROM MOVIE;
