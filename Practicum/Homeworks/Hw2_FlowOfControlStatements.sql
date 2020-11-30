- 1. Задаване на схемата по подрабиране
SET SCHEMA FN71904# -- # -> statement terminator

-- 2. Създаване на модул в схемата
CREATE MODULE MOD_HW3#

-- 3. Създаване на асоциативен масив с индекс низ и стойности на масива също низове
ALTER MODULE MOD_HW3 ADD TYPE empDeptNamesArr AS VARCHAR(30) ARRAY[VARCHAR(36)]#

-- глобален курсор (константен курсор) - връща информация, не позволява правене на промени
ALTER MODULE MOD_HW3 ADD VARIABLE empDeptCurr
CURSOR CONSTANT (CURSOR FOR SELECT FIRSTNME || ' ' || LASTNAME, DEPTNAME, SALARY 
							FROM EMP AS E, DEPT AS D 
							WHERE E.WORKDEPT = D.DEPTNO)# 

--4. Създаване на процедура, която е част от модула.В нея има реализиран един cursor, while цикъл
--и се използва дефинирания асоциативен масив

ALTER MODULE MOD_HW3 ADD TYPE emplRowInfo AS 
ROW (empName VARCHAR(30), deptName ANCHOR DEPT.DEPTNAME, empSalary ANCHOR EMP.SALARY)#

ALTER MODULE FN71904.MOD_HW3 PUBLISH PROCEDURE list_emplInfo(IN in_salary ANCHOR EMP.SALARY)
BEGIN
	DECLARE empVar emplRowInfo;
	DECLARE empDeptArrVar empDeptNamesArr;
	DECLARE sqlcode INT;
	DECLARE empName VARCHAR(30);
	
	OPEN empDeptCurr;
	
	FETCH empDeptCurr INTO empVar; -- взимаме ред от курсора и го записва в променливата empVar
	WHILE sqlcode = 0 DO
		IF empVar.empSalary > in_salary
		THEN
			SET empDeptArrVar[empVar.empName] = empVar.deptName;
		END IF;
		FETCH empDeptCurr INTO empVar; -- минава на следващия ред
	END WHILE;
	
	SET empName = ARRAY_FIRST(empDeptArrVar); -- първия индекс от масива
	WHILE empName IS NOT NULL DO
		INSERT INTO FN71904.EMP_INFO 
		VALUES(CURRENT_TIMESTAMP, 'EMPL NAME: ' || empName || ' - DEPT NAME: ' || empDeptArrVar[empName]);
		SET empName = ARRAY_NEXT(empDeptArrVar, empName); -- минава на следващия индекс от масива
	END WHILE;
END#

-- отделна таблица, в която се записват данните от създадения асоциативен масив
CREATE TABLE EMP_INFO(
	CTIME TIMESTAMP,
	EMPINFO VARCHAR(200)
)#

DROP TABLE EMP_INFO#

SELECT * FROM EMP_INFO#

-- 5. Извикване на процедурата
CALL FN71904.MOD_HW3.list_emplInfo(20000)#
