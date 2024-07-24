CREATE DATABASE Example;

USE Example;

CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');


INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);


-- -------------------------------------------------------------------------------------------------------------------------
-- Q1. Management wants to see all the users that did not login in the past 5 months
-- return username

SELECT * FROM logins;

SELECT DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH);

SELECT DATE(CURRENT_DATE());

SELECT USER_ID,DATE(MAX(LOGIN_TIMESTAMP)) AS LAST_LOGIN FROM logins
GROUP BY USER_ID
HAVING MAX(LOGIN_TIMESTAMP) < DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH);

-- SELECT USER_ID,MAX(DATE(LOGIN_TIMESTAMP)) FROM logins
-- GROUP BY USER_ID
-- HAVING MAX(DATE(LOGIN_TIMESTAMP)) < DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH);

SELECT * FROM users;
SELECT * FROM logins;

-- ONE WAY
SELECT DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH);

SELECT USER_ID,MAX(LOGIN_TIMESTAMP) FROM logins
GROUP BY USER_ID
HAVING MAX(LOGIN_TIMESTAMP) < DATE_ADD(current_date(),INTERVAL -5 MONTH);

-- ANOTHER WAY
SELECT DISTINCT(USER_ID) AS user_id FROM logins 
WHERE USER_ID NOT IN
(
SELECT USER_ID FROM logins
WHERE LOGIN_TIMESTAMP > DATE_ADD(CURRENT_DATE(),INTERVAL -5 MONTH)
);

-- --------------------------------------------------------------------------------------
-- Q2.For the business units' quaterly analysis,calculate how many users and how many sessions
-- were at each quarter order by quarter from newest to oldest.
-- return :first day of the quarter,user_cnt,session_cnt

SELECT * FROM logins;

SELECT LOGIN_TIMESTAMP,QUARTER(LOGIN_TIMESTAMP) as quarters FROM logins
order by quarters;
-- One Way
SELECT STR_TO_DATE(CONCAT(YEAR(LOGIN_TIMESTAMP), '-', 
                       LPAD((QUARTER(LOGIN_TIMESTAMP) * 3 -2 ), 2, '0'), 
                       '-01'), 
                '%Y-%m-%d') AS first_day_of_quarter,COUNT(SESSION_ID),COUNT(DISTINCT USER_ID) FROM logins
group by first_day_of_quarter;
-- Another Way
SELECT 
	CASE 
		WHEN QUARTER(LOGIN_TIMESTAMP)=1 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-01-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=2 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-04-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=3 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-07-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=4 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-10-01')
	END AS first_day_of_the_quarter,
    COUNT(DISTINCT USER_ID) AS user_count,
    COUNT(SESSION_ID) AS session_count,
    QUARTER(LOGIN_TIMESTAMP) as quarters
    
FROM logins
GROUP BY first_day_of_the_quarter,quarters
ORDER BY first_day_of_the_quarter DESC;
-- -------------------------------------------------------------------------------------------------------
-- Q3. Display user id's that login in january 2024 and did not login on november 2023.
-- Return id
SELECT DISTINCT USER_ID as user_id FROM logins
WHERE LOGIN_TIMESTAMP BETWEEN '2024-01-01' and '2024-01-31'
AND USER_ID NOT IN 
(
SELECT USER_ID FROM logins
WHERE LOGIN_TIMESTAMP BETWEEN '2023-11-01' and '2023-11-30');


-- --------------------------------------------------------------------------------------

-- Q4.) Add to the Query 2 the percentage change in sessions from the last quarter.
-- Return: first day of the quarter,session_cnt,session_cnt_prev,session_percent_change.

WITH CTE AS (SELECT 
	CASE 
		WHEN QUARTER(LOGIN_TIMESTAMP)=1 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-01-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=2 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-04-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=3 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-07-01')
		WHEN QUARTER(LOGIN_TIMESTAMP)=4 THEN CONCAT(YEAR(LOGIN_TIMESTAMP),'-10-01')
	END AS first_day_of_the_quarter,
    COUNT(DISTINCT USER_ID) AS user_count,
    COUNT(SESSION_ID) AS session_count
FROM logins
GROUP BY first_day_of_the_quarter)

SELECT first_day_of_the_quarter,user_count,session_count,
LAG(session_count,1) OVER(ORDER BY first_day_of_the_quarter) as prev_session_count,
(session_count - LAG(session_count,1) OVER(ORDER BY first_day_of_the_quarter))*100/LAG(session_count,1) OVER(ORDER BY first_day_of_the_quarter) as percentage_sess_change
 FROM cte;


-- -------------------------------------------------------------------------------------------------
-- Q5.)Display the user that had the highest session score (max) for each day 
-- Return Date,Username,Score

SELECT * FROM logins;
WIth cte as (SELECT USER_ID,DATE(LOGIN_TIMESTAMP) login_date,SUM(SESSION_SCORE) score FROM logins
GROUP BY USER_ID,DATE(LOGIN_TIMESTAMP))

SELECT * FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY login_date ORDER BY score desc) as rn
FROM cte) as a
WHERE rn = 1;

-- -------------------------------------------------------------------------------------------------------------------------

-- Q6.) To identify our best users - Return the users that had a session on every single day 
--      since their firt login (make assumptions if needed)
-- Return: User_id 

SELECT * FROM logins;

SELECT USER_ID,DATE(MIN(LOGIN_TIMESTAMP)) AS first_login,
		datediff(CAST('2024-06-28' AS DATE),MIN(DATE(LOGIN_TIMESTAMP)))+1 AS no_of_logins_days_required,
        COUNT(DISTINCT LOGIN_TIMESTAMP) as no_of_days_login FROM logins
GROUP BY USER_ID
HAVING datediff(CAST('2024-06-28' AS DATE),MIN(DATE(LOGIN_TIMESTAMP)))+1 = COUNT(DISTINCT LOGIN_TIMESTAMP)
ORDER BY USER_ID;

-- -----------------------------------------------------------------------------------------------------------------
-- Q7.) On what dates there were no logins at all ?
-- Return : Login_Dates

WITH RECURSIVE cte AS (
    -- Initial selection: Get the first date from the logins table and set the last date
    SELECT 
        CAST(MIN(LOGIN_TIMESTAMP) AS DATE) AS first_date,
        CAST('2024-06-28' AS DATE) AS last_date
    FROM logins
    -- Recursive part: Increment the first_date by 1 day
    UNION ALL
    SELECT 
        DATE_ADD(first_date, INTERVAL 1 DAY) AS first_date,
        last_date
    FROM cte
    WHERE first_date < last_date
)
-- Select all rows from the CTE
SELECT *
FROM cte
WHERE first_date not in
(select distinct cast(login_timestamp as date) from logins);

-- ------------------------------------------------------------------------------------------------------





	



