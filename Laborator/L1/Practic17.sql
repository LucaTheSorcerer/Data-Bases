create database Practic17;


use Practic17;

--============================================================
--Exercise 1
create table TrainType(
    TrainTypeID int primary key,
    TrainType varchar(255)
);

create table Train(
    TrainID int primary key,
    TrainName varchar(255),
    TrainTypeID int foreign key references TrainType(TrainTypeID)
);

create table Station(
    StationID int primary key,
    StationName varchar(255)
);

create table Route(
    RouteID int primary key,
    RouteName varchar(255),
    TrainID int foreign key references Train(TrainID)
);

create table RouteStation(
    RouteID int foreign key references Route(RouteID),
    StationID int foreign key references Station(StationID),
    DepartureTime time,
    ArrivalTime time,
    primary key(RouteID, StationID)
);

insert into TrainType(TrainTypeID, TrainType) values
(1, 'din ala rapid'),
(2, 'din ala vai mortii lui'),
(3, 'din ala merg studentii cu el');

insert into Train(trainid, trainname, traintypeid) VALUES
(1, 'Train A', 1),
(2, 'Train B', 2),
(3, 'Train D', 3);



insert into Station(StationID, StationName) VALUES
(1, 'Station A'),
(2, 'Station B'),
(3, 'Station C'),
(4, 'Station D');

insert into Route(RouteID, RouteName, TrainID) VALUES
(1, 'Route A-D', 1),
(2, 'Route A-B', 2),
(3, 'Route A-C', 3);

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(1, 1, '08:00:00', '09:00:00'),
(1, 2, '09:00:00', '09:30:00'),
(1, 3, '10:00:00', '10:30:00'),
(1, 4, '11:00:00', '12:00:00'),
(2, 1, '11:00:00', '12:00:00'),
(3, 2, '11:00:00', '12:00:00');

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(2, 2, '09:00:00', '11:00:00')

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
        insert into RouteStation(RouteID, StationID, DepartureTime, ArrivalTime)
        values(@RouteID, @StationID, @ArrivalTime, @DepartureTime);
    end
end


exec UpdateRoute @RouteID = 1, @StationID = 1, @ArrivalTime = '07:00:00', @DepartureTime = '08:30:00';

select * from RouteStation;

--============================================================
--Exercise 3
create or alter function ShowStations(@SpecificTime time)
returns table
as return (
            select s.StationID, s.StationName
            from Station s
            join RouteStation RS on s.StationID = RS.StationID
            join Route R2 on R2.RouteID = RS.RouteID
            join Train T on T.TrainID = R2.TrainID
            where @SpecificTime >= rs.ArrivalTime and @SpecificTime <= rs.DepartureTime
            group by s.StationID, s.StationName
            having count(t.TrainID) > 1

)

select * from ShowStations('09:10:00');


--============================================================
--Exercise 3

create or alter view ListRoutes
as
    select r.RouteID, r.RouteName
    from Route r
    join RouteStation RS2 on r.RouteID = RS2.RouteID
    group by r.RouteID, r.RouteName
    having count(rs2.StationID) = (
                                    select min(StationCounter) from (
                                        select count(rs.StationID) as StationCounter
                                        from RouteStation rs
                                        group by rs.StationID
                                                                   ) as subquery
        )

select * from ListRoutes;


--============================================================
--Exercise 5

select r.RouteID, r.RouteName
from Route r
join RouteStation RS3 on r.RouteID = RS3.RouteID
group by r.RouteID, r.RouteName
having count(rs3.StationID) = (select count(StationID) from Station)

--============================================================
--Exercise 6

select s.StationID, s.StationName
from Station s
join RouteStation RS4 on s.StationID = RS4.StationID
join Route R3 on RS4.RouteID = R3.RouteID
join Train T2 on R3.TrainID = T2.TrainID
where Datediff(minute, ArrivalTime, DepartureTime) = (select
                                                           max(DATEDIFF(minute, rs.ArrivalTime, rs.DepartureTime)) from RouteStation rs)

select top 1 with ties s.StationID, s.StationName, Datediff(minute, ArrivalTime, DepartureTime)
from Station s
join RouteStation RS4 on s.StationID = RS4.StationID
join Route R3 on RS4.RouteID = R3.RouteID
join Train T2 on R3.TrainID = T2.TrainID
group by s.StationID, s.StationName, Datediff(minute, ArrivalTime, DepartureTime)
order by Datediff(minute, ArrivalTime, DepartureTime) desc

--============================================================
--Exercise 7

create or alter trigger UpdateRule on RouteStation
after insert
as
    begin
        if exists(select * from inserted where (ArrivalTime between '03:00' and '05:00') or (DepartureTime between '03:00' and '05:00'))
        begin
            raiserror ('Cannot be bla bla', 16, 1);
            rollback transaction ;
        end
    end

insert into RouteStation(RouteID, StationID, ArrivalTime, DepartureTime) VALUES
(3, 4, '11:00:00', '20:00:00');