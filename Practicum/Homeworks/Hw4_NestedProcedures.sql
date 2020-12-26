-- Задаване на схемата по подрабиране 
SET SCHEMA FN71904# -- # -> statement terminator

-- Създавате процедура, в която да имате реализиран поне един cursor и в която извиквате друга процедура реализирана от вас. 
-- Използвайте таблиците EMP и DEPT от Домашно 2. Тествайте и двете процедури

-- Създаване на модул в схемата
CREATE MODULE MOD_HW4#

-- Процедура, която намира броя служители в даден отдел
ALTER MODULE FN71904.MOD_HW4 PUBLISH PROCEDURE count_employees(IN v_deptno CHAR(3), OUT v_count INT)
LANGUAGE SQL
SPECIFIC count_employees
BEGIN
	SELECT COUNT(E.EMPNO)
	INTO v_count
	FROM EMP AS E, DEPT AS D
	WHERE E.WORKDEPT = D.DEPTNO
	AND D.DEPTNO = v_deptno
	GROUP BY D.DEPTNO;
END#

-- Тестване на процедурата
CALL FN71904.MOD_HW4.count_employees('A00', ?)#

-- Целна на процедурата е да намери кандидатите за нов мениджър на даден отдел.
-- Процедурата приема номера на отдела, връща като резултат броя на кандидатите
-- и записва информацията за тях в нова таблица с предложение за увеличаване на заплатата им.
-- Кандидатите за нов мениджър са тези служители в отдела, които са били наети преди техния мениджър
-- (тъй като това означава, че имат повече опит от него).
-- Предложението е заплатите им да се вдигнат с толкова процента, колкото са служителите в съответния отдел.
ALTER MODULE FN71904.MOD_HW4 PUBLISH PROCEDURE managers_candidates(IN v_deptno CHAR(3), OUT v_candidates_result INT)
LANGUAGE SQL
SPECIFIC managers_candidates
BEGIN
	DECLARE v_emp_count INT DEFAULT 0;
	DECLARE v_mngno CHAR(6) DEFAULT ' ';
	DECLARE v_mngname VARCHAR(28) DEFAULT ' ';
	DECLARE v_empno CHAR(6) DEFAULT ' ';
	DECLARE v_empname VARCHAR(28) DEFAULT ' ';
	DECLARE v_emp_salary DECIMAL(9,2) DEFAULT 0;
	DECLARE v_candidates_count INT DEFAULT 0;
	DECLARE at_end INTEGER DEFAULT 0;
	DECLARE not_found CONDITION FOR SQLSTATE '02000';
	DECLARE cursor1 CURSOR FOR SELECT M.EMPNO, M.FIRSTNME || ' ' || M.LASTNAME, 
							   		  E.EMPNO, E.FIRSTNME || ' ' || E.LASTNAME, E.SALARY
						FROM EMP AS E, DEPT AS D, EMPLOYEE AS M
						WHERE E.WORKDEPT = D.DEPTNO
						AND M.EMPNO = D.MGRNO
						AND DEPTNO = v_deptno
						AND E.HIREDATE < M.HIREDATE;
	DECLARE CONTINUE HANDLER FOR not_found 
		SET at_end = 1;
	CALL FN71904.MOD_HW4.count_employees(v_deptno, v_emp_count);
OPEN cursor1;
	loop1: LOOP
		FETCH cursor1 INTO v_mngno, v_mngname, v_empno, v_empname, v_emp_salary;
		IF at_end = 1 THEN 
			LEAVE loop1; 
		END IF;
		INSERT INTO CANDIDATES_INFO
		VALUES(CURRENT_TIMESTAMP, v_deptno, v_mngno || ' - ' || v_mngname,
								  v_empno || ' - ' || v_empname,
								  v_emp_salary, 
								  v_emp_salary + v_emp_salary * (v_emp_count / 100.0));		
		SET v_candidates_count = v_candidates_count + 1;
	END LOOP;
SET v_candidates_result = v_candidates_count;
CLOSE cursor1;
END#

-- Тестване на процедурата
CALL FN71904.MOD_HW4.managers_candidates('A00', ?)#

-- Таблица, в която се записват кандидатите за нов мениджър, старата им заплата 
-- и предложението за увеличена заплата   
CREATE TABLE CANDIDATES_INFO(
	CTIME TIMESTAMP,
	WORKDEPT CHAR(3),
	MNGINFO VARCHAR(200),
	EMPINFO VARCHAR(200),
	EMP_OLDSALARY DECIMAL(9,2),
	EMP_NEWSALARY DECIMAL(9,2)  
)#


SELECT * FROM CANDIDATES_INFO#


-- Тестване на заявките от процедурите
SELECT COUNT(E.EMPNO)
FROM EMP AS E, DEPT AS D
WHERE E.WORKDEPT = D.DEPTNO
AND D.DEPTNO = 'A00'
GROUP BY D.DEPTNO#

SELECT M.EMPNO, M.FIRSTNME || ' ' || M.LASTNAME,
       E.EMPNO, E.FIRSTNME || ' ' || E.LASTNAME, E.SALARY
FROM EMP AS E, DEPT AS D, EMPLOYEE AS M
WHERE E.WORKDEPT = D.DEPTNO
AND M.EMPNO = D.MGRNO
AND DEPTNO = 'A00'
AND E.HIREDATE < M.HIREDATE#

SELECT D.DEPTNO, M.LASTNAME AS MNG_LASTNME, M.HIREDATE AS MNG_HIREDATE,
       E.LASTNAME AS EMP_LASTNME, E.HIREDATE AS EMP_HIREDATE, E.SALARY AS EMP_SALARY
FROM EMP AS E, DEPT AS D, EMPLOYEE AS M
WHERE E.WORKDEPT = D.DEPTNO
AND M.EMPNO = D.MGRNO
AND DEPTNO = 'A00'
AND E.HIREDATE < M.HIREDATE
ORDER BY E.LASTNAME#

