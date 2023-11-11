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

EXEC ChangeColumnType 'Employees', 'Email', 'CHAR(150)';


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









-- Procedure to change column type and log the version
-- Procedure to change column type and log the version






--=============== CREATE NEW TABLE + ROLLBACK ===================

CREATE OR ALTER PROCEDURE CreateNewTableVersion(
    @tableName VARCHAR(100),
    @columnsDefinition VARCHAR(MAX),
    @addToVersionCheck BIT = 1
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'CREATE TABLE ' + QUOTENAME(@tableName) + ' (' + @columnsDefinition + ')';
	PRINT @sql;
    EXEC sp_executesql @sql;

    IF @addToVersionCheck = 1
    BEGIN
        DECLARE @existingVersion INT;

        -- Check if the version for the table already exists
        SELECT @existingVersion = VersionID
        FROM DataBaseVersions
        WHERE ProcedureName = 'CreateNewTableVersion'
          AND tableName = @tableName
          AND columnsDefinition = @columnsDefinition;

        IF @existingVersion IS NOT NULL
        BEGIN
            -- Update the existing version
            UPDATE DataBaseVersions
            SET columnsDefinition = @columnsDefinition
            WHERE VersionID = @existingVersion;
        END
        ELSE
        BEGIN
            -- Insert a new version
            INSERT INTO DataBaseVersions (ProcedureName, tableName, columnsDefinition)
            VALUES ('CreateNewTableVersion', @tableName, @columnsDefinition);

            IF EXISTS (SELECT * FROM currentVersion)
                UPDATE currentVersion
                SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
            ELSE
                INSERT INTO currentVersion
                VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions));
        END;
    END;
END
GO




CREATE OR ALTER PROCEDURE RollbackCreateNewTableVersion
    @tableName NVARCHAR(100),
    @version INT
AS
BEGIN
    IF OBJECT_ID(@tableName, 'U') IS NOT NULL
    BEGIN
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = 'DROP TABLE ' + QUOTENAME(@tableName);

        -- Use sp_executesql without parameters
        EXEC sp_executesql @sql;

        -- Update the current version in the CurrentVersion table
        UPDATE CurrentVersion SET CurrentVersion = @version - 1;
    END
END;
GO

--===========================================================================


--==================== CHANGE COLUMN TYPE + ROLLBACK ========================




CREATE OR ALTER PROCEDURE ChangeColumnTypeVersion
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @newDataType NVARCHAR(100),
    @addToVersionCheck BIT = 1
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @oldDataType NVARCHAR(100); -- New variable to store the original data type

    -- Retrieve the original data type of the column
    SELECT @oldDataType = DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')'  -- Include length in data type
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName
      AND COLUMN_NAME = @columnName;

    -- Generate and execute the ALTER TABLE statement
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' ALTER COLUMN ' + QUOTENAME(@columnName) + ' ' + @newDataType;
    EXEC sp_executesql @sql;

    IF @addToVersionCheck = 1
    BEGIN
        DECLARE @existingVersion INT;

        -- Check if the version for the column already exists
        SELECT @existingVersion = VersionID
        FROM DataBaseVersions
        WHERE ProcedureName = 'ChangeColumnTypeVersion'
          AND tableName = @tableName
          AND columnName = @columnName
          AND columnType = @newDataType
          AND oldColumnType = @oldDataType; -- Compare with the original data type

        IF @existingVersion IS NOT NULL
        BEGIN
            -- Update the existing version
            UPDATE DataBaseVersions
            SET columnType = @newDataType,
                oldColumnType = @oldDataType -- Store the original data type
            WHERE VersionID = @existingVersion;
        END
        ELSE
        BEGIN
            -- Insert a new version
            INSERT INTO DataBaseVersions (ProcedureName, tableName, columnName, columnType, oldColumnType)
            VALUES ('ChangeColumnTypeVersion', @tableName, @columnName, @newDataType, @oldDataType);

            IF EXISTS (SELECT * FROM currentVersion)
                UPDATE currentVersion
                SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
            ELSE
                INSERT INTO currentVersion
                VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions));
        END;
    END;
END;
GO





-- Procedure to rollback column type change and update the version
CREATE OR ALTER PROCEDURE RollbackChangeColumnTypeVersion
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @originalDataType NVARCHAR(100),
    @version INT
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    -- Use the original data type in the rollback
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' ALTER COLUMN ' + QUOTENAME(@columnName) + ' ' + @originalDataType;
    EXEC sp_executesql @sql;

    -- Update the current version in the CurrentVersion table
    UPDATE CurrentVersion SET CurrentVersion = @version - 1;
END;
GO

--=====================================================================

--==================== ADD COLUMN TO TABLE + ROLLBACK ========================


CREATE OR ALTER PROCEDURE AddColumnToTableVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @columnDefinition NVARCHAR(100),
    @addToVersionCheck BIT = 1
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) +  ' ADD ' + QUOTENAME(@columnName) + ' ' + @columnDefinition;
    PRINT @sql;
    EXEC sp_executesql @sql;

    IF @addToVersionCheck = 1
    BEGIN
        DECLARE @existingVersion INT;

        -- Check if the version for the table already exists
        SELECT @existingVersion = VersionID
        FROM DataBaseVersions
        WHERE ProcedureName = 'AddColumnToTableVersion'
          AND tableName = @tableName
          AND columnName = @columnName
          AND columnsDefinition = @columnDefinition;

        IF @existingVersion IS NOT NULL
        BEGIN
            -- Update the existing version
            UPDATE DataBaseVersions
            SET columnsDefinition = @columnDefinition
            WHERE VersionID = @existingVersion;
        END
        ELSE
        BEGIN
            -- Insert a new version
            INSERT INTO DataBaseVersions (ProcedureName, tableName, columnName, columnsDefinition)
            VALUES ('AddColumnToTableVersion', @tableName, @columnName, @columnDefinition);

            IF EXISTS (SELECT * FROM currentVersion)
                UPDATE currentVersion
                SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
            ELSE
                INSERT INTO currentVersion
                VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions));
        END;
    END;
END;
GO



CREATE OR ALTER PROCEDURE RollbackAddColumnToTableVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @version INT
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' DROP COLUMN ' + QUOTENAME(@columnName);
    EXEC sp_executesql @sql;

    -- Update the current version in the CurrentVersion table
    UPDATE CurrentVersion SET CurrentVersion = @version - 1;
END;
GO



--=====================================================================

--=================== ADD A DEFAULT CONSTRAINT TO COLUMN + ROLLBACK ================
CREATE OR ALTER PROCEDURE AddDefaultConstraintVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @defaultConstraint NVARCHAR(100),
    @addToVersionCheck BIT = 1
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' ADD CONSTRAINT DF_' + @tableName + '_' + @columnName + ' DEFAULT ' + @defaultConstraint + ' FOR ' + QUOTENAME(@columnName);
    PRINT @sql;
    EXEC sp_executesql @sql;

    IF @addToVersionCheck = 1
    BEGIN
        DECLARE @existingVersion INT;

        -- Check if the version for the table already exists
        SELECT @existingVersion = VersionID
        FROM DataBaseVersions
        WHERE ProcedureName = 'AddDefaultConstraintVersion'
          AND tableName = @tableName
          AND columnName = @columnName
          AND columnsDefinition = @defaultConstraint;

        IF @existingVersion IS NOT NULL
        BEGIN
            -- Update the existing version
            UPDATE DataBaseVersions
            SET columnsDefinition = @defaultConstraint
            WHERE VersionID = @existingVersion;
        END
        ELSE
        BEGIN
            -- Insert a new version
            INSERT INTO DataBaseVersions (ProcedureName, tableName, columnName, columnsDefinition)
            VALUES ('AddDefaultConstraintVersion', @tableName, @columnName, @defaultConstraint);

            IF EXISTS (SELECT * FROM currentVersion)
                UPDATE currentVersion
                SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
            ELSE
                INSERT INTO currentVersion
                VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions));
        END;
    END;
END;
GO
EXEC AddDefaultConstraintVersion 'Employees', 'LastName', '''Doe''';

CREATE OR ALTER PROCEDURE RollbackAddDefaultConstraintVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @version INT
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @constraintName NVARCHAR(100) = 'DF_' + @tableName + '_' + @columnName;

    IF EXISTS (SELECT * FROM sys.default_constraints WHERE name = @constraintName)
    BEGIN
        SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' DROP CONSTRAINT ' + @constraintName;
        EXEC sp_executesql @sql;
    END

    -- Update the current version in the CurrentVersion table
    UPDATE CurrentVersion SET CurrentVersion = @version - 1;
END;
GO

--=====================================================================

--=================== ADD A FOREIGN KEY CONSTRAINT TO COLUMN + ROLLBACK ================

CREATE OR ALTER PROCEDURE AddForeignKeyConstraintVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @referencedTable NVARCHAR(100),
    @referencedColumn NVARCHAR(100),
    @addToVersionCheck BIT = 1
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' ADD CONSTRAINT FK_' + @tableName + '_' + @columnName +
               ' FOREIGN KEY (' + QUOTENAME(@columnName) + ') REFERENCES ' + QUOTENAME(@referencedTable) + '(' + QUOTENAME(@referencedColumn) + ')';
    PRINT @sql;
    EXEC sp_executesql @sql;

    IF @addToVersionCheck = 1
    BEGIN
        DECLARE @existingVersion INT;

        -- Check if the version for the table already exists
        SELECT @existingVersion = VersionID
        FROM DataBaseVersions
        WHERE ProcedureName = 'AddForeignKeyConstraintVersion'
          AND tableName = @tableName
          AND columnName = @columnName
          AND referencedTable = @referencedTable
          AND referencedColumn = @referencedColumn;

        IF @existingVersion IS NOT NULL
        BEGIN
            -- Update the existing version
            UPDATE DataBaseVersions
            SET referencedTable = @referencedTable,
                referencedColumn = @referencedColumn
            WHERE VersionID = @existingVersion;
        END
        ELSE
        BEGIN
            -- Insert a new version
            INSERT INTO DataBaseVersions (ProcedureName, tableName, columnName, referencedTable, referencedColumn)
            VALUES ('AddForeignKeyConstraintVersion', @tableName, @columnName, @referencedTable, @referencedColumn);

            IF EXISTS (SELECT * FROM currentVersion)
                UPDATE currentVersion
                SET CurrentVersion = (SELECT MAX(VersionID) FROM DataBaseVersions)
            ELSE
                INSERT INTO currentVersion
                VALUES ((SELECT MAX(VersionID) FROM DataBaseVersions));
        END;
    END;
END;
GO


CREATE OR ALTER PROCEDURE RollbackAddForeignKeyConstraintVersion(
    @tableName NVARCHAR(100),
    @columnName NVARCHAR(100),
    @version INT
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @constraintName NVARCHAR(100);

    SELECT @constraintName = fk.name
    FROM sys.foreign_keys AS fk
    INNER JOIN sys.foreign_key_columns AS fkc ON fk.OBJECT_ID = fkc.constraint_object_id
    INNER JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
    WHERE fk.parent_object_id = OBJECT_ID(@tableName) AND c.name = @columnName;

    IF @constraintName IS NOT NULL
    BEGIN
        SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' DROP CONSTRAINT ' + QUOTENAME(@constraintName);
        EXEC sp_executesql @sql;

        -- Update the current version in the CurrentVersion table
        UPDATE CurrentVersion SET CurrentVersion = @version - 1;
    END
END;
GO



CREATE OR ALTER PROCEDURE GoToVersion @targetVersion INT
AS
BEGIN
    DECLARE @CurrentVersion INT;
    DECLARE @ProcedureName NVARCHAR(50),
            @TableName NVARCHAR(100),
            @ColumnName NVARCHAR(100),
            @OriginalDataType NVARCHAR(100),
            @ColumnType NVARCHAR(MAX),
            @ReferencedTable NVARCHAR(100),
            @ReferencedColumn NVARCHAR(100);

    SELECT @CurrentVersion = CurrentVersion FROM CurrentVersion;

    IF @targetVersion >= 0 AND @targetVersion <= (SELECT MAX(VersionID) FROM DataBaseVersions)
    BEGIN
        WHILE @CurrentVersion <> @targetVersion
        BEGIN
            IF @CurrentVersion > @targetVersion
            BEGIN
                SELECT
                    @ProcedureName = ProcedureName,
                    @TableName = TableName,
                    @ColumnName = columnName,
                    @OriginalDataType = oldColumnType,
                    @ColumnType = columnsDefinition,
                    @ReferencedTable = referencedTable,
                    @ReferencedColumn = referencedColumn
                FROM DataBaseVersions
                WHERE VersionID = @CurrentVersion;

                DECLARE @RollbackProcedure NVARCHAR(50) = 'Rollback' + @ProcedureName;

                IF @ProcedureName = 'CreateNewTableVersion'
                    EXEC @RollbackProcedure @TableName, @CurrentVersion;
                ELSE IF @ProcedureName = 'ChangeColumnTypeVersion'
                    EXEC @RollbackProcedure @TableName, @ColumnName, @OriginalDataType, @CurrentVersion;
                ELSE IF @ProcedureName = 'AddColumnToTableVersion'
                    EXEC @RollbackProcedure @TableName, @ColumnName, @CurrentVersion;
                ELSE IF @ProcedureName = 'AddDefaultConstraintVersion'
                    EXEC @RollbackProcedure @TableName, @ColumnName, @CurrentVersion;
                ELSE IF @ProcedureName = 'AddForeignKeyConstraintVersion'
                    EXEC @RollbackProcedure @TableName, @ColumnName, @CurrentVersion;

                SET @CurrentVersion = @CurrentVersion - 1;
            END
            ELSE
            BEGIN
                SELECT
                    @ProcedureName = ProcedureName,
                    @TableName = TableName,
                    @ColumnName = columnName,
                    @ColumnType = columnsDefinition,
                    @ReferencedTable = referencedTable,
                    @ReferencedColumn = referencedColumn
                FROM DataBaseVersions
                WHERE VersionID = @CurrentVersion + 1;

                IF @ProcedureName = 'CreateNewTableVersion'
                    EXEC @ProcedureName @TableName, @ColumnType;
                ELSE IF @ProcedureName = 'ChangeColumnTypeVersion'
                    EXEC @ProcedureName @TableName, @ColumnName, @OriginalDataType;
                ELSE IF @ProcedureName = 'AddColumnToTableVersion'
                    EXEC @ProcedureName @TableName, @ColumnName, @ColumnType;
                ELSE IF @ProcedureName = 'AddDefaultConstraintVersion'
                    EXEC @ProcedureName @TableName, @ColumnName, @ColumnType;
                ELSE IF @ProcedureName = 'AddForeignKeyConstraintVersion'
                    EXEC @ProcedureName @TableName, @ColumnName, @ReferencedTable, @ReferencedColumn;
                SET @CurrentVersion = @CurrentVersion + 1;
            END;
        END;

        UPDATE CurrentVersion SET CurrentVersion = @targetVersion;
    END;
END;

EXEC GoToVersion 6;

EXEC CreateNewTableVersion 'Employees',
    'EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50) NOT NULL, LastName NVARCHAR(50) NOT NULL, Email NVARCHAR(100)';
EXEC ChangeColumnTypeVersion 'Employees', 'Email', 'CHAR(150)';
EXEC AddColumnToTableVersion 'Employees', 'PhoneNumber', 'NVARCHAR(20)';
EXEC CreateNewTableVersion 'Departments', 'DepartmentID INT PRIMARY KEY, DepartmentName NVARCHAR(50)';
EXEC AddColumnToTableVersion 'Employees', 'DepartmentID', 'INT';
EXEC AddDefaultConstraintVersion 'Employees', 'LastName', '''Doe''';
EXEC AddForeignKeyConstraintVersion 'Employees', 'DepartmentID', 'Departments', 'DepartmentID'







DROP TABLE CurrentVersion;
DROP TABLE DataBaseVersions;
DROP TABLE Employees;
DROP TABLE Departments;



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









    -- Procedure to rollback column type change and update the version
-- CREATE OR ALTER PROCEDURE RollBackChangeColumnTypeVersion
--     @tableName NVARCHAR(100),
--     @columnName NVARCHAR(100),
--     @originalDataType NVARCHAR(100),
--     @version INT
-- AS
-- BEGIN
--     DECLARE @sql NVARCHAR(MAX);
--     DECLARE @oldColumnType NVARCHAR(100);
--
--     -- Retrieve the original column type from the DataBaseVersions table
--     SELECT @oldColumnType = oldColumnType
--     FROM DataBaseVersions
--     WHERE ProcedureName = 'ChangeColumnTypeVCtrl'
--       AND tableName = @tableName
--       AND columnName = @columnName
--       AND columnType = @originalDataType
--       AND VersionID = @version;
--
--     -- Use the oldColumnType in the rollback
--     SET @sql = 'ALTER TABLE ' + QUOTENAME(@tableName) + ' ALTER COLUMN ' + QUOTENAME(@columnName) + ' ' + @oldColumnType;
--     EXEC sp_executesql @sql;
--
--     -- Update the current version in the CurrentVersion table
--     UPDATE CurrentVersion SET CurrentVersion = @version - 1;
-- END;
-- GO