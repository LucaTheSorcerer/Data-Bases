create database BusFleetManagement;

use BusFleetManagement;

create schema dbo;

--============================================================
--Exercise 1

create table BusTypes(
    BusTypeID int primary key,
    Description nvarchar(255)
);


create table Buses(
    BusID int primary key,
    Name nvarchar(255),
    BusTypeID int foreign key references BusTypes(BusTypeID)
);


create table Terminals(
    TerminalID int primary key,
    Name nvarchar(255)
);

create table Routes(
    RouteID int primary key,
    Name nvarchar(255),
    BusID int foreign key references Buses(BusID)
);

create table RouteTerminals(
    ArrivalTime time,
    DepartureTime time,
    RouteID int foreign key references Routes(RouteID),
    TerminalID int foreign key references Terminals(TerminalID),
    PRIMARY KEY (RouteID, TerminalID)
);



-- Insert data into BusTypes
INSERT INTO BusTypes (BusTypeID, Description) VALUES (1, 'Type A'), (2, 'Type B');

-- Insert data into Buses
INSERT INTO Buses (BusID, Name, BusTypeID) VALUES (1, 'Bus1', 1), (2, 'Bus2', 2);

-- Insert data into Terminals
INSERT INTO Terminals (TerminalID, Name) VALUES (1, 'Terminal 1'), (2, 'Terminal 2');

-- Insert data into Routes
INSERT INTO Routes (RouteID, Name, BusID) VALUES (1, 'Route 1', 1), (2, 'Route 2', 2);

-- Insert data into RouteTerminals
INSERT INTO RouteTerminals (RouteID, TerminalID, ArrivalTime, DepartureTime) VALUES
(1, 1, '09:30:00', '09:45:00'), (1, 2, '10:00:00', '10:15:00');

--============================================================
--Exercise 2

create procedure UpdateOrInsertTerminal
@RouteID int,
@TerminalID int,
@ArrivalTime time,
@DepartureTime time
as
    begin
        if exists(select * from RouteTerminals where RouteID = @RouteID and TerminalID = @TerminalID)
        begin
            update RouteTerminals
            set ArrivalTime = @ArrivalTime, DepartureTime = @DepartureTime
            where RouteID = @RouteID and TerminalID = @TerminalID;
        end
        else
        begin
            insert into RouteTerminals(RouteID, TerminalID, ArrivalTime, DepartureTime)
            values (@RouteID, @TerminalID, @ArrivalTime, @DepartureTime)
        end
end;

--============================================================
--Exercise 3


create function TerminalWithMultipleBuses (@SpecificTime time)
returns table
as
return (
        select TerminalID
        from RouteTerminals
        where ArrivalTime <= @SpecificTime and DepartureTime >= @SpecificTime
        group by TerminalID
        having count(*) > 1
    );


--============================================================
--Exercise 4

create view RoutesWithFewestTerminals as
select top 100 percent r.Name
-- select r.Name
from Routes r
join RouteTerminals rt on r.RouteID = rt.RouteID
group by r.Name
having count (rt.TerminalID) <= 4
-- order by count(rt.TerminalID);

select * from RoutesWithFewestTerminals;


--============================================================
--Exercise 5

select r.Name
from Routes r
join RouteTerminals rt on r.RouteID = rt.RouteID
group by r.name
having count(distinct rt.TerminalID) = (select count(*) from Terminals);


--============================================================
--Exercise 6

select t.Name
from Terminals T
join RouteTerminals rt on t.TerminalID = rt.TerminalID
group by t.Name
order by max(datediff(minute, rt.ArrivalTime, rt.DepartureTime)) desc;


--============================================================
--Exercise 7

create trigger RestrictTimeOnRouteTerminals
on RouteTerminals
after insert, update
as
begin
    if exists(select * from inserted where ArrivalTime between '01:00:00' and '04:00:00' or
                                           DepartureTime between '01:00:00' and '04:00:00')
    begin
        raiserror('Arrival and departure times cannot be between 1 am and 4 am', 16, 1);
        rollback transaction;
    end
end;