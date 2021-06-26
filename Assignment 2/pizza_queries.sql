


/* Create the schema for our tables */
create table Person(name VARCHAR(30), age int, gender VARCHAR(10));
create table Frequents(name VARCHAR(30), pizzeria VARCHAR(30));
create table Eats(name VARCHAR(30), pizza VARCHAR(30));
create table Serves(pizzeria VARCHAR(30), pizza VARCHAR(30), price float);

/* Populate the tables with our data */
insert into Person values('Amy', 16, 'female');
insert into Person values('Ben', 21, 'male');
insert into Person values('Cal', 33, 'male');
insert into Person values('Dan', 13, 'male');
insert into Person values('Eli', 45, 'male');
insert into Person values('Fay', 21, 'female');
insert into Person values('Gus', 24, 'male');
insert into Person values('Hil', 30, 'female');
insert into Person values('Ian', 18, 'male');

insert into Frequents values('Amy', 'Pizza Hut');
insert into Frequents values('Ben', 'Pizza Hut');
insert into Frequents values('Ben', 'Chicago Pizza');
insert into Frequents values('Cal', 'Straw Hat');
insert into Frequents values('Cal', 'New York Pizza');
insert into Frequents values('Dan', 'Straw Hat');
insert into Frequents values('Dan', 'New York Pizza');
insert into Frequents values('Eli', 'Straw Hat');
insert into Frequents values('Eli', 'Chicago Pizza');
insert into Frequents values('Fay', 'Dominos');
insert into Frequents values('Fay', 'Little Caesars');
insert into Frequents values('Gus', 'Chicago Pizza');
insert into Frequents values('Gus', 'Pizza Hut');
insert into Frequents values('Hil', 'Dominos');
insert into Frequents values('Hil', 'Straw Hat');
insert into Frequents values('Hil', 'Pizza Hut');
insert into Frequents values('Ian', 'New York Pizza');
insert into Frequents values('Ian', 'Straw Hat');
insert into Frequents values('Ian', 'Dominos');

insert into Eats values('Amy', 'pepperoni');
insert into Eats values('Amy', 'mushroom');
insert into Eats values('Ben', 'pepperoni');
insert into Eats values('Ben', 'cheese');
insert into Eats values('Cal', 'supreme');
insert into Eats values('Dan', 'pepperoni');
insert into Eats values('Dan', 'cheese');
insert into Eats values('Dan', 'sausage');
insert into Eats values('Dan', 'supreme');
insert into Eats values('Dan', 'mushroom');
insert into Eats values('Eli', 'supreme');
insert into Eats values('Eli', 'cheese');
insert into Eats values('Fay', 'mushroom');
insert into Eats values('Gus', 'mushroom');
insert into Eats values('Gus', 'supreme');
insert into Eats values('Gus', 'cheese');
insert into Eats values('Hil', 'supreme');
insert into Eats values('Hil', 'cheese');
insert into Eats values('Ian', 'supreme');
insert into Eats values('Ian', 'pepperoni');

insert into Serves values('Pizza Hut', 'pepperoni', 12);
insert into Serves values('Pizza Hut', 'sausage', 12);
insert into Serves values('Pizza Hut', 'cheese', 9);
insert into Serves values('Pizza Hut', 'supreme', 12);
insert into Serves values('Little Caesars', 'pepperoni', 9.75);
insert into Serves values('Little Caesars', 'sausage', 9.5);
insert into Serves values('Little Caesars', 'cheese', 7);
insert into Serves values('Little Caesars', 'mushroom', 9.25);
insert into Serves values('Dominos', 'cheese', 9.75);
insert into Serves values('Dominos', 'mushroom', 11);
insert into Serves values('Straw Hat', 'pepperoni', 8);
insert into Serves values('Straw Hat', 'cheese', 9.25);
insert into Serves values('Straw Hat', 'sausage', 9.75);
insert into Serves values('New York Pizza', 'pepperoni', 8);
insert into Serves values('New York Pizza', 'cheese', 7);
insert into Serves values('New York Pizza', 'supreme', 8.5);
insert into Serves values('Chicago Pizza', 'cheese', 7.75);
insert into Serves values('Chicago Pizza', 'supreme', 8.5);

/* Question 1 Find all the persons under the age of 18.*/
SELECT NAME, AGE
FROM PERSON
WHERE AGE < 18;

/*Question 2 Find all the pizzerias that serve at least one pizza that Amy eats for less than $10.00. */
SELECT PIZZERIA, PIZZA, PRICE
FROM EATS JOIN SERVES USING(pizza)
WHERE PRICE < 10 AND NAME = 'Amy';

/*Question 3 Find all the pizzerias frequented by at least one person under the age of 18.*/
SELECT PIZZERIA, NAME, AGE
FROM PERSON JOIN FREQUENTS USING(name)
WHERE AGE < 18;

/*Question 4 Find all the pizzerias frequented by at least one person under the age of 18
  and at least one person over the age of 30.*/

SELECT DISTINCT PIZZERIA
FROM (PERSON JOIN FREQUENTS USING (name)) P1 JOIN  (PERSON JOIN FREQUENTS USING (name)) P2 USING (pizzeria)
WHERE P1.AGE <18 AND P2.AGE>30;

/* Question5 */
CREATE VIEW X AS
SELECT PIZZERIA, NAME, AGE
FROM PERSON JOIN FREQUENTS USING(name)
WHERE AGE < 18 ;

CREATE VIEW Y AS
SELECT PIZZERIA, NAME, AGE
FROM PERSON JOIN FREQUENTS USING(name)
WHERE AGE > 30 ;

SELECT X.pizzeria, X.name, X.age, Y.name, Y.age
FROM X INNER JOIN Y
ON Y.pizzeria = X.pizzeria ;

DROP VIEW X ;
DROP VIEW Y ;

/* Question 6 For each person, find how many types of pizzas he/she eats.
   Show only those people who eat at least two types of pizzas.
   Sort in descending order of the number of types of pizzas they eat.*/
SELECT name, COUNT(pizza)
FROM Eats
GROUP BY name
HAVING COUNT(pizza)>=2
ORDER BY COUNT(pizza)DESC;



/* Question 7 For each type of pizza, find its average price. Sort descending by average price.*/
SELECT PIZZA,AVG(price) as PRICE
FROM SERVES
GROUP BY pizza
ORDER BY PRICE DESC;

