/*4. Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.*/

--method 1: CTE
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
GROUP BY category

--method 2, starting doing this and realized it does not work - it just counts the number of outfielders, infielders and pitchers/catchers in the database
SELECT
    COUNT(CASE WHEN pos = 'OF' THEN 'Outfield' END) as outfield,
    COUNT(CASE WHEN pos = 'SS' THEN 'Infield'
        WHEN pos = '1B' THEN 'Infield'
        WHEN pos = '2B' THEN 'Infield'
        WHEN pos = '3B' THEN 'Infield' END) as infield,
    COUNT(CASE WHEN pos ='P' THEN 'Battery'
        WHEN pos ='C' THEN 'Battery' END) as battery
FROM fielding
