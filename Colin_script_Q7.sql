/*7.  

Doing this will probably result in an unusually small number of wins for a world series champion – 
determine why this is the case. **they only played 110 games** 


*/

--From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? **116 wins**
SELECT MAX(w)
FROM teams
WHERE WSWin = 'N' AND yearid >= 1970;

--What is the smallest number of wins for a team that did win the world series? **63 wins**
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970;

--Then redo your query, excluding the problem year. **83 wins**
SELECT MIN(w)
FROM teams
WHERE WSWin = 'Y' AND yearid >= 1970 AND yearid <> 1981;

/*How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
What percentage of the time?*/
SELECT *
FROM teams
WHERE yearid >= 1970

--*****START HERE now you need to use case when to get 1 for Y and 0 for N and AVG those for % of time that max wins team wins it all
with xyz as (SELECT yearid, franchid, w, MAX(w) OVER(PARTITION BY yearid) as max_wins, wswin
           FROM teams
            WHERE yearid >= 1970)
        SELECT *
        FROM xyz
        WHERE w = max_wins

--has year, franchise with max wins, only teams where wswin is Y
SELECT yearid, franchid, max(w)
FROM teams
WHERE yearid >= 1970 AND wswin ='Y'
GROUP BY yearid, franchid
ORDER BY yearid

--return only rows that match the max
SELECT yearid, franchid, w, wswin
FROM teams
WHERE w = (SELECT MAX(w)
         FROM teams
         WHERE yearid > 1970
         GROUP BY yearid)