/* -- MVP -- */

-- Q1 -- 
-- How many employee records are lacking both a grade and salary?
SELECT
    count(e.id)  
FROM employees AS e
WHERE e.grade IS NULL AND e.salary IS NULL;
    

-- Q2 -- 
-- Produce a table with the two following fields (columns):
--  * the department
--  * the employees full name (first and last name)
--  * Order your resulting table alphabetically by department,
--    and then by last name
SELECT
    department,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY
    department ASC NULLS LAST,
    full_name ASC NULLS LAST;
    


-- Q3 -- 
--Find the details of the top ten highest paid employees who have a
--  last_name beginning with ‘A’.
SELECT * 
FROM employees 
WHERE lower(last_name) like 'a%' and salary notnull
ORDER BY salary DESC 
LIMIT 10;


-- Q4 -- 
-- Obtain a count by department of the employees who started work with the
-- corporation in 2003.
SELECT 
  department, 
  COUNT(id) AS employee_numbers 
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;



-- Q5 -- 
-- Obtain a table showing department, fte_hours and the number of employees in each
-- department who work each fte_hours pattern. Order the table alphabetically by
-- department, and then in ascending order of fte_hours.
-- Hints --
-- You need to GROUP BY two columns here.
SELECT 
  department,
  fte_hours,
  COUNT(id) AS employee_numbers 
FROM employees
GROUP BY
    department,
    fte_hours 
HAVING fte_hours NOTNULL
ORDER BY 
    department ASC,
    fte_hours ASC;


-- Q6 -- 
-- Provide a breakdown of the numbers of employees enrolled, not enrolled, 
--and with unknown enrollment status in the corporation pension scheme.
select 
    pension_enrol,
    count(id)   AS num_enrolled 
from employees 
group by pension_enrol;


-- Q7 -- 
-- Obtain the details for the employee with the highest salary in the ‘Accounting’
-- department who is not enrolled in the pension scheme?
SELECT * 
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
LIMIT 1;


-- Q8 -- 
-- Get a table of country, number of employees in that country,
--  and the average salary of employees in that country for any
-- countries in which more than 30 employees are based. Order the table by average salary descending.
-- Hints --
-- A HAVING clause is needed to filter using an aggregate function.
-- You can pass a column alias to ORDER BY.
 SELECT 
  country,
  COUNT(id) AS employee_numbers,
  round(avg(salary)) AS avg_salary
FROM employees
WHERE country IN (SELECT
                    country
                  FROM employees
                  GROUP BY country
                  HAVING count(country) > 30)
GROUP BY country
ORDER BY avg_salary DESC NULLS LAST;
    

-- Q9 -- 
-- 11. Return a table containing each employees first_name, last_name,
-- full-time equivalent hours (fte_hours), salary, and a new column
--  effective_yearly_salary which should contain fte_hours multiplied by salary.
-- Return only rows where effective_yearly_salary is more than 30000.
SELECT 
  first_name,
  last_name,
  fte_hours,
  salary 
  (fte_hours * salary) AS effective_yearly_salar
FROM employees
WHERE (fte_hours * salary) > 30000


-- Q10 -- 
-- Find the details of all employees in either Data Team 1 or Data Team 2
-- Hint
-- name is a field in table `teams
SELECT 
t.name AS team_name,  
e.*
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
WHERE t.name = 'Data Team 2' -- WHERE t.name LIKE 'Data Team%'

-- Q11 -- 
-- Find the first name and last name of all employees who lack a local_tax_code.
-- Hints --
--local_tax_code is a field in table pay_details, and first_name and last_name
-- are fields in table employees
SELECT 
e.first_name,
e.last_name,
pd.local_tax_code 
FROM employees AS e INNER JOIN pay_details AS pd
ON e.id = pd.id
WHERE pd.local_tax_code IS NULL


-- Q12 -- 
-- The expected_profit of an employee is defined as
-- (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends 
-- upon the team to which the employee belongs. Get a table showing expected_profit
-- for each employee.
-- Hints --
-- charge_cost is in teams, while salary and fte_hours are in employees,
-- so a join will be necessary
-- You will need to change the type of charge_cost in order to perform the calculation
SELECT 
  e.first_name, 
  e.last_name,
  (48 * 35 * CAST(t.charge_cost AS int) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id;

-- Q13 --  [Tough]
-- Find the first_name, last_name and salary of the lowest paid employee in Japan
-- who works the least common full-time equivalent hours across the corporation.”
-- Hints --
-- You will need to use a subquery to calculate the mode
/*SELECT
    first_name,
    last_name,
    MIN(salary) AS min_salary
FROM 
    employees 
WHERE
    country = 'Japan' AND fte_hours IN (
    SELECT fte_hours
  FROM employees
  GROUP BY fte_hours
  HAVING COUNT(*) = (
    SELECT MAX(count)
    FROM (
      SELECT COUNT(*) AS count
      FROM employees
      GROUP BY fte_hours
    ) AS temp
  ); */ 
/*SELECT
        fte_hours,
        how_many AS how_many
    FROM (
        SELECT
        fte_hours,
                COUNT(*) AS how_many,
                RANK() OVER (ORDER BY COUNT(*) DESC) AS fte_hours_rank
            FROM employees
            GROUP BY fte_hours
    ) 
    WHERE fte_hours_rank = 1 */-- failed attempt
  
SELECT
    first_name,
    last_name,
    salary AS min_salary
FROM employees
WHERE country = 'Japan' AND fte_hours IN(
    SELECT
        fte_hours,
        COUNT(*) AS how_many
    FROM employees
    GROUP BY fte_hours 
    ORDER BY how_many DESC
    FETCH FIRST 1 ROWS WITH TIES
    )
ORDER BY salary 
LIMIT 1;

--ANSWER:
SELECT
  first_name,
  last_name,
  salary
FROM employees
WHERE country = 'Japan' AND fte_hours = (
  SELECT fte_hours
  FROM employees
  GROUP BY fte_hours
  ORDER BY COUNT(*) DESC NULLS LAST
  LIMIT 1
  )
ORDER BY salary ASC NULLS LAST
LIMIT 1

-- Q14 -- 
-- Obtain a table showing any departments in which there are two or more employees
-- lacking a stored first name. Order the table in descendl order by department.
SELECT 
  department, 
  COUNT(*) AS no_first 
FROM employees
HAVING first_name IS NULL AND count(*) > 1
GROUP BY department
ORDERY BY department DESC ;


--ANSWER:
SELECT department, COUNT(id) AS num_employees_no_first
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY COUNT(id) DESC NULLS LAST, department ASC NULLS LAST

-- ing order of the number
-- of employees lacking a first name, and then in alphabetica


-- Q15 --  [Bit tougher]
-- Return a table of those employee first_names shared by more than one employee,
-- together with a count of the number of times each first_name occurs. 
-- Omit employees without a stored first_name from the table. 
-- Order the table descending by count, and then alphabetically by first_name.

-- ANSWER:
SELECT 
  first_name, 
  COUNT(id) AS name_count
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name 
HAVING COUNT(id) > 1
ORDER BY COUNT(id) DESC, first_name ASC

-- Q16 --  [Tough]
-- Find the proportion of employees in each department who are grade 1.
-- Hints --
-- Think of the desired proportion for a given department as the number of
-- employees in that department who are grade 1, divided by the total number of
-- employees in that department.
-- You can write an expression in a SELECT statement, e.g. grade = 1.
-- This would result in BOOLEAN values.


SELECT 
  department, 
  SUM(CAST(grade = '1' AS INT)) / CAST(COUNT(id) AS REAL) AS prop_grade_1 
FROM employees 
GROUP BY department

-- OR 

SELECT
  department, 
  SUM((grade = '1')::INT) / COUNT(id)::REAL AS prop_grade_1 
FROM employees 
GROUP BY department