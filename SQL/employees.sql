USE employees;

# Exercise 1
# Find the average salary of the male and female employees in each department.
SELECT
    e.gender,
    ROUND(AVG(s.salary), 2) AS average_salary,
    d.dept_name
FROM
    salaries s
        JOIN
    employees e ON s.emp_no = e.emp_no
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
GROUP BY e.gender, d.dept_no
ORDER BY d.dept_name;


# Exercise 2
# Find the lowest department number encountered in the 'dept_emp' table. Then, find
# the highest department number.
SELECT
    MIN(de.dept_no) AS lowest_dept_number,
    MAX(de.dept_no) AS highest_dept_number
FROM
    dept_emp de;


-- Exercise 3
-- Obtain a table containing the following three fields for all individuals whose employee number
-- is not greater than 10040:
-- - employee number
-- - the lowest department number among the departments where the employee has worked in (Hint: use
-- a subquery to retrieve this value from the 'dept_emp' table)
-- - assign '110022' as 'manager' to all individuals whose employee number is lower than or equal to
-- 10020, and '110039' to those whose number is between 10021 and 10040 inclusive.
-- Use a CASE statement to create the third field.
-- If you've worked correctly, you should obtain an output containing 40 rows.
SELECT
    e.emp_no,
    (SELECT
            MIN(de.dept_no)
        FROM
            dept_emp de
        WHERE
            e.emp_no = de.emp_no) lowest_dept_number,
    CASE
        WHEN e.emp_no <= 10020 THEN '110022'
        ELSE '110039'
    END AS manager
FROM
    employees e
WHERE e.emp_no <= 10040;


# Exercise 4
# Retrieve a list of all employees that have been hired in 2000.
SELECT
    *
FROM
    employees
WHERE YEAR(hire_date) = '2000';


-- Exercise 5
-- Retrieve a list of all employees from the ‘titles’ table who are engineers.
-- Repeat the exercise, this time retrieving a list of all employees from the ‘titles’ table who are
-- senior engineers. After LIKE, you could indicate what you are looking for with or without using
-- parentheses. Both options are correct and will deliver the same output. We think using parentheses
-- is better for legibility and that’s why it is the first option we’ve suggested.
SELECT
    *
FROM
    titles
WHERE title = 'Engineer';

SELECT
    *
FROM
    titles
WHERE
    title LIKE ('%engineer%');
    
SELECT
    *
FROM
    titles
WHERE
    title LIKE ('%senior engineer%');


-- Exercise 6
-- Create a procedure that asks you to insert an employee number and that will obtain an output
-- containing the same number, as well as the number and name of the last department the employee has
-- worked in. Finally, call the procedure for employee number 10010. If you've worked correctly, you
-- should see that employee number 10010 has worked for department number 6 - "Quality Management".










