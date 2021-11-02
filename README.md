#Pewlett-Hackard-Analysis by Ben Altshuler

## Overview

Pewlett Hackard sought insight into its aging workforce. Administrators and HR needed the number of looming vacancies, and obviously the department and title, in order to begin recruiting replacements. Finally, in order to ease transitions and conserve institutional knowledge, we tried to identify good candidates for an imminent mentorship program. 


## Methods

First, we identified the data types and keys of the disparate csv tables and created our own ERD (see below)

![ERD](Images/EmployeeDB.png?raw=true “ERD”)

- Based on our ERD and CSV inputs, corresponding Postgresql tables were created

- Because the scope of the search required parameters be filtered across tables, we merged several into new tables

### New Table Query
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

### Finding Most Recent Titles
-- Use Dictinct with Orderby to remove duplicate rows to get most recent titles
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

## Results

Number of retiring employees PER TITLE 

![Count](Images/Count_Titles.png?raw=true “Count of retirees per title”)

The above graphic is generated from the new retiring_titles table

- The greatest needs by number of vacant positions by title are Senior Engineer and Senior Staff

- We used the following code to filter the employee data for potential mentorship candidates
``` SQL

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
```


- According to this table, PH currently employs 1,549 possible mentorship program entrants. See the included mentorshhip_eligibility.csv for the complete data set

- The mentorship program is a good idea, but with only 1,549 eligible current employees, PH should start looking outside for hiring ASAP to fill the looming 90,398 open positions due to retirement. 

- This many retirees will result in great cost in the form of training and lost revenue, so it’s not a bad idea to analyze the financial repercussions of the current employees leaving. What are their current salaries? The following queries give PH a quick snapshot of the current annual expenditure 
``` SQL

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

```
Currently, the average annual salary of PH’s soon-to-retire workforce is $52,909.18. 
