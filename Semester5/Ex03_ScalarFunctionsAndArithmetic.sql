SET SCHEMA DB2INST1;

-- SCALAR FUNCTIONS AND ARITHMETIC

SELECT CURRENT_DATE AS CURR_DATE,
       CURRENT_TIME AS CURR_TIME,
       CURRENT_TIME + 70 MINUTES  AS NEW_TIME
FROM SYSIBM.SYSDUMMY1;

SELECT CURRENT_DATE  + 1 MONTH + 5 DAYS
FROM SYSIBM.SYSDUMMY1;

SELECT CURRENT_DATE - DATE('1999-08-20') AS YYMMDD,
DAYS(CURRENT_DATE) - DAYS(DATE('1999-08-20')) AS DAYS,
YEAR(CURRENT_DATE  - DATE('1999-08-20'))*12 + MONTH(CURRENT_DATE  - DATE('1999-08-20')) AS MONTHS
-- DECIMAL(ROUND(MONTHS_BETWEEN(CURRENT_DATE,DATE('1999-08-20')),0),6,0)
FROM SYSIBM.SYSDUMMY1;

SELECT LASTNAME AS FULL_NAME, SUBSTR(LASTNAME, 3, 2)
FROM EMPLOYEE
WHERE EMPNO = '000020';

--Problem 1
--For employees whose salary, increased by 5 percent, is less than or equal to
--$40,000, list the following:
-- • Last name
-- • Current Salary
-- • Salary increased by 5 percent
-- • Monthly salary increased by 5 percent
--Use the following column names for the two generated columns:
--INC-Y-SALARY and INC-M-SALARY Use the proper conversion function to display
--the increased salary and monthly salary with two of the digits to the right of the
--decimal point. Sort the results by annual salary.
SELECT LASTNAME AS "EMPLOYEE-LASTNAME",
       SALARY AS "OLD-SALARY",
       DECIMAL((SALARY + COALESCE(SALARY, 0) * 0.05), 8, 2) AS "INC-Y-SALARY",
       DECIMAL(((COALESCE(SALARY, 0) / 12) + (COALESCE(SALARY, 0) / 12) * 0.05), 8, 2) AS "INC-M-SALARY"
       --DECIMAL(((COALESCE(SALARY, 0) / 12) * 1.05), 8, 2) AS "INC-M-SALARY"
FROM EMPLOYEE
WHERE (SALARY + COALESCE(SALARY, 0) * 0.05) <= 40000
ORDER BY SALARY;

--Problem 2
--All employees with an education level of 18 or 20 will receive a salary increase of
--$1,200 and their bonus will be cut in half. List last name, education level, new salary,
--and new bonus for these employees. Display the new bonus with two digits to the
--right of the decimal point.
--Use the column names NEW-SALARY and NEW-BONUS for the generated columns.
--Employees with an education level of 20 should be listed first. For employees with
--the same education level, sort the list by salary.
SELECT LASTNAME, EDLEVEL,
       SALARY AS OLD_SALARY,
       SALARY + 1200 AS NEW_SALARY,
       BONUS AS OLD_BONUS,
       DECIMAL((BONUS / 2),8,2) AS NEW_BONUS
FROM EMPLOYEE
WHERE EDLEVEL IN (18,20)
ORDER BY EDLEVEL DESC, SALARY;

--Problem 3
--The salary will be decreased by $1,000 for all employees matching the following
--criteria:
-- • They belong to department D11
-- • Their salary is more than or equal to 80 percent of $20,000
-- • Their salary is less than or equal to 120 percent of $20,000
--Use the name DECR-SALARY for the generated column.
--List department number, last name, salary, and decreased salary. Sort the result by salary.
SELECT WORKDEPT, LASTNAME, SALARY, SALARY - 1000 AS "DECR-SALARY"
FROM EMPLOYEE
WHERE WORKDEPT = 'D11'
AND SALARY >= 20000* 0.8 AND SALARY <= 20000 * 1.2
ORDER BY SALARY;

--Problem 4
--Produce a list of all employees in department D11 that have an income (sum of
--salary, commission, and bonus) that is greater than their salary increased by 10 percent.
--Name the generated column INCOME.
--List department number, last name, and income. Sort the result in descending order by income.
--For this problem assume that all employees have non-null salaries, commissions, and bonuses.
SELECT WORKDEPT, LASTNAME, SALARY,
       SALARY + SALARY * 0.1 AS INCR_SALARY,
       SALARY + COMM + BONUS AS INCOME
FROM EMPLOYEE
WHERE WORKDEPT = 'D11'
AND  SALARY + COMM + BONUS >= SALARY + SALARY * 0.1-- COALESCE(SALARY, 0) * 1.1
ORDER BY INCOME;

--Problem 5
--List all departments that have no manager assigned. List department number,
--department name, and manager number. Replace unknown manager numbers with
--the word UNKNOWN and name the column MGRNO.
SELECT DEPTNO, DEPTNAME, COALESCE(MGRNO, 'UNKNOWN')
FROM DEPARTMENT
WHERE MGRNO IS NULL;

--Problem 6
--List the project number and major project number for all projects that have a project
--number beginning with MA. If the major project number is unknown, display the text
--'MAIN PROJECT.'
--Name the derived column MAJOR PROJECT. Sequence the results by PROJNO.
SELECT PROJNO, COALESCE(MAJPROJ, 'MAIN PROJECT') AS "MAJOR PROJECT"
FROM PROJECT
WHERE PROJNO LIKE 'MA%' --  SUBSTR(PROJNO,1,2) ='MA' - counting starts from 1 in SQL
ORDER BY PROJNO;

--Problem 7
--List all employees who were younger than 25 when they joined the company.
--List their employee number, last name, and age when they joined the company.
--Name the derived column AGE.
--Sort the result by age and then by employee number.
SELECT EMPNO, LASTNAME, BIRTHDATE, HIREDATE, EDLEVEL,
       YEAR(HIREDATE-BIRTHDATE) AS AGE -- HIREDATE-BIRTHDATE -> дава duration и взимаме годината
FROM EMPLOYEE
WHERE YEAR(HIREDATE-BIRTHDATE) <= 25 AND YEAR(HIREDATE-BIRTHDATE) >= 18
ORDER BY AGE, EMPNO;

-- дали са били наети на работа към момента към който са учили
-- (били са наети преди да завършат образованието си)
-- ако са започнали да учат на 6-7 гадини
SELECT EMPNO, LASTNAME, BIRTHDATE, HIREDATE,
       YEAR(HIREDATE-BIRTHDATE) AS AGE,
       YEAR(BIRTHDATE + 7 YEARS) AS STARTYEAR, -- start education
       YEAR(BIRTHDATE + 7 YEARS) + EDLEVEL AS ENDYEAR -- end education
FROM EMPLOYEE
WHERE YEAR(HIREDATE-BIRTHDATE) <= 25 AND YEAR(HIREDATE-BIRTHDATE) >= 18
AND YEAR(HIREDATE) <= YEAR(BIRTHDATE + 7 YEARS) + EDLEVEL;

--Problem 8
--Provide a list of all projects which ended on December 1, 1982. Display the year and
--month of the starting date and the project number. Sort the result by project number.
--Name the derived columns YEAR and MONTH.
SELECT YEAR(PRSTDATE) AS YEAR, MONTH(PRSTDATE) AS MONTH, PROJNO
FROM PROJECT
WHERE PRENDATE = '1982-12-01'
ORDER BY PROJNO;

--Problem 9
--List the project number and duration, in weeks, of all projects that have a project
--number beginning with MA. The duration should be rounded and displayed with one
--decimal position. Name the derived column WEEKS.
--Order the list by the project number.
SELECT PROJNO, DECIMAL(((DAYS(PRENDATE) - DAYS(PRSTDATE)) / 7.0 + 0.05), 8, 1) AS WEEKS
FROM PROJECT
WHERE PROJNO LIKE 'MA%' -- SUBSTR(PROJNO, 1, 2) = 'MA'
ORDER BY PROJNO;

SELECT PROJNO, DECIMAL(ROUND((DAYS(PRENDATE) - DAYS(PRSTDATE)) / 7.0, 1), 9, 1) AS WEEKS
FROM PROJECT
WHERE PROJNO LIKE 'MA%' AND PRSTDATE < PRENDATE -- validate dates
ORDER BY PROJNO;

SELECT WEEK_ISO(CURRENT_DATE) -- ISO - по различните стандарти - коя седмица подред е от годината
FROM SYSIBM.SYSDUMMY1;

--Problem 10
--For projects that have a project number beginning with MA, list the project number,
--project ending date, and a modified ending date assuming the projects will be
--delayed by 10 percent.
--Name the column containing PRENDATE, ESTIMATED. Name the derived column EXPECTED.
--Order the list by project number.
SELECT PROJNO, PRENDATE AS ESTIMATED,
       PRSTDATE + ((DAYS(PRENDATE) - DAYS(PRSTDATE))*1.1) DAYS AS EXPECTED -- * 0.1 ??
FROM PROJECT
WHERE PROJNO LIKE 'MA%'
ORDER BY PROJNO;

--Problem 11
--How many days are between the first manned landing on the moon (July 20, 1969)
--and the first day of the year 2000?
SELECT DAYS('2000-01-01')-DAYS('1969-07-20') AS DAYS
FROM EMPLOYEE
WHERE EMPNO = '000010';

SELECT DAYS('2000-01-01')-DAYS('1969-07-20') AS DAYS
FROM SYSIBM.SYSDUMMY1;
