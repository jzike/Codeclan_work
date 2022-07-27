/*
 * Table relationships and joins
 */

-- One to one - e.g. one person has 1 NI number
-- One to many - e.g. 1 diet can have MANY animals
-- Many to many - e.g. One animal can have many Keepers, one keeper can have many animals

-- If you see more than 1 foreign key in a table, it generally means that it is a join table (many to many relationship)
-- ER diagram - entity relationship diagram
-- Foreign keys are generally not allowed to be NULL, if they are, it could result in an 'orphan'
-- Not all databases have foreign keys


-- Inner join IMPLIES at LEAST and 1-1 or a 1-Many 

SELECT 
	A.name, A.species, A.age,
	D.diet_type
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id = D.id
WHERE A.age > 4;

--Count the animals in the zoo grouped by diet type 

SELECT 
	count(A.id),
	D.diet_type 
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id  = D.id
GROUP BY D.diet_type ;



-- Modify the above to return all HERBIVORES only 

SELECT 
	count(A.id),
	A.species,
	D.diet_type 
FROM animals AS A
INNER JOIN diets AS D ON A.diet_id  = D.id
WHERE D.diet_type = 'herbivore'
GROUP BY A.species, D.diet_type ;

-- INNER JOIN only includes observations that have one or more matches in each table.



-- LEFT join, Brings back all records on the LEFT table and any matching records on the right 

SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type
FROM animals AS A
LEFT JOIN diets AS D ON A.diet_id = D.id;



-- RIGHT JOIN - brings back all records on the RIGHT table and any matching records on the LEFT if any

SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type
FROM animals AS A
RIGHT JOIN diets AS D ON A.diet_id = D.id;

-- Return how many animals follow each diet typel, including any diets which no animals follow
SELECT 
	count(A.id),
	D.diet_type
FROM animals AS A
RIGHT JOIN diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type ;

-- Return how many animals have a matching diet, including those with no diet
SELECT 
	count(A.id),
	D.diet_type
FROM animals AS A
LEFT JOIN diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type ;

-- Full join brings back ALL records in BOTH tables
SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type
FROM animals AS A
FULL JOIN diets AS D ON A.diet_id = D.id ;

-- Get a rota for the keepers and the animals they look after, ordered first by animal name and then by day 

SELECT 
	A.name AS animal_name,
	A.species,
	CS."day",
	K.name AS keeper_name
FROM animals AS A
INNER JOIN care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN keepers AS K ON K.id = CS.keeper_id 
ORDER BY CS.DAY, A.name ;

-- Task - for the above, change to show me the keeper for Ernest the snake
SELECT 
	A.name AS animal_name,
	A.species,
	CS."day",
	K.name AS keeper_name
FROM animals AS A
INNER JOIN care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN keepers AS K ON K.id = CS.keeper_id 
WHERE A.name = 'Ernest' AND A.species = 'Snake'
ORDER BY CS.DAY, A.name ;

-- Various animals feture on various tours around the zoo (this is another example of a many-to-many relationship).
--Identify the JOIN/bridge table linking that animals and tours table and reacquaint yourself with its contents
-- Obtain a table showing animal name and species, the tour name on which they featured,
-- along with the start date and end date (if stored) of their involvement
-- Order the table by tour name, and then by animal name


SELECT 
	A.name,
	A.species ,
	T.name,
	animals_tours.start_date ,
	animals_tours.end_date 
FROM animals AS A
INNER JOIN animals_tours ON A.id = animals_tours.animal_id 
INNER JOIN tours AS T ON animals_tours.tour_id  = T.id 
ORDER BY T.name, A.name ;

-- Harder - can you limit the table to just those animals currently featuring on tours
--Perhaps the NOW() function might help?

SELECT 
	A.name,
	A.species ,
	T.name,
	animals_tours.start_date ,
	animals_tours.end_date 
FROM animals AS A
INNER JOIN animals_tours ON A.id = animals_tours.animal_id 
INNER JOIN tours AS T ON animals_tours.tour_id  = T.id 
WHERE (animals_tours.start_date <= NOW()) AND
((animals_tours.end_date IS NULL) OR (animals_tours.end_date >= NOW()))
ORDER BY T.name, A.name ;


-- Self join - when a table joins to itself - using an INNER JOIN

SELECT 
keepers.name AS keeper_name,
managers.name AS manager_name
FROM keepers 
INNER JOIN keepers AS managers ON keepers.manager_id  = managers.id;

--Optionals
-- Union - columns must be the same

SELECT *
FROM animals 
--100 where conditions
UNION -- eliminates duplicates
SELECT *
FROM animals; 


--Union all, brings back duplicates as well.

SELECT *
FROM animals 
--100 where conditions
UNION ALL
SELECT *
FROM animals; 



















