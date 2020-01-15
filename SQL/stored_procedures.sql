USE employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
            SELECT * FROM employees
            LIMIT 1000;
END$$

DELIMITER ;


CALL employees.select_employees();


# Shorter syntax once loaded.
call select_employees;


# Create a procedure that will provide the average salary of all employees.
# Then, call the procedure.
DELIMITER $$
CREATE PROCEDURE average_salary()
BEGIN
            SELECT ROUND(AVG(salary), 2) FROM salaries;
END$$

DELIMITER ;

CALL average_salary;


# Created stored procedure in GUI. Section 18, lesson 224.
#CALL select_salaries;


# Drop procedure.
#DROP PROCEDURE select_salaries;


DROP PROCEDURE IF EXISTS emp_salary;
DELIMITER $$
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
    e.first_name, e.last_name, s.salary, s.from_date, s.to_date
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
END$$

DELIMITER ;

CALL emp_salary(11300);


DROP PROCEDURE IF EXISTS emp_average_salary;
DELIMITER $$
CREATE PROCEDURE emp_average_salary(IN p_emp_no INTEGER)
BEGIN
SELECT
    e.first_name, e.last_name, AVG(s.salary)
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
END$$

DELIMITER ;

CALL emp_average_salary(11300);


DROP PROCEDURE IF EXISTS emp_average_salary_out;
DELIMITER $$
CREATE PROCEDURE emp_average_salary_out(IN p_emp_no INTEGER, out p_avg_salary DECIMAL(10, 2))
BEGIN
SELECT
    AVG(s.salary)
INTO p_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;
END$$

DELIMITER ;

SET @p_avg_salary = 0;
CALL employees.emp_average_salary_out(11300, @p_avg_salary);
SELECT @p_avg_salary;


# Create a procedure called ‘emp_info’ that uses as parameters the first and the last name
# of an individual, and returns their employee number.
DROP PROCEDURE IF EXISTS emp_info;
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), out p_emp_no INTEGER)
BEGIN
SELECT
    e.emp_no
INTO p_emp_no FROM
    employees e
WHERE
    e.first_name = p_first_name AND e.last_name = p_last_name;
END$$

DELIMITER ;


-- Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created
-- in the last exercise. Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a
-- first and last name respectively. Finally, select the obtained output.
SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;


# function. See section 18 lesson 233 for DETERMINISTIC NO SQL READS SQL DATA key words.
DROP FUNCTION IF EXISTS f_avg_emp_salary;

DELIMITER $$
CREATE FUNCTION f_avg_emp_salary(p_emp_no INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_avg_salary DECIMAL(10, 2);

SELECT
    AVG(s.salary)
INTO v_avg_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.emp_no = p_emp_no;

RETURN v_avg_salary;
END$$

DELIMITER ;


# Call function:
SELECT f_avg_emp_salary(11300);


-- Create a function called ‘emp_info’ that takes for parameters the first and last name
-- of an employee, and returns the salary from the newest contract of that employee.
--
-- Hint: In the BEGIN-END block of this program, you need to declare and use two variables
-- – v_max_from_date that will be of the DATE type, and v_salary, that will be of
-- the DECIMAL (10,2) type.
DROP FUNCTION IF EXISTS emp_info;

DELIMITER $$

CREATE FUNCTION emp_info(p_first_name VARCHAR(255), p_last_name VARCHAR(255)) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN

DECLARE v_max_from_date DATE;
DECLARE v_salary DECIMAL(10, 2);

SELECT
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name AND e.last_name = p_last_name;

SELECT
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;

RETURN v_salary;

END$$

DELIMITER ;


# Call function:
SELECT emp_info('Aruna', 'Journel');














