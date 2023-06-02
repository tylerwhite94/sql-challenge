-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/tr2EBp
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

--Data Engineering
REATE TABLE Titles (
    title_id varchar(5) NOT NULL,
    title varchar(18) NOT NULL,
    PRIMARY KEY (title_id)
);

CREATE TABLE Employees (
    emp_no int NOT NULL,
    emp_title_id varchar(5) NOT NULL,
    birth_date date NOT NULL,
    first_name varchar(15) NOT NULL,
    last_name varchar(16) NOT NULL,
    sex varchar(1) NOT NULL,
    hire_date date NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES Titles (title_id),
	PRIMARY KEY (emp_no)
);

CREATE TABLE Salaries (
    emp_no int NOT NULL,
    salary int NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE Departments (
    dept_no varchar(4) NOT NULL,
    dept_name varchar(18) NOT NULL,
    PRIMARY KEY (dept_no)
);

CREATE TABLE Department_Manager (
    dept_no varchar(4) NOT NULL,
    emp_no int NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE Department_Employee (
    emp_no int NOT NULL,
    dept_no varchar(4) NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

--Data Analyis
--Step 1 List the employee number, last name, first name, sex, and salary of each employee
SELECT emp.emp_no, emp.last_name, emp.first_name, emp.sex, sal.salary
FROM Employees as emp
LEFT JOIN Salaries as sal
ON (emp.emp_no = sal.emp_no)
ORDER BY emp.emp_no

--Step 2 List the first name, last name, and hire date for the employees who were hired in 1986
SELECT emp.first_name, emp.last_name, emp.hire_date
FROM Employees as emp
WHERE hire_date BETWEEN '01/01/1986' AND '12/31/1986'
ORDER BY hire_date

--Step 3 List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT dept.dept_no, dept.dept_name, dept_manager.emp_no, emp.last_name, emp.first_name
FROM Departments as dept
INNER JOIN Department_Manager as dept_manager
ON (dept.dept_no = dept_manager.dept_no)
INNER JOIN Employees as emp
ON (emp.emp_no = dept_manager.emp_no)

--Step 4 List the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT dept_emp.dept_no, emp.emp_no, emp.last_name, emp.first_name, dept.dept_name
FROM Department_Employee as dept_emp
INNER JOIN Employees as emp
ON (dept_emp.emp_no = emp.emp_no)
INNER JOIN Departments as dept
ON (dept.dept_no = dept_emp.dept_no)

--Step 5 List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT emp.first_name, emp.last_name, emp.sex
FROM Employees as emp
WHERE first_name = 'Hercules'
AND last_name Like 'B%'

-- Step 6List each employee in the Sales department, including their employee number, last name, and first name
SELECT dept.dept_name, emp.emp_no, emp.last_name, emp.first_name
FROM Department_Employee as dept_emp
INNER JOIN Employees as emp
ON (dept_emp.emp_no = emp.emp_no)
INNER JOIN Departments as dept
ON (dept_emp.dept_no = dept.dept_no)
WHERE dept.dept_name = 'Sales'

-- Step 7 List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)
SELECT dept.dept_name, emp.emp_no, emp.last_name, emp.first_name
FROM Department_Employee as dept_emp
INNER JOIN Employees as emp
ON (dept_emp.emp_no = emp.emp_no)
INNER JOIN Departments as dept
ON (dept_emp.dept_no = dept.dept_no)
WHERE dept.dept_name = 'Sales' OR dept.dept_name = 'Development'

-- Step 8 List the frequency counts, in descending order, of all the employee last names
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC