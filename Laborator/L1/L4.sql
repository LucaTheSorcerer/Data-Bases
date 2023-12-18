use employeeLastV;

-- ================= EXERCISE 1 =================

CREATE OR ALTER FUNCTION ValidateFirstName(@FirstName varchar(50))
RETURNS BIT
AS
    BEGIN
    DECLARE @IsValid BIT = 0;

    IF @FirstName NOT LIKE '%[^a-z]%'
        SET @IsValid = 1;
    RETURN @IsValid;
END

CREATE OR ALTER FUNCTION ValidateSalaryAmount(@SalaryAmount DECIMAL(10,2))
RETURNS BIT
AS
    BEGIN
       DECLARE @IsValid BIT = 0;

       IF @SalaryAmount >= 0
        SET @IsValid = 1;

        RETURN @IsValid;
END


CREATE OR ALTER PROCEDURE InsertEmployee
    @EmployeeID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @DepartmentID INT,
    @SalaryAmount DECIMAL(10, 2),
    @CurrentStatus NVARCHAR(50)
AS
BEGIN
    IF dbo.ValidateFirstName(@FirstName) = 0
    BEGIN
        RAISERROR ('Invalid FirstName parameter', 16, 1)
        RETURN
    END

    IF dbo.ValidateSalaryAmount(@SalaryAmount) = 0
    BEGIN
        RAISERROR ('Invalid SalaryAmount parameter', 16, 1)
        RETURN
    END


    INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus)
    VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Phone, @DepartmentID, @SalaryAmount, @CurrentStatus)
END

Select * FROm Employees;
EXEC InsertEmployee 21,'John','Woods','johnn.woods@email.com','888-888-8888',1,70000.00,'Active';
EXEC InsertEmployee 21,'123','Woods','john.woods@email.com','888-888-8888',1,70000.00,'Active';
EXEC InsertEmployee 21,'John','Woods','john.woods@email.com','888-888-8888',1,-1,'Active';


-- ================= END EXERCISE 1 =============


-- ================= EXERCISE 2 =================

-- CREATE OR ALTER VIEW EmployeeDetailsView AS
-- SELECT
--     E.EmployeeID,
--     E.FirstName,
--     E.LastName,
--     E.Email,
--     E.SalaryAmount,
--     D.DepartmentName,
--     S.SkillName
-- FROM
--     Employees E
-- JOIN Departments D ON E.DepartmentID = D.DepartmentID
-- LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
-- LEFT JOIN Skills S ON ES.SkillID = S.SkillID;


CREATE OR ALTER VIEW EmployeeDetailsView AS
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.SalaryAmount,
    D.DepartmentName,
    S.SkillName,
    COUNT(P.EmployeeID) AS TotalProjects
FROM
    Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Skills S ON ES.SkillID = S.SkillID
LEFT JOIN EmployeeProjects P ON E.EmployeeID = P.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.SalaryAmount,
    D.DepartmentName,
    S.SkillName;



CREATE OR ALTER FUNCTION GetTopEmployeesBySalary(@TopCount INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@TopCount)
--         E.EmployeeID,
--         E.FirstName,
--         E.LastName,
--         E.SalaryAmount,
        SUM(TT.HoursWorked) AS TotalHoursWorked
    FROM
        Employees E
--         EmployeeDetailsView E
    LEFT JOIN TimeTracking TT ON E.EmployeeID = TT.EmployeeID
    GROUP BY
--         E.EmployeeID,
--         E.FirstName,
--         E.LastName,
        E.SalaryAmount
    ORDER BY
        E.SalaryAmount DESC, TotalHoursWorked DESC
)

SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.SalaryAmount,
    E.DepartmentName,
    E.SkillName,
    E.TotalProjects,
    TopEmployees.TotalHoursWorked
FROM
    EmployeeDetailsView E
JOIN
    dbo.GetTopEmployeesBySalary(3) TopEmployees ON E.EmployeeID = TopEmployees.EmployeeID


-- ================= END EXERCISE 2 =============

-- ================= EXERCISE 3 =================

CREATE TABLE Logger (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    LogDate DATETIME NOT NULL,
    LogType CHAR(1) NOT NULL, -- I = Insert, U = Update, D = Delete
    TableName NVARCHAR(100) NOT NULL,
    AffectedRows INT NOT NULL
);

CREATE OR ALTER TRIGGER EmployeeOperationTrigger
ON Employees
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @OperationType CHAR(1);

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        IF EXISTS (SELECT * FROM deleted)
            SET @OperationType = 'U';
        ELSE
            SET @OperationType = 'I';
    END
    ELSE
        SET @OperationType = 'D';

    INSERT INTO Logger (LogDate, LogType, TableName, AffectedRows)
    VALUES (GETDATE(), @OperationType, 'Employees', (SELECT COUNT(DISTINCT EmployeeID) FROM (
            SELECT EmployeeID FROM inserted
            UNION
            SELECT EmployeeID FROM deleted
        ) AS CombinedTable));
END;

SELECT * FROM Logger WHERE LogID > 4047;
DROP TABLE Logger;
SELECT  * FROM Employees;
SELECT COUNT(*) FROM Employees;
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus)
    VALUES (18,'Ana','Dove','ana.dove@email.com','999-999-9999',2,50000.00,'Active');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (22,'Ion','Gheorghe','ion.gheorghe@email.com','123-456-7890',1,60000.00,'Active'),
    (23,'BimBim','BamBam','bim.bam@email.com','7890-456-123',1,65000.00,'Active');




UPDATE Employees
SET SalaryAmount = 5500.00
WHERE EmployeeID = 18;
    SELECT @@ROWCOUNT AS AffectedRows;

UPDATE Employees
SET SalaryAmount = 6000.00
WHERE EmployeeID IN (18, 22, 23);

SELECT @@ROWCOUNT AS AffectedRows;



DELETE FROM Employees
WHERE EmployeeID in (15, 18);

DELETE FROM Employees
WHERE EmployeeID IN (22, 23);
SELECT @@ROWCOUNT AS AffectedRows;



-- ================= END EXERCISE 3 =============

-- ================= EXERCISE 4 =================

-- CREATE TABLE UpdateLog (
--     LogID INT PRIMARY KEY IDENTITY(1,1),
--     EmployeeID INT,
--     OldSalaryAmount DECIMAL(10, 2),
--     NewSalaryAmount DECIMAL(10, 2),
--     UpdateDate DATETIME
-- );
--
-- CREATE OR ALTER PROCEDURE UpdateEmployeeSalary
--     @EmployeeID INT,
--     @NewSalaryAmount DECIMAL(10, 2)
-- AS
--     BEGIN
--        DECLARE @OldSalaryAmount DECIMAL(10, 2);
--
--        SELECT @OldSalaryAmount = SalaryAmount
--         FROM Employees
--         WHERE EmployeeID = @EmployeeID;
--
--        UPDATE Employees
--         SET SalaryAmount = @NewSalaryAmount
--         WHERE EmployeeID = @EmployeeID;
--
--        INSERT INTO UpdateLog (EmployeeID, OldSalaryAmount, NewSalaryAmount, UpdateDate)
--         VALUES (@EmployeeID, @OldSalaryAmount, @NewSalaryAmount, GETDATE());
--     END;
--
--
-- DECLARE EmployeeCursor CURSOR FOR
-- SELECT EmployeeID, SalaryAmount
-- FROM Employees;
--
-- DECLARE @EmployeeID INT, @OldSalaryAmount DECIMAL(10, 2), @NewSalaryAmount DECIMAL(10, 2);
--
-- OPEN EmployeeCursor;
--
-- FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @OldSalaryAmount;
--
-- WHILE @@FETCH_STATUS = 0
-- BEGIN
--     SET @NewSalaryAmount = ROUND(@OldSalaryAmount * 1.1, 2);
--
--     EXEC UpdateEmployeeSalary @EmployeeID, @NewSalaryAmount;
--
--     FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @OldSalaryAmount;
-- END
--
-- CLOSE EmployeeCursor;
-- DEALLOCATE EmployeeCursor;
--
--
-- DROP TABLE UpdateLog;
-- SELECT * FROM UpdateLog;
-- SELECT * FROM Employees;

-- ================= END EXERCISE 4 =============



CREATE OR ALTER PROCEDURE UpdateAllEmployeeSalaries
AS
BEGIN
    DECLARE @EmployeeID INT;
    DECLARE @NewSalary DECIMAL(10, 2);

    DECLARE EmployeeCursor CURSOR FOR
    SELECT EmployeeID
    FROM Employees;

    OPEN EmployeeCursor;

    FETCH NEXT FROM EmployeeCursor INTO @EmployeeID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @NewSalary = ROUND((RAND() * (8800 - 5000) + 5000), 2);

        UPDATE Employees
        SET SalaryAmount = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        FETCH NEXT FROM EmployeeCursor INTO @EmployeeID;
    END;

    CLOSE EmployeeCursor;
    DEALLOCATE EmployeeCursor;
END;


EXEC UpdateAllEmployeeSalaries;

DROP TABLE UpdateLog;

CREATE TABLE UpdateLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    OldSalaryAmount DECIMAL(10, 2),
    BonusAmount DECIMAL(10, 2),
    BonusRating NVARCHAR(50),
    NewSalaryAmount DECIMAL(10, 2),
    UpdateDate DATETIME
);


CREATE OR ALTER PROCEDURE dbo.AllocateBonusForEmployee
    @EmployeeID INT,
    @OldSalaryAmount DECIMAL(10, 2)
AS
BEGIN
    DECLARE @BonusAmount DECIMAL(10, 2), @NewSalaryAmount DECIMAL(10, 2), @BonusRating NVARCHAR(50);

    SET @BonusAmount = CASE
                        WHEN (SELECT DepartmentID FROM Employees WHERE EmployeeID = @EmployeeID) = 1 THEN @OldSalaryAmount * 0.005
                        WHEN (SELECT DepartmentID FROM Employees WHERE EmployeeID = @EmployeeID) = 2 THEN @OldSalaryAmount * 0.1
                        WHEN (SELECT DepartmentID FROM Employees WHERE EmployeeID = @EmployeeID) = 3 THEN @OldSalaryAmount * 0.08
                        ELSE 0.00
                     END;

    IF @BonusAmount > 500
        SET @BonusRating = 'Excellent Performance';
    ELSE IF @BonusAmount >= 250 AND @BonusAmount <= 500
        SET @BonusRating = 'Good Performance';
    ELSE
        SET @BonusRating = 'Average Performance';

    SET @NewSalaryAmount = @OldSalaryAmount + @BonusAmount;

    UPDATE Employees
    SET SalaryAmount = @NewSalaryAmount
    WHERE EmployeeID = @EmployeeID;

    INSERT INTO UpdateLog (EmployeeID, OldSalaryAmount, BonusAmount, BonusRating, NewSalaryAmount, UpdateDate)
    VALUES (@EmployeeID, @OldSalaryAmount, @BonusAmount, @BonusRating, @NewSalaryAmount, GETDATE());
END;


SELECT * FROM Employees;

DECLARE EmployeeCursor CURSOR FOR
SELECT EmployeeID, SalaryAmount
FROM Employees;

DECLARE @EmployeeID INT, @OldSalaryAmount DECIMAL(10, 2), @BonusAmount DECIMAL(10, 2), @NewSalaryAmount DECIMAL(10, 2);

OPEN EmployeeCursor;

FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @OldSalaryAmount;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC dbo.AllocateBonusForEmployee @EmployeeID, @OldSalaryAmount;

    FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @OldSalaryAmount;
END

CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;

SELECT * FROM Employees;

SELECT * FROM UpdateLog;