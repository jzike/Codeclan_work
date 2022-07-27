-- Find the number of employees within each department
SELECT
	count(id) AS num_employees,
	department
FROM employees 
GROUP BY department --Anything IN the GROUP BY can be IN the SELECT, but you can't use an AGGREGATE IN SELECT AND COLUMN names unless those COLUMN names ARE ALSO IN GROUP BY
ORDER BY count(id);


--How many employees are there in each country and department

SELECT 
	count(id) AS num_employees,
	country,
	department
FROM employees 
GROUP BY country, department
ORDER BY country;

--How many employees in each department work either 0.25 or 0.5 FTE hours

SELECT 
	count (id),
	fte_hours
FROM employees
--WHERE fte_hours BETWEEN 0.25 AND 0.5
--WHERE fte_hours = 0.25 OR fte_hours = 0.5
WHERE fte_hours IN (0.25, 0.5) --IN the background, SQL breaks this up INTO an OR
GROUP BY fte_hours ;

-- See how NULL affects counts
-- Gotcha Counts can exist without a group by if no other column is present
SELECT 
count(id), -- IF IN doubt about what TO put IN count parentheses, use the PRIMARY key
count(first_name), -- count does NOT INCLUDE nulls
count(*) -- BIG gotcha - IF you use count * it will INCLUDE NULLS
FROM employees;


-- Find the longest serving employee in each department
-- COUNT, SUM, AVG, MIN, MAX
-- NOW() gives today's date and time (for the server)

SELECT 
	NOW() - MIN(start_date) AS time_served,
	first_name,
	last_name,
	department,
	ROUND (EXTRACT (DAYS FROM NOW() - MIN (start_date)) / 365)
FROM employees 
WHERE start_date IS NOT NULL
GROUP BY 
	department, first_name, last_name 
ORDER BY time_served DESC;



/*
 * Order of execution
 * 1) FROM
 * 2) WHERE
 * 3) GROUP BY
 * 4) HAVING
 * 5) SELECT
 * 6) ORDER BY
 * 7) LIMIT
 */


-- Task - How many employees in each department are enrolled in the pension scheme
-- Perform a breakdown by country of the number of employees that do not have a stored first NAME

SELECT 
	count(id) AS pension_enrolled_employees,
	department
FROM employees 
WHERE pension_enrol IS TRUE 
GROUP BY department 
ORDER BY pension_enrolled_employees;

SELECT 
	count(id) AS no_stored_first_name,
	country
FROM employees 
WHERE first_name IS NULL 
GROUP BY country 
ORDER BY no_stored_first_name;

-- Show those department in which at least 40 employees work either 0.25 or 0.5 FTE hours
-- The WHERE clause for group by is called a HAVING
SELECT 
count(id),
department
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.50
GROUP BY department
HAVING count(id) >=40; -- ONLY works WITH aggregates

-- Show any countries in which the minimum salary amongst pension enrolled employees in less than 21,000 dollars.

SELECT
	country,
	min(salary),
	department
FROM employees 
WHERE pension_enrol = TRUE
GROUP BY country, department 
HAVING min(salary) < 21000
ORDER BY min(salary), country, department

-- NOTE: order by is usually similar to the group by.


-- Task - show any department in which the earliest [MIN] start date amongst grade 1 employees is prior to 1991

SELECT 
	department,
	min (start_date) AS min_start_date
FROM employees 
WHERE grade = 1
GROUP BY department
HAVING min(start_date) < '1991-01-01'
ORDER BY min_start_date;


/*
 * Nested operations
 */


-- Find all the employees in Japan who earn over the company-wide average salary

SELECT *
FROM employees 
WHERE country = 'Japan'
AND salary > (
				SELECT
				avg (salary)
				FROM employees
			);




-- Find all the employees in Legal who earn less than the avg salary in that same department
		
SELECT *
FROM employees 
WHERE department = 'Legal'
AND salary < (
				SELECT
				avg (salary)
				FROM employees
				WHERE department = 'Legal'
				);

--Check avg salary for legal employees

SELECT
	avg (salary)
FROM employees 
WHERE department = 'Legal'


--

SELECT 
	count(id),
	country,
	salary 
FROM employees 
WHERE department = 'Legal'
AND salary < (
				SELECT
				avg (salary)
				FROM employees
				WHERE department = 'Legal'
				)
GROUP BY country, salary 
ORDER BY salary, country; -- GOTCHA - ordery BY COLUMNS IS important







