# Create an SQL stored procedure that will allow you to obtain the average male and female
# salary per department within a certain salary range. Let this range be defined by two values
# the user can insert when calling the procedure.
# Finally, visualize the obtained result-set in Tableau as a double bar chart.
DROP PROCEDURE IF EXISTS average_salary_by_gender;
DELIMITER $$
CREATE PROCEDURE average_salary_by_gender(IN lower_limit FLOAT, IN upper_limit FLOAT)
BEGIN
SELECT
    e.gender, ROUND(AVG(s.salary), 2) AS average_salary, d.dept_name
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
    JOIN
    t_departments d ON de.dept_no = d.dept_no
WHERE s.salary BETWEEN lower_limit AND upper_limit
GROUP BY e.gender, d.dept_no
ORDER BY d.dept_name;
END$$

DELIMITER ;

CALL average_salary_by_gender(50000, 90000);








