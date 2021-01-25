SET SCHEMA FN71904#

-- скрипт, в който са дефинирани функции и тестове с тях

-- Функция, която по подадено име на форум връща имейла на неговия собственик, за да бъде уведомен при
-- получаване на нови харесвания на форума си. В случай, че не е намерен съответния собственик,
-- се хвърля изключение с подходящ текст.
CREATE FUNCTION FN71904.episodeForumOwnerEmail(p_episodeForum VARCHAR(50))
RETURNS VARCHAR(50)
SPECIFIC watchlistOwnerEmail_435678
BEGIN ATOMIC
    DECLARE v_owner_email VARCHAR(50);
    DECLARE v_err VARCHAR(70);
    SET v_owner_email = (SELECT U.EMAIL
                      FROM USERS AS U, EPISODEFORUMS AS E
                      WHERE U.USERNAME = E.USERNAME
                      AND E.NAME = p_episodeForum);
    SET v_err = 'Error, email of ' || p_episodeForum || ' forum''s owner was not found.';
    IF v_owner_email IS NULL
        THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = v_err;
    END IF;
RETURN v_owner_email;
END#

-- Тестване на функцията
VALUES FN71904.episodeForumOwnerEmail('My Forum')#

-- Тестване на функцията с получаване на изключение
VALUES FN71904.episodeForumOwnerEmail('FavouritesForum')#

--Тестване на функцията в заявка
SELECT NAME AS EPISODEFORUMNAME, LIKESNUMBER, USERNAME,
       FN71904.episodeForumOwnerEmail(NAME) AS USEREMAIL
FROM EPISODEFORUMS
ORDER BY LIKESNUMBER DESC#

-- Функция, която връща основната информация зя епизод по подадено име.
CREATE FUNCTION FN71904.episodeBasicInfo(p_epname VARCHAR(50))
RETURNS TABLE(
    EPISODENAME VARCHAR(50),
    SEASONNUMBER INTEGER,
    DIRECTORNAME  VARCHAR(50),
    ACTORNAME VARCHAR(50)
)
SPECIFIC episodeBasicInfo_456789
RETURN
    SELECT E.NAME, S.NUMBER, D.NAME, A.SERIALNAME
    FROM EPISODES AS E, SEASONS AS S,
         DIRECTS AS DR, DIRECTORS AS D,
         STARSIN AS ST, ACTORS AS A
    WHERE E.SEASONNUMBER = S.NUMBER
    AND E.NAME = DR.EPISODENAME AND DR.UCNDIRECTOR = D.UCN
    AND E.NAME = ST.EPISODENAME AND ST.ACTORNAME = A.SERIALNAME
    AND E.NAME = p_epname#

--Тестване на функцията
SELECT * FROM TABLE (FN71904.episodeBasicInfo('Ye Who Enter Here')) T#


-- Функция, която връща информация за подаден брой най-популярни потребители.
-- Популярни потребители са тези, чиито форуми имат най-много харесвания
CREATE FUNCTION FN71904.topNMostPopularUsers(p_usersno INTEGER)
RETURNS TABLE(
    RANKCLASSATION INTEGER,
    USERNAME VARCHAR(24),
    USEREMAIL VARCHAR(50),
    TOTALLIKESNUMBER INTEGER,
    TOTALEPISODEFORUMSNUMBER INTEGER
             )
RETURN
    SELECT * FROM ( SELECT RANK() OVER (ORDER BY SUM(E.LIKESNUMBER) DESC) AS R,
           U.USERNAME, U.EMAIL, COUNT(E.NAME), SUM(E.LIKESNUMBER)
    FROM USERS AS U, EPISODEFORUMS AS E
    WHERE U.USERNAME = E.USERNAME
    GROUP BY U.USERNAME, U.EMAIL) T
    WHERE R <= p_usersno#

SELECT * FROM TABLE(FN71904.topNMostPopularUsers(6)) T#



