create database Practic9;

use Practic9;

create schema dbo;

/*
 1. Erstelle eine Datenbank, die Züge verwaltet und alle Informationen über die Routen der Züge enthält.
• Die Datenbank enthält folgende Relationen (kann aber auch andere enthalten, wenn nötig): Züge,
Zugtypen, Bahnhöfe, Routen
• Jeder Zug hat einen Namen und gehört zu einem Zugtyp.
• Der Zugtyp hat nur eine Beschreibung.
• Jede Route hat einen Namen, einen zugeordneten Zug und eine Liste von Bahnhöfe mit dem
Ankunftszeit und Abfahrtszeit des Zuges (z.B. der Zug kommt um 10:00 AM an und fährt um 10:10 AM ab)
Erstelle eine Datenbank in Boyce-Codd Normalform (mit den entsprechenden Primär- und Fremdschlüsseln), um die gegebenen Daten zu speichern,
 und füge ein paar Tupeln in die Relationen ein (sodass die Ergebnisse für die folgenden Aufgaben nicht die leere Menge sind)
2. Schreibe eine gespeicherte Prozedur, die Route, Bahnhof, Ankunftszeit und Abfahrtszeit als Parameter kriegt. Falls
 sich der Bahnhof schon auf dieser Route befindet, dann werden die Ankunftszeit und Abfahrtszeit entsprechend geändert.
 Ansonsten, wird der neue Bahnhof zu der Route eingefügt.
3. Schreibe eine benutzerdefinierte Funktion, die alle Bahnhöfe auflistet, die mehr als ein Zug haben an einem bestimmten Zeitpunkt. (z.B. um 10:30)
4. Erstelle einen Sicht mit den Namen der Routen, welche die wenigsten Bahnhöfe enthalten und, die, zusätzlich, nicht mehr als 5 Bahnhöfe enthalten.
5. Schreibe eine Abfrage, welche die Namen der Routen ausgibt, die alle Bahnhöfe enthalten.
6. Schreibe eine Abfrage, welche die Bahnhöfe ausgibt, wo ein Zug am längsten bleibt.
7. Erstelle einen Trigger um folgende Regel durchzusetzen. Wenn man einen neuen Bahnhof auf eine Route einfügt,
 dann muss man überprüfen, dass die Ankunfts- und Abfahrtszeiten nicht zwischen 3:00 AM und 5:00 AM sind.
 Falls das der Fall ist, dann wird eine Fehlermeldung angezeigt und die Daten werden nicht eingefügt.
 */

drop table TrainType;
--============================================================
--Exercise 1

create table TrainType(
    TypeID int primary key,
    Description varchar(max)
);

create table Train(
    TrainID int primary key,
    Name varchar(255),
    TypeID int foreign key references TrainType(TypeID)
);


create table Routes(
    RouteID int primary key,
    Name nvarchar(255),
    TrainID int foreign key references Train(TrainID)
);

create table Station(
    StationID int primary key,
    Name nvarchar(255)
);

create table RouteStation(
    RouteID int foreign key references Routes(RouteID),
    StationID int foreign key references Station(StationID),
    primary key (RouteID, StationID),
    ArrivalTime time,
    DepartureTime time
);


INSERT INTO TrainType (TypeID, Description) VALUES
(1, 'High-speed electric train'),
(2, 'Diesel locomotive train'),
(3, 'Maglev');


INSERT INTO Train (TrainID, Name, TypeID) VALUES
(101, 'Lightning Express', 1),
(102, 'Mountain Mover', 2),
(103, 'Futuristic Flyer', 3);


INSERT INTO Routes (RouteID, Name, TrainID) VALUES
(201, 'Capital Line', 101),
(202, 'Coastal Express', 102),
(203, 'Mountain Trail', 103);

INSERT INTO Station (StationID, Name) VALUES
(301, 'Central Station'),
(302, 'North End'),
(303, 'South Gate'),
(304, 'East Park'),
(305, 'West Haven');


INSERT INTO RouteStation (RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(201, 301, '08:00:00', '08:15:00'),
(201, 303, '09:30:00', '09:45:00'),
(202, 302, '10:00:00', '10:15:00'),
(202, 304, '11:30:00', '11:45:00'),
(203, 305, '12:00:00', '12:15:00'),
(203, 301, '13:30:00', '13:45:00');


INSERT INTO RouteStation (RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(203, 302, '15:00:00', '16:00:00');

INSERT INTO RouteStation (RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(203, 303, '17:00:00', '18:00:00');

--============================================================
--Exercise 2

create or alter procedure UpdateArrivalDepartureTime
@RouteID int,
@StationID int,
@ArrivalTime time,
@DepartureTime time
as
    begin
        if exists(select * from RouteStation where RouteID = @RouteID and StationID = @StationID)
        begin
            update RouteStation
            set ArrivalTime = @ArrivalTime, DepartureTime = @DepartureTime
            where RouteID = @RouteID and StationID = @StationID
        end
        else
        begin
            insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime)
            values(@RouteID, @StationID, @ArrivalTime, @DepartureTime)
        end
    end

exec UpdateArrivalDepartureTime @RouteID = 201, @StationID = 301, @ArrivalTime = '08:30:00', @DepartureTime = '09:00:00';
select * from RouteStation;

--============================================================
--Exercise 3

create or alter function getStationWithMultipleTrain(@SpecificTime time)
returns table
as return (
                select s.Name, count(distinct r.TrainID) as TotalTrains
                from Station s
                join RouteStation rs on s.StationID = rs.StationID
                join Routes r on rs.RouteID = r.RouteID
                where @SpecificTime between rs.ArrivalTime and rs.DepartureTime
                group by s.Name
                having count(distinct r.TrainID) > 0
              )

select * from getStationWithMultipleTrain ('10:00:00');

--============================================================
--Exercise 4

create or alter view RoutesWithFewestStations
as
    SELECT r.RouteID, r.Name, count(rs.StationID) as StationCount
    from Routes r
    join RouteStation rs on r.RouteID = rs.RouteID
    group by r.RouteID, r.Name
    having count(rs.StationID) = (
        select min(StationCount)
        from (
            select Count(rs.StationID) as StationCount
            from RouteStation rs
            group by rs.RouteID
            having count(rs.StationID) <= 5
             ) as subquery
        )



select * from RoutesWithFewestStations;



--============================================================
--Exercise 5

select r.Name
from Routes r
join RouteStation rs on r.RouteID = rs.RouteID
group by r.RouteID, r.Name
having count(distinct rs.StationID) = (Select count(distinct StationID) from Station);

--============================================================
--Exercise 6

select StationID
from RouteStation
where DATEDIFF(minute,ArrivalTime, DepartureTime) = (
    select max(datediff(minute,ArrivalTime,DepartureTime))
    from RouteStation
    );

--============================================================
--Exercise 7

create or alter trigger InsertRestriction on RouteStation
after insert
as
    begin
        if exists(select * from inserted where (ArrivalTime between '03:00:00' and '05:00:00')
                                            or (DepartureTime between '03:00:00' and '05:00:00'))
        begin
            raiserror('arrival and departure cannot be between 3 and 5 am', 16, 2);
            rollback transaction;
        end
end



