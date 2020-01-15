USE employees;

SELECT
    *
FROM
    dept_emp;


# SQL Error 1055 again?
SELECT
    emp_no, from_date, to_date, COUNT(emp_no) AS Num
FROM
    dept_emp
GROUP BY emp_no
HAVING Num > 1;


# This is can viewed in the "views" subsection of the schema on MYSQL Workbench.
# The third icon executes the view query.
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS 
    SELECT
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;


-- Create a view that will extract the average salary of all managers registered in the database.
-- Round this value to the nearest cent. If you have worked correctly, after executing the view
-- from the “Schemas” section in Workbench, you should obtain the value of 66924.27.
CREATE OR REPLACE VIEW v_average_manager_salary AS
    SELECT
        ROUND(AVG(salary), 2) AS average_manager_salary
    FROM
        employees e
            JOIN
        dept_manager m ON e.emp_no = m.emp_no
            JOIN
        salaries s ON m.emp_no = s.emp_no;


# Solution
CREATE OR REPLACE VIEW v_manager_avg_salary AS
    SELECT
        ROUND(AVG(salary), 2)
    FROM
        salaries s
            JOIN
        dept_manager m ON s.emp_no = m.emp_no;
