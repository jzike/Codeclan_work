-- Advanced SQL topics( Quick tour)
-- 1. Create your function
/*
 * Can help when performing the same or similar tasks often (an answer to tediousness)
 * 
 * You may not be allowed to create functions (depends on your database permissions)
 * 
 * omni user cannot create functions (permissions)
 * 
 * functions are attached to databeses
 * 
 */


/*
 * Description of the function below
 */
-- 1. use the keyword CREATE [OR REPLACE] to start defining your FUNCTION 
-- 2. Give your function a name = percent_change
-- 3. Specify the arguments of your function and their datatypes (unlike in R where you don't have to specify the data type)
-- 4. Specify the data type of the result 
-- 5. Write the code for the function 
-- 6. Additional things - specify the language (SQL) PLSQL
-- 7. Immutable means cannot be changed

--Note that the create function input below won't run b/c we don't have permission to create functions on this database 
CREATE OR REPLACE FUNCTION 
percent_change(new_value NUMERIC, old_value NUMERIC, decimals INT DEFAULT 2)
RETURNS NUMERIC AS 
    'SELECT ROUND(100 * (new_value - old_value) / old_value, decimals);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;


-- 8. Call the function, just as you would any other built in function 

SELECT 
	percent_change (50, 40),
	percent_change(100, 99, 4);



SELECT 
	id,
	first_name,
	last_name,
	salary,
	salary + 1000 AS new_salary,
	percent_change(salary + 1000, salary, 2)
FROM employees 
WHERE department = 'Legal'
ORDER BY percent_change DESC NULLS LAST;


SELECT 
	make_badge (first_name, last_name, department) AS badge
FROM employees;

--You kind of need to know how the functions work ahead of time (you can see the available functions in the advanced database view > public > functions)







-- 2. Investigate query performance
-- EXPLAIN, ANALYZE 

/*
 * Why would you do this?
 * Maybe a query is taking a surprisingly long amount of time to run
 * Interview questions (How would I speed up a slow running query?)
 * 
 */

-- Get a table of deparment average salaries for employees working in Germany France Italy or Spain

EXPLAIN ANALYSE 
SELECT 
	department,
	avg(salary)
FROM employees 
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department 
ORDER BY avg(salary);

-- How could we speed up this query?
-- index column(s)!
-- what index column(s) do, is behind the scenes they provide a quick (lookup-y) way of finding rows using the index column

--searching a phone book for 'David Currie'
--Sequential scan (the default behaviour)
--1. start at the start and go through each page until we find 'David Currie'
-- look at all the A's, all the B's, and a good chunk of the C's until we found 'David Currie'

-- Index scan 
-- 2. use an index. notice that the surname starts with a C 
-- go directly to C and look there

-- let's use employees indexed
-- This was created with employees and indexes by country
-- You need to have appropriate permissions to create indexes (so the below CREATE INDEX won't run)

CREATE INDEX employees_indexed_country ON employees_indexed (country ASC NULLS LAST);


EXPLAIN ANALYSE 
SELECT 
	department,
	avg(salary)
FROM employees_indexed
WHERE country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY department 
ORDER BY avg (salary);

-- drawbacks
-- storage (less of an issue these days)
-- slows down other CRUD operations (insert, update, delete) since indexes need to be updated
-- Most common columns to index would be dates, since these are frequently queried. 
-- Sometimes SQL will decide not to use the index b/c it decides that the query would run quicker without.




-- 3. Common table expressions (CTEs) - WITH 

/*
 * We can create temporary tables before the start of our query and access them like tables in teh database
 */

-- Find all the employees in the Legal department who earn less than the mean salary of people in that same department
-- We can solve this using what we already know by using a subquery

SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
					SELECT avg(salary)
					FROM employees
					WHERE department = 'Legal');


/*
 * common tables allow you to specify this temporary table created in our subquery as table in the database
 */

				
WITH dep_average AS(
	SELECT avg(salary) AS avg_salary
	FROM employees 
	WHERE department = 'Legal'
	)
SELECT *
FROM employees 
WHERE department = 'Legal' AND salary < (
				SELECT avg_salary
				FROM dep_average);
			
/*
 * Find all the employees in Legal who earn less than the mean salary and work fewer than the mean fte hours
 */

--subquery solution
SELECT *
FROM employees 
WHERE department  = 'Legal' AND salary < (
	SELECT avg(salary)
	FROM employees
	WHERE department = 'Legal'
	) AND fte_hours < (
	SELECT avg(fte_hours)
	FROM employees 
	WHERE department = 'Legal'
	);	

--solution using common table

WITH dep_averages AS (
SELECT avg(salary) AS avg_salary,
		avg(fte_hours) AS avg_fte
FROM employees 
WHERE department = 'Legal'
)
SELECT *
FROM employees 
WHERE department = 'Legal' AND salary< (
	SELECT avg_salary
	FROM dep_averages
) AND fte_hours < (
	SELECT avg_fte
	FROM dep_averages
);
			
-- Get a table with each employee's 
--first name,
--last name,
--department
--country
--salary
--and a comparison of their salary vs that of the country they work in
--and the department they work in

/*
 * first| last |dep |country | salary | sal vs dep | sal vs country|
 */
--1. get the average salary for each department
--2. get the average salary for each country
--3. 2 JOINs 
--4. using these average values, calculate each employee's ratio (SELECT)			
			
/*
 * first| last |dep |country | salary | dep avg sal | country avg salary|
 */			
			
WITH dep_avgs AS(
	SELECT 
		department,
		avg(salary) AS avg_salary_dept 
	FROM employees 
	GROUP BY department
	),
	country_avgs AS(
	SELECT 
	country,
	avg(salary) AS avg_salary_country
FROM employees 
GROUP BY country
)
SELECT 
	e.first_name ,
	e.last_name ,
	e.department ,
	e.country ,
	e.salary,
	round(e.salary / dep_a.avg_salary_dept, 2) AS employee_ratio_dept,
	round(e.salary / c_a.avg_salary_country, 2) AS employee_ratio_country
FROM employees AS e INNER JOIN dep_avgs AS dep_a
ON e.department = dep_a.department
INNER JOIN country_avgs AS c_a 
ON e.country = c_a.country;



-- 4. Window functions: OVER

/*
 * Show for each employee their salary together with the minimum and maximum salaries for employees in their department
 */

SELECT
first_name ,
last_name ,
salary,
department ,
min(salary) OVER (PARTITION BY department),
max(salary) OVER (PARTITION BY department)
FROM employees ;


-- common tables

WITH dep_avgs AS(
	SELECT 
		department,
		min(salary) AS min_salary,
		max(salary) AS max_salary
	FROM employees 
	GROUP BY department 
	)
SELECT
	e.first_name ,
	e.last_name ,
	e.salary,
	e.department ,
	dep_a.min_salary,
	dep_a.max_salary
FROM employees AS e
INNER JOIN dep_avgs AS dep_a 
ON e.department = dep_a.department
ORDER BY e.department, e.salary;





