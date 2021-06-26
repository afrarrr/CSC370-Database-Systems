
/*
This assignment introduces an example concerning World War II capital ships.
It involves the following relations:

Classes(class, type, country, numGuns, bore, displacement)
Ships(name, class, launched)  --launched is for year launched
Battles(name, date_fought)
Outcomes(ship, battle, result)

Ships are built in "classes" from the same design, and the class is usually
named for the first ship of that class.

Relation Classes records the name of the class,
the type (bb for battleship or bc for battlecruiser),
the country that built the ship, the number of main guns,
the bore (diameter of the gun barrel, in inches)
of the main guns, and the displacement (weight, in tons).

Relation Ships records the name of the ship, the name of its class,
and the year in which the ship was launched.

Relation Battles gives the name and date of battles involving these ships.

Relation Outcomes gives the result (sunk, damaged, or ok)
for each ship in each battle.
*/


/*
Exercise 1. (1 point)

1.	Create simple SQL statements to create the above relations
    (no constraints for initial creations).
2.	Insert the following data.

For Classes:
('Bismarck','bb','Germany',8,15,42000);
('Kongo','bc','Japan',8,14,32000);
('North Carolina','bb','USA',9,16,37000);
('Renown','bc','Gt. Britain',6,15,32000);
('Revenge','bb','Gt. Britain',8,15,29000);
('Tennessee','bb','USA',12,14,32000);
('Yamato','bb','Japan',9,18,65000);

For Ships
('California','Tennessee',1921);
('Haruna','Kongo',1915);
('Hiei','Kongo',1914);
('Iowa','Iowa',1943);
('Kirishima','Kongo',1914);
('Kongo','Kongo',1913);
('Missouri','Iowa',1944);
('Musashi','Yamato',1942);
('New Jersey','Iowa',1943);
('North Carolina','North Carolina',1941);
('Ramilles','Revenge',1917);
('Renown','Renown',1916);
('Repulse','Renown',1916);
('Resolution','Revenge',1916);
('Revenge','Revenge',1916);
('Royal Oak','Revenge',1916);
('Royal Sovereign','Revenge',1916);
('Tennessee','Tennessee',1920);
('Washington','North Carolina',1941);
('Wisconsin','Iowa',1944);
('Yamato','Yamato',1941);

For Battles
('North Atlantic','27-May-1941');
('Guadalcanal','15-Nov-1942');
('North Cape','26-Dec-1943');
('Surigao Strait','25-Oct-1944');

For Outcomes
('Bismarck','North Atlantic', 'sunk');
('California','Surigao Strait', 'ok');
('Duke of York','North Cape', 'ok');
('Fuso','Surigao Strait', 'sunk');
('Hood','North Atlantic', 'sunk');
('King George V','North Atlantic', 'ok');
('Kirishima','Guadalcanal', 'sunk');
('Prince of Wales','North Atlantic', 'damaged');
('Rodney','North Atlantic', 'ok');
('Scharnhorst','North Cape', 'sunk');
('South Dakota','Guadalcanal', 'ok');
('West Virginia','Surigao Strait', 'ok');
('Yamashiro','Surigao Strait', 'sunk');
*/

-- Write your sql statements here.
CREATE TABLE Classes(
	class VARCHAR(20),
	type VARCHAR(10),
	country VARCHAR(20),
	numGuns INT,
	bore INT,
	displacement INT

);
INSERT INTO Classes VALUES('Bismarck','bb','Germany',8,15,42000);
INSERT INTO Classes VALUES('Kongo','bc','Japan',8,14,32000);
INSERT INTO Classes VALUES('North Carolina','bb','USA',9,16,37000);
INSERT INTO Classes VALUES('Renown','bc','Gt. Britain',6,15,32000);
INSERT INTO Classes VALUES('Revenge','bb','Gt. Britain',8,15,29000);
INSERT INTO Classes VALUES('Tennessee','bb','USA',12,14,32000);
INSERT INTO Classes VALUES('Yamato','bb','Japan',9,18,65000);


CREATE TABLE Ships(
	name VARCHAR(20),
	class VARCHAR(20),
	launched int
);

INSERT INTO Ships VALUES ('California','Tennessee',1921);
INSERT INTO Ships VALUES ('Haruna','Kongo',1915);
INSERT INTO Ships VALUES ('Hiei','Kongo',1914);
INSERT INTO Ships VALUES ('Iowa','Iowa',1943);
INSERT INTO Ships VALUES ('Kirishima','Kongo',1914);
INSERT INTO Ships VALUES ('Kongo','Kongo',1913);
INSERT INTO Ships VALUES ('Missouri','Iowa',1944);
INSERT INTO Ships VALUES ('Musashi','Yamato',1942);
INSERT INTO Ships VALUES ('New Jersey','Iowa',1943);
INSERT INTO Ships VALUES ('North Carolina','North Carolina',1941);
INSERT INTO Ships VALUES ('Ramilles','Revenge',1917);
INSERT INTO Ships VALUES ('Renown','Renown',1916);
INSERT INTO Ships VALUES ('Repulse','Renown',1916);
INSERT INTO Ships VALUES ('Resolution','Revenge',1916);
INSERT INTO Ships VALUES ('Revenge','Revenge',1916);
INSERT INTO Ships VALUES ('Royal Oak','Revenge',1916);
INSERT INTO Ships VALUES ('Royal Sovereign','Revenge',1916);
INSERT INTO Ships VALUES ('Tennessee','Tennessee',1920);
INSERT INTO Ships VALUES ('Washington','North Carolina',1941);
INSERT INTO Ships VALUES ('Wisconsin','Iowa',1944);
INSERT INTO Ships VALUES ('Yamato','Yamato',1941);

Create table Battles(
    name VARCHAR(20),
    date_fought DATE
);
INSERT INTO Battles VALUES ('North Atlantic','27-May-1941');
INSERT INTO Battles VALUES('Guadalcanal','15-Nov-1942');
INSERT INTO Battles VALUES('North Cape','26-Dec-1943');
INSERT INTO Battles VALUES('Surigao Strait','25-Oct-1944');

Create table Outcomes(
    ship VARCHAR(20),
    battle VARCHAR(20),
    result VARCHAR(20)
);
INSERT INTO Outcomes VALUES('Bismarck','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('California','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Duke of York','North Cape', 'ok');
INSERT INTO Outcomes VALUES('Fuso','Surigao Strait', 'sunk');
INSERT INTO Outcomes VALUES('Hood','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('King George V','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Kirishima','Guadalcanal', 'sunk');
INSERT INTO Outcomes VALUES('Prince of Wales','North Atlantic', 'damaged');
INSERT INTO Outcomes VALUES('Rodney','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Scharnhorst','North Cape', 'sunk');
INSERT INTO Outcomes VALUES('South Dakota','Guadalcanal', 'ok');
INSERT INTO Outcomes VALUES('West Virginia','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Yamashiro','Surigao Strait', 'sunk');

select * from Classes;
select * from Ships;
select * from Outcomes;
select * from Battles;
-- Exercise 2. (6 points)
-- Write SQL queries for the following requirements.

-- 1.	(2 pts) List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.
/*
Expected result:
ship,displacement,numguns
Kirishima,32000,8
South Dakota,NULL,NULL
*/
select ship, displacement, numguns
from outcomes left outer join ships ON name = ship
             left outer join classes ON Ships.class = Classes.class
where outcomes.battle = 'Guadalcanal';



-- 2.	(2 pts) Find the names of the ships whose number of guns was the largest for those ships of the same bore.

select name
from (select name, numGuns, bore from classes natural join ships) x
where numGuns =
      (select max(numGuns)
       from ships natural join classes
       where bore=x.bore);


--3. (2 pts) Find for each class with at least three ships the number of ships of that class sunk in battle.
/*
class,sunk_ships
Revenge,0
Kongo,1
Iowa,0
*/

create view x as
    select class from ships group by class having count(name)>=3;
create view y as
    select class, ship from (ships join outcomes on ships.name =outcomes.ship) where outcomes.result='sunk';
select class, count(ship) as sunk_ships
from x left outer join y using (class)
group by class;

drop view x;
drop view y;

-- Exercise 3. (4 points)

-- Write the following modifications.

-- 1.	(2 points) Two of the three battleships of the Italian Vittorio Veneto class –
-- Vittorio Veneto and Italia – were launched in 1940;
-- the third ship of that class, Roma, was launched in 1942.
-- Each had 15-inch guns and a displacement of 41,000 tons.
-- Insert these facts into the database.

-- Write your sql statements here.
INSERT INTO Classes VALUES ('Vittorio Veneto','bb','Italy',15,41000);
INSERT INTO Ships VALUES ('Vittorio Veneto','Vittorio Veneto',1940);
INSERT INTO Ships VALUES ('Italia','Vittorio Veneto',1940);
INSERT INTO Ships VALUES ('Roma','Vittorio Veneto',1942);

-- 2.	(1 point) Delete all classes with fewer than three ships.

DELETE FROM Classes where class in (
    select class from classes left outer join ships using (class) group by (class) having count(name)<3
    );


-- 3.	(1 point) Modify the Classes relation so that gun bores are measured in centimeters
-- (one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton).

update classes
set bore=bore*2.5, displacement =displacement/1.1;




-- Exercise 4.  (9 points)
-- Add the following constraints using views with check option.

--1. (3 points) No ship can be in battle before it is launched.

-- Write your sql statement here.

-- Now we can try some insertion on this view.

CREATE OR REPLACE VIEW OutcomesView AS
SELECT ship, battle, result
FROM Outcomes O
WHERE NOT EXISTS (
    SELECT *
    FROM Ships S, Battles B
    WHERE S.name=O.ship AND O.battle=B.name AND
    S.launched > extract(year from B.date_fought)
)
WITH CHECK OPTION;

INSERT INTO OutcomesView (ship, battle, result)
VALUES('Musashi', 'North Atlantic','ok');
-- This insertion, as expected, should fail since Musashi is launched in 1942,
-- while the North Atlantic battle took place on 27-MAY-41.


-- 2. (3 points) No ship can be launched before
-- the ship that bears the name of the first ship’s class.

create view ShipsV as
    select name,class,launched from ships s1
    where not exists (select * from ships s2 where s1.name<> s2.name and s1.class = s2.class and s1.launched < s2.launched)
    with check option;


-- Now we can try some insertion on this view.
INSERT INTO ShipsV(name, class, launched)
VALUES ('AAA','Kongo',1912);
-- This insertion, as expected, should fail since ship Kongo (first ship of class Kongo) is launched in 1913.


--3. (3 points) No ship fought in a battle that was at a later date than another battle in which that ship was sunk.

create view OutcomesV as
    select ship,battle, result
    from Outcomes x
    where not exists (select * from outcomes y where y.ship = x.ship AND y.result = 'sunk' AND
                (SELECT date_fought from Battles Where name = x.battle)>(SELECT date_fought from Battles Where name = y.battle) )
    with check option;

-- Now we can try some insertion on this view.
INSERT INTO OutcomesV(ship, battle, result)
VALUES('Bismarck', 'Guadalcanal', 'ok');
-- This insertion, as expected, should fail since 'Bismarck' was sunk in
-- the battle of North Atlantic, in 1941, whereas the battle of Guadalcanal happened in 1942.