use L5;

create schema dbo;

CREATE TABLE Ta (
    idA INT PRIMARY KEY,
    a2 INT UNIQUE
);

CREATE TABLE Tb (
    idB INT PRIMARY KEY,
    b2 INT,
    b3 INT
);

CREATE TABLE Tc (
    idC INT PRIMARY KEY,
    idA INT FOREIGN KEY REFERENCES Ta(idA),
    idB INT FOREIGN KEY REFERENCES Tb(idB)
);


CREATE PROCEDURE InsertData
AS
BEGIN
    DECLARE @counter INT = 1;

    WHILE @counter <= 10000
    BEGIN
        INSERT INTO Ta (idA, a2)
        VALUES (@counter, @counter * 2);

        SET @counter = @counter + 1;
    END

    SET @counter = 1;

    WHILE @counter <= 3000
    BEGIN
        INSERT INTO Tb (idB, b2, b3)
        VALUES (@counter, @counter * 3, @counter * 4);

        SET @counter = @counter + 1;
    END

    SET @counter = 1;

    WHILE @counter <= 30000
    BEGIN
        DECLARE @idA INT, @idB INT;

        SELECT TOP 1 @idA = idA FROM Ta ORDER BY NEWID();
        SELECT TOP 1 @idB = idB FROM Tb ORDER BY NEWID();

        INSERT INTO Tc (idC, idA, idB)
        VALUES (@counter, @idA, @idB);

        SET @counter = @counter + 1;
    END
END;

EXEC InsertData;


EXEC sp_helpindex 'Ta';
    SELECT *
FROM sys.indexes
WHERE object_id = OBJECT_ID('Ta');


SELECT COUNT(*) From Ta;
SELECT COUNT(*) From Tb;
SELECT COUNT(*) From Tc;

SELECT * FROM Ta;
SELECT * FROM Tb;
SELECT * FROM Tc;

--Exercise 2

--a)
SET SHOWPLAN_TEXT ON;
GO

SET SHOWPLAN_TEXT OFF;
GO

SELECT a2 FROM Ta Where a2>= 10000 ORDER BY idA DESC;

SELECT * FROM Ta WHERE idA > 100;

SELECT idA, a2 FROM Ta ORDER BY a2;

SELECT idA, a2 FROM Ta WHERE a2 >= 500 AND a2 <= 1000;
SELECT * FROM Ta WHERE a2 = 500

--b)
    SET SHOWPLAN_TEXT ON;
GO

SET SHOWPLAN_TEXT OFF;
GO
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Ta');

ALTER TABLE Ta ADD a3 INT;
-- CREATE NONCLUSTERED INDEX idx_a2 ON Ta(a2);
-- CREATE NONCLUSTERED INDEX idx_a3 ON Ta(a3);

-- CREATE NONCLUSTERED INDEX idx_a2 ON Ta(a2) INCLUDE (a3);
-- CREATE NONCLUSTERED INDEX idx_a3 ON Ta(a3) INCLUDE (a2);

-- DROP index idx_a2 ON Ta;
--     DROP index idx_a3 ON Ta;
SELECT a3 from Ta;
SELECT idA, a3 FROM Ta WHERE a2 = 5000;



--c)

SET SHOWPLAN_TEXT ON;
GO
SET SHOWPLAN_TEXT OFF;
GO

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Tb');

SELECT * FROM Tb WHERE b2 > 1500;


CREATE NONCLUSTERED INDEX idx_b2 ON Tb(b2) INCLUDE (b3);
DROP INDEX idx_b2 on Tb;


--d)
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Tc');
SET SHOWPLAN_TEXT ON;
GO

SET SHOWPLAN_TEXT OFF;
GO
SELECT Tc.idC, Ta.a2, Ta.a3 FROM Tc
JOIN Ta on Tc.idA = Ta.idA
WHERE tc.idA = 700;

SELECT Tc.idC, Tb.b2 FROM Tc
JOIN Tb ON Tc.idB = Tb.idB
WHERE Tc.idB = 1700;

SELECT * FROM Tc INNER JOIN Ta ON Tc.idA = Ta.idA WHERE Ta.idA = 100;


CREATE NONCLUSTERED INDEX I_idA ON Tc(idA);
CREATE NONCLUSTERED INDEX I_idB ON Tc(idB);

DROP INDEX Tc.I_idA;
DROP INDEX Tc.I_idB;

