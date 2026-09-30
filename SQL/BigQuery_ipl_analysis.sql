select Player, Wkts
FROM `hitman22.ipl_analysis.2018_bowlers`
order by Wkts DESC limit 1;

-- Names and teams of all batsmen who played in 2018
select player as Batsmen, Team
from `hitman22.ipl_analysis.2018_batsmen`;

select distinct Team
from `hitman22.ipl_analysis.2019_batsmen`;

-- Batsmen who played for chennai and total no of matches played in 2019
select Player, Mat
from `hitman22.ipl_analysis.2019_batsmen`
WHERE Team ="Chennai Super Kings";

-- Bowlers who took 4w haul in 2018
select Player
from `hitman22.ipl_analysis.2018_bowlers`
where FourWs >0;

select Team, Player
from `hitman22.ipl_analysis.2018_bowlers`
where FourWs>0;

-- Players and the run conceded in 2018
SELECT Player, Runs
from `hitman22.ipl_analysis.2018_bowlers`
ORDER BY Runs; 

-- Two bolwers who took most number of wickets
SELECT Player, Wkts
from `hitman22.ipl_analysis.2018_bowlers`
ORDER BY Wkts desc
limit 2;

-- list all-rounder names and their teams in 2018
select a.Player, a.Team
from `hitman22.ipl_analysis.2018_bowlers` as a inner join `hitman22.ipl_analysis.2018_batsmen` as b 
on a.Player = b.Player

-- List of batsmen who played in 2018 as well as 2019
select g.Player
from `hitman22.ipl_analysis.2019_batsmen` as g inner join `hitman22.ipl_analysis.2018_batsmen` as h
on g.Player = h.Player

-- How many batsmen were there in each team for the year 2019 , also sort the total count in descending order
select Team, count(Player) as Total_count
from `hitman22.ipl_analysis.2019_batsmen`
group by Team
order by Total_count desc;

select Team, count(Player) as Total_count
from `hitman22.ipl_analysis.2019_batsmen`
group by Team
order by count(Player) desc;

-- Q6. How many bowlers were there in each team in 2018 who took at least one 4 wicket haul?  
-- Show the top 2 teams that had most number of such bowers 
 
select Team, count(player) as TotalCount 
from `hitman22.ipl_analysis.2018_bowlers` 
where FourWs > 0 
group by Team 
order by Team limit 2;

/*What are the names of top 2 teams which consists of most number of bowlers in 2018? 
Explanation: This question is designed to demonstrate the use of the GROUP BY clause in combination with the ORDER BY clause and the LIMIT clause, which allows us to limit the number of results returned.*/

select Team, count(Player) as Total_count
from `hitman22.ipl_analysis.2018_bowlers` 
group by Team
order by count(Player) desc limit 2;

-- Who were the purple cap contenders in 2018

select Player,Team, Wkts
from `hitman22.ipl_analysis.2018_bowlers`
order by Wkts desc
limit 8;


/*Practice questions*/
/*
1. Which bowler took the most wickets in the 2018 season? 
2. Which batsmen scored the most runs in the 2018 season while maintaining an average strike rate of at least 130? 
3. Which bowlers took the most wickets in the 2018 season while maintaining an economy rate of less than 7 runs per over? 
4. Which batsmen scored the most runs across both 2018 and 2019 seasons? 
5. Which batsmen has hit the maximum number of boundaries in 2018, combining 4s and 6s? 
6. Name the bowlers who have got 4 wickets haul in 2019. 
7. Name 5 such bowlers who bowled the least number of overs in 2018. 
8. Which team scored the maximum number of runs in 2019? 
9. Name the Batsmen who has hit maximum half centuries, both the years combined 
*/

select Player,Team, Wkts
from `hitman22.ipl_analysis.2018_bowlers`
order by Wkts desc
limit 1;

select Player,Team, Runs, SR
from `hitman22.ipl_analysis.2018_batsmen`
where SR >= 130
order by Runs desc limit 1;


select Player,Team, Wkts, ER
from `hitman22.ipl_analysis.2018_bowlers`
where ER <7
order by Wkts desc
limit 1;

select b.Player, (a.Runs + b.Runs) as most_runs
from `hitman22.ipl_analysis.2018_batsmen` as a inner join `hitman22.ipl_analysis.2019_batsmen` as b
on a.Player=b.Player
order by most_runs desc
limit 1;

select Player,Fours, Sixes, (Fours + Sixes) as Boundaries
from `hitman22.ipl_analysis.2018_batsmen`
where Fours + Sixes >= 1
order by Boundaries desc;


select Player, FourWs
from `hitman22.ipl_analysis.2019_bowlers`
where FourWs > 0;

select Player, Overs
from `hitman22.ipl_analysis.2018_bowlers`
where Overs>1
order by Overs limit 5;

select Team, sum(Runs) as Total_Runs
from `hitman22.ipl_analysis.2019_batsmen`
group by Team
ORDER BY sum(Runs) desc;

select a.Player,(a.Fifties + b.Fifties) as Total_Fifties
from `hitman22.ipl_analysis.2018_batsmen` as a inner join `hitman22.ipl_analysis.2019_batsmen` as b
on a.Player=b.Player
order by Total_Fifties desc limit 1;