SET SCHEMA FN71904#

CREATE OR REPLACE PROCEDURE DEMO1(IN VARNAME VARCHAR(128), OUT VARCOUNT INTEGER)
P1: BEGIN
	SELECT COUNT(*) INTO VARCOUNT 
	FROM SYSIBM.SYSTABLES
	WHERE CREATOR = 'DB2INST1' AND NAME LIKE VARNAME;
	
--	SET VARCOUNT = (SELECT COUNT(*)
--	FROM SYSIBM.SYSTABLES
--	WHERE CREATOR = 'DB2INST1' AND NAME LIKE VARNAME);
END P1#

CALL FN71904.DEMO1('DEPT', ?)#

-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE FN71904.GET_DEPT_INFO ( IN in_deptno CHAR(3) )
RESULT SETS 1
LANGUAGE SQL
BEGIN -- начало на процедурата
	DECLARE r_error int default 0;
	DECLARE SQLCODE int default 0; -- системна променлиа, пази код на грешката

	DECLARE CONTINUE HANDLER FOR SQLWARNING, SQLEXCEPTION, NOT FOUND
		BEGIN
			SET r_error = SQLCODE; -- присвоява се кода на дефинираната променлиа и се работи с него
		END;
		BEGIN
			DECLARE C1 CURSOR WITH RETURN FOR -- дефиниране на курсор - указател към резултатното множество
			SELECT DEPTNAME, MGRNO, LOCATION -- SQL заявка
			FROM DB2INST1.DEPT
			WHERE
			DEPTNO = in_deptno;
			-- Cursor left open for client application
			OPEN C1; -- отваряне на курсора - ако искаме да върне резултат
		END;
END# -- край на цялата процедура


CALL FN71904.GET_DEPT_INFO ('B01')#

-------------------------------------------------------------------------------------------------------------

-- процедура с 2 курсора
CREATE OR REPLACE PROCEDURE FN71904.DEPT_INFO ( IN in_deptno CHAR(3) )
RESULT SETS 2
LANGUAGE SQL
BEGIN 
	DECLARE r_error int default 0; -- Declaration statements
	DECLARE SQLCODE int default 0; 

	DECLARE CONTINUE HANDLER FOR SQLWARNING, SQLEXCEPTION, NOT FOUND -- Exception Handling
	BEGIN
		SET r_error = SQLCODE; -- Assignment statements
	END;
	BEGIN
		DECLARE C1 CURSOR WITH RETURN FOR 
			SELECT DEPTNAME, MGRNO, LOCATION -- взима данните за отдел с подаден DEPTNO
			FROM DB2INST1.DEPT 
			WHERE DEPTNO = in_deptno;
		DECLARE C2 CURSOR WITH RETURN FOR -- казваме за кое резултатно множество е курсора
			SELECT LASTNAME, FIRSTNME, BIRTHDATE LOCATION -- взима данните за мениджър с подаден DEPTNO
			FROM DB2INST1.EMP 
			WHERE EMPNO = (SELECT MGRNO FROM 
							DB2INST1.DEPT 
							WHERE DEPTNO = in_deptno);
	OPEN C1; 
	OPEN C2; 
	END;
END# 


CALL FN71904.DEPT_INFO ('B01')#

-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE FN71904.CURRENT_DAY_OF_YEAR ( out day_Of_Year int )
LANGUAGE SQL
P1: BEGIN
	DECLARE c_Date DATE;
	SET c_Date = CURRENT DATE;
	SET day_of_Year = dayofyear(c_Date); -- SET day_of_Year = dayofyear(CURRENT DATE);
END P1#


CALL FN71904.CURRENT_DAY_OF_YEAR (?)#

DROP PROCEDURE FN71904.CURRENT_DAY_OF_YEAR#
--DROP SPECIFIC PROCEDURE Specific name#
