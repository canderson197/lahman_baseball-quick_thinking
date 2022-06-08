--Lahman Project
--Question 1. 1871 to 2016
/*SELECT Min(yearID), MAX(yearID) 
FROM teams*/

--Question 2. Eddie Gaedel, 43, 1, SLA
/*SELECT people.namefirst, people.namelast, MIN(people.height), people.playerID,
		appearances.playerID, appearances.g_all, appearances.teamID
FROM people FULL JOIN appearances
USING (playerID)
GROUP BY people.namefirst, people.namelast, people.height, people.playerID,
		appearances.playerID, appearances.g_all, appearances.teamID
ORDER BY people.height;*/

--Question 4. Battery-41,424, Infield-58,934, Outfield-29,560
/*SELECT SUM(PO),
	CASE WHEN pos = 'OF' THEN 'Outfield'
		WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR  
		pos = '3B' THEN 'Infield'
		WHEN pos = 'P' OR pos = 'C' THEN 'Battery' END as pos_groups
FROM fielding
WHERE yearID = '2016'
GROUP BY pos_groups;*/

--Question 9. David Allen Johnson-WAS/BAL & James Richard Leyland-PIT/DET				
WITH al_winners as (SELECT DISTINCT awardsmanagers.yearid, awardsmanagers.awardid, awardsmanagers.lgID, people.playerID,
						people.namegiven, people.namelast, managers.teamID 
						FROM people INNER JOIN awardsmanagers USING (playerID)
						INNER JOIN managers USING (playerID, yearID)
						WHERE awardsmanagers.awardid iLIKE 'TSN Manager of the Year'
						AND  awardsmanagers.lgID = 'AL'
						ORDER BY awardsmanagers.awardid, people.namegiven, people.namelast),
 nl_winners as (SELECT managers.playerID, al_winners.namegiven, al_winners.namelast, awardsmanagers.awardid, 
				awardsmanagers.lgID, awardsmanagers.yearID as yr, 
 				al_winners.lgID, al_winners.yearID, al_winners.teamID 
						FROM al_winners INNER JOIN awardsmanagers USING (playerID)
						INNER JOIN managers USING (playerID)
						INNER JOIN people USING (playerID)
						INNER JOIN teams ON teams.teamID = managers.teamID AND teams.lgID = managers.lgID
						AND teams.yearID = managers.yearID AND teams.lgID = al_winners.lgID AND 
						teams.yearID = al_winners.yearID
						WHERE awardsmanagers.awardid iLIKE 'TSN Manager of the Year'
						AND awardsmanagers.lgID = 'NL'
						ORDER BY awardsmanagers.awardid, people.namegiven, people.namelast)
						
SELECT namegiven, namelast, awardID, yr as nl_year, managers.teamID as nl_team, 
		nl_winners.yearID as al_year, nl_winners.teamID as al_team
FROM nl_winners LEFT JOIN managers ON nl_winners.playerID = managers.playerID 
		AND nl_winners.yr = managers.yearID
