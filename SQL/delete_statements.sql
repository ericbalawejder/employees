USE employees;


COMMIT;


SELECT
    *
FROM
    employees
WHERE emp_no = 999903;


SELECT
    *
FROM
    titles
WHERE emp_no = 999903;


DELETE FROM employees
WHERE
    emp_no = 999903;


ROLLBACK;

# Becareful with the DELETE statement. Don't forget to attach a condition in the
# WHERE clause unless you want to lose all the information.
SELECT
    *
FROM
    departments_dup
ORDER BY dept_no;


# This DELETES the entire departments_dup table!
DELETE FROM departments_dup;


ROLLBACK;


# Remove the department number 10 record from the “departments” table.
SELECT
    *
FROM
    departments
ORDER BY dept_no;


DELETE FROM departments
WHERE
    dept_no = 'd010';


SELECT
    *
FROM
    departments
ORDER BY dept_no;


# DROP TABLE command removes EVERYTHING. Data (records), structure (columns) and all related
# objects (indexes and foreign keys). You will NOT be able to ROLLBACK this action.
# ONCE YOU DROP A TABLE IT'S GONE YO!

# TRUNCATE will remove ALL records from a table just as you were to use DELETE without a WHERE clause.
# The structure will remain intact and all AUTO INCREMENT values will be reset.

# DELETE removes records row by row where a condition is specified in a WHERE clause.
# AUTO INCREMENT values will NOT be reset.
# If the WHERE clause is omitted, the resulting DELETE action is synonymous to TRUNCATE.

# TRUNCATE is more performant than DELETE.

