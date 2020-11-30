SET SCHEMA FN71904#

--------------------------------------------------------------------------------------------------

CREATE TABLE EMPLOYEE LIKE DB2INST1.EMPLOYEE#
CREATE TABLE EMPACT LIKE DB2INST1.EMP_ACT#

INSERT INTO EMPLOYEE (SELECT * FROM DB2INST1.EMPLOYEE)#
INSERT INTO EMPACT (SELECT * FROM DB2INST1.EMP_ACT)#

ALTER TABLE EMPLOYEE ADD PRIMARY KEY(EMPNO)#
ALTER TABLE EMPACT ADD FOREIGN KEY(EMPNO) REFERENCES EMPLOYEE(EMPNO)#

SELECT * FROM EMPLOYEE#
SELECT * FROM EMPACT#

--------------------------------------------------------------------------------------------------

CREATE OR REPLACE MODULE MOD_EMP#

--ALTER MODULE MOD_EMP PUBLISH TYPE empRowType AS ANCHOR ROW EMP#
ALTER MODULE MOD_EMP ADD VARIABLE empRowType ANCHOR ROW FN71904.EMP#

ALTER MODULE MOD_EMP 
PUBLISH FUNCTION EMP_AGE(in_empno ANCHOR EMPLOYEE.EMPNO) 
RETURNS INT#

ALTER MODULE MOD_EMP -- дефиниция на процедурата
PUBLISH PROCEDURE EMP_STAJ(OUT in_empno ANCHOR EMPLOYEE.EMPNO)# -- ANCHOR - препратка към типа на EMPLOYEE.EMPNO

ALTER MODULE MOD_EMP DROP PROCEDURE EMP_STAJ# 

ALTER MODULE MOD_EMP DROP BODY# -- трие реализациите, оставя само дефинициите 

--------------------------------------------------------------------------------------------------


ALTER MODULE MOD_EMP -- имплементация
ADD PROCEDURE EMP_STAJ(IN in_empno ANCHOR EMPLOYEE.EMPNO, OUT out_result INT)
BEGIN
	SET out_result = (SELECT YEAR(CURRENT_DATE - HIREDATE) 
						FROM EMPLOYEE 
						WHERE EMPNO = in_empno);
END#

--------------------------------------------------------------------------------------------------

-- FUNCTION
ALTER MODULE MOD_EMP ADD FUNCTION EMP_AGE(IN in_empno ANCHOR EMP.EMPNO)
RETURNS INT
BEGIN
	DECLARE AGE INT;
	SET AGE = (SELECT YEAR(CURRENT_DATE - BIRTHDATE)
				FROM EMP
				WHERE EMPNO = in_empno);
	RETURN AGE;
END#


VALUES FN71904.MOD_EMP.EMP_AGE('000010')#


--ALTER MODULE MOD_EMP DROP FUNCTION EMP_AGE#

--------------------------------------------------------------------------------------------------

CREATE PROCEDURE FN71904.Proc1 (out p1_a integer, out p2_a integer)
RESULT SETS 2
LANGUAGE SQL
P1: BEGIN
	declare a integer default 5; -- PARAMETERS 
	declare c1 cursor with return for 
	select * from EMPLOYEE;
		P2: BEGIN
			declare a integer default 7;
			declare c2 cursor with return 
			for select * from EMPACT;
			open c2; -- реално изпълнение
			set p2_a = a;
		END P2;
	open c1; -- реално изпълнение
	set p1_a = a; -- задаване на стойност на променлива
END P1#


CALL FN71904.Proc1(?, ?)#

--------------------------------------------------------------------------------------------------

-- котрол на потока, разклоняване - if, else, loop, repeat

CREATE PROCEDURE FN71904.UPDATE_SAL(IN RATING INT, IN I_NUM ANCHOR EMPLOYEE.EMPNO)
BEGIN
IF rating = 1 THEN
	UPDATE EMPLOYEE
	SET salary = salary*1.10 WHERE empno = i_num;
ELSEIF rating = 2 THEN
	UPDATE EMPLOYEE
	SET salary = salary*1.05 WHERE empno = i_num;
ELSE
	UPDATE EMPLOYEE
	SET salary = salary*1.03 WHERE empno = i_num;
END IF;
END#


SELECT * FROM EMPLOYEE WHERE EMPNO = '000010'#
CALL FN71904.UPDATE_SAL(1, '000010')#
SELECT * FROM EMPLOYEE WHERE EMPNO = '000010'#


SELECT EMPNO, PROJNO FROM EMPACT#


SELECT EMPNO, RANK() OVER(ORDER BY BPROJ_PROJECTS) AS RANK 
FROM EMPACT#

SELECT EMPNO, 
	   COUNT(DISTINCT PROJNO) AS PROJNUM, -- обединяваме дейностите за всеки проект
	   RANK() OVER(ORDER BY COUNT(DISTINCT PROJNO) DESC) AS RANK 
FROM EMPACT 
GROUP BY EMPNO# 

--------------------------------------------------------------------------------------------------

-- VIEW
CREATE VIEW EMP_RANK AS
SELECT EMPNO, 
	   RANK() OVER(ORDER BY COUNT(DISTINCT PROJNO) DESC) AS RANK 
FROM EMPACT 
GROUP BY EMPNO# 

--------------------------------------------------------------------------------------------------

-- променя заплатите според съответния ранк
CREATE OR REPLACE PROCEDURE FN71904.UPDATE_SAL_RANK(OUT V_COUNT INT)
RESULT SETS 2
BEGIN
DECLARE COUNTER INT; 
	DECLARE C_BEFORE CURSOR WITH RETURN FOR SELECT EMPNO, SALARY FROM EMPLOYEE; -- за да видим разликата
	DECLARE C_AFTER CURSOR WITH RETURN FOR SELECT EMPNO, SALARY FROM EMPLOYEE;
	SET COUNTER = 0;
	OPEN C_BEFORE;
	FOR v1 AS -- променлива върху курсора C1
	c1 CURSOR 
	FOR SELECT EMPNO, RANK FROM EMP_RANK
		DO
			CALL FN71904.UPDATE_SAL(RANK, EMPNO);
			SET COUNTER = COUNTER + 1;
	END FOR;
	SET V_COUNT = COUNTER;
	OPEN C_AFTER;
END#

CALL FN71904.UPDATE_SAL_RANK(?)#

--------------------------------------------------------------------------------------------------

SELECT EMPNO, 
	   BIRTHDATE, 
	   COUNT(DISTINCT WORKDEPT) AS PROJNUM, 
	   RANK() OVER(ORDER BY BIRTHDATE ASC) AS RANK 
FROM EMPLOYEE 
GROUP BY EMPNO, BIRTHDATE# 

--------------------------------------------------------------------------------------------------

CREATE PROCEDURE TEST_FOR(OUT out_fullname CHAR(40))
RESULT SETS 1
BEGIN
DECLARE fullname CHAR(40);
	FOR v1 AS c1 CURSOR FOR SELECT firstnme, midinit, lastname, empno FROM employee -- заявка за която е дефиниран курсора
	DO -- обработване
		IF EMPNO = '000010' THEN 
			SET fullname = firstnme || ' ' ||midinit || ' ' || lastname;
		END IF;
	END FOR;
SET out_fullname = fullname;
END#

CALL TEST_FOR(?)#

--------------------------------------------------------------------------------------------------

SELECT * FROM EMPLOYEE#

-- проверяваме дали HIREDATE е 18 години след BIRTHDATE - ако е грешно - HIREDATE се сетва на NULL

CREATE PROCEDURE FN71904.CORRECT_HIREADTE()
BEGIN
	FOR v1 AS c1 CURSOR FOR SELECT EMPNO, HIREDATE, BIRTHDATE FROM EMPLOYEE
	DO
		IF v1.HIREDATE < v1.BIRTHDATE + 18 YEARS
			THEN UPDATE EMPLOYEE
				 SET HIREDATE = NULL
				 WHERE EMPNO = v1.EMPNO;
		END IF;
	END FOR;
END#

SELECT EMPNO, HIREDATE, BIRTHDATE FROM EMPLOYEE#
CALL FN71904.CORRECT_HIREADTE()#
SELECT EMPNO, HIREDATE, BIRTHDATE FROM EMPLOYEE#

--------------------------------------------------------------------------------------------------
