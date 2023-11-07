use L3;

create schema dbo;


--Exercise 1 Part 1

--1. CREATE TABLE + Rollback procedure

CREATE OR ALTER PROCEDURE ProcedureUp3
AS
BEGIN
	CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE
);
END
GO

EXEC ProcedureUp3;





CREATE OR ALTER PROCEDURE CreateNewTable
    @tableName NVARCHAR(100),
    @columnsDefinition NVARCHAR(MAX)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'CREATE TABLE ' + @tableName + ' (' + @columnsDefinition + ')';
    PRINT @sql
    EXEC sp_executesql @sql;
END;

EXEC CreateNewTable 'Employees',
    'EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50) NOT NULL, LastName NVARCHAR(50) NOT NULL, Email NVARCHAR(100)';

EXEC CreateNewTable 'Departments', 'DepartmentID INT PRIMARY KEY, DepartmentName NVARCHAR(50)';



CREATE OR ALTER PROCEDURE DropTableIfExists(@tableName NVARCHAR(100))
AS
BEGIN
    IF OBJECT_ID(@tableName, 'U') IS NOT NULL
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'DROP TABLE ' + @tableName;
        EXEC sp_executesql @sql;
    END
END;
GO

EXEC DropTableIfExists 'Employees';
EXEC DropTableIfExists 'Departments';



--2. change the type of an attribute or column + ROLLBACK

CREATE OR ALTER PROCEDURE ChangeColumnType (@tableName NVARCHAR(100), @columnName NVARCHAR(100), @newDataType NVARCHAR(100))
AS
BEGIN
   DECLARE @sql NVARCHAR(MAX);
   SET @sql = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @newDataType;
   EXEC sp_executesql @sql;
END;

EXEC ChangeColumnType 'Employees', 'Email', 'NVARCHAR(150)';


CREATE OR ALTER PROCEDURE RollBackChangeColumnType(@tableName NVARCHAR(100), @columnName NVARCHAR(100), @originalDateType NVARCHAR(100))
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @originalDateType;
       EXEC sp_executesql @sql;
    END;

EXEC RollBackChangeColumnType 'Employees', 'Email', 'NVARCHAR(100)';




CREATE OR ALTER PROCEDURE RollBackChangeColumnType2(@tableName NVARCHAR(100), @columnName NVARCHAR(100), @originalDateType NVARCHAR(100))
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'IF EXISTS (SELECT * FROM sys.indexes WHERE name = ''UQ__Employee__A9D10534DF7C65B2'') ' +
               'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT UQ__Employee__A9D10534DF7C65B2; ' +
               'ALTER TABLE ' + @tableName + ' ALTER COLUMN ' + @columnName + ' ' + @originalDateType;
    EXEC sp_executesql @sql;
END;

EXEC RollBackChangeColumnType2 'Employees', 'Email', 'NVARCHAR(100)';



--3. add a new column to a table + ROLLBACK

CREATE OR ALTER PROCEDURE AddColumnToTable2(@tableName NVARCHAR(100), @columnName NVARCHAR(100), @columnDefinition NVARCHAR(100))
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName +  ' ADD ' + @columnName + ' ' + @columnDefinition;
       EXEC sp_executesql @sql;
    END;

EXEC AddColumnToTable2 'Employees', 'PhoneNumber', 'NVARCHAR(20)';
EXEC AddColumnToTable2 'Employees', 'DepartmentID', 'INT';


CREATE OR ALTER PROCEDURE DropColumnFromTable(@tableName NVARCHAR(100), @columnName NVARCHAR(100))
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName + ' DROP COLUMN ' + @columnName;
       EXEC sp_executesql @sql;
    END

EXEC DropColumnFromTable 'Employees', 'PhoneNumber';
EXEC DropColumnFromTable 'Employees', 'DepartmentID';


---4. ADD A CONSTRAINT TO COLUMN + ROLLBACK
CREATE OR ALTER PROCEDURE AddDefaultConstraint(@tableName NVARCHAR(100), @columnName NVARCHAR(100), @defaultConstraint NVARCHAR(100))
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT DF_' + @tableName + '_' + @columnName + ' DEFAULT ' + @defaultConstraint + ' FOR ' + @columnName;
       print @sql
        EXEC sp_executesql @sql
    END

EXEC AddDefaultConstraint 'Employees', 'LastName', '''Doe''';

CREATE OR ALTER PROCEDURE DropDefaultConstraint(@tableName NVARCHAR(100), @columnName NVARCHAR(100))
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT DF_' + @tableName + '_' + @columnName;
       EXEC sp_executesql @sql;
    END

EXEC DropDefaultConstraint 'Employees', 'LastName'

---5. ADD A FOREIGN KEY + ROLLBACK

CREATE OR ALTER PROCEDURE AddForeignKeyConstraint(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @referencedTable NVARCHAR(100),
    @referencedColumn NVARCHAR(100)
)
AS
    BEGIN
       DECLARE @sql NVARCHAR(MAX);
       SET @sql = 'ALTER TABLE ' + @tableName + ' ADD CONSTRAINT FK_' + @tableName + '_' + @columnName +
                  ' FOREIGN KEY (' + @columnName + ') REFERENCES ' + @referencedTable + '(' + @referencedColumn + ')';
       EXEC sp_executesql @sql;
    END


CREATE PROCEDURE DropForeignKeyConstraint
    @tableName NVARCHAR(100),
    @constraintName NVARCHAR(100)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + @tableName + ' DROP CONSTRAINT ' + @constraintName;
    EXEC sp_executesql @sql;
END;


EXEC AddForeignKeyConstraint 'Employees', 'DepartmentID', 'Departments', 'DepartmentID'

EXEC DropForeignKeyConstraint 'Employees', 'FK_Employees_DepartmentID';
















---PART II


CREATE OR ALTER PROCEDURE CreateNewTableVCtrl(
    @tableName VARCHAR(100),
    @columnsDefinition VARCHAR(MAX)
)
AS
BEGIN
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'CREATE TABLE ' + @tableName + ' (' + @columnsDefinition + ')';
	PRINT @sql;
    EXEC (@sql);

	INSERT INTO DataBaseVersions (ProcedureName, tableName, columnsDefinition)
	VALUES ('CreateTable', @tableName, @columnsDefinition);

	IF EXISTS (SELECT * FROM currentVersion)
		UPDATE currentVersion
		SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
	ELSE
		INSERT INTO currentVersion
		VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions))
END
GO




CREATE OR ALTER PROCEDURE DropTableIfExistsVCtrl(@tableName NVARCHAR(100))
AS
BEGIN
    IF OBJECT_ID(@tableName, 'U') IS NOT NULL
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'DROP TABLE ' + @tableName;
        EXEC sp_executesql @sql;
    END
END;
GO


CREATE OR ALTER PROCEDURE UpdateToVersion
    @targetVersion INT
AS
BEGIN
    DECLARE @currentVersion INT, @procedureName VARCHAR(50), @tableName VARCHAR(100), @columnsDefinition VARCHAR(MAX);

    -- Get the current version of the database
    SELECT @currentVersion = CurrentVersion FROM CurrentVersion;

    -- Rollback if the target version is lower than the current version
    IF @targetVersion < @currentVersion
    BEGIN
        WHILE @currentVersion > @targetVersion
        BEGIN
            SELECT TOP 1 @procedureName = ProcedureName, @tableName = tableName, @columnsDefinition = columnsDefinition
            FROM DataBaseVersions
            WHERE VersionID = @currentVersion
            ORDER BY VersionID DESC;

            -- Perform rollback based on the procedure name
            IF @procedureName = 'CreateTable'
            BEGIN
                EXEC DropTableIfExistsVCtrl @tableName;
            END
            -- Add more conditions for other operations rollback as per your requirements

            DELETE FROM DataBaseVersions WHERE VersionID = @currentVersion;
            SET @currentVersion = @currentVersion - 1;
        END
    END
    -- Apply changes if the target version is higher than the current version
    ELSE IF @targetVersion > @currentVersion
    BEGIN
        WHILE @currentVersion < @targetVersion
        BEGIN
            SELECT TOP 1 @procedureName = ProcedureName, @columnsDefinition = columnsDefinition, @tableName = tableName
            FROM DataBaseVersions
            WHERE VersionID = @currentVersion + 1;

            -- Apply changes based on the procedure name
            IF @procedureName = 'CreateTable'
            BEGIN
                EXEC CreateNewTableVCtrl @tableName, @columnsDefinition;
            END
            -- Add more conditions for other operations as per your requirements

            SELECT @currentVersion = @currentVersion + 1;
        END

        -- Update the current version after applying changes
        UPDATE CurrentVersion SET CurrentVersion = @targetVersion;
    END
END;





EXEC UpdateToVersion 1;




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
    referencedColumn VARCHAR(100)
);






-- CREATE TABLE DatabaseVersions (
--     VersionID INT PRIMARY KEY,
--     ProcedureName NVARCHAR(100),
--     Parameters NVARCHAR(MAX)
-- );


-- Create the CurrentVersion table with the appropriate column
CREATE TABLE CurrentVersion (
    CurrentVersionID INT PRIMARY KEY DEFAULT 1 -- Assume initial version is 1
);




SELECT * FROM CurrentVersion;



-- DROP TABLE Departments;
-- DROP TABLE Employees;
-- DROP TABLE DatabaseVersions;

-- DROP TABLE VersionHistory;
-- DROP TABLE CurrentVersion;
-- DROP TABLE Departments;





