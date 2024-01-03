create database Practic1;

create schema dbo;

use Practic1;

--============================================================
--Exercise 1
CREATE TABLE TrainTypes (
    TrainTypeID INT PRIMARY KEY,
    Description NVARCHAR(255)
);


CREATE TABLE Trains(
    TrainID INT PRIMARY KEY,
    Name NVARCHAR(255),
    TrainTypeID INT FOREIGN KEY REFERENCES TrainTypes(TrainTypeID)
);

CREATE TABLE Stations(
    StationID INT PRIMARY KEY,
    Name NVARCHAR(255)
);

CREATE TABLE Routes(
    RouteID INT PRIMARY KEY,
    Name NVARCHAR(255),
    TrainID INT FOREIGN KEY REFERENCES Trains(TrainID)
);

CREATE TABLE RouteStations(
    RouteStationID INT PRIMARY KEY,
    RouteID INT FOREIGN KEY REFERENCES Routes(RouteID),
    StationID INT FOREIGN KEY REFERENCES Stations(StationID),
    ArrivalTime TIME,
    DepartureTime TIME
);

INSERT INTO TrainTypes(TrainTypeID, Description) VALUES (1, 'Din ala vai de capul lui');
INSERT INTO Trains (TrainID, Name, TrainTypeID) VALUES (1, 'CFR1', 1);
INSERT INTO Stations(StationID, Name) VALUES (1, 'Statia1');
INSERT INTO Stations(StationID, Name) VALUES (2, 'Statia2');
INSERT INTO Stations(StationID, Name) VALUES (3, 'Statia3');
INSERT Routes(RouteID, Name, TrainID) VALUES (1, 'Arad-Iasi', 1);
INSERT INTO RouteStations(RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime) VALUES (1, 1, 1, '10:00:00', '11:00:00'), (2, 1, 2, '11:00:00', '12:30:00');

SELECT * FROM Trains;
SELECT * FROM Stations;
SELECT * FROM TrainTypes;
SELECT * FROM Routes;
SELECT * FROM Stations;
SELECT * FROM RouteStations;

--============================================================

--Exercise 2
CREATE OR ALTER PROCEDURE UpdateOrInsertRouteStations
    @RouteID INT,
    @StationID INT,
    @ArrivalTime TIME,
    @DepartureTime TIME
AS
    BEGIN
       IF EXISTS(SELECT 1 FROM RouteStations where RouteID = @RouteID and StationID = @StationID)
        BEGIN
           UPDATE RouteStations
            SET ArrivalTime = @ArrivalTime, DepartureTime = @DepartureTime
            WHERE RouteID = @RouteID AND StationID = @StationID;
        END
        ELSE
        BEGIN
            DECLARE @NewStationID INT;
            SELECT @NewStationID = ISNULL(MAX(RouteStationID), 0) + 1 FROM RouteStations;
           INSERT INTO RouteStations(RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime)
            VALUES (@NewStationID, @RouteID, @StationID, @ArrivalTime, @DepartureTime);
        END
    END

EXEC UpdateOrInsertRouteStations @RouteID = 1, @StationID = 2, @ArrivalTime = '15:00:00', @DepartureTime = '15:15:00';
EXEC UpdateOrInsertRouteStations @RouteID = 1, @StationID = 3, @ArrivalTime = '17:00:00', @DepartureTime = '17:10:00';
--============================================================

--Exercise 3

CREATE OR ALTER FUNCTION GetStationsWithMultipleTrains (@SpecificTime TIME)
RETURNS TABLE
AS
RETURN (
        SELECT s.Name, COUNT(Distinct r.TrainID) as TrainCount
        FROM Stations s
        JOIN RouteStations rs ON s.StationID = rs.StationID
        JOIN Routes r on rs.RouteID = r.RouteID
        WHERE(@SpecificTime BETWEEN rs.ArrivalTime and rs.DepartureTime)
        GROUP BY s.Name
        HAVING COUNT(DISTINCT r.TrainID) > 0
);

SELECT * FROM GetStationsWithMultipleTrains('10:30:00')

--============================================================

--Exercise 4

CREATE VIEW RoutesWithFewestStations AS
SELECT r.Name
FROM Routes r
JOIN (
    SELECT RouteID, COUNT(StationID) as StationCount
    FROM RouteStations
    GROUP BY RouteID
    HAVING COUNT(StationID) <= 5
) AS RouteCounts on r.RouteID = RouteCounts.RouteID
WHERE RouteCounts.StationCount = (
        SELECT MIN(StationCount)
        FROM (
            SELECT COUNT(StationID) as StationCount
            FROM RouteStations
            GROUP BY RouteID
            HAVING COUNT(StationID) <= 5
             ) as MinStationsCount
    )


SELECT * FROM RoutesWithFewestStations;

--============================================================

--Exercise 5

SELECT r.Name
FROM Routes r
JOIN RouteStations rs on r.RouteID = rs.RouteID
GROUP BY r.Name, r.RouteID
HAVING COUNT(DISTINCT rs.StationID) = (SELECT COUNT(DISTINCT StationID) FROM Stations);

--============================================================

--Exercise 6

SELECT s.Name, MAX(DATEDIFF(MINUTE, CAST(rs.ArrivalTime AS DATETIME), CAST(rs.DepartureTime AS DATETIME))) as LongestStationingTime
FROM RouteStations rs
JOIN Stations s on rs.StationID = s.StationID
GROUP BY s.Name
ORDER BY LongestStationingTIme DESC;


--============================================================

--Exercise 7

CREATE OR ALTER TRIGGER CheckTimeOnInsert
ON RouteStations
INSTEAD OF INSERT
AS
BEGIN
   IF EXISTS(
       SELECT 1
       FROM inserted
       WHERE (CAST(ArrivalTime AS TIME) BETWEEN '03:00:00' AND '05:00:00')
        OR (CAST(DepartureTIme as TIME) BETWEEN '03:00:00' AND '05:00:00')
   )
    BEGIN
       RAISERROR ('Insertion Failed: Arrival and Departure time cannot be between 3 and 5 am', 16, 1);
       ROLLBACK TRANSACTION ;
       RETURN;
    END

    INSERT INTO RouteStations (RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime)
    SELECT RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime
    FROM inserted;
END;


INSERT INTO RouteStations(RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime) VALUES (1, 1, 1, '03:00:00', '11:00:00');
INSERT INTO RouteStations(RouteStationID, RouteID, StationID, ArrivalTime, DepartureTime) VALUES (1, 1, 1, '07:00:00', '05:00:00');

