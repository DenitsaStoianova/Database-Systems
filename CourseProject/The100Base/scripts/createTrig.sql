SET SCHEMA FN71904#


-- Тригер, който в отделна таблица записва информация за променения имейл на даден потребител, както и времето на промяната
CREATE TABLE FN71904.USEREMAILCHANGES(
	CHANGETIME TIMESTAMP,
	EMAILINFO VARCHAR(600) 
)#

CREATE TRIGGER trigUpdateEmail
AFTER UPDATE OF EMAIL ON FN71904.USERS
REFERENCING OLD AS O NEW AS N
FOR EACH ROW
	INSERT INTO FN71904.USEREMAILCHANGES 
	VALUES (CURRENT_TIMESTAMP, 'User ' || O.USERNAME || ' change his email from ' || O.EMAIL || ' to ' || N.EMAIL)#

SELECT * FROM FN71904.USEREMAILCHANGES#

SELECT * FROM USERS#

UPDATE FN71904.USERS 
SET EMAIL = 'idrenchevaa99@abv.com' 
WHERE USERNAME = 'iDrencheva'#	


SELECT * FROM EPISODEFORUMS#


-- Тригер, който при създаването на нов форум от даден потребител добавя коменар към форума,
-- където потребителя съобщава за добавения епизод към форума и открива тема за дискусия 
CREATE PROCEDURE FN71904.addFirstComment(IN p_episodeForumsName VARCHAR(50), IN p_publishDate DATE, IN p_username VARCHAR(24))
LANGUAGE SQL
SPECIFIC addFirstComment_24517
BEGIN
	DECLARE v_episodeName VARCHAR(50) DEFAULT '' ;
		SET v_episodeName = (SELECT EPISODENAME FROM EPISODEFORUMS WHERE NAME = p_episodeForumsName);
	INSERT INTO COMMENTS 
	VALUES ('1' || p_episodeForumsName, p_episodeForumsName, p_username, 
	'Hello, I just created my forum for ' || v_episodeName || ', so we can discuss it here.', p_publishDate);
END#


CREATE TRIGGER trigFirstComment
AFTER INSERT ON FN71904.EPISODEFORUMS
REFERENCING NEW AS N
FOR EACH ROW
	CALL FN71904.addFirstComment(N.NAME, N.CREATINGDATE, N.USERNAME)#

INSERT INTO EPISODEFORUMS(NAME, CREATINGDATE, TOTALCOMMENTSNUMBER, LIKESNUMBER, VISITSNUMBER, USERNAME, EPISODENAME)
VALUES ('1SEpisode', '2020-01-15', 3, 6, 13, 'martin65', 'Pilot')#

SELECT * FROM COMMENTS#

