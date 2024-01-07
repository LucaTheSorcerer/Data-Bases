create database TrainStation;

use TrainStation;

create schema dbo;

--============================================================
--Exercise 1

create table TrainTypes(
    TypeID int primary key,
    Description nvarchar(255)
);

create table Trains(
    TrainID int primary key,
    Name nvarchar(255),
    TypeID int foreign key references TrainTypes(TypeID)
);

create table Stations(
    StationID int primary key,
    Name nvarchar(255)
);

create table Routes(
    RouteID int primary key,
    Name nvarchar(255),
    TrainID int foreign key references Trains(TrainID)
);

create table RouteStations(
    RouteID int foreign key references Routes(RouteID),
    StationID int foreign key references Stations(StationID),
    ArrivalTime time,
    DepartureTime time,
    primary key (RouteID, StationID)

);


insert into TrainTypes(TypeID, Description) values
(1, 'Regio'),
(2, 'Inter-Regio'),
(3, 'Rapid'),
(4, 'Accelerat');

insert into Trains(TrainID, Name, TypeID) values
(1, 'Tren A', 1),
(2, 'Tren B', 2),
(3, 'Tren C', 3),
(4, 'Tren D', 4);

insert into Stations(StationID, Name) values
(1, 'Timisoara'),
(2, 'Arad'),
(3, 'Lipova'),
(4, 'Santana');

insert into Routes(RouteID, Name, TrainID) values
(1, 'Timisoara-Iasi', 2);


insert into RouteStations(RouteID, StationID, ArrivalTime, DepartureTime) values
(1, 1, '08:00:00', '09:00:00'),
(1, 2, '09:10:00', '10:30:00'),
(1, 3, '10:30:00', '11:00:00'),
(1, 4, '11:00:00', '12:30:00');


-- insert into RouteStations(RouteID, StationID, ArrivalTime, DepartureTime) values

select * from RouteStations;


--============================================================
--Exercise 2

create procedure UpdateOrAddStationToRoute
    @RouteID int,
    @StationID int,
    @NewArrivalTime time,
    @NewDepartureTime time
as
begin
    if exists(select 1 from RouteStations where RouteID=@RouteID and StationID=@StationID)
    begin
        update RouteStations
        set ArrivalTime=@NewArrivalTime, DepartureTime=@NewDepartureTime
        where RouteID=@RouteID and StationID=@StationID
    end
    else
    begin
        insert into RouteStations(RouteID, StationID, ArrivalTime, DepartureTime)
        values (@RouteID, @StationID, @NewArrivalTime, @NewDepartureTime)
    end
end;

exec UpdateOrAddStationToRoute @RouteID=1, @StationID=1, @NewArrivalTime = '07:00:00', @NewDepartureTime='07:30:00';




--============================================================
--Exercise 4

create or alter view RoutesWithFewestStation as
select top 100 percent r.Name
from Routes r
join RouteStations rs on r.RouteID = rs.RouteID
group by r.Name
having count(rs.StationID) <= 5;

select Name from RoutesWithFewestStation
order by (select count(*) from RouteStations where RouteID = (select RouteID from Routes where Name = RoutesWithFewestStation.Name)) asc;

