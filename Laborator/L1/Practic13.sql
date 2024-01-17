create database Practic13;

use Practic13;

--============================================================
--Exercise 1

create table TrainType(
    TrainTypeID int primary key,
    TrainType nvarchar(255)
);

create table Train(
    TrainID int primary key,
    TrainName nvarchar(255),
    TrainTypeID int foreign key references TrainType(TrainTypeID)
);

create table Station(
    StationID int primary key,
    StationName nvarchar(255)
);


create table Route(
    RouteID int primary key,
    RouteName varchar(255),
    TrainID int foreign key references Train(TrainID)
);

create table RouteStation(
    RouteID int foreign key references Route(RouteID),
    StationID int foreign key references Station(StationID),
    ArrivalTime time,
    DepartureTime time,
    primary key(RouteID, StationID)
);


insert into TrainType(TrainTypeID, TrainType) values
(1, 'Rapid'),
(2, 'Regio'),
(3, 'Inter-Regio'),
(4, 'Accelerat');

insert into Train(TrainID, TrainName, TrainTypeID) values
(1, 'IR-123', 3),
(2, 'R-456', 2),
(3, 'Rapid-789', 1),
(4, 'A-765', 4);


insert into Station(StationID, StationName) values
(1, 'Timisoara'),
(2, 'Arad'),
(3, 'Santana'),
(4, 'Lipova'),
(5, 'Oradea');

insert into Route(RouteID, RouteName, TrainID) values
(1, 'Timisoara-Arad',1),
(2, 'Arad-Cluj', 2),
(3, 'Timisoara-Iasi', 3),
(4, 'Arad-Bucuresti', 4);

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) values
(1, 1, '08:00:00', '08:30:00'),
(2, 1, '08:30:00', '10:00:00'),
(2, 2, '08:00:00', '08:45:00'),
(2, 3, '09:00:00', '11:30:00'),
(2, 4, '12:00:00', '12:30:00'),
(2, 5, '13:00:00', '14:00:00'),
(3, 2, '08:00:00', '09:00:00'),
(3, 3, '09:00:00', '09:45:00'),
(4, 1, '10:00:00', '10:30:00'),
(4, 2, '10:30:00', '11:00:00'),
(4, 3, '08:00:00', '08:30:00');

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) values
(3, 1, '07:00:00', '08:00:00');



--============================================================
--Exercise 2

create or alter procedure UpdateRoute
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

exec UpdateRoute @RouteID = 1, @StationID = 1, @ArrivalTime = '07:00:00', @DepartureTime = '08:00:00';

select * from RouteStation;


--============================================================
--Exercise 3

create or alter function GetStationWithMoreThanOneTrain(@SpecificTime time)
returns table
as return (
        select s.StationName, count(distinct r.TrainID) as TotalTrains
        from Station s
        join RouteStation rs on s.StationID = rs.StationID
        join Route r on rs.RouteID = r.RouteID
        where @SpecificTime >= rs.ArrivalTime and @SpecificTime <= rs.DepartureTime
        group by s.StationName
        having count(distinct r.TrainID) > 1
    )

select * from GetStationWithMoreThanOneTrain('07:30:00');

--============================================================
--Exercise 4

create or alter view GetRoutesWithFewestTrains
as
    select r.RouteID, r.RouteName, count(rs.StationID) as StationCount
    from Route r
    join RouteStation rs on r.RouteID = rs.RouteID
    join Station s on rs.StationID = s.StationID
    group by r.RouteID, r.RouteName
    having count(rs.StationID) = (
            select min(StationCount)
            from(
                select count(rs.StationID) as StationCount
                from RouteStation rs
                group by rs.RouteID
                having count(rs.StationID) <= 5
                ) as subquery

        )

select * from GetRoutesWithFewestTrains;


--============================================================
--Exercise 5

select r.RouteID ,r.RouteName, count(rs.StationID) as TotalStations
from Route r
join RouteStation rs on r.RouteID = rs.RouteID
group by r.RouteID, r.RouteName
having count(distinct rs.StationID) = (
    select count(s.StationID) as TotalStations
    from Station s
    )


--============================================================
--Exercise 6

select s.StationID, s.StationName
from Station s
join RouteStation rs on s.StationID = rs.StationID
where DATEDIFF(minute, rs.ArrivalTime, rs.DepartureTime) = (
    select max(datediff(minute, rs.ArrivalTime, rs.DepartureTime))
    from RouteStation rs
    );


--============================================================
--Exercise 7

create or alter trigger TrainRules on RouteStation
after insert
as
    begin
        if exists(select * from inserted where (ArrivalTime between '03:00:00' and '05:00:00')
                                                or (DepartureTime between '03:00:00' and '05:00:00'))
        begin
            raiserror ('Time cant be between 3 and 5 am', 16, 2);
            rollback transaction;
        end
end

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) values
(3, 4, '09:00:00', '05:00:00');