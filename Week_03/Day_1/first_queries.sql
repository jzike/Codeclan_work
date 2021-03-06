/*
*This is a multiline comment
*
*/

-- This is an inline comment

-- Get me a table of all the animals information

-- SELECT = columns to select
-- * = all the columns
-- FROM = table / entity to select FROM 
-- ; = end of query

SELECT *
FROM animals;

-- READ operation

-- Get me a table of information about the animal with ID = 2

SELECT *
FROM animals
WHERE id = 2;

-- Task: Get me a table of information about Ernest the Snake
-- Hint: in sql, varchars are referenced with 'single quotes'

SELECT *
FROM animals 
WHERE id = 7;

-- Because animal ID is a primary key, we can expect only one result from the above query

SELECT *
FROM animals 
WHERE name = 'Ernest' AND species = 'Snake'
