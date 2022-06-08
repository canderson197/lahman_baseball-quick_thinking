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


--???
WITH CTE_2 as (SELECT /*DISTINCT*/ playerid, yearid, MAX(hr) OVER(PARTITION BY playerid) as max_hr
            FROM batting)
SELECT * 
FROM CTE_2
GROUP BY playerid, yearid
HAVING COUNT(*) > 10