# Create a visualization that provides a breakdown between the male and female
# employees working in the company each year, starting from 1990.
USE employees_mod;

SELECT
    emp_no,
    from_date,
    to_date
FROM
    t_dept_emp;


# Using DISTINCT, check to see if the output is the same.
SELECT DISTINCT
    emp_no,
    from_date,
    to_date
FROM
    t_dept_emp;


SELECT
    YEAR(de.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS number_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no

GROUP BY calendar_year, e.gender
HAVING calendar_year >= '1990'
ORDER BY calendar_year;
