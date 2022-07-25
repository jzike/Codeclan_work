SELECT *
FROM employees;

SELECT *
FROM employees 
WHERE first_name = 'Jessa';

SELECT *
FROM employees 
WHERE country = 'China';

-- Find the info for the employee with id = 3

SELECT *
FROM employees 
WHERE id = 3;


/*
 * Comparison Operators
 * 
 * != not equal to
 * = equal to
 * > greater than
 * < less than
 * <= less than or equal to
 */


-- Find all the employees who work 0.5 full-time equivalent hours or MORE 
SELECT *
FROM employees 
WHERE fte_hours >= 0.5;

/*
 * Task - Find all the employees not based in Brazil
 */

SELECT *
FROM employees 
WHERE country != 'Brazil';


/*
 * Combination operators
 * AND and OR
 */

-- Find all employees in China who started working for omni corp in 2019

SELECT *
FROM employees 
WHERE (country = 'China') AND (start_date >= '2019-01-01'
AND start_date <= '2019-12-31');

-- Be wary of the order of evaluation...

-- Find all the employees in China who either started working for omni corp from 2019 onwards OR are enrolled in the pension scheme

SELECT *
FROM employees 
WHERE country = 'China' AND (start_date >= '2019-01-01'
OR pension_enrol = TRUE);

--WHERE (condition_1) AND (condition_2) - but in above example, condition 2 consists of two conditions

/*
 * BETWEEN, NOT and IN
 * 
 * let you specify a range of values
 * 
 */

-- Find all employees who work between 0.25 and 0.5 fte hours (inclusive)

SELECT *
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5;

-- can think of this as >= lower_range AND <= higher range 

--Find all employees who started working for omni corp in years other than 2017

SELECT *
FROM employees 
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-12-31';

--Things to note: BETWEEN is inclusive. So fte hours could be 0.25 or 0.5 in our example

-- IN 

--Find all employees based in Spain, South Africa, Ireland or Germany

SELECT *
FROM employees 
WHERE country NOT IN ('Spain', 'South Africa', 'Ireland', 'Germany');

-- note: can negate with NOT

-- Task: Find all employees who started work at omni corp in 2016 who work 0.5 fte hours or greater

SELECT *
FROM employees 
WHERE (start_date BETWEEN '2016-01-01' AND '2016-12-31') AND (fte_hours >= 0.5);


/*
 * LIKE, wildcards, and regex
 * 
 */

-- Your manager comes to you and says:

/*
 * I was talking with a colleague from Greece last month. I can't remember their last name exactly. I think it began with 'Mc...' something or other. Can you find them?
 */

SELECT *
FROM employees 
WHERE (country = 'Greece') AND (last_name LIKE 'Mc%');

/*
 * Wildcards
 * _ a single character
 * % matches zero or more characters
 * 
 */

-- You can put wildcards anywhere in the pattern

--Find all employees with last names containing the phrase 'ere'

SELECT *
FROM employees 
WHERE last_name LIKE '%ere%';


/*
 * LIKE is case sensitive (distinguishes between lower and upper case)
 * 
 */

SELECT *
FROM employees 
WHERE last_name LIKE 'D%';

-- You can use ILIKE to be insensitive to upper/lowercase letters

SELECT *
FROM employees 
WHERE last_name ILIKE 'D%';


-- ~ to define a regex pattern match

--Find all employees for who the second letter of their last name is 'r' or 's' and the third letter is 'a' or 'o'

SELECT *
FROM employees 
WHERE last_name ~ '^.[rs][ao]';

-- '^' anchors the expression to the beginning of the string
-- '.' matches any character


-- regex tweaks

/*
 *  ~ ---- define a regex
 *  ~*---- define a case-insensitive regex
 * !~---- define a negative regex (case sensitive, does not match pattern)
 * !~* ---- define a case-insensitive negative regex (does not match pattern
 */


SELECT *
FROM employees 
WHERE last_name !~ '^.[rs][ao]';


/*
 * IS NULL
 */

-- Q: We need to ensure our employee records are up to date. Find all employees who do not have a listed email address

SELECT *
FROM employees 
WHERE email IS NULL;

-- You must use 'column name' IS NULL, not 'column name' = NULL. If you use = NULL, it will run but it won't work. It is similar to is.na() in R

















