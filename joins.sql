USE employees;

SELECT
    *
FROM
    departments_dup;


ALTER TABLE departments_dup
DROP COLUMN dept_manager;


ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no CHAR(4) NULL;


ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;


SELECT
    *
FROM
    departments_dup;


INSERT INTO departments_dup
    (dept_name)
VALUES('Public Relations');


DELETE FROM
    departments_dup
WHERE
    dept_no = 'd002'; 


SELECT
    *
FROM
    departments_dup;


DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
    emp_no int(11) NOT NULL,
    dept_no char(4) NULL,
    from_date date NOT NULL,
    to_date date NULL
);


INSERT INTO dept_manager_dup
SELECT
    *
FROM
    dept_manager;


INSERT INTO dept_manager_dup
    (emp_no, from_date)
VALUES
    (999904, '2017-01-01'),
    (999905, '2017-01-01'),
    (999906, '2017-01-01'),
    (999907, '2017-01-01');


DELETE FROM
    dept_manager_dup
WHERE
    dept_no = 'd001';


SELECT 
    *
FROM
    departments_dup;


SELECT 
    *
FROM
    dept_manager_dup;


# Exercise:
# Extract a list containing information about all managers’
# employee number, first and last name, department number, and hire date.
SELECT
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    e.hire_date
FROM
    employees e
JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;


# inner join or commonly referred to as join
SELECT
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m 
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY dept_no;


# Remove the duplicates from the two tables.
DELETE FROM dept_manager_dup
WHERE emp_no = '110228';

DELETE FROM departments_dup
WHERE dept_no = 'd009';


# Add back the initial records.
INSERT INTO dept_manager_dup
VALUES ('110228', 'd003', '1992-03-21', '9999-01-01');

INSERT INTO departments_dup
VALUES ('d009', 'Customer Service');


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no;


SELECT
    *
FROM
    dept_manager_dup
ORDER BY dept_no;


# What happens when we switch the JOIN order?
SELECT
    m.dept_no, m.emp_no, d.dept_name
FROM
    departments_dup d 
        LEFT JOIN
    dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY m.dept_no;


# The first SELECT should match the first FROM table
SELECT
    d.dept_no, m.emp_no, d.dept_name
FROM
    departments_dup d 
        LEFT JOIN
    dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY d.dept_no;


# LEFT JOIN = LEFT OUTER JOIN syntax wise. However, the result sets are different.
# Select the 6 NULL values via the WHERE clause to retrieve info from the
# right table that is NULL. This result set with the added WHERE clause is
# our LEFT OUTER JOIN.
SELECT
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m 
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
WHERE
    dept_name IS NULL
ORDER BY m.dept_no;


/* Exercise:
Join the 'employees' and the 'dept_manager' tables to return a subset of all the employees
whose last name is Markovitch. See if the output contains a manager with that name.

Hint: Create an output containing information corresponding to the following fields:
‘emp_no’, ‘first_name’, ‘last_name’, ‘dept_no’, ‘from_date’. Order by 'dept_no' descending
and then by 'emp_no'.
*/
SELECT
    *
FROM
    employees
ORDER BY emp_no;


SELECT
    *
FROM
    dept_manager
ORDER BY emp_no;


SELECT
    e.emp_no, e.first_name, e.last_name, m.from_date, m.dept_no
FROM
    employees e
        LEFT JOIN
    dept_manager m ON e.emp_no = m.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY m.dept_no DESC, e.emp_no;


# Whether we run a RIGHT JOIN or a LEFT JOIN with an inverted tables order, we will
# obtain the same output.
SELECT
    e.emp_no, e.first_name, e.last_name, m.from_date, m.dept_no
FROM
    dept_manager m
        RIGHT JOIN
    employees e ON e.emp_no = m.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY m.dept_no DESC, e.emp_no;



# The new and the old JOIN syntax. Using WHERE is more time consuming and considered an
# old practice. The JOIN syntax allows you to modify the connection between tables easily.
SELECT
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m,
    departments_dup d
WHERE
    m.dept_no = d.dept_no
ORDER BY dept_no;


# Extract a list containing information about all managers’ employee number, first and
# last name, department number, and hire date. Use the old type of join syntax to obtain the result.
SELECT
    e.emp_no, e.first_name, e.last_name, e.hire_date, m.dept_no
FROM
    employees e,
    dept_manager m
WHERE
    e.emp_no = m.emp_no
ORDER BY e.emp_no;


# Newer JOIN syntax, same result.
SELECT
    e.emp_no, e.first_name, e.last_name, e.hire_date, m.dept_no
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
ORDER BY e.emp_no;


# Select the first and last name, the hire date, and the job title of all employees
# whose first name is “Margareta” and have the last name “Markovitch”.
SELECT
    e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE 
	e.first_name = 'Margareta' AND e.last_name = 'Markovitch'
ORDER BY e.emp_no;


# CROSS JOIN or Cartesian product
SELECT
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
ORDER BY dm.emp_no, d.dept_no;


# CROSS JOIN = INNER JOIN = Old syntax
SELECT
    dm.*, d.*
FROM
    dept_manager dm,
    departments d
ORDER BY dm.emp_no, d.dept_no;


# JOIN + ON = CROSS JOIN + WHERE
SELECT
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;


# CROSS JOIN multiple tables
SELECT
    e.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
        JOIN
    employees e ON dm.emp_no
WHERE d.dept_no <> dm.dept_no
ORDER BY dm.emp_no, d.dept_no;


# Exercise:
# Use a CROSS JOIN to return a list with all possible combinations between managers
# from the dept_manager table and department number 9.
SELECT
    dm.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE 
    d.dept_no = 'd009'
ORDER BY d.dept_name;


# Exercise:
# Return a list with the first 10 employees with all the departments they can be assigned to.
SELECT
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;


# Find the average salary of the men and women in the company.
SELECT
    e.gender, AVG(s.salary) AS average_salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY gender;


# JOIN multiple tables
# first_name, last_name, hire_date are in the employees table.
# from_date is in the dept_manager table.
# dept_name is in the departments table.
SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no;


# We can achieve the same output, except the order will be sorted differently.
SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    employees e ON m.emp_no = e.emp_no;


# JOIN more than two tables exercise:
# Select all managers’ first and last name, hire date, job title, start date, and department name.
SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no;


# 2nd Solution:
SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    m.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    departments d ON m.dept_no = d.dept_no
        JOIN
    titles t ON e.emp_no = t.emp_no
            AND m.from_date = t.from_date
ORDER BY e.emp_no;


SELECT
    d.dept_name, AVG(salary) AS average_salary
    
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
#ORDER BY d.dept_no;
ORDER BY AVG(salary) DESC;


# How many male and how many female managers do we have in the ‘employees’ database?
SELECT
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;


# UNION vs UNION ALL
SELECT
    *
FROM
    (SELECT
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT
            NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) as a
ORDER BY -a.emp_no DESC;





