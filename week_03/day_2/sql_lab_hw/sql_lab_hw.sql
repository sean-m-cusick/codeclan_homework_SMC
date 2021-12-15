/* -- MVP -- */

-- Q1 -- 
-- (a). Find the first name, last name and team name of employees who
-- are members of teams.
SELECT
    t.name,
    e.first_name,
    e.last_name 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id;
    


-- (b). Find the first name, last name and team name of employees who
-- are members of teams and are enrolled in the pension scheme.
SELECT
    t.name,
    e.first_name,
    e.last_name,
    e.pension_enrol 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
WHERE e.pension_enrol = TRUE;

-- (c). Find the first name, last name and team name of employees who
-- are members of teams, where their team has a charge cost greater than 80
SELECT
    t.name,
    e.first_name,
    e.last_name,
    t.charge_cost
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
where cast(charge_cost as int) > 80;


-- Q2 -- 
-- (a). Get a table of all employees details, together with their
-- local_account_no and local_sort_code, if they have them.
SELECT
    e.*,
    pd.local_account_no,
    pd.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.id = pd.id;

-- (b). Amend your query above to also return the name of the team
-- that each employee belongs to
SELECT
    e.*,
    pd.local_account_no,
    pd.local_sort_code,
    t.name AS team_name
FROM (employees AS e LEFT JOIN pay_details AS pd
ON e.id = pd.id)
LEFT JOIN teams AS t
ON e.team_id = t.id;



-- Q3 -- 
-- (a). Make a table, which has each employee id along with the team
-- that employee belongs to
SELECT
    e.id,
    t.name 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id;

-- (b). Breakdown the number of employees in each of the teams.
SELECT
    t.name,
    COUNT(e.id) AS employees_in_team 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY t.name;


-- (c). Order the table above by so that the teams with the least
-- employees come first.
SELECT
    t.name,
    COUNT(e.id) AS employees_in_team 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY t.name
ORDER BY employees_in_team;


-- Q4 -- 
-- (a). Create a table with the team id, team name and the count of the
-- number of employees in each team.
SELECT
    e.team_id,
    t.name,
    COUNT(e.id) AS employees_in_team 
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY e.team_id, t.name;

-- (b). The total_day_charge of a team is defined as the charge_cost of
-- the team multiplied by the number of employees in the team. Calculate the total_day_charge for each team.
SELECT
    COUNT(e.team_id),
    t.name,
    (CAST(t.charge_cost AS int)*COUNT(e.id)) AS total_day_charge
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY e.team_id, t.name, t.charge_cost;



-- (c). How would you amend your query from above to show only those
-- teams with a total_day_charge greater than 5000?
SELECT
    COUNT(e.team_id),
    t.name,
    (CAST(t.charge_cost AS int)*COUNT(e.id)) AS total_day_charge
FROM teams AS t INNER JOIN employees AS e
ON t.id = e.team_id
GROUP BY e.team_id, t.name, t.charge_cost
WHERE total_day_charge > 5000; -- Not working / cast as int

SELECT 
    t.name,
    COUNT(e.id) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id 
HAVING COUNT(e.id) * CAST(t.charge_cost AS INT) > 5000

SELECT 
  t.name,
  COUNT(e.id) * CAST(t.charge_cost AS INT) AS total_day_charge
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
HAVING COUNT(e.id) * CAST(t.charge_cost AS INT) > 5000


/* -- EXTENSION -- */

-- Q5 -- 
-- How many of the employees serve on one or more committees?
SELECT
    count(e.id) AS in_committee
    ec.committee_id
FROM employees AS e
GROUP BY ec.committee_id, e.id
WHERE in_committee > 1 (
    SELECT
        ec.employee_id FROM employees_committees AS ec)

--INNER JOIN employees_committees AS ec ON e.id = ec.employee_id 

SELECT 
  COUNT(DISTINCT(employee_id)) AS num_employees_on_committees
FROM employees_committees

-- Q6 -- 
-- How many of the employees do not serve on a committee?
SELECT
    ec.committee_id 
    COUNT(e.id) AS not_in_committee
FROM employees AS e
WHERE e.id NOT IN (
    SELECT 
        ec.employee_id FROM employees_committees AS ec)
        
        
SELECT 
  COUNT(*) AS num_not_in_committees
FROM employees e
LEFT JOIN employees_committees ec
ON e.id = ec.employee_id 
WHERE ec.employee_id IS NULL

SELECT 
  (SELECT COUNT(id) FROM employees) -
  (SELECT COUNT(DISTINCT(employee_id)) FROM employees_committees)
    AS num_not_in_committees