USE L3;



CREATE TABLE CurrentVersion (
	CurrentVersion INT PRIMARY KEY
);

INSERT INTO CurrentVersion (CurrentVersion) VALUES (0);

CREATE TABLE DataBaseVersions (
	VersionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ProcedureName VARCHAR(50),
	tableName VARCHAR(100),
    columnsDefinition VARCHAR(MAX),
    columnName VARCHAR(100),
    columnType VARCHAR(100),
    defaultConstraint VARCHAR(100),
    oldColumnType VARCHAR(100),
    referencedTable VARCHAR(100),
    referencedColumn VARCHAR(100),
--     length INT

);


SELECT * FROM DataBaseVersions;
SELECT * FROM CurrentVersion



DROP TABLE CurrentVersion;
DROP TABLE DataBaseVersions;
DROP TABLE Employees;
DROP TABLE Departments;


EXEC CreateNewTableVersion 'Employees',
    'EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50) NOT NULL, LastName NVARCHAR(50) NOT NULL, Email NVARCHAR(100)';
EXEC ChangeColumnTypeVersion 'Employees', 'Email', 'CHAR(150)';
EXEC AddColumnToTableVersion 'Employees', 'PhoneNumber', 'NVARCHAR(20)';
EXEC CreateNewTableVersion 'Departments', 'DepartmentID INT PRIMARY KEY, DepartmentName NVARCHAR(50)';
EXEC AddColumnToTableVersion 'Employees', 'DepartmentID', 'INT';
EXEC AddDefaultConstraintVersion 'Employees', 'LastName', '''Doe''';
EXEC AddForeignKeyConstraintVersion 'Employees', 'DepartmentID', 'Departments', 'DepartmentID'
EXEC AddColumnToTableVersion 'Employees', 'Salary', 'INT';
EXEC AddDefaultConstraintVersion 'Employees', 'Salary', '100'


EXEC GoToVersion 0;
EXEC GoToVersion 1;
EXEC GoToVersion 2;
EXEC GoToVersion 3;
EXEC GoToVersion 4;
EXEC GoToVersion 5;
EXEC GoToVersion 6;
EXEC GoToVersion 7;
EXEC GoToVersion 8;
EXEC GoToVersion 9;
