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
DROP PROCEDURE IF EXISTS get_most_recent_employee_department_number;
DELIMITER $$
CREATE PROCEDURE get_most_recent_employee_department_number(IN v_emp_no INTEGER)
BEGIN
SELECT
    e.emp_no,
    d.dept_no,
    d.dept_name
FROM
    employees e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
        JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    e.emp_no = v_emp_no
        AND de.from_date = (SELECT
            MAX(from_date)
        FROM
            dept_emp
        WHERE
            emp_no = v_emp_no);
END$$
DELIMITER ;

CALL employees.get_most_recent_employee_department_number(10010);


-- Exercise 7
-- How many contracts have been registered in the ‘salaries’ table with duration of more than one year
-- and of value higher than or equal to $100,000? Note: Apply this exercise for non-leap years only.
-- Hint: You may wish to compare the difference between the start and end date of the salaries contracts
-- to the number of seconds there are in a non-leap year.
SELECT
    salary, from_date, to_date, to_date - from_date
FROM
    salaries
WHERE
    # Seconds in non leap year = 365.2425 * 86400 = 31556952
    # This apllication 365 * 86400 = 31536000
    to_date - from_date >= (365 * 86400) AND salary >= 100000;
    #DATEDIFF(to_date, from_date) > 366 AND salary >= 100000;


-- Exercise 8
-- Create a trigger that checks if the hire date of an employee is higher than the current date.
-- If true, set the hire date to equal the current date. Format the output appropriately (YY-mm-dd).
-- Extra challenge: You can try to declare a new variable called 'today' which stores today's date, and
-- then use it in your trigger! After creating the trigger, execute the following code to see if it's
-- working properly.
DROP TRIGGER IF EXISTS trigger_hire_date;

DELIMITER $$

CREATE TRIGGER trigger_hire_date
BEFORE INSERT ON employees

FOR EACH ROW
BEGIN
    DECLARE today DATE;
    SET today = date_format(sysdate(), '%Y-%m-%d');
    #SELECT date_format(sysdate(), '%Y-%m-%d') INTO today;

    IF NEW.hire_date > today THEN
        SET NEW.hire_date = today;
    END IF;
END $$

DELIMITER ;

INSERT employees VALUES ('999907', '1970-01-01', 'Joe', 'Blow', 'M', '2025-01-01');

SELECT
    *
FROM
    employees
ORDER BY emp_no DESC;


-- Exercise 9
-- Define a function that retrieves the largest contract salary value of an employee. Apply it to employee
-- number 11356. In addition, what is the lowest contract salary value of the same employee? You may want
-- to create a new function that to obtain the result.
DROP FUNCTION IF EXISTS max_contract_salary;

DELIMITER $$
CREATE FUNCTION max_contract_salary(v_emp_no INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN

DECLARE max_salary INTEGER;

SELECT
    MAX(salary)
INTO max_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = v_emp_no;

RETURN max_salary;
END$$

DELIMITER ;


# Call function:
SELECT max_contract_salary(11356);


DROP FUNCTION IF EXISTS min_contract_salary;

DELIMITER $$
CREATE FUNCTION min_contract_salary(v_emp_no INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN

DECLARE max_salary INTEGER;

SELECT
    MIN(salary)
INTO max_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = v_emp_no;

RETURN max_salary;
END$$

DELIMITER ;


# Call function:
SELECT min_contract_salary(11356);


-- Exercise 10
-- Based on the previous exercise, you can now try to create a third function that also accepts a second
-- parameter. Let this parameter be a character sequence. Evaluate if its value is 'min' or 'max' and
-- based on that retrieve either the lowest or the highest salary, respectively (using the same logic and
-- code structure from Exercise 9). If the inserted value is any string value different from ‘min’
-- or ‘max’, let the function return the difference between the highest and the lowest salary of that employee.
DROP FUNCTION IF EXISTS salary_info;

DELIMITER $$
CREATE FUNCTION salary_info(v_emp_no INTEGER, v_range VARCHAR(11)) RETURNS INTEGER
DETERMINISTIC
BEGIN

DECLARE range_salary INTEGER;

SELECT
    CASE
        WHEN v_range = 'min 'THEN MIN(salary)
        WHEN v_range = 'max' THEN MAX(salary)
        ELSE MAX(salary) - MIN(salary)
    END AS salary_info
INTO range_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = v_emp_no;

RETURN range_salary;
END$$

DELIMITER ;


# Call function:
SELECT salary_info(11356, 'max');
SELECT salary_info(11356, 'min');
SELECT salary_info(11356, 'some_string');
SELECT salary_info(11356, '');

