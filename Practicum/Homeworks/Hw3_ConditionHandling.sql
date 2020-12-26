SET SCHEMA FN71904#

-- 1. Създаване на процедура, в която да има реализиран поне един cursor, един цикъл (for, while или друг) 
-- и два Condition Handling

-- Целта на процедурата е да увеличи бонуса на даден мениджър на отдел с 5% от средната заплата за целия отдел
-- само ако в отдела има 5 или повече служители. В случай, че бонуса на мениджъра е NULL (т.е. мениджъра не получава бонус)
-- се хвърля изключение със съответното съобщение на потребителя.

-- 22002 - A null value, or the absence of an indicator parameter was detected; 
-- for example, the null value cannot be assigned to a variable, because no indicator variable is specified.

CREATE PROCEDURE FN71904.INCRMENT_BONUS()
LANGUAGE SQL
BEGIN
	DECLARE cursor_end INTEGER DEFAULT 0;
	DECLARE null_data CONDITION FOR SQLSTATE '22002';
	DECLARE v_deptno CHAR(3) DEFAULT ' ';
	DECLARE v_mngno CHAR(6) DEFAULT ' ';
	DECLARE v_mngbonus DECIMAL(9, 2) DEFAULT 0;
	DECLARE v_empcount INTEGER DEFAULT 0;
	DECLARE v_avgsalary DECIMAL(9, 2) DEFAULT 0;
	DECLARE not_nextline CONDITION FOR SQLSTATE '02000';
	DECLARE cursor1 CURSOR 
		FOR SELECT D.DEPTNO,
				   M.EMPNO,
				   M.BONUS,
       			   COUNT(E.EMPNO) AS CNT_EMP,
       			   DECIMAL(AVG(E.SALARY), 8, 2) AS AVG_SAL
			FROM EMP AS E, EMP AS M, DEPT AS D
			WHERE E.WORKDEPT = D.DEPTNO
			AND M.EMPNO = D.MGRNO
			GROUP BY D.DEPTNO, M.EMPNO, M.BONUS;
	DECLARE CONTINUE HANDLER FOR not_nextline
		SET cursor_end = 1;
	DECLARE CONTINUE HANDLER FOR null_data
		CALL DBMS_OUTPUT.PUT_LINE('Manager does not receive bonus.');
OPEN cursor1;
	loop1: LOOP
		FETCH cursor1 INTO v_deptno, v_mngno, v_mngbonus, v_empcount, v_avgsalary;
		IF cursor_end = 1 THEN
			LEAVE loop1;
		END IF;	
		IF v_empcount >= 5 THEN
			IF v_mngbonus IS NULL THEN
				SIGNAL null_data;
			ELSE
				UPDATE EMP 
					SET BONUS = v_mngbonus + v_avgsalary * 0.05
				WHERE EMPNO = v_mngno;
			END IF;
		END IF;
	END LOOP;
CLOSE cursor1;
END#

SELECT D.DEPTNO,
       COUNT(E.EMPNO) AS CNT_EMP,
       DECIMAL(AVG(E.SALARY), 8, 2) AS AVG_SAL,
       M.BONUS AS MNG_BONUS,
       M.EMPNO
FROM EMP AS E, EMP AS M, DEPT AS D
WHERE E.WORKDEPT = D.DEPTNO
AND M.EMPNO = D.MGRNO
GROUP BY D.DEPTNO, M.BONUS, M.EMPNO#

-- 2. Извикване на процедурата
CALL FN71904.INCRMENT_BONUS()#

