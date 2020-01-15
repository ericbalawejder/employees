# How many departments are there in the “employees” database?
SELECT
    *
FROM
    dept_emp
ORDER BY emp_no DESC;


SELECT
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;

# The wildcard * only works with COUNT(). It will count NULL values. COUNT(*)
# COUNT() will work with numeric and non-numeric data.
# SUM(), MIN(), MAX() and AVG() only work with numeric data.


# What is the total amount of money spent on salaries for all contracts starting
# after the 1st of January 1997?
SELECT
    *
FROM
    salaries
LIMIT 100;


SELECT
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';


# Which is the lowest employee number in the database?
SELECT
    MIN(emp_no)
FROM
    employees;


# Which is the highest employee number in the database?
SELECT
    MAX(emp_no)
FROM
    employees;


# What is the average annual salary paid to employees who started after the 1st of January 1997?
SELECT
    AVG(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';


# Round the average amount of money spent on salaries for all contracts that started after
# the 1st of January 1997 to a precision of cents.
SELECT
    ROUND(AVG(salary), 2)
    #ROUND(AVG(salary)) Rounds to integers.
FROM
    salaries
WHERE
    from_date > '1997-01-01';





# Explaining IFNULL() and COALESCE()

# In the departments_dup DDL statement:
#
# CREATE TABLE `departments_dup` (
#`dept_no` char(4) COLLATE utf8mb4_general_ci NOT NULL,
#`dept_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL
#) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
#
# Both fields have a NOT NULL constraint
SELECT
    *
FROM
    departments_dup;


# Here, we will change the table to allow NULL values.
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL; 


INSERT INTO departments_dup(dept_no)
VALUES ('d010'), ('d011');


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no ASC; 


ALTER TABLE employees.departments_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no ASC;


COMMIT;


# IFNULL() works with two arguments.
SELECT
    dept_no,
    IFNULL(dept_name, "Department name not provided") as dept_name
FROM
    departments_dup;


# COALESCE() works like IFNULL() with two arguments but allows for more than two parameters.
SELECT
    dept_no,
    COALESCE(dept_name, "Department name not provided") as dept_name
FROM
    departments_dup;


# COALESCE() with three arguments:
SELECT
    dept_no,
    dept_name,
    COALESCE(dept_manager, dept_name, "N/A") as dept_manager
FROM
    departments_dup
ORDER BY dept_no ASC;


# COALESCE() can be used to help with a prototype visualization:
SELECT
    dept_no,
    dept_name,
    COALESCE("department manager name") AS fake_column
FROM
    departments_dup;


# COALESCE() AND IFNULL() do not make changes to the data set. They merely create an output
# where certain data values appear in place of NULL values.


# Select the department number and name from the ‘departments_dup’ table and add a third
# column where you name the department number (‘dept_no’) as ‘dept_info’.
# If 'dept_no' does not have a value, use 'dept_name'.
SELECT
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;


# Modify the code obtained from the previous exercise in the following way.
# Apply the IFNULL() function to the values from the first and second column,
# so that ‘N/A’ is displayed whenever a department number has no value, and
# ‘Department name not provided’ is shown if there is no value for ‘dept_name’.
SELECT
    IFNULL(dept_no, "N/A") AS dept_no,
    IFNULL(dept_name, "Department name not provided") AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

