/* MVP */


/* Q1
 * Find all the employees who work in the ‘Human Resources’ department */
SELECT * 
FROM employees 
WHERE department = 'Human Resources';

/* Q2
 * Get the first_name, last_name,
 * and country of the employees who work in the ‘Legal’ department. */
SELECT  
  first_name, 
  last_name,
  country 
FROM employees 
WHERE department = 'Legal';

/* Q3 
 * Count the number of employees based in Portugal.*/
SELECT 
  COUNT(id) 
FROM employees 
WHERE country = 'Portugal'

/* Q4 
 * Count the number of employees based in either Portugal or Spain.*/
SELECT 
  COUNT(id) 
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain'

/* Q5
 * Count the number of pay_details records lacking a local_account_no. */
SELECT 
  COUNT(*) 
FROM pay_details pd 
WHERE local_account_no IS NULL 

/* Q6 
 * Are there any pay_details records lacking both a local_account_no
 * and iban number?*/
SELECT 
  local_account_no,
  iban 
FROM pay_details pd 
WHERE local_account_no IS NULL AND iban IS NULL 
-- checked with OR - no matches


/* Q7 
 * Get a table with employees first_name
 * and last_name ordered alphabetically by last_name (put any NULLs last).*/
SELECT * 
FROM employees 
ORDER BY 
     last_name ASC NULLS LAST,  
    first_name ASC NULLS LAST;


/* Q8
 * Get a table of employees first_name, last_name and country,
 * ordered alphabetically first by country 
 * and then by last_name (put any NULLs last). */
SELECT * 
FROM employees 
ORDER BY 
    country ASC NULLS LAST, 
    last_name ASC NULLS LAST,  
    first_name ASC NULLS LAST;

/* Q9
 * Find the details of the top ten highest paid employees in the corporation. */
SELECT * 
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;

/* Q10 
 * Question 10.
Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/
SELECT
    first_name, 
    last_name,
    salary 
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS FIRST 
LIMIT 1;

/* Q11
 * How many employees have a first_name beginning with ‘F’? */
SELECT 
  COUNT(*)
FROM employees
WHERE first_name ~* '^f';


/* Q12
 * Find all the details of any employees with a ‘yahoo’ email address? */
SELECT *
FROM employees
WHERE email ~* '@yahoo.*$';

/* Q13
 * Count the number of pension enrolled employees
 * not based in either France or Germany.*/
SELECT 
  COUNT(id) 
FROM employees
WHERE (country != 'France' AND country != 'Germany') AND pension_enrol = TRUE
-- WHERE pension_enrol = TRUE AND (country != 'France' OR country != 'Germany')

/* Q14
 * What is the maximum salary among those employees in the ‘Engineering’ department
 * who work 1.0 full-time equivalent hours (fte_hours)? */
SELECT
    salary 
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1
ORDER BY salary ASC NULLS FIRST 
LIMIT 1;

/* Q15 
 * Return a table containing each employees first_name, last_name,
 * full-time equivalent hours (fte_hours), salary,
 * and a new column effective_yearly_salary which should contain
 * fte_hours multiplied by salary.*/
SELECT
    first_name,
    last_name,
    fte_hours,
    salary,
    (fte_hours * salary) AS effective_yearly_salary 
FROM employees 
ORDER BY salary ASC NULLS LAST 




/* Extension */

/* Q16 */

/* Q17 */

/* Q18 */