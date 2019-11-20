USE employees;

SELECT
    *
FROM
    employees
WHERE emp_no = 999901;


UPDATE employees
SET
    first_name = 'Stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE 
    emp_no = 999901;


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no;


COMMIT;


UPDATE departments_dup
SET
    dept_no = 'd011',
    dept_name = 'Quality Control';


ROLLBACK;


COMMIT;


# Change the “Business Analysis” department name to “Data Analysis”.
DROP TABLE departments_dup;

CREATE TABLE departments_dup
(
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no;


SELECT
    *
FROM
    departments
ORDER BY dept_no;


INSERT INTO departments_dup
(
    dept_no,
    dept_name
)
SELECT
    *
FROM
    departments;


SELECT
    *
FROM
    departments_dup
ORDER BY dept_no;


UPDATE departments_dup
SET
    dept_name = 'Data Analysis'
WHERE
    dept_name = 'Business Analysis';
    #dept_no = 'd010';




