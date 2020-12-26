--SET SCHEMA DB2INST1;
SET SCHEMA DB2ADMIN;

-- CREATE OBJECTS

/*
създаване на таблица със същата стрктура, не се копират записите и ограниченията:
CREATE TABLE NEW_TABLE
LIKE OTHER_TABLE;

CREATE TABLE NEW_TABLE
AS (
SELECT COL1, COL2, COL3
FROM OTHER_TABLE
) DEFINITION ONLY;
*/

/*
добавяне на ограничения:
- при създаването на самата таблица
CREATE TABLE ORDER_ITEM(
ORDER_NO INT NOT NULL,
ART_NO INT NOT NULL,
QUANTITY SMALLINT NOT NULL
CONSTRAINT ORDER_LIMIT CHECK(QUANTITY <= 100),
CONSTRAINT OTHER_CONSTRAINT CHECK(SOMETHING)
)

- при промяна на таблицата
ALTER TABLE ORDER_ITEM DROP CONSTRAINT ORDER_LIMIT;

ALTER TABLE ORDER_ITEM ADD CONSTRAINT ORDER_LIMIT CHECK(QUANTITY <= 100);

- основни ограничения:
- PK - всяка таблица може да има само един, не може да е NULL
- FK - връзка между оделните таблици
- UNIQUE CONSTRAINT - може да са няколко за една таблица, поддържа NULL стойности
- CHECK - правила, които да се спазят при въвеждане на данните в таблицата,
          ако са повече от 1 се навързват с AND, (работи на ниво таблица)
*/


/*
VIEW - Изгледи
- обекти, които връщат резултатни множества
- дефинират се със заявка, но не приемат никакви входни параметри
- връщат резултатно множество от изпълнението на една заявка
- не може да съдържа ORDER BY
- всички данни, които са NOT NULL трябва да присъсват в изгледа
*/

/*
- Прости изгледи - в тях има само таблици
- дефинирани са върху 1,2 или повече таблици
- CREATE VIEW VIEW_NAME(NAME, DEPT) - резултатното множество се състои от колони с имена NAME и DEPT
- те трябва да бъдат в SELECT клаузата в заявката
- всеки път при обръщане към изгледа се изпълнява заявката
- третира се като таблица

- Йерархичен изглед - в нето има и други изгледи

- Цел на изгледите:
- 1 - опростявяне на заявките - може да съдържа само колоните от които имаме нужда в заявката
- 2 - реализиране на сигурност в базата данни - скрива информация и показва само определени данни на потребителя

- Има 2 вида изгледи:
- 1 - READ-ONLY - през него не може да се правят промени
    - забранени са INSERT, UPDATE, DELETE
    - ако в нето има съединение, групиране, агрегиращи функции - автоматично става READ-ONLY
- 2 - UPDATEABLE
    - за да може да се правят промени, изгледа трябва да е дефиниран само върху една таблица
    - всички NOT NULL колони трабва да присъстват в изгледа (всички колони, които изискват стойност)

- може да има CHECK опции - ако се прави UPDATE върху изгледа
- не трябва да се нарушава посоченото условие в WHERE клаузата в SELECT заявката при създаването на изгледа
- изгледа работи с данните на съответната таблица

- MERGE на изгледи
- сливане на заявката към изгледа с условието към него - ускорява извличането на информацията

- Материализирани изгледи - не позволяват MERGE на изгледи
- не позволява MERGE
- когато има агрегации - първо се взимат данните в изгледа и върху тях се прилага заявката
- резултата се записва на диска и върху него се прилага заявката
- по-бавни изгледи
*/

CREATE VIEW FN71904.EMP_DEPT_VIEW (EMP_NAME, DEPT_NAME)
AS SELECT LASTNAME, DEPTNAME
    FROM EMPLOYEE, DEPARTMENT
    WHERE WORKDEPT = DEPTNO;

SELECT  * FROM FN71904.EMP_DEPT_VIEW;

CREATE VIEW FN71904.EMP_PROJ
AS SELECT E.EMPNO, E.LASTNAME, E.WORKDEPT, P.PROJNO, P.PROJNAME
    FROM DB2ADMIN.EMPLOYEE AS E, DB2ADMIN.EMPPROJACT AS EA, DB2ADMIN.PROJECT AS P
    WHERE E.EMPNO = EA.EMPNO
    AND EA.PROJNO = P.PROJNO;

---------------------------------------------------------------------------------------------------------------------

/*
 Problem 1
Create the table EMP_DEPT with these columns:
 • EMPNO
 • LASTNAME
 • SALARY
 • DEPTNO
 • DEP_NAME
The data types and null characteristics for these columns should be the same as for
the columns with the same names in the EMPLOYEE and DEPARTMENT tables.
These tables are described in our course data model.
 */
CREATE TABLE FN71904.EMP_DEPT
AS (
    SELECT E.EMPNO, E.LASTNAME, E.SALARY, D.DEPTNO, D.DEPTNAME
    FROM EMPLOYEE AS E, DEPARTMENT AS D
) DEFINITION ONLY; -- създава се само структурата на таблицата, затова не е нужно да се съединявят двете таблици

SELECT * FROM FN71904.EMP_DEPT;

/*
The definition of the table should limit the values for the yearly salary (SALARY) column to ensure that:
 • The yearly salary for employees in department E11 (operations) must not exceed 28000.
 • No employee in any department may have a yearly salary that exceeds 50000.
*/
ALTER TABLE FN71904.EMP_DEPT
ADD CONSTRAINT CK_SALARY CHECK ((DEPTNO = 'E11' AND SALARY <= 28000) OR (DEPTNO <> 'E11' AND SALARY <= 50000));

/*
The values in the EMPNO column should be unique. The uniqueness should be
guaranteed via a unique index.
*/
-- автоматично се създава върху първичния ключ
-- разпределя данните от колоната във вид на дървовидна структура
-- всички стойности от колоната се намират в листата
CREATE UNIQUE INDEX INDEX_EMPNO
ON FN71904.EMP_DEPT(EMPNO);

/*
Create the table HIGH_SALARY_RAISE with the following columns:
 • EMPNO
 • PREV_SAL
 • NEW_SAL
The data type for column EMPNO is CHAR(6). The other columns should be defined
as DECIMAL(9,2). All columns in this table should be defined with NOT NULL.
*/
CREATE TABLE FN71904.HIGH_SALARY_RAISE(
    EMPNO CHAR(6) NOT NULL,
    PREV_SAL DECIMAL(9, 2) NOT NULL,
    NEW_SAL DECIMAL(9,2) NOT NULL
);

----------------------------------------------------------------------------------------------------------

/*
-Тригери
- използват се за реализиране на бизнес правила, които не могат да се напишат с CHECK CONSTRAINTS
- папример когато им ограничение, включващо 2 различни таблици

- Има 3 вида тригери:
- 1 - BEFORE - преди да настъпи дадено събитие - операциите в него не могат да задействат друг тригер
- 2 - AFTER - след като настъпи дадено събитие - операциите в него могат да задействат друг тригер
- 3 - INSTEAD OF - при промени в изглед, задейства се вместо самото събитие
- задействат се неявно при INSERT, UPDATE, DELETE
- един тригер се дефинира само за една таблица, указво се при каква промяна се задейства
- NO CASCADE - в рамките на тригера не може да се задейства друг тригер
- ако се изтрие дадена таблица се трие и съответния и тригер
*/

-- BEFORE TRIGGER
CREATE TRIGGER TRIG_HIREADTE
NO CASCADE BEFORE INSERT ON FN71904.EMP
REFERENCING NEW AS n -- NEW - таблица в която се пазят новите данни при INSERT
FOR EACH ROW -- FOR EACH STATEMENT - еднократно изпълнява действието на тригера независимо от броя на редовете
MODE DB2SQL
WHEN (n.HIREDATE IS NULL)
    SET n.HIREDATE = n.BIRTHDATE + 10 YEARS;

SELECT * FROM FN71904.EMP;

-- AFTER TRIGGER
CREATE TABLE TRIG_SALARY_AUDIT_TABLE(
    MYTIMESTAMP TIMESTAMP,
    COMMENT VARCHAR(1000)
);

CREATE TRIGGER TRIG_SALARY
AFTER UPDATE OF SALARY ON FN71904.EMP
REFERENCING OLD AS o NEW AS n
FOR EACH ROW
MODE DB2SQL
INSERT INTO TRIG_SALARY_AUDIT_TABLE
VALUES (
    CURRENT TIMESTAMP, 'Employee ' || o.EMPNO || ' salary changed from ' || CHAR(o.SALARY)
    || ' to ' || CHAR(n.SALARY) || ' by ' || USER
);


/*
Problem 2
After creating the table, you should add referential constraints.
The primary key for the EMP_DEPT table should be EMPNO.
*/
ALTER TABLE FN71904.EMP_DEPT
ADD CONSTRAINT PK_EMPNO
PRIMARY KEY(EMPNO);

/*
The EMP_DEPT table should only allow values in column EMPNO which exist in the
EMPLOYEE table. If an employee is deleted from the EMP table, the corresponding
row in the EMP_DEPT table should also be immediately deleted.
*/
ALTER TABLE FN71904.EMP_DEPT
ADD CONSTRAINT PK_EMPDEPT_EMP
FOREIGN KEY (EMPNO) REFERENCES DB2ADMIN.EMPLOYEE(EMPNO)
ON DELETE CASCADE; -- ако се изтрие запис от DB2ADMIN.EMPLOYEE(EMPNO) - се изтрива и от FN71904.EMP_DEPT

/*
The EMP_DEPT table should only allow values in column DEPTNO which exist in the
DEPARTMENT table. It should not be possible to delete a department from the
DEPARTMENT table as long as a corresponding DEPTNO exists in the EMP_DEPT
table.
 */
ALTER TABLE FN71904.EMP_DEPT
ADD CONSTRAINT PK_EMPDEPT_DEPT
FOREIGN KEY (DEPTNO) REFERENCES DB2ADMIN.DEPARTMENT(DEPTNO);

/*
Problem 4
Now, you should insert data in the EMP_DEPT table. Use the combined contents of
tables EMPLOYEE and DEPARTMENT as the source for your data.
*/
INSERT INTO FN71904.EMP_DEPT
 SELECT EMPNO, LASTNAME, SALARY, DEPTNO, DEPTNAME
    FROM EMPLOYEE, DEPARTMENT
    WHERE WORKDEPT = DEPTNO
    AND ((DEPTNO = 'E11' AND SALARY <= 28000) OR (DEPTNO <> 'E11' AND  SALARY <= 50000));

-- с INSERT може да се вмъкнат съответните данни ат друга таблица

/*
Problem 3
Klaus must update the yearly salaries for the employees of the EMPDEPT table. If
the new value for a salary exceeds the previous value by 10 percent or more,
Harvey wants to insert a row into the HIGH_SALARY_RAISE table. The values in
this row should be the employee number, the previous salary, and the new salary.
Create something in DB2 that will ensure that a row is inserted into the
HIGH_SALARY_RAISE table whenever an employee of the EMPDEPT table gets a
raise of 10 percent or more.
 */
CREATE TRIGGER FN71904.TRIG_UPDATE_SAL
    AFTER UPDATE OF SALARY ON FN71904.EMP_DEPT
    REFERENCING OLD AS O NEW AS N
    FOR EACH ROW -- STATEMENT - изпълнява се еднократно за един ред
        WHEN (N.SALARY > 1.1 * O.SALARY) -- ако навата стойност на заплатата е по-голяма от старата с 10%
            INSERT INTO FN71904.HIGH_SALARY_RAISE(EMPNO, PREV_SAL, NEW_SAL)
            VALUES (O.EMPNO, O.SALARY, N.SALARY);

SELECT * FROM FN71904.HIGH_SALARY_RAISE;

UPDATE FN71904.EMP_DEPT
SET SALARY = 1.2*SALARY
WHERE SALARY < 37000;

-- 1.Създайте изглед, който да връща номер на департамент, номер на работник,
-- заплата, номер на шефа на отдела, в който работи и заплатата на шефа.
CREATE VIEW V_SAL_EMP_MGR
AS
    SELECT E.WORKDEPT, E.EMPNO, E.SALARY AS EMPSAL, D.MGRNO,
           (SELECT SALARY FROM EMPLOYEE WHERE EMPNO = D.MGRNO) AS MGRSAL
    FROM EMPLOYEE AS E, DEPARTMENT AS D
    WHERE E.WORKDEPT = D.DEPTNO;

SELECT * FROM  V_SAL_EMP_MGR;

-- 2.1.Създайте тригер за таблицата employee,
-- който при всяка промяна на заплатата на работник обновява заплатата на шефа на този департамент с
-- 10%. Като използвате изгледа от 1 тествайте тригера за департамент 'C01'
-- ще има разлики само в стойностите на заплатите
-- в таблиците OLD и NEW се съдържат само променените данни
CREATE TRIGGER FN71904.TRIG_UPDATE_SAL_EMP
    AFTER UPDATE OF SALARY ON DB2ADMIN.EMPLOYEE
    REFERENCING OLD AS O NEW AS N
    FOR EACH ROW
        WHEN(O.EMPNO != (SELECT MGRNO FROM EMPLOYEE, DEPARTMENT -- шефа на департмента в който работе служителя, чиято заплата увеличаваме
                        WHERE DEPTNO = O.WORKDEPT AND EMPNO = O.EMPNO)) -- ако служителя не е шеф - обновяваме заплатата му
            UPDATE EMPLOYEE
            SET SALARY = 1.1*SALARY
            WHERE EMPNO = (SELECT MGRNO FROM EMPLOYEE, DEPARTMENT -- обновяваме заплатата на шефа на департмента
                        WHERE DEPTNO = O.WORKDEPT AND EMPNO = O.EMPNO);

UPDATE  DB2ADMIN.EMPLOYEE
SET SALARY = SALARY + 100
WHERE EMPNO = '000140';

/*
- Функции
- има 2 вида функции
- 1 - връщат скалар - SELECT, WHERE
- 2 - връщат резултатно множество(таблица) - FROM
*/

-- скаларна функция
CREATE FUNCTION FN71904.deptname(p_empno VARCHAR(6))
RETURNS VARCHAR(30)
SPECIFIC deptname
BEGIN ATOMIC
    DECLARE v_deptname VARCHAR(30);
    DECLARE v_err VARCHAR(70);
    SET v_deptname = (SELECT DEPTNAME
                      FROM DB2ADMIN.DEPARTMENT D, DB2ADMIN.EMPLOYEE E
                      WHERE E.WORKDEPT = D.DEPTNO AND E.EMPNO = p_empno);
    SET v_err = 'Error, employee was not found.';
    IF v_deptname IS NULL
        THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = v_err;
    END IF;
RETURN v_deptname;
END;

-- извикване на функцията
SELECT FN71904.deptname('000010') FROM SYSIBM.SYSDUMMY1;
-- или
VALUES FN71904.deptname('000010');

-- функция, която връща повече от една стойност
CREATE FUNCTION FN71904.getEnumEmployee(p_deptno CHAR(3))
RETURNS TABLE(
    EMPNO CHAR(6),
    LASTNAME VARCHAR(15),
    FIRSTNAME VARCHAR(12))
SPECIFIC getEnumEmployee
RETURN
    SELECT EMPNO, LASTNAME, FIRSTNME
    FROM DB2ADMIN.EMPLOYEE
    WHERE WORKDEPT = p_deptno;

SELECT * FROM
TABLE (FN71904.getEnumEmployee('A00')) T;


--2.2. Създайте тригер за таблицата employee,
--който при изтриване на ред от таблицата employee,
--записва номера на работника, име, дата на наемане,
--заплата и дата на изтриване в таблица employee_del,
--само за тези работници чиято длъжност е 'MANAGER'.
--(За целта, трябва предварително да сте създали таблицата employee_del със съответните колони)
CREATE TABLE FN71904.EMPLOYEE_DEL
AS(
    SELECT EMPNO, LASTNAME, HIREDATE, SALARY, CURRENT_TIMESTAMP AS FIREDATE
    FROM EMPLOYEE
) DEFINITION ONLY;


CREATE TRIGGER FN71904.TRIG_DEL_MGR
AFTER DELETE ON DB2ADMIN.EMPLOYEE
    REFERENCING OLD AS O
    FOR EACH ROW
    WHEN(O.EMPNO IN (SELECT MGRNO FROM DEPARTMENT))
        INSERT INTO FN71904.EMPLOYEE_DEL -- въвеждат се изтритите мениджъри в таблицата
        VALUES(O.EMPNO, O.LASTNAME, O.HIREDATE, O.SALARY, CURRENT_TIMESTAMP);

SELECT * FROM FN71904.EMPLOYEE_DEL;

DELETE FROM DB2ADMIN.EMPLOYEE
WHERE EMPNO = '000140';

CREATE FUNCTION FN71904.getDeptname(v_empno CHAR(6))
RETURNS VARCHAR(50)
SPECIFIC getDeptname
    RETURN SELECT DEPTNAME
            FROM DB2ADMIN.DEPARTMENT, DB2ADMIN.EMPLOYEE
            WHERE DEPTNO = WORKDEPT
            AND EMPNO = v_empno;

SELECT LASTNAME, WORKDEPT, FN71904.getDeptname(EMPNO) AS DNAME
FROM DB2ADMIN.EMPLOYEE
WHERE WORKDEPT IN ('C01', 'B01');

VALUES FN71904.getDeptname('000010');

CREATE FUNCTION FN71904.EMP_DEPT(v_deptno CHAR(3))
RETURNS TABLE (EMPNO CHAR(6),
                LASTNAME VARCHAR(20),
                HIREDATE DATE)
SPECIFIC RMP_DEPT_653729
RETURN
    SELECT EMPNO, LASTNAME, HIREDATE
    FROM EMPLOYEE
    WHERE WORKDEPT = v_deptno;

SELECT * FROM TABLE(FN71904.EMP_DEPT('A00')) T;

-- Напишете функция за таблицата employee, която връща възрастта на работника към момента в години
CREATE FUNCTION FN71904.AGE(v_empno CHAR(6))
RETURNS INT
RETURN SELECT YEAR(CURRENT_DATE  - BIRTHDATE) AS AGE
        FROM EMPLOYEE
        WHERE EMPNO = v_empno;

VALUES FN71904.AGE('000010');

-- Напишете функция за таблицата employee, която връща трудовия стаж на работника към момента в години
CREATE FUNCTION FN71904.EXPERIENCE_YEARS(v_empno CHAR(6))
RETURNS INT
RETURN SELECT YEAR(CURRENT_DATE  - HIREDATE) AS AGE
        FROM EMPLOYEE
        WHERE EMPNO = v_empno;

-- Напишете функция за таблицата employee, която връща последно име на работника и
-- заплатата му за тези работници които са от департамент подаден като входен параметър за функцията.
CREATE FUNCTION TEST(v_deptno CHAR(3))
RETURNS TABLE (
    LASTNAME VARCHAR(30),
    SALARY DECIMAL(9,2)
)
RETURN SELECT LASTNAME, SALARY
        FROM EMPLOYEE
        WHERE WORKDEPT = v_deptno;

SELECT * FROM TABLE(DB2ADMIN.TEST('CO1')) T;

-- Като използвате горните функции, създайте изглед за таблицата employee,
-- която връща трудовия стаж на работника в години, годините на работника,
-- стойността на заплатата, пола и номера на работника, само за тези работници на възраст
-- над 59 години за жените и на възраст над 62 години за мъжете.
CREATE VIEW VIEW_EMP_TEST
AS
SELECT FN71904.EXPERIENCE_YEARS(EMPNO) AS EXPERIENCE,
       FN71904.AGE(EMPNO) AS AGE,
       SEX,
       EMPNO
FROM DB2ADMIN.EMPLOYEE
WHERE (FN71904.AGE(EMPNO) > 59 AND SEX = 'F') OR
      (FN71904.AGE(EMPNO) > 62 AND SEX = 'M');

SELECT * FROM VIEW_EMP_TEST;

/*
Problem 3
Klaus must update the yearly salaries for the employees of the EMPDEPT table. If
the new value for a salary exceeds the previous value by 10 percent or more,
Harvey wants to insert a row into the HIGH_SALARY_RAISE table. The values in
this row should be the employee number, the previous salary, and the new salary.
Create something in DB2 that will ensure that a row is inserted into the
HIGH_SALARY_RAISE table whenever an employee of the EMPDEPT table gets a
raise of 10 percent or more.
 */
CREATE TRIGGER TRIG
AFTER UPDATE OF SALARY ON DB2ADMIN.EMPLOYEE
REFERENCING OLD AS O NEW AS N
    FOR EACH ROW
    WHEN (N.SALARY > O.SALARY * 1.1)
        INSERT INTO FN71904.HIGH_SALARY_RAISE
        VALUES (O.EMPNO, O.SALARY, N.SALARY);


