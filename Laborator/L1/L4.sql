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


EXEC InsertEmployee 17,'John','Woods','john.woods@email.com','888-888-8888',1,70000.00,'Active';
EXEC InsertEmployee 17,'123','Woods','john.woods@email.com','888-888-8888',1,70000.00,'Active';
EXEC InsertEmployee 17,'John','Woods','john.woods@email.com','888-888-8888',1,-1,'Active';


-- ================= END EXERCISE 1 =============


-- ================= EXERCISE 2 =================

CREATE OR ALTER VIEW EmployeeDetailsView AS
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.SalaryAmount,
    D.DepartmentName,
    S.SkillName
FROM
    Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Skills S ON ES.SkillID = S.SkillID;



CREATE OR ALTER FUNCTION GetTopEmployeesBySalary(@TopCount INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@TopCount)
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        E.SalaryAmount,
        SUM(TT.HoursWorked) AS TotalHoursWorked
    FROM
        Employees E
    LEFT JOIN TimeTracking TT ON E.EmployeeID = TT.EmployeeID
    GROUP BY
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        E.SalaryAmount
    ORDER BY
        E.SalaryAmount DESC, TotalHoursWorked DESC
)

SELECT DISTINCT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.SalaryAmount,
    E.DepartmentName,
    TopEmployees.TotalHoursWorked
FROM
    EmployeeDetailsView E
JOIN
    dbo.GetTopEmployeesBySalary(3) TopEmployees ON E.EmployeeID = TopEmployees.EmployeeID
ORDER BY
    E.SalaryAmount DESC, E.EmployeeID;

-- ================= END EXERCISE 2 =============
