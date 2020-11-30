SET SCHEMA DB2INST1;

-- GROUPING FUNCTIONS

-------------------------------------------------------------------------------------------------

SELECT SUM(SALARY) AS TOTAL_SAL, -- взима цялата таблица като една група
       MIN(SALARY) AS MIN_SAL,
       MAX(SALARY) AS MAX_SAL,
       DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL,
       COUNT(*) AS EMP_CNT,
       COUNT(DISTINCT EDLEVEL) AS EDLVL_CNT
FROM EMPLOYEE;

SELECT EDLEVEL, SUM(SALARY) AS GROUP_TOTAL
FROM EMPLOYEE
GROUP BY EDLEVEL
HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------------------------

-- ROLLUP
SELECT EDLEVEL, DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
GROUP BY EDLEVEL;

SELECT DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE;

SELECT EDLEVEL, DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
GROUP BY ROLLUP(EDLEVEL); -- изкарва допълнителен ред, който пази стойностто за цялата таблица

-------------------------------------------------------------------------------------------------

-- CUBE
SELECT JOB, DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
WHERE EDLEVEL IN (14, 15)
GROUP BY JOB;

SELECT EDLEVEL, DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
WHERE EDLEVEL IN (14, 15)
GROUP BY EDLEVEL;

SELECT DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
WHERE EDLEVEL IN (14, 15);

SELECT EDLEVEL, JOB, DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
WHERE EDLEVEL IN (14, 15)
GROUP BY CUBE(JOB, EDLEVEL);
-- групира само по JOB
-- после само по EDLEVEL
-- изкарва допълнителен ред, който пази стойностто за цялата таблица (групира по цялата таблица)
-- групира по JOB, EDLEVEL

-------------------------------------------------------------------------------------------------

-- GROUPING
SELECT EDLEVEL, GROUPING(EDLEVEL), DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
GROUP BY ROLLUP(EDLEVEL);
-- GROUPING(EDLEVEL)
-- 0 -> част от групата
-- 1 -> обобщена справка за цялата таблица
-- показва къде се намираме
-- решава проблема с изкарването на повече NULL стойности при ROLLUP
-------------------------------------------------------------------------------------------------

-- GROUPING SETS
SELECT JOB, DAY(BIRTHDATE), DECIMAL(AVG(SALARY), 8, 2) AS AVG_SAL
FROM EMPLOYEE
WHERE YEAR(BIRTHDATE) > 1938
GROUP BY GROUPING SETS(DAY(BIRTHDATE), JOB);
-- грулира само по първото, после само по второто
-- групира само по DAY(BIRTHDATE)
-- после само по JOB
-- няма (група по цялата таблица) и групира по двете

-------------------------------------------------------------------------------------------------

-- RANK () OVER ()
SELECT EMPNO, LASTNAME, SALARY,
       RANK() OVER (ORDER BY SALARY DESC) AS SALARY_RANK
FROM EMPLOYEE
ORDER BY EMPNO;
-- за класиране (наредба) на 1-во място е служителя с най-висока заплата

-------------------------------------------------------------------------------------------------

--Задачи 1

--Problem 1
--For all departments, display department number and the sum of all salaries for each
--department. Name the derived column SUM_SALARY.
SELECT WORKDEPT, SUM(SALARY) AS SUM_SALARY
FROM EMPLOYEE
GROUP BY WORKDEPT;

--Problem 2
--For all departments, display the department number and the number of employees.
--Name the derived column EMP_COUNT.
SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMPLOYEE
GROUP BY WORKDEPT;

--Problem 3
--Display those departments which have more than 3 employees.
SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING COUNT(*) > 3;

--Problem 4
--For all departments with at least one designer, display the number of designers and
--the department number. Name the derived column DESIGNER.
SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMPLOYEE
WHERE JOB = 'DESIGNER'
GROUP BY WORKDEPT;

--Problem 5
--Show the average salary for men and the average salary for women for each
--department. Display the work department, the sex, the average salary, average
--bonus, average commission, and the number of people in each group. Include only
--those groups that have two or more people. Show only two decimal places in the averages.
--Use the following names for the derived columns: AVG-SALARY, AVG-BONUS, AVG-COMM, and COUNT.
SELECT WORKDEPT, SEX,
       DECIMAL(AVG(SALARY),9,2) AS AVG_SAL,
       DECIMAL(AVG(BONUS),9,2) AS AVG_BONUS,
       DECIMAL(AVG(COMM),9,2) AS AVG_COM, COUNT(*)
FROM EMPLOYEE
GROUP BY WORKDEPT, SEX
HAVING COUNT(*) > 2;

--Problem 6
--Display the average bonus and average commission for all departments with an
--average bonus greater than $500 and an average commission greater than $2,000.
--Display all averages with two digits to the right of the decimal point. Use the column
--headings AVG-BONUS and AVG-COMM for the derived columns.
SELECT WORKDEPT,
       DECIMAL(AVG(BONUS),9,2) AS AVG_BONUS,
       DECIMAL(AVG(COMM),9,2) AS AVG_COM
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING AVG(BONUS) > 500 AND AVG(COMM) > 2000;

-------------------------------------------------------------------------------------------------

--Задачи 2

--Problem 1
--Joe's manager wants information about employees which match the following criteria:
-- • Their yearly salary is between 22000 and 24000.
-- • They work in departments D11 or D21.
--List the employee number, last name, yearly salary, and department number of the
--appropriate employees.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMPLOYEE
WHERE SALARY BETWEEN 20000 AND 60000
AND WORKDEPT IN ('D11', 'D21');

--Problem 2
--Now, Joe's manager wants information about the yearly salary. He wants to know
--the minimum, the maximum, and average yearly salary of all employees with an
--education level of 16. He also wants to know how many employees have this
--education level.
SELECT MIN(SALARY) AS MIN_SAL,
       MAX(SALARY) AS MAX_SAL,
       DECIMAL(AVG(SALARY),9,2) AS AVG_SAL,
       COUNT(*) AS CNT_EMPL
FROM EMPLOYEE
WHERE EDLEVEL = 16; -- фиксираме една група служители (от всички с този номер) - иначе трябва GROUP BY

--Problem 3
--Joe's manager is interested in some additional salary information. This time, he
--wants information for every department that appears in the EMPLOYEE table,
--provided that the department has more than five employees. The report needs to
--show the department number, the minimum, maximum, and average yearly salary,
--and the number of employees who work in the department.
SELECT WORKDEPT,
       MIN(SALARY) AS MIN_SAL,
       MAX(SALARY) AS MAX_SAL,
       DECIMAL(AVG(SALARY),9,2) AS AVG_SAL,
       COUNT(*)
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING COUNT(*) > 5;

--Problem 4
--Joe's manager wants information about employees grouped by department,
--grouped by sex and in addition by the combination of department and sex. List only
--those who work in a department which start with the letter D.
--List the department, the sex, sum of the salaries, minimum salary and maximum salary.
SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY),9,2) AS AVG_SAL
FROM EMPLOYEE
WHERE WORKDEPT LIKE 'D%'
GROUP BY CUBE(WORKDEPT, SEX);

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY),9,2) AS AVG_SAL
FROM EMPLOYEE
WHERE WORKDEPT LIKE 'D%'
GROUP BY ROLLUP (WORKDEPT, SEX);

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY),9,2) AS AVG_SAL, EDLEVEL
FROM EMPLOYEE
WHERE WORKDEPT LIKE 'D%'
GROUP BY CUBE(WORKDEPT, SEX, EDLEVEL);

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY),9,2) AS AVG_SAL, EDLEVEL
FROM EMPLOYEE
WHERE WORKDEPT LIKE 'D%'
GROUP BY ROLLUP (WORKDEPT, SEX, EDLEVEL);

SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY),9,2) AS AVG_SAL, EDLEVEL
FROM EMPLOYEE
WHERE WORKDEPT LIKE 'D%'
GROUP BY GROUPING SETS (WORKDEPT, SEX, EDLEVEL);

--Problem 5
--Joe's manager wants information about the average total salary for all departments.
--List in department order, the department, average total salary and rank over the
--average total salary.
SELECT WORKDEPT,
       DECIMAL(AVG(SALARY),9,2) AS AVG_SAL,
       RANK() OVER (ORDER BY AVG(SALARY) DESC) AS RANK_SAL
FROM EMPLOYEE
GROUP BY WORKDEPT;

SELECT WORKDEPT,
       COUNT(*) AS CNT,
       RANK() OVER (ORDER BY COUNT(*) DESC)
FROM EMPLOYEE
GROUP BY WORKDEPT;

SELECT * FROM ( SELECT WORKDEPT,
                      COUNT(*) AS CNT,
                      RANK() OVER (ORDER BY COUNT(*) DESC) AS R
                FROM EMPLOYEE
                GROUP BY WORKDEPT) T
WHERE R = 2; -- VZIMAME VSICHKO S RANK 2
-------------------------------------------------------------------------------------------------

--Задачи 3

-- 1
-- Да се изведе LASTNAME, COUNT на различните дейности и  RANK
-- на служителите според рбоя на различните дейности
SELECT E.LASTNAME,
       COUNT(DISTINCT EA.ACTNO), -- различни дейности
       RANK() OVER (ORDER BY COUNT(DISTINCT EA.ACTNO) DESC)
FROM EMPLOYEE AS E, EMPPROJACT AS EA
WHERE E.EMPNO = EA.EMPNO
GROUP BY E.EMPNO, E.LASTNAME;

-- 2
-- LASTNAME, WORKDEPT и JOB
-- за всички отдели с D по средата
SELECT LASTNAME, WORKDEPT, JOB
FROM EMPLOYEE AS E
WHERE  WORKDEPT = '_D_';
--SUBSTR(WORKDEPT, 2, 1) = '2'
--SUBSTR(WORKDEPT, LENGTH(WORKDEPR) / 2 + 1, 1) = '2'

-- 3
-- Всички служители, които са родени в годината на маймуната (1968, 1980, 1992, 2004)
SELECT LASTNAME, YEAR(BIRTHDATE)
FROM EMPLOYEE
WHERE MOD(YEAR(BIRTHDATE), 12) = 0;

-- По двойки с еднаква година
SELECT E1.LASTNAME, E2.LASTNAME ,YEAR(E1.BIRTHDATE)
FROM EMPLOYEE AS E1, EMPLOYEE AS E2
WHERE MOD(YEAR(E1.BIRTHDATE), 12) = 0
AND YEAR(E1.BIRTHDATE) = YEAR(E2.BIRTHDATE)
AND E1.EMPNO > E2.EMPNO; -- да не се повтарят


