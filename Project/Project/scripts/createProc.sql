SET SCHEMA FN71904#

-- ���������, ����� ��� �� ��� �� ������� ���� �������, ������ �� �� ����
-- ���������� �� ��������� ���, �������� ��� � ������ �� ������� �� ������ ������� �� ����� �����
-- ����� �� ��������� �� ������ �� ����������� ���� ������ ��������� �� �����������, 
-- ������ � ������ �� ������. ����������� ����� ���� �������� ���� �� ��������� ��������� �� ���������
-- � ����� �� ���� �� ���������� ������ � ���.

-- ������� ��������� �� ��������� �� ���������
CREATE PROCEDURE FN71904.createTableBySeason(IN p_tableName VARCHAR(50))
BEGIN
    DECLARE p_tableQuery VARCHAR(1000);
        SET p_tableQuery = 'CREATE TABLE ' || p_tableName || '(SERIALNAME VARCHAR(50),
        													   REALNAME VARCHAR(50),
        													   BIRTHDATE DATE)';
    PREPARE s1 FROM p_tableQuery;
    EXECUTE s1;
END#

-- ������� ��������� �� �������� �� ����� � ���������
CREATE PROCEDURE FN71904.insertIntoSeasonTable(IN p_tableName VARCHAR(50), IN v_actorSerialname VARCHAR(50),
							  IN v_actorRealname VARCHAR(50), IN v_actorBirthdate DATE)
LANGUAGE SQL
BEGIN
	DECLARE stmt VARCHAR(1000);
		SET stmt = 'INSERT INTO '|| p_tableName || ' VALUES (''' || v_actorSerialname || ''', '''
					|| v_actorRealname || ''', ''' || v_actorBirthdate || ''')';
	PREPARE s1 FROM stmt;
	EXECUTE s1;
END#


CREATE PROCEDURE FN71904.createSeasonInfo(IN p_seasonNo INTEGER, IN p_tableName VARCHAR(50), OUT p_tableCretedText VARCHAR(124), 
										  OUT p_tableInsertedText VARCHAR(124))
LANGUAGE SQL
SPECIFIC createSeasonInfo_345678
BEGIN
	DECLARE v_countActno INTEGER DEFAULT 0;
	DECLARE v_actorSerialname VARCHAR(50) DEFAULT ' ';
	DECLARE v_actorRealname VARCHAR(50) DEFAULT ' ';
	DECLARE v_actorBirthdate DATE;
	DECLARE at_end INTEGER DEFAULT 0;
	DECLARE not_found CONDITION FOR SQLSTATE '02000';
	DECLARE cursor1 CURSOR FOR SELECT A.SERIALNAME, A.REALNAME, A.BIRTHDATE
    						   FROM ACTORS AS A, STARSIN AS ST,
        							EPISODES AS E, SEASONS AS S
    						   WHERE A.SERIALNAME = ST.ACTORNAME
    						   AND ST.EPISODENAME = E.NAME
    						   AND E.SEASONNUMBER = S.NUMBER
   							   AND S.NUMBER = p_seasonNo;
	DECLARE CONTINUE HANDLER FOR not_found 
		SET at_end = 1;
	CALL FN71904.createTableBySeason(p_tableName);
OPEN cursor1;
	loop1: LOOP
		FETCH cursor1 INTO v_actorSerialname, v_actorRealname, v_actorBirthdate;
		IF at_end = 1 THEN 
			LEAVE loop1; 
		END IF;
			CALL FN71904.insertIntoSeasonTable(p_tableName, v_actorSerialname, v_actorRealname, v_actorBirthdate);
		SET v_countActno = v_countActno + 1;
	END LOOP;
SET p_tableCretedText = 'Table with name ' || p_tableName || ' was created';
SET p_tableInsertedText = v_countActno || ' rows was inserted';
END#

-- �������� �� �����������
CALL FN71904.createSeasonInfo(5, 'SEASON5TABLEINFO', ?, ?)#

SELECT * FROM SEASON5TABLEINFO#

DROP TABLE SEASON5TABLEINFO#



-- ���������, ����� ������� ��������� � ������� ������ ������� �����������.
-- ������������� �� ����� ������ �� �������� �� ���� ����� ����� �� � ������ � �������.
-- � ������� ������� �� ������� ����������� ���� � ��� �� ������������ �� ���������� � ����� � ����� � ����� �� �������

-- ��������� �� ����������� ����� � ������ ��� (����� �� �������) � ��������� �� ������ ���� ����� (����� �� ������� � ����������)
CREATE TYPE FN71904.actorsClassationArray AS INTEGER ARRAY[VARCHAR(50)]#

-- �������� ������ (���������� ������) 
CREATE VARIABLE FN71904.actorsClassationCurr
CURSOR CONSTANT (CURSOR FOR SELECT A.SERIALNAME,
       							  RANK() OVER (ORDER BY MAX(YEAR(S.ENDDATE - A.BIRTHDATE)) -
                            						    MIN(YEAR(S.STARTDATE - A.BIRTHDATE)) DESC )
							FROM ACTORS AS A, STARSIN AS ST,
    							 EPISODES AS E, SEASONS AS S
							WHERE A.SERIALNAME = ST.ACTORNAME
							AND ST.EPISODENAME = E.NAME
							AND E.SEASONNUMBER = S.NUMBER
							GROUP BY A.SERIALNAME)# 


CREATE TYPE FN71904.actorsClassationRowInfo AS 
ROW (actorName VARCHAR(50), actorRank INTEGER)#

CREATE PROCEDURE FN71904.actorsClassification()
LANGUAGE SQL
SPECIFIC topNFamousActors_56043
BEGIN
	DECLARE actorVar FN71904.actorsClassationRowInfo;
	DECLARE actorsClassationArrVar FN71904.actorsClassationArray;
	DECLARE actorName VARCHAR(50) DEFAULT ' ';
	DECLARE sqlcode INT;
	
	OPEN FN71904.actorsClassationCurr;
	
	FETCH FN71904.actorsClassationCurr INTO actorVar; 
	WHILE sqlcode = 0 DO
			SET actorsClassationArrVar[actorVar.actorName] = actorVar.actorRank;
		FETCH FN71904.actorsClassationCurr INTO actorVar; 
	END WHILE;
	
	SET actorName = ARRAY_FIRST(actorsClassationArrVar); 
	WHILE actorName IS NOT NULL DO
		INSERT INTO FN71904.ACTORS_CLASSATION_INFO 
		VALUES(CURRENT_TIMESTAMP, 'Actor serial name: ' || actorName || ' - classation: ' || actorsClassationArrVar[actorName]); 
		SET actorName = ARRAY_NEXT(actorsClassationArrVar, actorName); 
	END WHILE;
END#

-- �������� �� �����������
CALL FN71904.actorsClassification()#

-- ������� �������, � ����� �� �������� ������� �� ���������� ����������� �����
CREATE TABLE FN71904.ACTORS_CLASSATION_INFO(
	CTIME TIMESTAMP,
	ACTORINFO VARCHAR(500)
)#

SELECT * 
FROM FN71904.ACTORS_CLASSATION_INFO 
ORDER BY SUBSTR(ACTORINFO, LENGTH(ACTORINFO), 1)#

DROP TABLE FN71904.ACTORS_CLASSATION_INFO#


-- ���������, ����� ��� �� ��� �� ������ � ������� ������� ������� �� �������������, �����
-- �� �� ��������� ���� ������ �� �������, �� �� �� ���� ������� ����� � ����������� �� �� �������� �����.
-- ���� �������� �� ����������� �� ���� ���������� �� ���� �������������, ����� ���� � ����� ����� ���� �����.
CREATE PROCEDURE FN71904.usersStatistics(OUT p_hasForums VARCHAR(200), OUT p_hasNotForums VARCHAR(200)) 
LANGUAGE SQL
SPECIFIC usersStatistics_78428
BEGIN
	DECLARE v_hasForumsCount INTEGER DEFAULT 0;
	DECLARE v_hasNotForumsCount INTEGER DEFAULT 0;
	DECLARE v_username VARCHAR(24) DEFAULT ' ';
	DECLARE v_useremail VARCHAR(50) DEFAULT ' ';
	DECLARE at_end INTEGER DEFAULT 0;
	DECLARE not_found CONDITION FOR SQLSTATE '02000';
	DECLARE cursor1 CURSOR FOR SELECT USERNAME, EMAIL FROM USERS;
	DECLARE CONTINUE HANDLER FOR not_found 
		SET at_end = 1;	
OPEN cursor1;
	loop1: LOOP
		FETCH cursor1 INTO v_username, v_useremail;
		IF at_end = 1 THEN 
			LEAVE loop1; 
		END IF;
		IF v_username IN (SELECT USERNAME FROM EPISODEFORUMS) THEN
			SET v_hasForumsCount = v_hasForumsCount + 1;
		ELSE
			INSERT INTO FN71904.USERSOFFERS VALUES(v_username, v_useremail, CURRENT_TIMESTAMP);
			SET v_hasNotForumsCount = v_hasNotForumsCount + 1;
		END IF;
	END LOOP;	
SET p_hasForums = v_hasForumsCount || ' users have their own forums';	
SET p_hasNotForums = v_hasNotForumsCount || ' users have not yet created their own forums';
END#

-- �������� �� �����������
CALL FN71904.usersStatistics(?,?)#

-- �������, � ����� �� �� ����� ����������� �� ����������� �� �����������
CREATE TABLE FN71904.USERSOFFERS(
	USERNAME VARCHAR(24) NOT NULL,
	USEREMAIL VARCHAR(50) NOT NULL,
	CTIME TIMESTAMP
)#

SELECT * FROM FN71904.USERSOFFERS#

DROP TABLE FN71904.USERSOFFERS#









