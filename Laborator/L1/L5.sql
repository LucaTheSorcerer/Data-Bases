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
FROM Ta
WHERE idA > 0;


SELECT *
FROM Ta
WHERE idA = 1000;

SELECT *
FROM Ta
WHERE a2 BETWEEN 1 AND 100;


SELECT *
FROM Ta
WHERE a2 = 3578;

--aufgabe 3



CREATE NONCLUSTERED INDEX IX_Tb_b2
ON Tb(b2);

SET SHOWPLAN_TEXT ON;
GO

SELECT *
FROM Tb
WHERE b2 = 1386;

SET SHOWPLAN_TEXT OFF;
GO

--EXERCISE 4

SET SHOWPLAN_TEXT ON;
GO

-- SELECT query with INNER JOIN between Tc and Ta with a condition
SELECT *
FROM Tc
INNER JOIN Ta ON Tc.idA = Ta.idA
WHERE Ta.a2 = 272; -- Replace [YourValue] with the specific value you are interested in

SET SHOWPLAN_TEXT OFF;
GO


SET SHOWPLAN_TEXT ON;
GO
-- SELECT query with INNER JOIN between Tc and Tb with a condition
SELECT *
FROM Tc
JOIN Tb ON Tc.idB = Tb.idB
WHERE Tb.b2 = 1386; -- Replace [YourValue] with the specific value you are interested in

SET SHOWPLAN_TEXT OFF;
GO