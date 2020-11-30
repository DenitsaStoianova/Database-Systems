SET SCHEMA DB2INST1;

-- SCALAR FUNCTIONS AND ARITHMETIC PART 2

--Problem 1
--Produce a report listing all employees whose last name ends with 'N'. List the
--employee number, the last name, and the last character of the last name used to
--control the result. The LASTNAME column is defined as VARCHAR. There is a
--function which provides the length of the last name.
SELECT EMPNO, LASTNAME,
       SUBSTR(LASTNAME, LENGTH(LASTNAME), 1) AS LAST_CHAR -- indexing starts with 1
FROM EMPLOYEE
WHERE LASTNAME LIKE '%N';

--Problem 2
--For each project, display the project number, project name, department number, and
--project number of its associated major project (COLUMN = MAJPROJ). If the value
--in MAJPROJ is NULL, show a literal of your choice instead of displaying a null value.
--List only projects assigned to departments D01 or D11. The rows should be listed in
--project number sequence.
SELECT PROJNO, PROJNAME, DEPTNO, COALESCE(MAJPROJ, 'MAJOR PROJECT FOR ' || PROJNO)
FROM PROJECT
WHERE DEPTNO IN ('D01', 'D11')
ORDER BY PROJNO;

--Problem 3
--The salaries of the employees in department E11 will be increased by 3.75 percent.
--What will be the increase in dollars? Display the last name, actual yearly salary, and
--the salary increase rounded to the nearest dollar. Do not show any cents.
SELECT EMPNO, LASTNAME,
       SALARY AS OLD_SALARY,
       DECIMAL(ROUND(SALARY * 1.0375, 0), 9, 2) AS NEW_SALARY, -- към предишната задача добавяме увеличението -> SALARY * 1.0375
       DECIMAL(ROUND(SALARY * 0.0375, 0), 9, 2) AS INCR_SAL -- показва само увеличението
FROM EMPLOYEE
WHERE WORKDEPT = 'E11';

--Problem 4
--Repeat Problem 3 but this time express the amount of salary increase as an integer,
--that is, a number with no decimal places and no decimal point. (QMF users, you do
--not get a decimal point even for Problem 3, so there is no point in doing this problem
--if you are using QMF.)
SELECT EMPNO, LASTNAME,
       SALARY AS OLD_SALARY,
       SALARY + INT(SALARY * 0.0375) AS NEW_SALARY, -- към предишната задача добавяме увеличението -> SALARY * 1.0375
       DECIMAL(TRUNCATE(SALARY * 0.0375), 9, 0) AS INCR_SAL, -- показва само увеличението - отрязва цялата част
       INT(SALARY * 0.0375) AS INCR_SAL_INT
FROM EMPLOYEE
WHERE WORKDEPT =  'E11';

--Problem 5
--For each female employee in the company present her department, her job and her
--last name with only one blank between job and last name.
SELECT WORKDEPT, JOB || ' ' || LASTNAME AS EMPL_INFO
FROM EMPLOYEE
WHERE SEX = 'F'
ORDER BY EMPL_INFO;

--Problem 6
--Calculate the difference between the date of birth and the hiring date for all
--employees for whom the hiring date is more than 30 years later than the date of
--birth. Display employee number and calculated difference. The difference should be
--shown in years, months, and days - each of which should be shown in a separate
--column. Make sure that the rows are in employee number sequence.
SELECT EMPNO,
       HIREDATE,
       BIRTHDATE,
       YEAR(HIREDATE - BIRTHDATE) AS YEARS,
       MONTH(HIREDATE - BIRTHDATE) AS MONTHS,
       DAY(HIREDATE - BIRTHDATE) AS DAYS
FROM EMPLOYEE
WHERE YEAR(HIREDATE - BIRTHDATE) > 30
ORDER BY EMPNO;

SELECT EMPNO,
       HIREDATE,
       BIRTHDATE,
       YEAR(HIREDATE - BIRTHDATE) || ' YEARS ' ||
       MONTH(HIREDATE - BIRTHDATE) || ' MONTHS ' ||
       DAY(HIREDATE - BIRTHDATE) || ' DAYS ' AS DURATION
FROM EMPLOYEE
WHERE YEAR(HIREDATE - BIRTHDATE) > 30
ORDER BY EMPNO;

--Problem 7
--Display project number, project name, project start date, and project end date of
--those projects whose duration was less than 10 months. Display the project duration
--in days.
SELECT PROJNO, PROJNAME,
       PRSTDATE,
       PRENDATE,
       PRENDATE - PRSTDATE
FROM PROJECT
WHERE INT(PRENDATE - PRSTDATE) < 1000 -- 10 months and 0 days
AND INT(PRENDATE - PRSTDATE) > 0; -- validate result

SELECT PROJNO, PROJNAME,
       PRSTDATE,
       PRENDATE,
       PRENDATE - PRSTDATE
FROM PROJECT
WHERE PRSTDATE + 10 MONTH  > PRENDATE -- adds 10 months and 0 days
AND INT(PRENDATE - PRSTDATE) > 0; -- validate result

--Problem 8
--List the employees in department D11 who had activities. Display employee number,
--last name, and first name. Also, show the activity number and the activity duration
--(in days) of the activities started last. Multiple activities may have been started on
--the same day.
SELECT DISTINCT E.EMPNO, E.LASTNAME, E.FIRSTNME, EA.ACTNO,
       EA.EMSTDATE, EA.EMENDATE,
       DAYS(EA.EMENDATE) - DAYS(EA.EMSTDATE) AS DAYS
FROM EMPLOYEE AS E, EMPPROJACT AS EA
WHERE E.EMPNO = EA.EMPNO
AND E.WORKDEPT = 'D11'
  AND EA.EMSTDATE = (SELECT MAX(EMSTDATE)
                     FROM EMPPROJACT
                     WHERE EMPNO = E.EMPNO) -- коя е последната дата на която е вършил някака дейност
ORDER BY E.EMPNO, EA.EMENDATE DESC, EA.ACTNO; -- може да е работил по различни проекти с едно и съща действие

SELECT PROJNO, ACTNO, COUNT(*) AS ACTV_CNT
FROM EMPPROJACT
GROUP BY PROJNO, ACTNO;

--Problem 9
--How many weeks are between the first manned landing on the moon (July 20, 1969)
--and the first day of the year 2000?
SELECT DAYS('2000-01-01') - DAYS('1969-07-20') AS DAYS_DIFF,
       (DAYS('2000-01-01') - DAYS('1969-07-20')) / 7 || ' WEEKS AND ' ||
       ((DAYS('2000-01-01') - DAYS('1969-07-20')) - ((DAYS('2000-01-01') - DAYS('1969-07-20')) / 7) * 7) || ' DAYS' AS FULL_DIFF
FROM SYSIBM.SYSDUMMY1;

--Problem 10
--Find out which employees were hired on a Saturday or a Sunday. List their last
--names and their hiring dates.
SELECT LASTNAME, HIREDATE,
       DAYNAME(HIREDATE) AS DAYNAME,
       DAYOFWEEK_ISO(HIREDATE) AS DAYNUMBER
FROM EMPLOYEE
WHERE DAYOFWEEK_ISO(HIREDATE) IN (6, 7);
