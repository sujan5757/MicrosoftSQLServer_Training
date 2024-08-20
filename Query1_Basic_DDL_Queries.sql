-- CRUD operations

-- CREATE operation
-- create databases
CREATE DATABASE HDFC;

-- READ operation
USE HDFC2;

-- UPDATE operation
-- a. renaming databases
ALTER DATABASE HDFC
MODIFY NAME=HDFC2;

-- DELETE operation
DROP DATABASE HDFC2;

-- CRUD operations in DB Objects :: TABLE
-- create operation in table
-- INT will not go with column-size, hence we use NUMERIC
CREATE TABLE EMPLOYEE(
	EMPLOYEE_ID 	INT,
    EMPLOYEE_NAME	VARCHAR(46),
    EMPLOYEE_SALARY INT
);

-- read operation
EXEC sp_columns EMPLOYEE;

-- update operation
-- a. renaming a table
EXEC sp_rename 'EMPLOYEES','EMPLOYEE';

-- b. adding a column
ALTER TABLE EMPLOYEE
ADD EMPLOYEE_PASSWORD VARCHAR(16);

-- c. renaming a column
EXEC sp_rename
'EMPLOYEE.EMPLOYEE_PASSWORD','EMPLOYEE_PWD';

-- d. changing the data-type of column
-- column MUST be empty
ALTER TABLE EMPLOYEE
ALTER COLUMN EMPLOYEE_PWD INT;

-- e.changing the size of a column
-- we cannot reduce the size beyond the maximum length of the existing data
ALTER TABLE EMPLOYEE
ALTER COLUMN EMPLOYEE_NAME VARCHAR(16);

-- f. deleting a column
ALTER TABLE EMPLOYEE
DROP COLUMN EMPLOYEE_PWD;

-- delete operation
DROP TABLE EMPLOYEE;

