-- VIEWS
CREATE VIEW MANAGER_VIEW
AS
	SELECT	DEPT.DEPARTMENT_NAME AS 'DEPARTMENT',
			EMP.EMPLOYEE_DOB 'DOB',
			EMP.EMPLOYEE_NAME 'NAME',
			PHONE.PHONE_NUMBER
	FROM DEPARTMENT DEPT
	INNER JOIN EMPLOYEE EMP
	ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
	INNER JOIN PHONE
	ON EMP.EMPLOYEE_ID=PHONE.PHONE_EMPLOYEE_ID
GO

SELECT * FROM MANAGER_VIEW
GO

-- view :: EmployeeView ::
-- Emp ID, Emp Name, Emp Salary, Emp Dept_Name, Emp Phone
CREATE VIEW EMPLOYEE_VIEW
	AS
		SELECT	EMP.EMPLOYEE_ID AS 'ID',
				EMP.EMPLOYEE_NAME 'NAME',
				EMP.EMPLOYEE_SALARY 'SALARY',
				DEPT.DEPARTMENT_NAME 'DEPARTMENT',
				PH.PHONE_NUMBER 'PHONE_NUMBER'
		FROM DEPARTMENT DEPT 
		INNER JOIN EMPLOYEE EMP
		ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
		LEFT JOIN PHONE PH
		ON EMP.EMPLOYEE_ID=PH.PHONE_EMPLOYEE_ID
GO

SELECT * FROM EMPLOYEE_VIEW
GO

-- checking whether the modifications in original table will reflect in view
INSERT INTO PHONE VALUES (3, 1324, 108)
GO

SELECT * FROM EMPLOYEE_VIEW
GO

-- checking whether the modifications in view will reflect in original table
-- Invalid column name 'EMPLOYEE_ID'.
UPDATE EMPLOYEE_VIEW
SET SALARY=8000
WHERE ID = 108
GO
-- if aliases are given while creating a view then column name should be same as those mentioned in the view

-- checking in employee table
SELECT EMPLOYEE_ID, EMPLOYEE_SALARY
FROM EMPLOYEE;

-- DDL ON VIEWS
-- adding a column to view
-- ERROR: 
-- renaming a column in view
-- resizing a column

-- MODIFYing view
ALTER VIEW EMPLOYEE_VIEW
	AS
		SELECT	EMP.EMPLOYEE_ID AS 'ID',
				EMP.EMPLOYEE_NAME 'FIRSTNAME',
				EMP.EMPLOYEE_LAST_NAME 'LASTNAME',
				EMP.EMPLOYEE_SALARY 'SALARY',
				DEPT.DEPARTMENT_NAME 'DEPARTMENT',
				PH.PHONE_NUMBER 'PHONE_NUMBER'
		FROM DEPARTMENT DEPT 
		INNER JOIN EMPLOYEE EMP
		ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
		LEFT JOIN PHONE PH
		ON EMP.EMPLOYEE_ID=PH.PHONE_EMPLOYEE_ID
GO

-- dropping columns in a view
ALTER VIEW EMPLOYEE_VIEW
	AS
		SELECT	EMP.EMPLOYEE_ID AS 'ID',
				EMP.EMPLOYEE_NAME 'FIRSTNAME',
				DEPT.DEPARTMENT_NAME 'DEPARTMENT',
				PH.PHONE_NUMBER 'PHONE_NUMBER'
		FROM DEPARTMENT DEPT 
		INNER JOIN EMPLOYEE EMP
		ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
		LEFT JOIN PHONE PH
		ON EMP.EMPLOYEE_ID=PH.PHONE_EMPLOYEE_ID
GO

EXEC sp_rename 'EMPLOYEE_VIEW','EMP_V'
GO

DROP VIEW MANAGER_VIEW

IF OBJECT_ID('MANAGER_VIEW','V') IS NOT NULL
	DROP VIEW MANAGER_VIEW
	GO

-- FUNCTIONS
-- display the sum of salary of employees in a particular department
SELECT SUM(EMPLOYEE_SALARY)
FROM EMPLOYEE
WHERE EMPLOYEE.EMPLOYEE_DEPARTMENT_ID=1
GO

SELECT SUM(EMPLOYEE_SALARY)
FROM EMPLOYEE
WHERE EMPLOYEE.EMPLOYEE_DEPARTMENT_ID=2
GO

SELECT SUM(EMPLOYEE_SALARY)
FROM EMPLOYEE
WHERE EMPLOYEE.EMPLOYEE_DEPARTMENT_ID=3
GO

-- observation	calAvgSalByDeptId	:: deptId int => i/p
--									:: avgSal float => o/p 

	
CREATE OR ALTER FUNCTION calAvgSalByDeptId(@deptId int)
RETURNS float
	AS
		BEGIN
			DECLARE @avgSal float

			SELECT @avgSal = AVG(EMPLOYEE_SALARY)
			FROM EMPLOYEE
			WHERE EMPLOYEE.EMPLOYEE_DEPARTMENT_ID=@deptId

			RETURN @avgSal
		END
-- database => Programmability => Functions
GO

SELECT dbo.calAvgSalByDeptId(1)
GO

CREATE OR ALTER FUNCTION getEmployeeList_IdAndName()
RETURNS TABLE
	AS
		RETURN
			SELECT EMPLOYEE_ID, EMPLOYEE_NAME
			FROM EMPLOYEE
GO

SELECT *
FROM dbo.getEmployeeList_IdAndName()
GO

-- TABLE MULTI_VALUED FUNCTION
CREATE OR ALTER FUNCTION getManagerTable()
RETURNS @MANAGERS TABLE
(
	MANAGER_ID INT,
	MANAGER_NAME VARCHAR(20)
)
AS
	BEGIN
		INSERT INTO @MANAGERS SELECT EMPLOYEE_ID, 
											EMPLOYEE_NAME
											FROM EMPLOYEE;
		DELETE FROM @MANAGERS WHERE MANAGER_ID>102;
		RETURN
	END
GO

SELECT *
FROM dbo.getManagerTable()
GO

-- functions mandatarily returns value
-- procedure need not return value
CREATE PROCEDURE usp_getAvgSal(@deptId int)
	AS
	BEGIN
		SELECT dbo.calAvgSalByDeptId(@deptId)
	END
GO

EXEC dbo.usp_getAvgSal
@deptId=2
GO

DROP PROCEDURE usp_getAvgSal;
GO

CREATE PROCEDURE usp_getEmployeeList
	AS
		BEGIN
			SELECT	EMPLOYEE_ID,
					EMPLOYEE_NAME,
					EMPLOYEE_SALARY
			FROM EMPLOYEE
		END
GO

EXEC dbo.usp_getEmployeeList
-- procedure need not return a value
-- procedure is just used to perform a task compulsorily written inside BEGIN and AND
GO

EXEC sp_columns EMPLOYEE
GO

CREATE PROCEDURE usp_addEmployee(
@empId INTEGER,
@empName VARCHAR(20),
@empSalary INTEGER,
@empDeptId NUMERIC(2),
@empLastName VARCHAR(46),
@empDob DATE)
AS
	BEGIN
		INSERT INTO EMPLOYEE
		VALUES
		(@empId, @empName,@empSalary,@empDeptId,@empLastName,@empDob)
	END

EXEC dbo.usp_addEmployee
@empId=110,
@empName='JAMSHEER',
@empSalary=9000,
@empDeptId=4,
@empLastName='MUHAMMED',
@empDob='11-26-2002'
GO

-- update operation wrt stored procedure
ALTER PROCEDURE usp_getEmployeeList
	AS
		BEGIN
			SELECT *
			FROM EMPLOYEE_VIEW
		END
GO

-- renaming a stored procedure
EXEC sp_rename 'usp_getEmployeeList','usp_getEmpList'
GO

-- deleting a stored procedure
DROP PROCEDURE usp_getEmpList
GO

-- input :: phone_id
-- output :: Department_name,Employee_name,phone_number
-- function :: getEmpDetailsByPhoneId(phId)
-- call the function in a stored Procedure

CREATE OR ALTER FUNCTION getEmpDetailsByPhoneId(@phoneId int)
RETURNS TABLE
	AS
		RETURN
			SELECT	DEPT.DEPARTMENT_NAME 'DEPARTMENT',
					EMP.EMPLOYEE_NAME 'NAME',
					PH.PHONE_NUMBER 'PHONE_NUMBER'
			FROM DEPARTMENT DEPT
			INNER JOIN EMPLOYEE EMP
			ON DEPT.DEPARTMENT_ID=EMP.EMPLOYEE_DEPARTMENT_ID
			INNER JOIN PHONE PH
			ON EMP.EMPLOYEE_ID=PH.PHONE_EMPLOYEE_ID
			WHERE PH.PHONE_ID=@phoneId
GO

CREATE PROCEDURE usp_getEmpDetailsByPhoneId(@phoneId int)
	AS
		BEGIN
			SELECT * FROM dbo.getEmpDetailsByPhoneId(@phoneId)
		END
GO

EXEC dbo.usp_getEmpDetailsByPhoneId
@phoneId=2
GO

-- reading stored procedure
SELECT OBJECT_DEFINITION
		(OBJECT_ID(N'hdfc2.dbo.usp_getEmpDetailsByPhoneId'))
GO

-- declaring a column which has already got repeated values as a primary key
ALTER TABLE PHONE
ALTER COLUMN PHONE_ID NUMERIC(4) NOT NULL
GO

DELETE FROM PHONE
WHERE PHONE_EMPLOYEE_ID=108
GO

ALTER TABLE PHONE
ADD CONSTRAINT PK_PHONE_ID
PRIMARY KEY(PHONE_ID)
GO

-- attempting to insert row with correct values
INSERT INTO PHONE
VALUES
(8, 1342,108)
GO

-- attempting to insert row with WRONG values
INSERT INTO PHONE
VALUES
(8, 1324,108)
GO
-- Error: Violation of PRIMARY KEY constraint 'PK_PHONE_ID'. Cannot insert duplicate key in object 'dbo.PHONE'. The duplicate key value is (8).

-- handling the RTE

CREATE PROCEDURE usp_insertPhoneRecord(
	-- input parameters
	@phoneId numeric(2),
	@phoneNum numeric(10),
	@empId INTEGER,
	@result INT OUTPUT
)
	AS
		BEGIN TRY
			INSERT INTO PHONE
			VALUES
			(@phoneId, @phoneNum,@empId)
			SET @result=1
		END TRY
		BEGIN CATCH
			SELECT @result = ERROR_NUMBER()
			--ERROR_MESSAGE() 'DESCRIPTION',
			--ERROR_SEVERITY() 'SEVERITY'
		END CATCH
GO

DECLARE @result integer
EXEC usp_insertPhoneRecord
	@phoneId =12,
	@phoneNum =1345,
	@empId =200,
	@result=@result OUTPUT

IF(@result=1)
	PRINT('1 ROW INSERTED')
else
	BEGIN
		IF(@result=2627)
			PRINT('ENTER PROPER PRIMARY KEY')
		ELSE
			PRINT('ENTER CORRECT EMPLOYEE ID')
	END
GO

-- input parameters
CREATE PROCEDURE USP_OPTIONAL_PARAMETER_DEMO(
	@empId INTEGER,
	-- optional parameters
	@empSalary INTEGER = 7000
)
AS
	BEGIN
		UPDATE EMPLOYEE
		SET EMPLOYEE_SALARY=@empSalary
		WHERE EMPLOYEE_ID=@empId
	END
GO

EXEC USP_OPTIONAL_PARAMETER_DEMO 
	@empId =101,
	@empSalary = 10000
GO

EXEC USP_OPTIONAL_PARAMETER_DEMO 105
GO

SELECT EMPLOYEE_ID, EMPLOYEE_SALARY FROM EMPLOYEE
GO

-- OUTPUT parameters
CREATE PROCEDURE usp_fetchEmployeeSalaryByEmployeeId(
		@empId int,
		@empSalary int OUTPUT
	)
	AS
		BEGIN
			SELECT @empSalary=EMPLOYEE_SALARY
			FROM EMPLOYEE
			WHERE EMPLOYEE_ID=@empId
		END
GO

DECLARE @empSalary int
EXEC dbo.usp_fetchEmployeeSalaryByEmployeeId 
	@empId=101,
	@empSalary = @empSalary OUTPUT

PRINT (@empSalary)
GO


SELECT * FROM PHONE
GO