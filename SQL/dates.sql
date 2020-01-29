# Returns years only.
SELECT '2018-01-01' - '2017-01-01';


# Returns 1 year. 
SELECT '2018-01-01' - '2017-012-31';


# Returns days of two non leap years. 365
SELECT DATEDIFF('2018-01-01', '2017-01-01');


# Returns days and accounts for leap years. 366
SELECT DATEDIFF('2017-01-01', '2016-01-01');


# Seconds in a leap year.
SELECT DATEDIFF('2017-01-01', '2016-01-01') * 86400;


# Seconds in a non year.
SELECT DATEDIFF('2018-01-01', '2017-01-01') * 86400;


# Get days between Current date to destination Date.
SELECT DATEDIFF('2019-04-12', CURDATE()) AS days;


# Get days between Current date to destination Date
SELECT DATEDIFF(CURDATE(), '2019-04-12') AS days;


# Don't use DATEDIFF on an entire column!
SELECT DATEDIFF(CURDATE(), '2019-04-12') * (365.2425 * 86400) AS seconds;


# boolean
SELECT '2018-01-01' - '2017-012-31' >= 1;


-- Exercise 7
-- How many contracts have been registered in the ‘salaries’ table with duration of more than one year
-- and of value higher than or equal to $100,000? Note: Apply this exercise for non-leap years only.
-- Hint: You may wish to compare the difference between the start and end date of the salaries contracts
-- to the number of seconds there are in a non-leap year.
USE employees;

SELECT
    salary, from_date, to_date, to_date - from_date
FROM
    salaries
WHERE
    # Seconds in non leap year = 365.2425 * 86400 = 31556952
    # This apllication 365 * 86400 = 31536000
    to_date - from_date >= (365 * 86400) AND salary >= 100000;


# Inspect the output of 'to_date - from_date' in the SELECT statement.
SELECT
    salary, from_date, to_date, to_date - from_date
FROM
    salaries
WHERE
    # This evaluates to years outside this WHERE clause but evaluates to seconds here?
    to_date - from_date >= 1 AND salary >= 100000;


# This implementation result is identical to:
# to_date - from_date >= (365 * 86400) AND salary >= 100000;
SELECT
    salary, from_date, to_date, DATEDIFF(to_date, from_date)
FROM
    salaries
WHERE
    # greater than non leap years and leap years.
    DATEDIFF(to_date, from_date) > 366 AND salary >= 100000;






