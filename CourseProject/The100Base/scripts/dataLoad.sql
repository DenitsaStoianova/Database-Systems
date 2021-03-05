SET SCHEMA FN71904#

-- скрипт за попълване на таблиците

INSERT INTO SEASONS(NUMBER, EPISODESNO, STARTDATE, ENDDATE)
VALUES (1, 13, '2014-03-19', '2014-06-11'),
       (2, 16, '2014-10-22', '2015-03-11'),
       (3, 16, '2016-01-21', '2016-05-19'),
       (4, 13, '2017-02-01', '2017-05-24'),
       (5, 13, '2018-04-24', '2018-08-07'),
       (6, 13, '2019-04-30', '2019-08-06'),
       (7, 16, '2020-05-20', '2020-09-30')#

INSERT INTO EPISODES(NAME, NUMBER, RATING, STARTDATE, LENGTH, SEASONNUMBER)
VALUES ('Pilot', 1, 7.5, '2014-03-19', '00:42:00', 1),
       ('Earth Skills', 2, 7.5, '2014-03-26', '00:45:00', 1),
       ('Earth Kills', 3, 7.9, '2014-04-02', '00:43:00', 1),
       ('The 48', 1, 8.4, '2014-10-22', '00:43:00', 2),
       ('Inclement Weather', 2, 8.3, '2014-10-29', '00:43:00', 2),
       ('Reapercussions', 3, 8.3, '2014-11-05', '00:43:00', 2),
       ('Wanheda: Part 1', 1, 8.0, '2016-01-21', '00:42:00', 3),
       ('Wanheda: Part 2', 2, 8.4, '2016-01-28', '00:42:00', 3),
       ('Ye Who Enter Here', 3, 8.9, '2016-02-04', '00:43:00', 3),
       ('Echoes', 1, 8.9, '2017-02-01', '00:31:00', 4),
       ('A Lie Guarded', 4, 8.2, '2017-02-22', '00:42:00', 4),
       ('The Tinder Box', 5, 8.4, '2017-03-01', '00:43:00', 4),
       ('Eden', 1, 8.8, '2018-04-24', '00:42:00', 5),
       ('How We Get to Peace', 8, 8.6, '2018-06-26', '00:42:00', 5),
       ('Sic Semper Tyrannis', 9, 8.9, '2018-07-10', '00:42:00', 5),
       ('Sanctum', 1, 8.7, '2019-04-30', '00:42:00', 6),
       ('Red Sun Rising', 2, 8.7, '2019-05-07', '00:42:00', 6),
       ('The Face Behind the Glass', 4, 8.7, '2019-05-21', '00:42:00', 6),
       ('From the Ashes', 1, 8.1, '2020-05-20', '00:41:00', 7),
       ('The Garden', 2, 8.2, '2020-05-27', '00:41:00', 7)#

INSERT INTO TRAILERS(STARTDATE, SEASONNUMBER, LENGTH)
VALUES ('2017-02-20', 1, '00:01:26'),
       ('2012-02-09', 2, '00:02:21'),
       ('2013-03-02', 3, '00:01:25'),
       ('2014-01-12', 4, '00:01:43'),
       ('2015-01-30', 5, '00:02:05'),
       ('2016-03-09', 6, '00:01:41'),
       ('2017-05-24', 7, '00:01:48')#

INSERT INTO ACTORS(SERIALNAME, REALNAME, BIRTHDATE)
VALUES ('Clarke Griffin', 'Eliza Taylor', '1989-10-24'),
       ('Octavia Blake', 'Marie Avgeropoulos', '1986-06-17'),
       ('Bellamy Blake', 'Bob Morley', '1984-12-20'),
       ('Raven Reyes', 'Lindsey Morgan', '1990-02-27'),
       ('John Murphy', 'Richard Harmon', '1991-08-18'),
       ('Dr. Abigail Griffin', 'Paige Turco', '1965-04-17'),
       ('Henry Ian Cusick', 'Marcus Kane', '1967-04-17'),
       ('Monty Green', 'Christopher Larkin', '1987-10-02'),
       ('Nathan Miller', 'Jarod Joseph', '1985-10-09'),
       ('Thelonious Jaha', 'Isaiah Washington', '1963-08-03'),
       ('Dr. Eric Jackson', 'Sachin Sahel', '1985-07-28'),
       ('Dr. Gabriel Santiago', 'Chuku Modu', '1990-06-19'),
       ('Jordan Green', 'Shannon Kook', '1987-01-09')#

INSERT INTO STARSIN(EPISODENAME, ACTORNAME)
VALUES ('The Garden', 'Clarke Griffin'),
       ('The Garden', 'Bellamy Blake'),
       ('The Garden', 'Octavia Blake'),
       ('The Garden', 'Dr. Gabriel Santiago'),
       ('The Garden', 'Raven Reyes'),
       ('From the Ashes', 'Clarke Griffin'),
       ('From the Ashes', 'Bellamy Blake'),
       ('From the Ashes', 'Octavia Blake'),
       ('From the Ashes', 'Dr. Gabriel Santiago'),
       ('From the Ashes', 'Raven Reyes'),
       ('From the Ashes', 'Dr. Eric Jackson'),
       ('Sanctum', 'Clarke Griffin'),
       ('Sanctum', 'Bellamy Blake'),
       ('Sanctum', 'Octavia Blake'),
       ('Sanctum', 'Dr. Gabriel Santiago'),
       ('Sanctum', 'Raven Reyes'),
       ('Sanctum', 'Dr. Eric Jackson'),
       ('Sanctum', 'Dr. Abigail Griffin'),
       ('Red Sun Rising', 'Clarke Griffin'),
       ('Red Sun Rising', 'Bellamy Blake'),
       ('Red Sun Rising', 'Octavia Blake'),
       ('Red Sun Rising', 'Dr. Abigail Griffin'),
       ('Red Sun Rising', 'Raven Reyes'),
       ('The Face Behind the Glass', 'Clarke Griffin'),
       ('The Face Behind the Glass', 'Bellamy Blake'),
       ('The Face Behind the Glass', 'Octavia Blake'),
       ('The Face Behind the Glass', 'Dr. Abigail Griffin'),
       ('The Face Behind the Glass', 'Raven Reyes'),
       ('The Face Behind the Glass', 'Jordan Green'),
       ('Eden', 'Clarke Griffin'),
       ('Eden', 'Bellamy Blake'),
       ('Eden', 'Octavia Blake'),
       ('Eden', 'Dr. Gabriel Santiago'),
       ('Eden', 'Raven Reyes'),
       ('Eden', 'John Murphy'),
       ('Eden', 'Dr. Abigail Griffin'),
       ('The Tinder Box', 'Clarke Griffin'),
       ('The Tinder Box', 'Bellamy Blake'),
       ('The Tinder Box', 'Octavia Blake'),
       ('The Tinder Box', 'Raven Reyes'),
       ('The Tinder Box', 'John Murphy'),
       ('Ye Who Enter Here', 'Dr. Abigail Griffin'),
       ('Ye Who Enter Here', 'Clarke Griffin'),
       ('Ye Who Enter Here', 'Bellamy Blake'),
       ('Ye Who Enter Here', 'Octavia Blake'),
       ('Ye Who Enter Here', 'Raven Reyes')#

INSERT INTO DIRECTORS(UCN, NAME, BIRTHDATE)
VALUES ('8965436782', 'Bharat Nalluri', '1965-04-15'),
       ('6432567891', 'Dean White', '1923-09-24'),
       ('9765438906', 'John F. Showalter', '1981-03-25'),
       ('6389658341', 'Mairzee Almas', '1995-08-22'),
       ('4315638986', 'Antonio Negret', '1982-02-13'),
       ('9473616787', 'Ian Samoil', '1986-05-04'),
       ('3672615784', 'Ed Fraiman', '1973-12-18'),
       ('8457268723', 'Alex Kalymnios', '1988-07-18'),
       ('5472383038', 'Tim Scanlan', '1978-05-15')#

INSERT INTO DIRECTS(UCNDIRECTOR, EPISODENAME)
VALUES ('8965436782', 'Pilot'),
       ('6432567891', 'Earth Skills'),
       ('6432567891', 'Earth Kills'),
       ('6432567891', 'The 48'),
       ('9765438906', 'Inclement Weather'),
       ('6432567891', 'Reapercussions'),
       ('6432567891', 'Wanheda: Part 1'),
       ('6389658341', 'Wanheda: Part 2'),
       ('4315638986', 'Ye Who Enter Here'),
       ('6432567891', 'Echoes'),
       ('9473616787', 'A Lie Guarded'),
       ('9765438906', 'The Tinder Box'),
       ('6432567891', 'Eden'),
       ('4315638986', 'How We Get to Peace'),
       ('9473616787', 'Sic Semper Tyrannis'),
       ('3672615784', 'Sanctum'),
       ('8457268723', 'Red Sun Rising'),
       ('5472383038', 'The Face Behind the Glass'),
       ('3672615784', 'From the Ashes'),
       ('6432567891', 'The Garden')#

INSERT INTO USERS(USERNAME, EMAIL, PASSWORD)
VALUES ('niki34213', 'nikolaypetrov@gmail.com', '12345678N'),
       ('aleks44213', 'aleks.petrova@gmail.com', '346256678A'),
       ('iva6782132', 'ivaila.naidenova@gmail.com', 'Iva8764567'),
       ('20122petur', 'ppetkov@gmail.com', 'petkov20'),
       ('ivan2432', 'ivannikolov@gmail.com', '732567936'),
       ('deniP342132', 'deniyordanova@gmail.com', 'dY45637567'),
       ('kiril002332', 'kirilstoyanov@gmail.com', 'kiro64543'),
       ('nati65213', 'nati.stoqnova@gmail.com', '56479r67Na'),
       ('petia27213', 'petiaivanova@gmail.com', 'p872453456'),
       ('georgiD', 'georgidenchev@gmail.com', '883657056GD'),
       ('martin65', 'martin.nikolaev@gmail.com', 'MN5784967'),
       ('mariaE67438', 'mariaelenkova@gmail.com', '536784567'),
       ('cveti996748', 'cvkarstov@gmail.com', 'k654323456'),
       ('nansiD56784', 'nansidimitrova@gmail.com', 'nansi994567'),
       ('anIlieva', 'antonia.ilieva@gmail.com', '67843456an'),
       ('iDrencheva', 'inadrencheva@gmail.com', 'id56784456'),
       ('krasiRy7848', 'krasimir.r@gmail.com', 'k7438845456'),
       ('vasi9956638', 'vasilenakaraivanova@gmail.com', '456783462vs')#

INSERT INTO EPISODEFORUMS(NAME, CREATINGDATE, TOTALCOMMENTSNUMBER, LIKESNUMBER, VISITSNUMBER, USERNAME, EPISODENAME)
VALUES ('Season1 Episode1', '2020-01-15', 3, 6, 13, 'martin65', 'Pilot'),
       ('Fav Episode', '2020-10-10', 1, 18, 20, 'deniP342132', 'Earth Kills'),
       ('My Forum', '2020-06-13', 2, 12, 22, 'nansiD56784', 'Inclement Weather'),
       ('Episode Ye Who Enter Here', '2020-11-04', 7, 2, 4, 'kiril002332', 'Ye Who Enter Here'),
       ('Favourite', '2020-04-16', 4, 9, 16, 'anIlieva', 'A Lie Guarded'),
       ('EpisodeSanctum', '2019-12-24', 5, 30, 33, 'niki34213', 'Sanctum'),
       ('My favourite episode', '2020-09-19', 5, 8, 9, 'vasi9956638', 'Sic Semper Tyrannis'),
       ('Season1Episode1', '2020-01-25', 3, 7, 20, 'cveti996748', 'Pilot')#

INSERT INTO COMMENTS(NUMBER, EPISODEFORUMNAME, USERNAME, TEXT, PUBLISHDATE)
VALUES ('1Season1 Episode1', 'Season1 Episode1', 'martin65', 'This is my forum.', '2020-01-15'),
       ('2Season1 Episode1', 'Season1 Episode1', 'deniP342132', 'I love this episode.', '2020-06-15'),
       ('3Season1 Episode1', 'Season1 Episode1', 'vasi9956638', 'This serial is very interesting.', '2020-01-15'),
       ('1Fav Episode', 'Fav Episode', 'anIlieva', 'This epidoe is very interesting.', '2020-12-10'),
       ('1My Forum', 'My Forum', 'cveti996748', 'Nice', '2020-07-13'),
       ('1Episode Ye Who Enter Here', 'Episode Ye Who Enter Here', 'nansiD56784', 'I like this episode.', '2020-11-05'),
        ('2Episode Ye Who Enter Here', 'Episode Ye Who Enter Here', 'nansiD56784', 'What do you think?', '2020-11-05'),
       ('1Favourite', 'Favourite', 'anIlieva', 'Here we can discuss this episode.', '2020-04-16'),
       ('1EpisodeSanctum', 'EpisodeSanctum', 'niki34213', 'Hey, do you like this episode?', '2019-12-24'),
       ('1My favourite episode', 'My favourite episode', 'vasi9956638', 'Sic Semper Tyrannis episode', '2020-09-19'),
       ('1Season1Episode1', 'Season1Episode1', 'cveti996748', 'Pilot episode forum', '2020-01-25'),
       ('2Season1Episode1', 'Season1Episode1', 'iDrencheva', 'You can comment here', '2020-01-25')#