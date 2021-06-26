
/*The questions in this assignment are about doing soccer analytics using SQL.
The data is in tables England, France, Germany, and Italy.
These tables contain more than 100 years of soccer game statistics.
Follow the steps below to create your tables and familizarize yourself with the data.
Then write SQL statements to answer the questions.
The first time you access the data you might experience a small delay while DBeaver
loads the metadata for the tables accessed.

Submit this file after adding your queries.
Replace "Your query here" text with your query for each question.
Submit one spreadsheet file with your visualizations for questions 2, 7, 9, 10, 12
(one sheet per question named by question number, e.g. Q2, Q7, etc).
*/

/*Create the tables.*/

create table england as select * from bob.england;
create table france as select * from bob.france;
create table germany as select * from bob.germany;
create table italy as select * from bob.italy;

/*Familiarize yourself with the tables.*/
SELECT * FROM england;
SELECT * FROM germany;
SELECT * FROM france;
SELECT * FROM italy;

/*Q1 (1 pt)
Find all the games in England between seasons 1920 and 1999 such that the total goals are at least 13.
Order by total goals descending.*/

SELECT *
FROM England
WHERE season BETWEEN 1920 AND 1999 AND totgoal >= 13
ORDER BY totgoal DESC ;

/*Sample result
1935-12-26,1935,Tranmere Rovers,Oldham Athletic,13,4,3,17,9,H
1958-10-11,1958,Tottenham Hotspur,Everton,10,4,1,14,6,H
...*/


/*Q2 (2 pt)
For each total goal result, find how many games had that result.
Use the england table and consider only the seasons since 1980.
Order by total goal.*/

SELECT totgoal, COUNT(totgoal)
FROM England
WHERE season >= 1980
GROUP BY totgoal
ORDER BY totgoal ASC ;

/*Sample result
0,6085
1,14001
...*/

/*Visualize the results using a barchart.*/


/*Q3 (2 pt)
Find for each team in England in tier 1 the total number of games played since 1980.
Report only teams with at least 300 games.

Hint. Find the number of games each team has played as "home".
Find the number of games each team has played as "visitor".
Then union the two and take the sum of the number of games.
*/
SELECT homew.home, (homewin+awaywin) AS total
FROM (SELECT home, COUNT(home) AS homewin
      FROM england
      WHERE tier=1 AND season>=1980
      GROUP BY home ) homew
JOIN (SELECT visitor, COUNT(visitor) AS awaywin
      FROM england
      WHERE tier=1 AND season>=1980
      GROUP BY visitor) awayw
ON homew.home=awayw.visitor
WHERE homewin + awaywin>=300
ORDER BY total DESC;


/*Sample result
Everton,1451
Liverpool,1451
...*/


/*Q4 (1 pt)
For each pair team1, team2 in England, in tier 1,
find the number of home-wins since 1980 of team1 versus team2.
Order the results by the number of home-wins in descending order.

Hint. After selecting the tuples needed (... WHERE tier=1 AND ...) do a GROUP BY home, visitor.
*/

SELECT home, visitor, COUNT(home)
FROM England
WHERE hgoal > vgoal AND season > 1980 AND tier = 1
GROUP BY home, visitor
ORDER BY COUNT(home) DESC ;

/*Sample result
Manchester United,Tottenham Hotspur,27
Arsenal,Everton,26
...*/


/*Q5 (1 pt)
For each pair team1, team2 in England in tier 1
find the number of away-wins since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.*/

SELECT visitor, home, COUNT(visitor)
FROM England
WHERE hgoal < vgoal AND tier=1 and season>=1980
GROUP BY home, visitor
ORDER BY COUNT(visitor) DESC ;



/*Sample result
Manchester United,Aston Villa,18
Manchester United,Everton,17
...*/


/*Q6 (2 pt)
For each pair team1, team2 in England in tier 1 report the number of home-wins and away-wins
since 1980 of team1 versus team2.
Order the results by the number of away-wins in descending order.

Hint. Join the results of the two previous queries. To do that you can use those
queries as subqueries. Remove their ORDER BY clause when making them subqueries.
Be careful on the join conditions.
*/

CREATE VIEW Wins AS
SELECT homewin.home, homewin.visitor, homewins, awaywins
FROM (SELECT home, visitor, COUNT(home)AS homewins
	  FROM england
	  WHERE hgoal > vgoal AND season > 1980 and tier=1
	  GROUP BY home, visitor) homewin
JOIN
	 (SELECT home, visitor, COUNT(visitor) as awaywins
	  FROM england
	  WHERE hgoal < vgoal AND season > 1980 and tier=1
	  GROUP BY home, visitor) visitwin
ON homewin.visitor = visitwin.home AND homewin.home = visitwin.visitor
ORDER BY awaywins DESC, homewins DESC ;
SELECT * FROM Wins;

/*Sample result
Manchester United,Aston Villa,26,18
Arsenal,Aston Villa,20,17
...*/

--Create a view, called Wins, with the query for the previous question.


/*Q7 (2 pt)
For each pair ('Arsenal', team2), report the number of home-wins and away-wins
of Arsenal versus team2 and the number of home-wins and away-wins of team2 versus Arsenal
(all since 1980).
Order the results by the second number of away-wins in descending order.
Use view W1.*/

SELECT W1.home, W1.Visitor, W1.homewins, W1.awaywins, W2.homewins, W2.awaywins
FROM Wins W1 JOIN Wins W2
ON W1.visitor = W2.home
WHERE W1.home = 'Arsenal' AND W2.visitor = 'Arsenal'
ORDER BY W2.awaywins DESC ;

/*Sample result
Arsenal,Liverpool,14,8,20,11
Arsenal,Manchester United,16,5,19,11
...*/

/*Drop view Wins.*/
DROP VIEW Wins;

/*Build two bar-charts, one visualizing the two home-wins columns, and the other visualizing the two away-wins columns.*/


/*Q8 (2 pt)
Winning at home is easier than winning as visitor.
Nevertheless, some teams have won more games as a visitor than when at home.
Find the team in Germany that has more away-wins than home-wins in total.
Print the team name, number of home-wins, and number of away-wins.*/
SELECT home,homewin,awaywin
FROM (SELECT home, COUNT(home)AS homewin
      FROM germany
      WHERE hgoal > vgoal
      GROUP BY home) hw
JOIN (SELECT visitor, COUNT(visitor) AS awaywin
      FROM germany
      WHERE hgoal <vgoal
      GROUP BY visitor)  aw
ON hw.home=aw.visitor
WHERE hw.homewin < aw.awaywin;


/*Sample result
Wacker Burghausen	...	...*/


/*Q9 (3 pt)
One of the beliefs many people have about Italian soccer teams is that they play much more defense than offense.
Catenaccio or The Chain is a tactical system in football with a strong emphasis on defence.
In Italian, catenaccio means "door-bolt", which implies a highly organised and effective backline defence
focused on nullifying opponents' attacks and preventing goal-scoring opportunities.
In this question we would like to see whether the number of goals in Italy is on average smaller than in England.

Find the average total goals per season in England and Italy since the 1970 season.
The results should be (season, england_avg, italy_avg) triples, ordered by season.

Hint.
Subquery 1: Find the average total goals per season in England.
Subquery 2: Find the average total goals per season in Italy
   (there is no totgoal in table Italy. Take hgoal+vgoal).
Join the two subqueries on season.
*/

SELECT engtotal.season, engtotal.engavg, itatotal.itaavg
FROM (SELECT DISTINCT season, (SUM(totgoal):: decimal /COUNT(home)) as engavg
	  FROM England
	  WHERE season >= 1970
	  GROUP BY season
	  ORDER BY season ASC) engtotal
JOIN
	 (SELECT DISTINCT season, (SUM(hgoal+vgoal):: decimal /COUNT(home)) AS itaavg
	  FROM Italy
	  WHERE season >= 1970
	  GROUP BY season
	  ORDER BY season ASC) itatotal
ON engtotal.season = itatotal.season ;


--Build a line chart visualizing the results. What do you observe?

/*Sample result
1970,2.5290927021696252,2.1041666666666667
1971,2.5922090729783037,2.0125
...*/


/*Q10 (3 pt)
Find the number of games in France and England in tier 1 for each goal difference.
Return (goaldif, france_games, eng_games) triples, ordered by the goal difference.
Normalize the number of games returned dividing by the total number of games for the country in tier 1,
e.g. 1.0*COUNT(*)/(select count(*) from france where tier=1)  */

SELECT eng.goaldif, ftotal :: decimal /(SELECT COUNT(home) AS ftotal FROM france WHERE tier=1) AS fran_games,
       total :: decimal /(SELECT COUNT(home) AS total FROM england WHERE tier=1) AS eng_games
FROM (SELECT goaldif, COUNT(home) AS total
      FROM england
      WHERE tier=1
      GROUP BY goaldif) eng
JOIN (SELECT goaldif, COUNT(home) AS ftotal
      FROM france
      WHERE tier=1
      GROUP BY goaldif) fran
ON eng.goaldif=fran.goaldif
ORDER BY eng.goaldif ASC;




/*Sample result
-8,0.00011369234850494562,0.000062637018477920450987
-7,0.00011369234850494562,0.00010439503079653408
...*/

/*Visualize the results using a barchart.*/


/*Q11 (2 pt)
Find all the seasons when England had higher average total goals than France.
Consider only tier 1 for both countries.
Return (season,england_avg,france_avg) triples.
Order by season.*/

SELECT eng.season, eng.engavg, fran.franavg
FROM (SELECT season, sum(totgoal)::decimal/count(home) AS engavg
	  FROM England
	  WHERE tier = 1
	  GROUP BY season) eng
JOIN
	 (SELECT season, sum(totgoal)::decimal/count(home) AS franavg
	  FROM France
	  WHERE tier = 1
	  GROUP BY season) fran
ON eng.season = fran.season AND eng.engavg > fran.franavg
ORDER BY eng.season ASC ;

/*Sample result
1936,3.3658008658008658,3.3041666666666667
1952,3.2640692640692641,3.1437908496732026
...*/
