SET SCHEMA DB2INST1;

-- USING SUBQUERIES

-- Who has the highest yearly salary?
SELECT EMPNO, LASTNAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);

-- Which employees are responsible for projects within their department?
SELECT EMPNO, LASTNAME
FROM EMPLOYEE
WHERE (EMPNO, WORKDEPT) IN (SELECT RESPEMP, DEPTNO FROM PROJECT);

-- Which employees are not responsible for projects?
SELECT EMPNO, LASTNAME
FROM EMPLOYEE
WHERE EMPNO NOT IN (SELECT RESPEMP FROM PROJECT);

-- Which departments have no employees?
SELECT DEPTNO, DEPTNAME
FROM DEPARTMENT
WHERE DEPTNO NOT IN (SELECT WORKDEPT FROM EMPLOYEE);

-- Which department has the highest salary cost?
SELECT WORKDEPT, SUM(SALARY) AS SUM_SAL
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING SUM(SALARY) >= ALL(SELECT SUM(SALARY) FROM EMPLOYEE GROUP BY WORKDEPT);

-- Which employees have a salary that is higher than the
-- average of at least one department?
SELECT EMPNO, LASTNAME
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT AVG(SALARY) FROM EMPLOYEE GROUP BY WORKDEPT);

-- List of all employees earning more than 30 000, if there is
-- any employee earning less than 35 000
SELECT EMPNO, LASTNAME, SALARY
FROM EMPLOYEE
WHERE SALARY > 30000
AND EXISTS(SELECT * FROM EMPLOYEE WHERE SALARY < 35000);

-- Which employees have a salary that is higher than
-- the average of their department?
SELECT EMPNO, LASTNAME, SALARY
FROM EMPLOYEE AS E
WHERE E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.WORKDEPT = WORKDEPT);

-- For which departments do no employees work?
SELECT DEPTNO, DEPTNAME
FROM DEPARTMENT AS D
WHERE NOT EXISTS(SELECT * FROM EMPLOYEE WHERE WORKDEPT = D.DEPTNO);

---------------------------------------------------------------------------------------------------

-- Задачи 1

--Problem 1
--List those employees that have a salary which is greater than or equal to the
--average salary of all employees plus $5,000.
--Display department number, employee number, last name, and salary. Sort the list
--by the department number and employee number.
SELECT  WORKDEPT, EMPNO, LASTNAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY) + 5000 FROM EMPLOYEE)
ORDER BY WORKDEPT, EMPNO;

--Problem 2
--List employee number and last name of all employees not assigned to any projects.
--This means that table EMP_ACT does not contain a row with their employee
--number.
SELECT EMPNO, LASTNAME
FROM EMPLOYEE
WHERE EMPNO NOT IN (SELECT EMPNO FROM EMPPROJACT);

--Problem 3
--List project number and duration (in days) of the project with the shortest duration.
--Name the derived column DAYS.
SELECT PROJNO, DAYS(PRENDATE) - DAYS(PRSTDATE) AS DAYS
FROM PROJECT
WHERE DAYS(PRENDATE) - DAYS(PRSTDATE) IN (SELECT MIN(DAYS(PRENDATE) - DAYS(PRSTDATE)) FROM PROJECT);
-- KATO IMA NESHTO SPECIFICHNO KAZANO -> PODZAQVKI

--Problem 4
--List department number, department name, last name, and first name of all those
--employees in departments that have only male employees.
SELECT DEPTNO, DEPTNAME, LASTNAME, FIRSTNME, SEX
FROM DEPARTMENT AS D, EMPLOYEE AS E
WHERE D.DEPTNO = E.WORKDEPT
AND DEPTNO NOT IN (SELECT WORKDEPT FROM EMPLOYEE WHERE EMPLOYEE.SEX = 'F');

--Problem 5
--We want to do a salary analysis for people that have the same job and education
--level as the employee Stern. Show the last name, job, edlevel, the number of years
--they've worked as of January 1, 2000, and their salary.
--Name the derived column YEARS.
--Sort the listing by highest salary first.
SELECT LASTNAME, JOB, EDLEVEL, YEAR('2001-01-01' - HIREDATE) AS YEARS
FROM EMPLOYEE
WHERE (JOB, EDLEVEL) IN (SELECT JOB, EDLEVEL FROM EMPLOYEE WHERE LASTNAME = 'STERN')
ORDER BY SALARY DESC;

---------------------------------------------------------------------------------------------------

-- Задачи 2

--Problem 1
--Retrieve all employees who are not involved in a project. Not involved in a project
--are those employees who have no row in the EMP_ACT table. Display employee
--number, last name, and department name.
SELECT EMPNO, LASTNAME, DEPTNAME
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE E.WORKDEPT = D.DEPTNO
AND E.EMPNO NOT IN (SELECT EMPNO FROM EMPPROJACT);

--Problem 2
--Retrieve all employees whose yearly salary is more than the average salary of the
--employees in their department. For example, if the average yearly salary for
--department E11 is 20998, show all people in department E11 whose individual
--salary is higher than 20998. Display department number, employee number, and
--yearly salary. Sort the result by department number and employee number.
SELECT WORKDEPT, EMPNO, SALARY
FROM EMPLOYEE AS E
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE WHERE E.WORKDEPT = WORKDEPT)
ORDER BY WORKDEPT, EMPNO;

--Problem 3
--Retrieve all departments having the same number of employees as department
--B01. List department number and number of employees. Department B01 should
--not be part of the result.
SELECT WORKDEPT, COUNT(*) AS EMPL_CNT
FROM EMPLOYEE AS E
WHERE WORKDEPT <> 'B01'
GROUP BY WORKDEPT
HAVING COUNT(*) IN (SELECT COUNT(*) FROM EMPLOYEE WHERE WORKDEPT = 'B01');

--Problem 4
--Display employee number, last name, salary, and department number of employees
--who earn more than at least one employee in department D11. Employees in
--department D11 should not be included in the result. In other words, report on any
--employees in departments other than D11 whose individual yearly salary is higher
--than that of at least one employee of department D11. List the employees in
--employee number sequence.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMPLOYEE
WHERE WORKDEPT <> 'D11'
AND SALARY > ANY(SELECT SALARY FROM EMPLOYEE WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMPLOYEE
WHERE WORKDEPT <> 'D11'
AND SALARY > (SELECT MIN(SALARY) FROM EMPLOYEE WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

--Problem 5
--Display employee number, last name, salary, and department number of all
--employees who earn more than everybody belonging to department D11.
--Employees in department D11 should not be included in the result. In other words,
--report on all employees in departments other than D11 whose individual yearly
--salary is higher than that of every employee in department D11. List the employees
--in employee number sequence.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMPLOYEE
WHERE WORKDEPT <> 'D11'
AND SALARY >= ALL(SELECT SALARY FROM EMPLOYEE WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMPLOYEE
WHERE WORKDEPT <> 'D11'
AND SALARY > (SELECT MAX(SALARY) FROM EMPLOYEE WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

--Problem 6
--Display employee number, last name, and number of activities of the employee with
--the largest number of activities. Each activity is stored as one row in the EMP_ACT
--table.
SELECT E.EMPNO, LASTNAME, COUNT(*) AS ACTNO_CNT
FROM EMPLOYEE AS E, EMPPROJACT AS EA
WHERE E.EMPNO = EA.EMPNO
GROUP BY E.EMPNO, LASTNAME
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM EMPPROJACT GROUP BY EMPNO);

--Problem 7
--Display employee number, last name, and activity number of all activities in the
--EMP_ACT table. However, the list should only be produced if there were any
--activities in 1982.
--Note: The EMP_ACT table in the Sample database of Windows has a duplicate row for
--employee number ‘000020’. This may effect the result.
SELECT E.EMPNO, LASTNAME, ACTNO
FROM EMPLOYEE AS E, EMPPROJACT AS EA
WHERE E.EMPNO = EA.EMPNO
AND EXISTS(SELECT * FROM EMPPROJACT WHERE 1982 BETWEEN YEAR(EMSTDATE) AND YEAR(EMENDATE));
