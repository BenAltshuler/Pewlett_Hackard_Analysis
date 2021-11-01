-- Create retirement titles table
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   t.title,
	   t.from_date,
	   t.to_date
INTO retirement_titles
FROM employees AS e
LEFT JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no, title;

-- Use Dictinct with Orderby to remove duplicate rows to get most recent titles
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Retrieve number of employees by most recent job title about to retire
SELECT count(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

-- Create a mentorship eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
       e.first_name,
	   e.last_name,
	   e.birth_date,
	   de.from_date,
	   de.to_date,
	   t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- Create query showing the salary of a retiring employee
SELECT ut.emp_no,
	   ut.first_name,
	   ut.last_name,
	   ut.title,
	   s.salary
INTO retirement_salaries
FROM unique_titles AS ut
INNER JOIN salaries AS s
ON (ut.emp_no = s.emp_no)
ORDER BY ut.emp_no;

-- Get the average salary of a retiring employee
SELECT AVG(salary)::numeric(10,2)
FROM retirement_salaries;