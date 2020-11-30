-- 1. Задаване на схемата по подрабиране
SET SCHEMA FN71904# -- # -> statement terminator

-- 2. Копиране на структурата на таблиците EMP и DEPT от схемата DB2INST1 
CREATE TABLE EMP LIKE DB2INST1.EMPLOYEE#
CREATE TABLE DEPT LIKE DB2INST1.DEPARTMENT#

-- 3. Създаване на PK и FK за копираните таблици
ALTER TABLE EMP ADD CONSTRAINT EMP_PK PRIMARY KEY(EMPNO)#
ALTER TABLE DEPT ADD CONSTRAINT DEPT_PK PRIMARY KEY(DEPTNO)#

ALTER TABLE EMP ADD CONSTRAINT EMPDEPT_FK FOREIGN KEY (WORKDEPT) REFERENCES DEPT(DEPTNO)# 
ALTER TABLE DEPT ADD CONSTRAINT DEPTEMP_FK FOREIGN KEY (MGRNO) REFERENCES EMP(EMPNO)# 

-- 4. Копиране на данните от таблиците EMP и DEPT от схемата DB2INST1
INSERT INTO EMP (SELECT * FROM DB2INST1.EMPLOYEE)#
INSERT INTO DEPT (SELECT * FROM DB2INST1.DEPARTMENT)#

-- 5. Създаване на модул в схемата
CREATE MODULE MOD_EMPDEPT#

-- 6. Създаване на процедура, която по номер на отдел връща резултатно множество съдържащо име на отдела, 
-- името на неговия шеф, брой служители към отдела и средна заплата за отдела

ALTER MODULE MOD_EMPDEPT -- дефиниция на процедурата
PUBLISH PROCEDURE DEPT_INFO(IN in_deptno ANCHOR DEPT.DEPTNO)#

ALTER MODULE MOD_EMPDEPT -- имплементация 
ADD PROCEDURE DEPT_INFO(IN in_deptno ANCHOR DEPT.DEPTNO)
RESULT SET 1
BEGIN -- начало на процедурата
	DECLARE C1 CURSOR WITH RETURN FOR -- дефиниране на курсор - указател към резултатното множество
		SELECT D.DEPTNAME,
	   		   M.FIRSTNME || ' ' || M.LASTNAME AS MGR_NAME, 
	   		   COUNT(E.EMPNO) AS CNT_EMP, 
	   		   DECIMAL(AVG(E.SALARY), 8, 2) AS AVG_SAL
		FROM EMPLOYEE AS E, EMPLOYEE AS M, DEPT AS D
		WHERE E.WORKDEPT = D.DEPTNO
		AND M.EMPNO = D.MGRNO
		AND E.WORKDEPT = in_deptno
		GROUP BY D.DEPTNAME, M.FIRSTNME, M.LASTNAME;
	OPEN C1; -- отваряне на курсора - ако искаме да върне резултат
END# -- край на цялата процедура

-- 7. Извикване на процедурата
CALL FN71904.MOD_EMPDEPT.DEPT_INFO('D11')#
