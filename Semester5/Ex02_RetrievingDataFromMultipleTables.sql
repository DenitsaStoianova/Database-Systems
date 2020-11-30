SET SCHEMA DB2INST1;

-- RETRIEVING DATA FROM MULTIPLE TABLES

--For department D21 list PROJNO, DEPTNO,
--DEPTNAME, MGRNO, and LASTNAME.
SELECT P.PROJNO, D.DEPTNO, D.DEPTNAME, D.MGRNO, E.LASTNAME
FROM DEPARTMENT AS D
    JOIN PROJECT AS P
    ON D.DEPTNO = P.DEPTNO
    JOIN EMPLOYEE AS E
    ON D.MGRNO = E.EMPNO
WHERE D.DEPTNO = 'D21'
ORDER BY PROJNO;

--Display the name of department B01 and the name of the
--department it reports to.
-- SELF JOIN
SELECT D1.DEPTNAME, D2.DEPTNAME
FROM DEPARTMENT AS D1, DEPARTMENT AS D2
WHERE D1.ADMRDEPT = D2.DEPTNO -- отиваме в подотдела и го търсим в другата таблица
AND D1.DEPTNO = 'B01'; -- отдела който търсим

--Which employees are older than their manager?
SELECT E.LASTNAME AS EMP_LASTNME, E.BIRTHDATE AS EMP_BIRTHDATE,
       M.LASTNAME AS MNG_LASTNME, M.BIRTHDATE AS MNG_BIRTHDATE
FROM EMPLOYEE AS E, EMPLOYEE AS M, DEPARTMENT AS D -- добавяме един служител 2 пъти - единия път е в ролята на шеф
WHERE E.WORKDEPT = D.DEPTNO -- избираме служител
AND M.EMPNO = D.MGRNO -- избираме мениджър
AND E.BIRTHDATE < M.BIRTHDATE;

SELECT E.EMPNO, E.LASTNAME, E.BIRTHDATE, D.MGRNO
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE E.WORKDEPT = D.DEPTNO;


--Problem 1
--Produce a report that lists employees' last names, first names, and department
--names. Sequence the report on first name within last name, within department name.
SELECT E.LASTNAME, E.FIRSTNME, D.DEPTNAME
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE E.WORKDEPT = D.DEPTNO
ORDER BY  D.DEPTNAME, E.LASTNAME, E.FIRSTNME;

--Problem 2
--Modify the previous query to include job. Also, list data for only departments
--between A02 and D22, and exclude managers from the list. Sequence the report on
--first name within last name, within job, within department name.
SELECT E.LASTNAME, E.FIRSTNME, D.DEPTNAME, E.JOB
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE E.WORKDEPT = D.DEPTNO
AND JOB <> 'MANAGER'
AND D.DEPTNAME BETWEEN 'A02' AND 'D22'
ORDER BY D.DEPTNAME, E.LASTNAME, E.FIRSTNME;

--Problem 3
--List the name of each department and the lastname and first name of its manager.
--Sequence the list by department name. Sequence the result rows by department name.
SELECT D.DEPTNAME
FROM DEPARTMENT AS D, EMPLOYEE AS E
WHERE D.MGRNO = E.EMPNO -- директно взима мениджъра
ORDER BY D.DEPTNAME;

--Problem 4
--Try the following: modify the previous query using WORKDEPT and DEPTNO as the
--join predicate. Include a local predicate that looks for people whose job is manager.
SELECT D.DEPTNAME
FROM DEPARTMENT AS D, EMPLOYEE AS E
WHERE D.DEPTNO = E.WORKDEPT -- взима служителите и филтрира
AND E.JOB = 'MANAGER'
ORDER BY D.DEPTNAME;

--Problem 5
--For all projects that have a project number beginning with AD, list project number,
--project name, and activity number. List identical rows once. Order the list by project
--number and then by activity number.
SELECT DISTINCT PR.PROJNO, PR.PROJNAME, EA.ACTNO
FROM PROJECT AS PR, EMPPROJACT AS EA
WHERE PR.PROJNO = EA.PROJNO
AND PR.PROJNO LIKE 'AD%'
ORDER BY PR.PROJNO, EA.ACTNO;

--Problem 6
--Which employees are assigned to project number AD3113? List employee number,
--last name, and project number. Order the list by employee number and then by
--project number. List only one occurrence of duplicate result rows.
SELECT DISTINCT E.EMPNO, E.LASTNAME, EA.PROJNO
FROM EMPLOYEE AS E, EMPPROJACT AS EA
WHERE E.EMPNO = EA.EMPNO
AND EA.PROJNO = 'AD3113'
ORDER BY E.EMPNO, EA.PROJNO;

--Problem 7
--Which activities began on October 1, 1982? For each of these activities, list the
--employee number of the person performing the activity, the project number, project
--name, activity number, and starting date of the activity. Order the list by project
--number, then by employee number, and then by activity number.
SELECT EA.EMPNO, P.PROJNO, P.PROJNAME, EA.ACTNO, EA.EMSTDATE
FROM PROJECT AS P, EMPPROJACT AS EA
WHERE P.PROJNO = EA.PROJNO
AND EA.EMSTDATE = '1982-10-01'
ORDER BY P.PROJNO, EA.EMPNO, EA.ACTNO;

--Problem 8
--Display department number, last name, project name, and activity number for
--activities performed by the employees in department A00.
--Sequence the results first by project name and then by activity number.
SELECT E.WORKDEPT, E.LASTNAME, P.PROJNAME, EA.ACTNO
FROM EMPLOYEE AS E, PROJECT AS P, EMPPROJACT AS EA
WHERE E.EMPNO = P.RESPEMP
AND E.EMPNO = EA.EMPNO
AND E.WORKDEPT = 'A00'
ORDER BY P.PROJNAME, EA.ACTNO;

--Problem 9
--List department number, last name, project name, and activity number for those
--employees in work departments A00 through C01. Suppress identical rows.
--Sort the list by department number, last name, and activity number.
SELECT DISTINCT E.WORKDEPT, E.LASTNAME, P.PROJNAME, A.ACTNO
FROM EMPLOYEE E, PROJECT P, EMPPROJACT A
WHERE E.EMPNO = A.EMPNO
AND A.PROJNO = P.PROJNO
AND E.WORKDEPT BETWEEN 'A00' AND 'C01'
ORDER BY E.WORKDEPT, E.LASTNAME, A.ACTNO;

--Problem 10
--The second line manager needs a list of activities which began on October 15, 2002
--or thereafter.
--For these activities, list the activity number, the manager number of the manager of
--the department assigned to the project, the starting date for the activity, the project
--number, and the last name of the employee performing the activity.
--The list should be ordered by the activity number and then by the activity start date.
SELECT EA.ACTNO, D.DEPTNAME, D.MGRNO, EA.EMSTDATE, P.PROJNO, E.LASTNAME
FROM EMPPROJACT AS EA, PROJECT AS P, DEPARTMENT AS D, EMPLOYEE AS E
WHERE EA.PROJNO = P.PROJNO
AND P.DEPTNO = D.DEPTNO -- взимаме отдела към проекта - той пази в себе си своя мениджър
AND EA.EMPNO = E.EMPNO
AND EA.EMSTDATE >= '2002-10-15'
ORDER BY EA.ACTNO, EA.EMSTDATE;

--Problem 11
--Which employees in department A00 were hired before their manager?
--List department number, the manager's last name, the employee's last name, and
--the hiring dates of both the manager and the employee.
--Order the list by the employee's last name.
SELECT D.DEPTNO, M.LASTNAME AS MNG_LASTNME, M.HIREDATE AS MNG_HIREDATE,
       E.LASTNAME AS EMP_LASTNME, E.HIREDATE AS EMP_HIREDATE
FROM EMPLOYEE AS E, DEPARTMENT AS D, EMPLOYEE AS M
WHERE E.WORKDEPT = D.DEPTNO
AND M.EMPNO = D.MGRNO
AND DEPTNO = 'A00'
AND E.HIREDATE < M.HIREDATE
ORDER BY E.LASTNAME;

------------------------------------------------------------------------------------------------------

--Problem 1
--Display all employees who work in the INFORMATION CENTER department. Show
--department number, employee number and last name for all employees in that
--department. The list should be ordered by employee number.
--Use the "old" SQL syntax that puts the join condition in the WHERE clause.
SELECT WORKDEPT, EMPNO, LASTNAME
FROM EMPLOYEE AS E INNER JOIN DEPARTMENT D ON E.WORKDEPT = D.DEPTNO
AND D.DEPTNAME = 'INFORMATION CENTER'
ORDER BY E.EMPNO;

--Problem 2
--Bill needs a list of those employees whose departments are involved in projects.
--The list needs to show employee number, last name, department number, and
--project name. The list should be ordered by project names within employee numbers.
SELECT E.EMPNO, E.LASTNAME, E.WORKDEPT, P.PROJNAME
FROM EMPLOYEE AS E, DEPARTMENT AS D, PROJECT AS P
WHERE E.WORKDEPT = D.DEPTNO
AND D.DEPTNO = P.DEPTNO
ORDER BY E.EMPNO, P.PROJNAME;

--Problem 4
--Now Bill wants to see all employees, whether or not their departments are involved a
--project. The list needs to show the employee number, last name, department
--number, and project name. If the department of an employee is not involved in a
--project, display NULLs instead of the project name. The list should be ordered by
--project name within employee number
SELECT E.EMPNO, E.LASTNAME, E.WORKDEPT, P.PROJNAME
FROM EMPLOYEE AS E INNER JOIN DEPARTMENT AS D
ON E.WORKDEPT = D.DEPTNO -- взимаме всички назначени служители и отдели
LEFT JOIN  PROJECT AS P
ON D.DEPTNO = P.DEPTNO -- към тях долавяме проектите като може да има и null за проект
ORDER BY E.EMPNO, P.PROJNAME;

--Problem 5
--Now Bill wants to see all projects, including those assigned to departments without
--employees. The list needs to show employee number, last name, department
--number, and project name. If a project is not assigned to a department having
--employees, NULLS should be displayed instead of the department number,
--employee number and last name. The list should be ordered by employee number
--within project name.
SELECT E.EMPNO, E.LASTNAME, D.DEPTNO, P.PROJNAME
FROM EMPLOYEE AS E RIGHT JOIN DEPARTMENT AS D
ON E.WORKDEPT = D.DEPTNO
RIGHT JOIN PROJECT AS P
ON P.DEPTNO = D.DEPTNO
ORDER BY P.PROJNAME, E.EMPNO;

SELECT E.EMPNO, E.LASTNAME, D.DEPTNO, P.PROJNAME
FROM PROJECT AS P LEFT JOIN DEPARTMENT AS D
ON P.DEPTNO = D.DEPTNO
LEFT JOIN EMPLOYEE AS E
ON D.DEPTNO = E.WORKDEPT
ORDER BY P.PROJNAME, E.EMPNO;


--Last, Bill wants to see all projects and all employees in one report. Projects not
--assigned to departments having employees should also be listed as well as
--employees who work in departments which are not involved in projects. The list
--needs to show employee number, last name, department number, and project
--name. If a project is not assigned to a department having employees, NULLS should
--be displayed instead of the department number, employee number and last name. If
--the department of an employee is not involved in a project, display NULLs instead of
--the project name. The list should be ordered by project name within last name.
SELECT E.EMPNO, E.LASTNAME, D.DEPTNO, P.PROJNAME
FROM EMPLOYEE AS E RIGHT OUTER JOIN DEPARTMENT AS D
ON E.WORKDEPT = D.DEPTNO
FULL OUTER JOIN PROJECT AS P
ON D.DEPTNO = P.DEPTNO
ORDER BY E.LASTNAME, P.PROJNAME;
