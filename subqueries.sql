SELECT
    *
FROM
    dept_manager;

# Select the first and last name form the "Employees" table for the same employee numbers
# that can be found in the "Department Manager" table.
SELECT
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT
            dm.emp_no
        FROM
            dept_manager dm);


# Extract the information about all department managers who were hired between the 1st of
# January 1990 and the 1st of January 1995.
SELECT
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');


# EXISTS tests row value for existence. Quicker in retrieving large amounts of data.
# IN searches among values. Faster with smaller data sets.


# Select the entire information for all employees whose job title is “Assistant Engineer”.
SELECT
    *
FROM
    employees
WHERE
    emp_no IN (SELECT
            emp_no
        FROM
            titles
        WHERE
            title = 'Assistant Engineer');


# Same solution.
SELECT
    *
FROM
    employees e
WHERE
    EXISTS( SELECT
                *
            FROM
                titles t
            WHERE
               t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');


# Assign employee number 110022 as a manager to all employees from 10001
# to 10020, and employee number 110039 as a manager to all employees 
# from 10021 to 10040.

# Subset A UNION subset B.
SELECT
    A.*
FROM
    (SELECT
        e.emp_no as employee_ID,
        MIN(de.dept_no) as department_code,
        (SELECT
                emp_no
            FROM
                dept_manager
            WHERE
                emp_no = 110022) as manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION
SELECT
    A.*
FROM
    (SELECT
        e.emp_no as employee_ID,
        MIN(de.dept_no) as department_code,
        (SELECT
                emp_no
            FROM
                dept_manager
            WHERE
                emp_no = 110039) as manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;


# Starting your code with “DROP TABLE”, create a table called “emp_manager”
# (emp_no – integer of 11, not null; dept_no – CHAR of 4, null;
# manager_no – integer of 11, not null). 
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager
(
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);


-- Fill emp_manager with data about employees, the number of the department they are working in,
-- and their managers.
--
-- Your query skeleton must be:
--
-- Insert INTO emp_manager SELECT
-- U.*
-- FROM
--                  (A)
-- UNION (B) UNION (C) UNION (D) AS U;
--
-- A and B should be the same subsets used in the last lecture (SQL Subqueries Nested in SELECT and FROM).
-- In other words, assign employee number 110022 as a manager to all employees from 10001 to 10020
-- (this must be subset A), and employee number 110039 as a manager to all employees from 10021 to 10040
-- (this must be subset B).
--
-- Use the structure of subset A to create subset C, where you must assign employee number 110039 as a
-- manager to employee 110022. Following the same logic, create subset D. Here you must do the opposite
-- - assign employee 110022 as a manager to employee 110039.

INSERT INTO emp_manager
SELECT
    U.*
FROM
    (SELECT
        A.*
    FROM
        (SELECT
            e.emp_no as employee_ID,
            MIN(de.dept_no) as department_code,
            (SELECT
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) as manager_ID
        FROM
            employees e
        JOIN dept_emp de ON e.emp_no = de.emp_no
        WHERE
            e.emp_no <= 10020
        GROUP BY e.emp_no
        ORDER BY e.emp_no) AS A
    UNION
    SELECT
        B.*
    FROM
        (SELECT
            e.emp_no as employee_ID,
            MIN(de.dept_no) as department_code,
            (SELECT
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) as manager_ID
        FROM
            employees e
        JOIN dept_emp de ON e.emp_no = de.emp_no
        WHERE
            e.emp_no > 10020
        GROUP BY e.emp_no
        ORDER BY e.emp_no
        LIMIT 20) AS B
    UNION
    SELECT
        C.*
    FROM
        (SELECT
            e.emp_no as employee_ID,
            MIN(de.dept_no) as department_code,
            (SELECT
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) as manager_ID
        FROM
            employees e
        JOIN dept_emp de ON e.emp_no = de.emp_no
        WHERE
            e.emp_no = 110022
        GROUP BY e.emp_no) AS C
    UNION
    SELECT
        D.*
    FROM
        (SELECT
            e.emp_no as employee_ID,
            MIN(de.dept_no) as department_code,
            (SELECT
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) as manager_ID
        FROM
            employees e
        JOIN dept_emp de ON e.emp_no = de.emp_no
        WHERE
            e.emp_no = 110039
        GROUP BY e.emp_no) AS d) as U;


# (A) UNION (B) UNION (C) UNION (D) AS U;
# Show set U
SELECT
    *
FROM
    emp_manager;
