/*6. Find the player who had the most success stealing bases in 2016, where __success__ is measured 
as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base 
or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.

-excluding rows where BOTH stolen bases and caught stealing are 0 seemed to work with sb <> 0 OR cs <> 0. I don't quite understand
why it works but I checked and it excludes the correct rows*/
WITH base_thieves as (SELECT playerid, sb as stolen_bases, cs as caught_stealing, (sb+cs) as attempts, ROUND(sb/(sb+cs)::decimal, 2) as success_rate
                     FROM batting
                     WHERE (sb <> 0 OR cs <> 0) AND yearid = 2016 
                     ORDER BY attempts DESC)
SELECT *
FROM base_thieves
WHERE attempts > 20
ORDER BY success_rate DESC

--simpler way
SELECT playerid, sb as stolen_bases, cs as caught_stealing, (sb+cs) as attempts, ROUND(sb/(sb+cs)::decimal, 2) as success_rate
FROM batting
WHERE (sb + cs) > 20 AND yearid = 2016
ORDER BY success_rate DESC, attempts DESC