/*1. What range of years for baseball games played does the provided database cover?
from 1871 to 2016 */

SELECT MAX(yearid), MIN(yearid)
FROM teams;

SELECT MAX(year), MIN(year)
FROM homegames

/* 3. Find all players in the database who played at Vanderbilt University. 
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

college playing has a row for every year they played. salaries also has a row for every year played.
I need a table with all players who played at Vandy. I need one row per dude.
*/

--Vandy CTE
WITH Vandy_alums as (SELECT DISTINCT people.playerid
                    FROM people LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
                    LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
                    WHERE schoolname = 'Vanderbilt University')
--GROUP BY method
SELECT playerid, 
       namefirst, 
       namelast, 
       SUM(salary) as major_league_earnings
FROM Vandy_alums LEFT JOIN people USING(playerid)
                 LEFT JOIN salaries USING(playerid)  
GROUP BY playerid, 
       namefirst, 
       namelast
ORDER BY major_league_earnings DESC NULLS LAST

--window function method
WITH Vandy_alums as (SELECT DISTINCT people.playerid
                    FROM people LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
                    LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
                    WHERE schoolname = 'Vanderbilt University')
SELECT DISTINCT playerid, 
       namefirst, 
       namelast, 
       SUM(salary) OVER(PARTITION BY playerid) as major_league_earnings
FROM Vandy_alums LEFT JOIN people USING(playerid)
                 LEFT JOIN salaries USING(playerid) 
                 
/*6. Find the player who had the most success stealing bases in 2016, where __success__ is measured 
as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base 
or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
*/

