create database Practic14;

use Practic14;

--============================================================
--Exercise 1

create table Resorts(
    ResortID int primary key,
    ResortName nvarchar(255),
    Stars int,
    Rating int
);

create table Huts(
    HutID int primary key,
    HutName nvarchar(255),
    NumberOfPlaces int,
    PricePerNight int,
    ResortID int foreign key references Resorts(ResortID)
);

create table Customer(
    CustomerID int primary key,
    CustomerName nvarchar(255),
    Birthdate date,
    CountryOfOrigin nvarchar(255)
);

create table ActivityCategory(
    CategoryID int primary key,
    ActivityType nvarchar(255)
);

create table Activity(
    ActivityID int primary key,
    ActivityName nvarchar(255),
    ActivityDescription nvarchar(max),
    ActivityPrice int,
    CategoryID int foreign key references ActivityCategory(CategoryID)
);

create table CustomerHut(
    CustomerID int foreign key references Customer(CustomerID),
    HutID int foreign key references Huts(HutID),
    ArrivalDate date,
    NumberOfNights int,
);

create table CustomerActivity(
    CustomerID int foreign key references Customer(CustomerID),
    ActivityID int foreign key references Activity(ActivityID),
    DateAndTime datetime
);

insert into Resorts(ResortID, ResortName, Stars, Rating) values
(1, 'Magic Resort', 5, 98),
(2, 'Super Resort', 5, 95),
(3, 'Galaxy Resort', 4, 88),
(4, 'Mega Resort', 3, 75),
(5, 'Empire Resort', 2, 90);

insert into Huts(HutID, HutName, NumberOfPlaces, PricePerNight, ResortID) values
(1, 'Hut 1', 5, 98, 1),
(2, 'Hut 2', 2, 88, 1),
(3, 'Hut 3', 3, 75, 2),
(4, 'Hut 4', 4, 55, 3),
(5, 'Hut 5', 8, 100,4),
(6, 'Hut 6', 1, 80, 5);

insert into Customer(CustomerID, CustomerName, Birthdate, CountryOfOrigin) values
(1, 'Mike Oxlong', '1985-01-01', 'USA'),
(2, 'Ben Dover', '1990-02-07', 'UK'),
(3, 'Ion Popescu', '1980-09-12', 'Romania'),
(4, 'Sheila Dower', '1970-12-12', 'USA'),
(5, 'Moe Lester', '2001-08-08', 'UK');

insert into ActivityCategory(CategoryID, ActivityType) VALUES
(1, 'Sport'),
(2, 'Relaxation'),
(3, 'Adventure');

insert into Activity(ActivityID, ActivityName, ActivityDescription, ActivityPrice, CategoryID) values
(1, 'Skiing', 'Ski with your friends', 100, 1),
(2, 'Yoga', 'Yoga with your friends', 95, 2),
(3, 'Hiking', 'Hike with your friends', 80, 3);

insert into CustomerHut(CustomerID, HutID, ArrivalDate, NumberOfNights) values
(1, 1, '2023-12-12', 5),
(2, 2, '2023-09-12', 2),
(3, 3, '2023-08-08', 3),
(4, 4, '2023-02-03', 8),
(5, 5, '2023-01-01', 1);

insert into CustomerActivity(CustomerID, ActivityID, DateAndTime) VALUES
(1, 1, '2024-01-11 10:00:00'),
(1, 3, '2024-01-12 09:00:00'),
(2, 2, '2024-01-13 08:00:00'),
(3, 3, '2024-01-16 09:30:00')


insert into CustomerActivity(CustomerID, ActivityID, DateAndTime) VALUES
(3, 1, '2024-02-16 09:45:00')


insert into CustomerActivity(CustomerID, ActivityID, DateAndTime) VALUES
(1, 2, '2024-02-16 09:45:00')


--============================================================
--Exercise 2

select avg(PricePerNight) as AveragePrice
from Huts
where NumberOfPlaces >= 3;

--============================================================
--Exercise 3

create or alter view FiveStarResorts
as
    select r.ResortID ,r.ResortName, count(ch.CustomerID) as TotalCustomers
    from Resorts r
    join Huts h on r.ResortID = h.ResortID
    join CustomerHut ch on ch.HutID = h.HutID
    where r.Stars = 5
    group by r.ResortID, r.ResortName;

select * from FiveStarResorts;

--============================================================
--Exercise 4

select c.CustomerID ,c.CustomerName, c.Birthdate, c.CountryOfOrigin
from Customer c
join CustomerActivity ca on c.CustomerID = ca.CustomerID
join Activity a on ca.ActivityID = a.ActivityID
join ActivityCategory ac on a.CategoryID = ac.CategoryID
where ac.ActivityType = 'Sport'
except
select c.CustomerID ,c.CustomerName, c.Birthdate, c.CountryOfOrigin
from Customer c
join CustomerActivity ca on c.CustomerID = ca.CustomerID
join Activity a on ca.ActivityID = a.ActivityID
join ActivityCategory ac on a.CategoryID = ac.CategoryID
where ac.ActivityType = 'Relaxation'