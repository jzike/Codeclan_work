/*
 * Manipulating returned data 
 * 
 * 
 * specifying column aliases using AS
 * use the DISTINCT() function
 * use some aggregate functions
 * sort records
 * limit the number of records returned
 */


-- we can manipulate the data that is returned by a query by altering the SELECT statement. 

SELECT 
	id,
	first_name,
	last_name
FROM employees 
WHERE department = 'Accounting';

-- Column aliases

-- Can we get a list of all employees with their first name and last name combined together into one field (column) called 'full_name'?


SELECT
	first_name,
	last_name,
	concat (first_name, ' ', last_name) AS full_name 
FROM employees;


-- You can export tables by right clicking and selecting export

-- Task - 2 mins
-- Add a WHERE clause to the query above to filter out any rows that don’t have both a first and second name

SELECT
	first_name,
	last_name,
	concat (first_name, ' ', last_name) AS full_name 
FROM employees
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL)

-- aliases (creating a new column using AS) are good because they're more informative than the default 



/*
 * DISTINCT()
 */


-- The company's problem: 

--Our database might be out of date! There's been a recent restructuring, we should now have six departments in the corp.
--How many departments do employees belong to at present in the database? 

SELECT DISTINCT(department)
FROM employees;

-- all the different distinct values within the department column (field)


/*
 * Aggregate functions
 */

-- How many employees started work for omni corp in 2001?

SELECT 
	count(*) AS started_in_2001
FROM employees 
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';



/*
 * Other aggregates
 * 
 * SUM() ---- sum of a column
 * AVG() ---- mean of a column
 * MIN() ---- min value of a column
 * MAX() ---- max value of a column
 */


/*
 * Task - 10 mins
 * 
 * Design queries using aggregate functions and what you have learned so far to answer these questions:
 * 
 * 1. What are the maximum and minimum salaries of all employees?
 * 2. What is the mean salary of employees in the Human Resources department?
 * 3. How much does the corporation spend on the salaries of employees hired in 2018?
 */


--Q1

SELECT 
	MIN(salary) AS minimum_salary,
	MAX(salary) AS maximum_salary
FROM employees;

--Q2

SELECT 
	AVG(salary) AS mean_salary_hr
FROM employees 
WHERE department = 'Human Resources';

--Q3

SELECT 
	SUM(salary) AS sum_salary_2018
FROM employees 
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';



/*
 * Sorting the results
 * 
 * ORDER BY
 */

-- Sorts the return of a query either - DESC or ASC 
-- thing to note ORDER BY comes after WHERE 

-- Get me a table of the employee's details for the employee who earns the minimum salary across Omni corp

SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary ASC 
LIMIT 1;

-- Limit the query results with LIMIT + a number 
-- if we want to put NULLS at the end of the sorted list, use NULLS LAST

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

/*
 * We can perform multi-level sorts (sorts on multiple columns)
 */



-- get me a table with employee details, ordered by fulltime equivalent hours (highest first) and then alphabetically by last name 

SELECT *
FROM employees 
ORDER BY
	fte_hours DESC NULLS LAST,
	last_name ASC NULLS LAST;

/*
 * Task - 5 min
 * 
 * Write queries to answer the following questions using the operators introduced in this section
 * 
 * 1. Get the details of the longest serving employee of the corp
 * 2. Get the details of the highest paid employee of the corp in Libya
 *
 */

-- Q1
SELECT *
FROM employees 
ORDER BY start_date ASC NULLS LAST
LIMIT 1;


-- Q2
SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC NULLS LAST 
LIMIT 1;


-- A note on ties 

-- ties can happen when ordering (e.g. two employees started on the same date) - LIMIT 1 would just return 1 row even when there was a tie 

-- Write a first query to find the max value in a COLUMN 
-- use this result in the where clause of a second query to find all rows with that value 

-- Get me a table of all employees who work in the alphabetically first country

SELECT 
	country
FROM employees 
ORDER BY country
LIMIT 1;


SELECT *
FROM employees 
WHERE country = 'Afghanistan'

-- Coming up tomorrow - will show how to nest queries so that you don't have to do separate operations to find the answer to the above question

SELECT 
	id, 
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name
	FROM employees 
	WHERE full_name LIKE 'A%';

-- The above operation does not execute because 
-- The order of definition != order of execution (SELECT happens later than it looks like)
-- So full_name doesn't exist yet!


--You would have to put the concat in WHERE as well.

SELECT 
	id, 
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name
	FROM employees 
	WHERE concat(first_name, ' ', last_name) LIKE 'A%';











