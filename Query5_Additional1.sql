-- if - else
DECLARE @empId INT =100
IF (@empId=101)
	PRINT 'HE IS THE CEO'
ELSE
	PRINT 'HE IS NOT THE CEO'
GO

-- by changing to 101
DECLARE @empId INT =101
IF (@empId=101)
	PRINT 'HE IS THE CEO'
ELSE
	PRINT 'HE IS NOT THE CEO'
GO

-- write an SQL query in if condition
IF((SELECT AVG(EMPLOYEE_SALARY) FROM EMPLOYEE WHERE EMPLOYEE_DEPARTMENT_ID=1) > 5000)
	PRINT 'EMPLOYEES ARE HAPPY'
ELSE
	PRINT 'EMPLOYEES NEED HIKE OR BONUS'
GO

-- calling a stored procedure in if condition
IF((SELECT dbo.calAvgSalByDeptId(1))>5000)
	PRINT 'EMPLOYEES ARE HAPPY'
ELSE
	PRINT 'EMPLOYEES NEED HIKE OR BONUS'
GO

-- nested if else
DECLARE @studentMarks int = 76
IF(@studentMarks>35)
	BEGIN
		IF(@studentMarks<=75)
			PRINT 'GOOD STUDENT'
		ELSE
			PRINT 'MANY PEOPLE CLIMBED Mt.EVEREST BUT NONE OF THEM ARE RESIDING THERE'
	END	
ELSE
	PRINT 'FAILURE IS THE STEPPING STONE TO SUCCESS'
GO

IF((SELECT dbo.calAvgSalByDeptId(3))>5000)
	BEGIN
		IF((SELECT dbo.calAvgSalByDeptId(1))<=5500)
			PRINT 'GIVE BONUS NO NEED OF HIKE'
		ELSE
			PRINT 'OVER EXPENDITURE SEND THEM OUT OF THE COMPANY'
	END	
ELSE
	PRINT 'HIKE COMPULSORY'
GO

-- loops in sql
-- display 1 to 10
DECLARE @value int = 1;
WHILE(@value<=10)
	BEGIN
		PRINT(@value)
		SET @value=@value+1
	END
GO

-- break and continue
DECLARE @value int = 1
WHILE(@value<=10)
	BEGIN
		SET @value=@value+1
		IF(@value=5) 
			BREAK
		ELSE
			PRINT(@value)
	END
GO

DECLARE @value int = 1
WHILE(@value<=10)
	BEGIN
		SET @value=@value+1
		IF(@value=5) 
			CONTINUE
		ELSE
			PRINT(@value)
	END
GO

DECLARE @value1 int = 1, @value2 int = 1
WHILE(@value1<=10)
	BEGIN
		WHILE(@value2<=3)
		BEGIN
			PRINT CONCAT ('value 2 = ', @value2)
			SET @value2=@value2+1
		END
		SET @value2=1
		SET @value1=@value1+2	
	END
GO

-- value 2 = 1
-- value 2 = 2
-- value 2 = 3
