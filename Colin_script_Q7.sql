--7.  

--From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? **116 wins**
SELECT MAX(w)
FROM teams
WHERE WSWin = 'N' AND yearid >= 1970;

--What is the smallest number of wins for a team that did win the world series? **63 wins**
/*Doing this will probably result in an unusually small number of wins for a world series champion – 
determine why this is the case. **they only played 110 games** */
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970;

--Then redo your query, excluding the problem year. **83 wins**
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970 AND yearid <> 1981;

/*How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
What percentage of the time? **23%** */
SELECT *
FROM teams
WHERE yearid >= 1970

/*when the CTE and main query are run together, some years (1971, 2006) have 2 teams b/c they tied for 1st for max wins. they were kept
because they represent 2 times that a team with max wins did not win the series.
*/
with window_max_wins as (SELECT yearid, franchid, w, MAX(w) OVER(PARTITION BY yearid) as max_wins, wswin,
             CASE WHEN wswin = 'Y' THEN 1
                  WHEN wswin = 'N' THEN 0 END AS calculation
           FROM teams
            WHERE yearid >= 1970)
            --now only show me rows where the wins are the max wins
        SELECT * --sub AVG(calculation) to get % of the time that the team with most wins also won world series
        FROM window_max_wins
        WHERE w = max_wins

--this query represents the number of wins of each WS winner
SELECT yearid, franchid, w
FROM teams
WHERE yearid >= 1970 AND wswin ='Y'
ORDER BY yearid