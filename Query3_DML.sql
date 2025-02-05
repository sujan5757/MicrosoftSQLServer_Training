USE [HDFC2]
GO

CREATE TABLE EMPLOYEE(
	EMPLOYEE_ID int NULL,
	EMPLOYEE_NAME varchar(20) NULL,
	EMPLOYEE_SALARY int NULL
);

EXEC sp_columns EMPLOYEE;

ALTER TABLE EMPLOYEE
ALTER COLUMN EMPLOYEE_ID INTEGER NOT NULL
GO

ALTER TABLE EMPLOYEE
ADD CONSTRAINT PK_EMPLOYEE_ID
PRIMARY KEY(EMPLOYEE_ID)
GO

-- DDL queries :: DB Admin
-- create => CREATE
-- read => USE, EXEC,  sp_column
-- UPDATE => ALTER
--			=> MODIFY, sp_rename,
--          => add, drop
-- Delete => DROP

-- DML Queries :: Dev or QA
-- CREATE operation :: INSERT
INSERT INTO EMPLOYEE
VALUES
(101,'GANESH', 1000)
GO

-- ORDER OF INSERTION cannot be changed
-- converting the varchar value 'KEERTHI' to data type int
INSERT INTO EMPLOYEE
VALUES
('KEERTHI', 102, 2000);

INSERT INTO EMPLOYEE
VALUES
(102, 102, 2000);
-- int can be supplied to varchar column but not vice-versa

-- OMITTING values cannot be done
-- number of supplied values does not match table definition
INSERT INTO EMPLOYEE
VALUES
(103, 'RAKESH');

-- still if the other columns needs to be empty then we can supply 'null'
-- note: null is not a value, it is just a token
INSERT INTO EMPLOYEE
VALUES
(103, 'RAKESH', null);

-- OVERCOMING the above two drawbacks :: Type II INSERT Query
-- changing the order of insertion
INSERT INTO EMPLOYEE
(EMPLOYEE_NAME, EMPLOYEE_ID, EMPLOYEE_SALARY)
VALUES
('RAKESH', 103, null),
('SURESH', 104, 4000)
GO

-- omitting values
INSERT INTO EMPLOYEE
(EMPLOYEE_ID, EMPLOYEE_NAME)
VALUES
(105, 'REVATI')
GO

-- INSERTING MULTIPLE ROWS
-- (3 rows affected)
INSERT INTO EMPLOYEE
(EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SALARY)
VALUES
(106,'RAMA',6000),
(107,'RAKESH',7000),
(108,'RANJITH',8000)
GO


-- read operation
SELECT * 
FROM EMPLOYEE;
-- order of execution::
-- FROM
-- table has to be selected, by default all the rows will be there
-- SELECT
-- regarding the rows (employees) which details has to be displayed
-- Hence SELECT can't exist without FROM

-- update operation
-- SELECT THE TABLE that needs to be updated, BY Default all rows will be selected
-- SELECT the column in which value has to be updated
UPDATE EMPLOYEE
SET EMPLOYEE_NAME='KEERTHI'
GO
-- output:: (8 rows affected)

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='GANESH'
WHERE EMPLOYEE_ID=101
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='RAMESH'
WHERE EMPLOYEE_ID=103
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='RAKESH'
WHERE EMPLOYEE_ID=104
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='RAMA'
WHERE EMPLOYEE_ID=105
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='RIYA'
WHERE EMPLOYEE_ID=106
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='MERLYN'
WHERE EMPLOYEE_ID=107
GO

UPDATE EMPLOYEE
SET EMPLOYEE_NAME='RAJESH'
WHERE EMPLOYEE_ID=108
GO

BEGIN TRANSACTION
UPDATE EMPLOYEE
SET EMPLOYEE_SALARY=3000
WHERE EMPLOYEE_ID=103
GO

UPDATE EMPLOYEE
SET EMPLOYEE_SALARY=5000
WHERE EMPLOYEE_ID=105
GO

UPDATE EMPLOYEE
SET EMPLOYEE_SALARY=7001,
	EMPLOYEE_NAME='NIDHI'
WHERE EMPLOYEE_ID=107
GO

-- order of execution
-- table gets selected, by default all rows will be selected
-- we need to filter the row whose value has to be updated
-- we need to set the value to the desired column
-- UPDATE, WHERE, SET


EXEC sp_columns DEPARTMENT;

BEGIN TRANSACTION
INSERT INTO DEPARTMENT
VALUES 
(1, 'HR'),
(2,'DEV'),
(3,'QA')
GO
COMMIT TRANSACTION
GO

ALTER TABLE EMPLOYEE
ADD DEPARTMENT_ID NUMERIC(2);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_DEPARTMENT_ID
FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID)
GO

BEGIN TRANSACTION
UPDATE EMPLOYEE SET DEPARTMENT_ID=1 WHERE EMPLOYEE_ID=105;
UPDATE EMPLOYEE SET DEPARTMENT_ID=2 WHERE EMPLOYEE_ID=104;
UPDATE EMPLOYEE SET DEPARTMENT_ID=3 WHERE EMPLOYEE_ID=103;
UPDATE EMPLOYEE SET DEPARTMENT_ID=2 WHERE EMPLOYEE_ID=101;
UPDATE EMPLOYEE SET DEPARTMENT_ID=2 WHERE EMPLOYEE_ID=102;
COMMIT TRANSACTION
-- NOTE: TCL works only with DML and not DDL

-- updating an employee from a value in another table
-- salary of an employee in QA department must be increased to 4000

-- AUTO-COMMIT manipulation:: SET IMPLICIT_TRANSACTION ON
UPDATE EMPLOYEE
SET EMPLOYEE_SALARY=4000
WHERE DEPARTMENT_ID=(SELECT DEPARTMENT_ID 
					FROM DEPARTMENT
					WHERE DEPARTMENT_NAME='QA');
-- commit transaction;

SELECT * FROM EMPLOYEE;

-- delete operation :: DELETE
SET IMPLICIT_TRANSACTION ON
BEGIN TRANSACTION

-- all rows will be dropped
DELETE FROM EMPLOYEE
GO

ROLLBACK TRANSACTION
GO

DELETE
FROM EMPLOYEE
WHERE DEPARTMENT_ID=1
GO

DELETE
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY>3000
GO

DELETE
FROM EMPLOYEE
WHERE DEPARTMENT_ID IS NULL;
-- WHERE DEPARTMENT_ID=NULL     can't be done
GO

-- ERROR: The DELETE statement conflicted with the REFERENCE constraint "FK_DEPARTMENT_ID".
-- The conflict occurred in database "HDFC2", table "dbo.EMPLOYEE", column 'EMPLOYEE
DELETE FROM DEPARTMENT
WHERE DEPARTMENT_NAME='HR'
GO

-- resolving ways
-- Method 1:: Two steps
DELETE EMPLOYEE
WHERE EMPLOYEE_DEPARTMENT_ID=1
GO

-- Method 2: -- mentioning on-delete cascade
ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_DEPARTMENT_ID
FOREIGN KEY (EMPLOYEE_DEPARTMENT_ID)
REFERENCES DEPARTMENT(DEPARTMENT_ID)
ON DELETE CASCADE	 -- if we delete the row in parent table even the corresponding entries in child table will be deleted
GO


-- order of execution
-- FROM, WHERE, DELETE
-- DELETE can't exist without FROM clause


-- Read operation :: SELECT
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE;

SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SALARY, DEPARTMENT_ID
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE;
-- order of execution
-- TABLE :: FROM, COLUMNS :: SELECT
-- SELECT clause can't exist without FROM clause
-- without table we cannot select columns (values of a row (entity))

-- updating the column name in EMPLOYEE table
EXEC sp_rename  'EMPLOYEE.DEPARTMENT_ID',
				'EMPLOYEE_DEPARTMENT_ID'
GO

-- alias names :: Method 1
SELECT 
EMPLOYEE_NAME AS 'NAME OF THE EMPLOYEE',
EMPLOYEE_SALARY AS 'SALARY OF EMPLOYEE'
FROM EMPLOYEE
GO

-- alias names :: Method 2
SELECT 
EMPLOYEE_NAME 'EMPLOYEE NAME', 
EMPLOYEE_SALARY AS 'SALARY OF EMPLOYEE'
FROM EMPLOYEE
GO

-- to display first name and last name together
-- rename the name column to first name
-- add a last name column
-- in select query concatenate

EXEC sp_rename 'EMPLOYEE.EMPLOYEE_NAME]',
'EMPLOYEE_FIRST_NAME'
GO

ALTER TABLE EMPLOYEE
ADD 
EMPLOYEE_LAST_NAME VARCHAR(46)
GO

SET IMPLICIT_TRANSACTION ON
BEGIN TRANSACTION
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='SHARMA'
WHERE EMPLOYEE_ID=101
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='SHARMA'
WHERE EMPLOYEE_ID=101
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='SHETTY'
WHERE EMPLOYEE_ID=102
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='RAO'
WHERE EMPLOYEE_ID=103
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='BHAT'
WHERE EMPLOYEE_ID=104
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='TENDULKAR'
WHERE EMPLOYEE_ID=105
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='KOHLI'
WHERE EMPLOYEE_ID=106
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='RAINA'
WHERE EMPLOYEE_ID=107
GO

UPDATE EMPLOYEE
SET EMPLOYEE_LAST_NAME='BUMRAH'
WHERE EMPLOYEE_ID=108
GO

COMMIT TRANSACTION
GO

EXEC sp_columns EMPLOYEE
GO

SELECT EMPLOYEE_FIRST_NAME+EMPLOYEE_LAST_NAME
 'EMPLOYEE NAME' 
 FROM EMPLOYEE
 GO

 ALTER TABLE EMPLOYEE
 ADD 
 EMPLOYEE_DOB DATE NULL
 GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='10-10-2050'
 WHERE EMPLOYEE_ID = 101
GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='06-22-1995'
 WHERE EMPLOYEE_ID = 102
GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='09-23-1995'
 WHERE EMPLOYEE_ID = 103
GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='03-06-2002'
 WHERE EMPLOYEE_ID = 104
GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='11-23-2000'
 WHERE EMPLOYEE_ID = 105
GO

UPDATE EMPLOYEE
 SET EMPLOYEE_DOB='12-24-2989'
 WHERE EMPLOYEE_ID = 106
GO

SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_LAST_NAME, EMPLOYEE_DOB, EMPLOYEE_DEPARTMENT_ID
FROM EMPLOYEE;

-- filtering
SELECT *
FROM EMPLOYEE
WHERE EMPLOYEE_DEPARTMENT_ID IS NULL;
-- order -- FROM, WHERE, SELECT
-- Table gets selected, by default all rows get selected, we filter the rows and then in those rows the required details will be selected

-- FROM :: FILTER TABLES
-- WHERE :: FILTER ROWS
-- SELECT :: FILTER COLUMNS

-- display ID and Name of those employees who are alotted to any of the departments
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_DEPARTMENT_ID IS NOT NULL;
GO

-- display ID and Name of those employees who work as Dev
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_DEPARTMENT_ID = 
	(SELECT DEPARTMENT_ID
	FROM DEPARTMENT
	WHERE DEPARTMENT_NAME='DEV')
GO

-- display ID and Name of those employees whose salary is greater than 3000
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY>3000
GO

-- display ID and Name of those employees whose salary is less than or equal 3000
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY<=3000
GO

-- display ID and Name of those employees whose salary is 2000, 4000, 5000
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY IN (2000,4000,5000)
GO

-- checking whether 'null' is considered in comparision operators while using less than
UPDATE EMPLOYEE
SET EMPLOYEE_SALARY=NULL
WHERE EMPLOYEE_ID=108
GO

SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY<=3000
GO
-- Note: NULL is not a value, hence it cannot be taken for consideration while comparing

-- range test operator
-- display the id, name, salary of employee whose salary is between 4000 and 7000

SELECT EMPLOYEE_ID, EMPLOYEE_NAME,EMPLOYEE_SALARY
FROM EMPLOYEE
GO

SELECT EMPLOYEE_ID, EMPLOYEE_NAME,EMPLOYEE_SALARY
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY 
BETWEEN 4000 AND 6000
GO

-- display id and name of employees whose department_id=1 and salary=1000
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY=1000 AND EMPLOYEE_DEPARTMENT_ID=1
GO

-- display id and name of employees whose department_id=1 OR salary=1000
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY=1000 OR EMPLOYEE_DEPARTMENT_ID=1
GO

-- Note:
-- IN keyword   :: set operator
-- LIKE keyword :: pattern-matching operator
-- SET :: is a clause

SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
GO

-- display ID and Name of employees whose names
-- start from R
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_NAME LIKE 'R%'
GO
-- start from R and ends with SH
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_NAME LIKE 'R%SH'
GO

-- ends with SH
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_NAME LIKE '%SH'
GO

-- second letter is A
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_NAME LIKE '_A%'
GO

-- second letter is A last letter is H
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
WHERE EMPLOYEE_NAME LIKE '_A%H'
GO

-- two tables
SELECT *
FROM EMPLOYEE, DEPARTMENT
GO;

SELECT EMPLOYEE.*, DEPARTMENT.*
FROM EMPLOYEE, DEPARTMENT
GO

SELECT EMPLOYEE.EMPLOYEE_NAME, DEPARTMENT.DEPARTMENT_NAME
FROM EMPLOYEE, DEPARTMENT
GO

SELECT EMP.EMPLOYEE_NAME, DEPT.DEPARTMENT_NAME
FROM EMPLOYEE EMP, DEPARTMENT DEPT
GO

SELECT EMP.EMPLOYEE_NAME, DEPT.DEPARTMENT_NAME
FROM EMPLOYEE EMP, DEPARTMENT DEPT
WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
GO

SELECT EMP.EMPLOYEE_NAME, DEPT.DEPARTMENT_NAME
FROM EMPLOYEE EMP, DEPARTMENT DEPT
WHERE EMP.EMPLOYEE_DEPARTMENT_ID <> DEPT.DEPARTMENT_ID
-- WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
GO

-- display the maximum salary taken by an employee in the company
SELECT MAX(EMPLOYEE_SALARY)
FROM EMPLOYEE
GO

-- display the minimum salary taken by an employee in the company
-- Note:: NULL is not considered as a minimum value as it is just a token to say empty
SELECT MIN(EMPLOYEE_SALARY)
FROM EMPLOYEE
GO

-- above two queries with alias names
SELECT MAX(EMPLOYEE_SALARY) AS 'MAXIMUM SALARY'
FROM EMPLOYEE
GO

SELECT MIN(EMPLOYEE_SALARY) 'MINIMUM SALARY'
FROM EMPLOYEE
GO

-- display the name & salary of the employee who takes the maximum salary
SELECT EMPLOYEE_NAME AS 'EMPLOYEE NAME',
	   EMPLOYEE_SALARY AS 'HIGHEST PAID'
FROM EMPLOYEE
WHERE EMPLOYEE_SALARY = (SELECT MAX(EMPLOYEE_SALARY)
						FROM EMPLOYEE)
GO

-- Error:: Column 'EMPLOYEE.EMPLOYEE_NAME' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
SELECT EMPLOYEE_NAME, MAX(EMPLOYEE_SALARY)
FROM EMPLOYEE
GO

-- display sum of salary of all the employees in the company
SELECT SUM(EMPLOYEE_SALARY) AS 'SUM OF SALARY'
FROM EMPLOYEE
GO

-- display employee_name and sum of salary of all the employees in the company
-- Error:: Column 'EMPLOYEE.EMPLOYEE_NAME' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
SELECT EMPLOYEE_NAME 'EMPLOYEE NAME',
	   SUM(EMPLOYEE_SALARY) AS 'SUM OF SALARY'
FROM EMPLOYEE
GO

-- display the avergae salary of all employees in the company
SELECT AVG(EMPLOYEE_SALARY) 'AVERAGE SALARY'
FROM EMPLOYEE
GO

-- display the number of employees who are working in one or the other department
SELECT COUNT(EMPLOYEE_DEPARTMENT_ID) AS 'NUMBER OF EMPLOYEES WORKING IN A DEPARTMENT'
FROM EMPLOYEE
GO

-- display the number of employees working in a company
SELECT COUNT(EMPLOYEE_ID)
FROM EMPLOYEE
GO

-- display all the details of employees by grouping them as per their departments
-- ERROR:: Column 'EMPLOYEE.EMPLOYEE_NAME' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
SELECT EMPLOYEE_DEPARTMENT_ID, EMPLOYEE_NAME
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
GO

-- display sum of salary given in each department
SELECT SUM(EMPLOYEE_SALARY)
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
GO

-- display department name and sum of salary given in each department
SELECT EMPLOYEE_DEPARTMENT_ID 'DEPARTMENT_ID', 
	   SUM(EMPLOYEE_SALARY) 'SUM OF SALARY'
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
GO

-- display the department ID and number of employees working in each department
SELECT EMPLOYEE_DEPARTMENT_ID AS 'DEPARTMENT ID',
	   COUNT(EMPLOYEE_ID) AS 'NUMBER OF EMPLOYEES'
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
GO

-- order of execution
-- table is selected, by default all the rows will be selected
-- we group the rows based on a particular value
-- we perform the required aggregate operations and displayed the result
-- FROM, GROUP BY, SELECT

-- display department_name and sum of salaries
SELECT DEPT.DEPARTMENT_NAME AS 'DEPARTMENT_NAME',
	   SUM(EMP.EMPLOYEE_SALARY) AS 'TOTAL EXPENDITURE TOWARDS SALARY'
FROM EMPLOYEE EMP,DEPARTMENT DEPT
WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
GROUP BY DEPT.DEPARTMENT_NAME;
GO
-- Order of execution::
-- first both tables gets selected, by default all the rows in each table will be selected
-- based on the condition the rows will be filtered and mapped between the tables
-- the above result will be grouped
-- required values along with aggregate operations will be displayed
-- FROM, WHERE, GROUP BY, SELECT

-- assigning departments to employees
SELECT * FROM EMPLOYEE
GO

UPDATE EMPLOYEE
SET EMPLOYEE_DEPARTMENT_ID=3
WHERE EMPLOYEE_ID=106
GO

UPDATE EMPLOYEE
SET EMPLOYEE_DEPARTMENT_ID=2
WHERE EMPLOYEE_ID=107
GO

UPDATE EMPLOYEE
SET EMPLOYEE_DEPARTMENT_ID=1
WHERE EMPLOYEE_ID=108
GO

-- display  department_id and total salary which is greater than 5000
SELECT EMPLOYEE_DEPARTMENT_ID AS 'DEPARTMENT ID',
	  SUM(EMPLOYEE_SALARY) AS 'SUM OF SALARY'
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
HAVING SUM(EMPLOYEE_SALARY)>5000
GO

-- display  department_id and number of employees working in them wherein the number of employees are more than 2
SELECT	EMPLOYEE_DEPARTMENT_ID 'DEPARTMENT ID',
		COUNT(EMPLOYEE_ID) 'NUMBER OF EMPLOYEES'
FROM EMPLOYEE
GROUP BY EMPLOYEE_DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID)>2
GO

-- display  department_name and number of employees working in them wherein the number of employees are less than or equal to 2
SELECT	DEPT.DEPARTMENT_NAME 'DEPARTMENT',
		COUNT(EMP.EMPLOYEE_ID) 'NUMBER OF EMPLOYEES'
FROM EMPLOYEE EMP, DEPARTMENT DEPT
WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
GROUP BY DEPT.DEPARTMENT_NAME
HAVING COUNT(EMP.EMPLOYEE_ID)<=2
GO

-- Sorting :: ORDER BY
-- display the details of employees sorted based on their name
SELECT *
FROM EMPLOYEE
ORDER BY EMPLOYEE_NAME
GO
-- FROM, SELECT, ORDER_BY

-- display the employee_id and employee_name of employees sorted based on their DOB
SELECT EMPLOYEE_ID, EMPLOYEE_NAME
FROM EMPLOYEE
ORDER BY EMPLOYEE_DOB
GO
-- the column used in ORDER BY need not be in the result
-- NULL is considered as least value
-- By default the sorting will happen in ascending order

-- display id, department_id, name by sorting as per department and then as per ID
SELECT EMPLOYEE_ID, EMPLOYEE_DEPARTMENT_ID, EMPLOYEE_NAME
FROM EMPLOYEE
ORDER BY EMPLOYEE_DEPARTMENT_ID, EMPLOYEE_ID
GO

-- display id, department_id, name by sorting as per department in ascending order and then as per ID in descending order
SELECT EMPLOYEE_ID, EMPLOYEE_DEPARTMENT_ID, EMPLOYEE_NAME
FROM EMPLOYEE
ORDER BY EMPLOYEE_DEPARTMENT_ID, EMPLOYEE_ID DESC
GO

-- display DEPARTMENT_NAME, EMPLOYEE_DOB, EMPLOYEE_NAME  in ascending order as per department_ID and DOB by using joins
SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME'
-- FROM DEPARTMENT DEPT, EMPLOYEE EMP
FROM DEPARTMENT DEPT INNER JOIN EMPLOYEE EMP
-- WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ON EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO

-- declare department ID for two employees null
UPDATE EMPLOYEE
SET EMPLOYEE_DEPARTMENT_ID=NULL
WHERE EMPLOYEE_ID IN (103, 107)
GO

INSERT INTO DEPARTMENT
VALUES (4, 'TRANS')
GO

-- display DEPARTMENT_NAME, EMPLOYEE_DOB, EMPLOYEE_NAME, PHONE_NUMBER in ascending order as per department_ID and DOB by using INNER JOIN
-- need to create Phone table
CREATE TABLE PHONE(
	PHONE_ID			NUMERIC(4),
	PHONE_NUMBER		NUMERIC(10),
	PHONE_EMPLOYEE_ID	INTEGER NOT NULL
)
GO

ALTER TABLE PHONE
ADD CONSTRAINT FK_PHONE_EMPLOYEE_ID
FOREIGN KEY(PHONE_EMPLOYEE_ID) REFERENCES
EMPLOYEE(EMPLOYEE_ID)
ON DELETE CASCADE
GO

INSERT INTO PHONE VALUES (1, 1234, 101)
GO

INSERT INTO PHONE VALUES (2, 1243, 101)
GO

INSERT INTO PHONE VALUES (3, 1324, 102)
GO

INSERT INTO PHONE VALUES (4, 1343, 103)
GO

INSERT INTO PHONE VALUES (5, 1432, 104)
GO

INSERT INTO PHONE VALUES (6, 1423, 105)
GO

INSERT INTO PHONE VALUES (7, 2134, 104)
GO

SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME',
		PHONE.PHONE_NUMBER
FROM DEPARTMENT DEPT
INNER JOIN EMPLOYEE EMP
ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
INNER JOIN PHONE
ON EMP.EMPLOYEE_ID=PHONE.PHONE_EMPLOYEE_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO

-- inner join :: 6 rows
SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME'
-- FROM DEPARTMENT DEPT, EMPLOYEE EMP
FROM DEPARTMENT DEPT INNER JOIN EMPLOYEE EMP
-- WHERE EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ON EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO

-- LEFT outer join
SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME'
FROM DEPARTMENT DEPT LEFT JOIN EMPLOYEE EMP
ON EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO

-- RIGHT outer join
SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME'
FROM DEPARTMENT DEPT RIGHT JOIN EMPLOYEE EMP
ON EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO

-- FULL outer join
SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
		EMP.EMPLOYEE_DOB 'DOB',
		EMP.EMPLOYEE_NAME 'NAME'
FROM DEPARTMENT DEPT FULL JOIN EMPLOYEE EMP
ON EMP.EMPLOYEE_DEPARTMENT_ID=DEPT.DEPARTMENT_ID
ORDER BY DEPT.DEPARTMENT_NAME, EMP.EMPLOYEE_DOB
GO











