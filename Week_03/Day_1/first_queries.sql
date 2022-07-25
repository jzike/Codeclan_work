/*
*This is a multiline comment
*
*/

-- This is an inline comment

-- Get me a table of all the animals information

-- SELECT = columns to select
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

SELECT *
FROM animals 
WHERE id = 7;

SELECT *
FROM animals 
WHERE name = 'Ernest' AND species = 'Snake'
