/* The complete project for Lahman baseball was a collaboration with Lauren Della Russo and Mylah Kate Gainey. However, 
in my script I have only included the code for certain questions, 
each of which represents my individual work and abilities. */

/*1. What range of years for baseball games played does the provided database cover?
from 1871 to 2016 */

SELECT MAX(yearid), MIN(yearid)
FROM teams;

/* 3. Find all players in the database who played at Vanderbilt University. 
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?*/

--GROUP BY method
WITH Vandy_alums as (SELECT DISTINCT people.playerid
                    FROM people LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
                    LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
                    WHERE schoolname = 'Vanderbilt University')
SELECT playerid, 
       namefirst, 
       namelast, 
       SUM(salary)::numeric::money as major_league_earnings
FROM Vandy_alums LEFT JOIN people USING(playerid)
                 LEFT JOIN salaries USING(playerid)  
GROUP BY playerid, 
       namefirst, 
       namelast
ORDER BY major_league_earnings DESC NULLS LAST;

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
ORDER BY major_league_earnings DESC NULLS LAST; 

/*4. Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.*/

WITH CTE as (SELECT *,
        CASE WHEN pos = 'OF' THEN 'Outfield'
        WHEN pos = 'SS' THEN 'Infield'
        WHEN pos = '1B' THEN 'Infield'
        WHEN pos = '2B' THEN 'Infield'
        WHEN pos = '3B' THEN 'Infield'
        WHEN pos ='P' THEN 'Battery'
        WHEN pos ='C' THEN 'Battery' END AS category       
        FROM fielding)
SELECT category, SUM(po)
FROM CTE
WHERE yearid = 2016
GROUP BY category;

/*5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. 
Do the same for home runs per game. Do you see any trends?*/

--strikeouts per game by decade
with CTE as (SELECT *,
            CASE WHEN yearid::text LIKE '192%' THEN '1920s'
            WHEN yearid::text LIKE '193%' THEN '1930s' 
            WHEN yearid::text LIKE '194%' THEN '1940s'
            WHEN yearid::text LIKE '195%' THEN '1950s'
            WHEN yearid::text LIKE '196%' THEN '1960s'
            WHEN yearid::text LIKE '197%' THEN '1970s'
            WHEN yearid::text LIKE '198%' THEN '1980s'
            WHEN yearid::text LIKE '199%' THEN '1990s'
            WHEN yearid::text LIKE '200%' THEN '2000s'
            WHEN yearid::text LIKE '201%' THEN '2010s' END AS decade
    FROM teams
    WHERE yearid >= 1920)
SELECT decade, ROUND((SUM(so)::decimal/(SUM(g)/2)::decimal), 2) as strikeouts_per_game --tricky, we divide by 2 cuz there are 2 teams playing in each game
FROM CTE 
GROUP BY decade
ORDER BY decade;

--home runs per game by decade
with CTE as (SELECT *,
            CASE WHEN yearid::text LIKE '192%' THEN '1920s'
            WHEN yearid::text LIKE '193%' THEN '1930s' 
            WHEN yearid::text LIKE '194%' THEN '1940s'
            WHEN yearid::text LIKE '195%' THEN '1950s'
            WHEN yearid::text LIKE '196%' THEN '1960s'
            WHEN yearid::text LIKE '197%' THEN '1970s'
            WHEN yearid::text LIKE '198%' THEN '1980s'
            WHEN yearid::text LIKE '199%' THEN '1990s'
            WHEN yearid::text LIKE '200%' THEN '2000s'
            WHEN yearid::text LIKE '201%' THEN '2010s' END AS decade
    FROM teams
    WHERE yearid >= 1920)
SELECT decade, ROUND((SUM(hr)::decimal/(SUM(g)/2)::decimal), 2) as homeruns_per_game
FROM CTE 
GROUP BY decade
ORDER BY decade;

/*6. Find the player who had the most success stealing bases in 2016, where __success__ is measured 
as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base 
or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.*/

SELECT namefirst, namelast, sb as stolen_bases, cs as caught_stealing, (sb+cs) as attempts, ROUND(sb/(sb+cs)::decimal, 2) as success_rate
FROM batting INNER JOIN people USING(playerid)
WHERE (sb + cs) > 20 AND yearid = 2016
ORDER BY success_rate DESC

--7.  

--7a. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? **116 wins**
SELECT MAX(w)
FROM teams
WHERE WSWin = 'N' AND yearid >= 1970;

--7b. What is the smallest number of wins for a team that did win the world series? **63 wins**
/*Doing this will probably result in an unusually small number of wins for a world series champion – 
determine why this is the case. **they only played 110 games** */
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970;

--7c. Then redo your query, excluding the problem year. **83 wins**
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970 AND yearid <> 1981;

/* 7d. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
What percentage of the time? **23%** */
SELECT *
FROM teams
WHERE yearid >= 1970

/* 7e. when the CTE and main query are run together, some years (1971, 2006) have 2 teams b/c they tied for 1st for max wins. they were kept
because they represent 2 times that a team with max wins did not win the series.
*/
with window_max_wins as (SELECT yearid, franchid, w, MAX(w) OVER(PARTITION BY yearid) as max_wins, wswin,
             CASE WHEN wswin = 'Y' THEN 1
                  WHEN wswin = 'N' THEN 0 END AS calculation
           FROM teams
            WHERE yearid >= 1970)
            --now only show me rows where the wins are the max wins
        SELECT AVG(calculation) --to get % of the time that the team with most wins also won world series
        FROM window_max_wins
        WHERE w = max_wins

--7f. this query represents the number of wins of each WS winner
SELECT yearid, franchid, w
FROM teams
WHERE yearid >= 1970 AND wswin ='Y'
ORDER BY yearid

/*8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance 
per game in 2016 (where average attendance is defined as total attendance divided by number of games). 
Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. 
Repeat for the lowest 5 average attendance.*/

--top 5
SELECT team, park, (attendance/games) as avg_attendance
FROM homegames
WHERE year = 2016 AND games >= 10
ORDER BY avg_attendance DESC
LIMIT 5

--bottom 5
SELECT team, park, (attendance/games) as avg_attendance
FROM homegames
WHERE year = 2016 AND games >= 10
ORDER BY avg_attendance
LIMIT 5

/*10. Find all players who hit their career highest number of home runs in 2016. 
Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. 
Report the players' first and last names and the number of home runs they hit in 2016.*/

--these 2 CTEs give you a list of players who had their career high in 2016
WITH career_high_in_2016  as (WITH window_function as (SELECT DISTINCT playerid, yearid, hr, MAX(hr) OVER(PARTITION BY playerid) as max_hr
                             FROM batting
                             ORDER BY playerid)
                SELECT *
                FROM window_function 
                WHERE yearid=2016 AND max_hr <> 0 AND hr = max_hr),
--league_veterans is list of players who have been playing at least 10 years
 league_veterans as (SELECT playerid, COUNT (DISTINCT yearid) as years_playing
                    FROM batting
                    GROUP BY playerid
                    HAVING COUNT (yearid) >= 10)
--INNER JOIN league_veterans and career_high_in_2016, then LEFT JOIN people to get their names
SELECT namefirst, namelast, max_hr
FROM league_veterans INNER JOIN career_high_in_2016 USING(playerid)
LEFT JOIN people USING(playerid)