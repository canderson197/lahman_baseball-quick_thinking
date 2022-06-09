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
SELECT decade, ROUND((SUM(so)::decimal/SUM(g)::decimal), 2) as strikeouts_per_game
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
SELECT decade, ROUND((SUM(hr)::decimal/SUM(g)::decimal), 2) as homeruns_per_game
FROM CTE 
GROUP BY decade
ORDER BY decade;