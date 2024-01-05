create database Practic3;

use Practic3;

create schema dbo;

drop table Resorts;
drop table huts;

--============================================================
--Exercise 1

create table Resorts (
    ResortID int primary key identity (1,1),
    Name varchar(255) not null,
    NumberOfStart int,
    Rating int
);

create table Huts(
    HutID int primary key identity (1,1),
    Name varchar(255) not null,
    NumberOfPlaces int,
    PricePerNight int,
    ResortID int foreign key references Resorts(ResortID)
);

create table Customers(
    CustomerID int primary key identity (1,1),
    Name varchar(255) not null,
    Birthdate date,
    CountryOfOrigin varchar(255)
);


create table ActivityCategories(
    CategoryID int primary key identity (1,1),
    Name varchar(255) not null
);

create table Activity(
    ActivityID int primary key identity(1,1),
    Name varchar(255) not null,
    Description varchar(255),
    Price int,
    CategoryID int foreign key references ActivityCategories(CategoryID)
);

create table CustomerHuts (
    CustomerID int foreign key references Customers(CustomerID),
    HutID int foreign key references Huts(HutID),
    ArrivalDate date,
    NumberOfNights int
);

create table CustomerActivities(
    CustomerID int foreign key references Customers(CustomerID),
    ActivityID int foreign key references Activity(ActivityID),
    DateAndTime DATETIME
);

INSERT INTO Resorts (Name, NumberOfStart, Rating) VALUES
('Alpine Paradise', 5, 4),
('Sunny Beach Resort', 4, 4),
('Forest Retreat', 3, 4);


INSERT INTO Huts (ResortID, Name, NumberOfPlaces, PricePerNight) VALUES
(1, 'Alpine Lodge', 5, 150),
(1, 'Mountain View', 4, 120),
(2, 'Beachfront Bungalow', 3, 200),
(3, 'Forest Cabin', 2, 100);

INSERT INTO Customers (Name, BirthDate, CountryOfOrigin) VALUES
('John Doe', '1985-06-15', 'USA'),
('Alice Smith', '1990-12-22', 'UK'),
('Maria Garcia', '1978-03-05', 'Spain');


INSERT INTO ActivityCategories (Name) VALUES
('Sport'),
('Relaxation'),
('Adventure');


INSERT INTO Activity (Name, Description, Price, CategoryID) VALUES
('Skiing', 'Downhill skiing on snowy slopes', 50, 1),
('Yoga', 'Relaxing yoga sessions by the beach', 30, 2),
('Hiking', 'Guided hiking tours in the mountains', 40, 3);


INSERT INTO CustomerHuts (CustomerID, HutID, ArrivalDate, NumberOfNights) VALUES
(1, 1, '2024-01-10', 5),
(2, 2, '2024-01-12', 3),
(3, 3, '2024-01-15', 4);


INSERT INTO CustomerActivities (CustomerID, ActivityID, DateAndTime) VALUES
(1, 1, '2024-01-11 10:00:00'),
(1, 3, '2024-01-12 09:00:00'),
(2, 2, '2024-01-13 08:00:00'),
(3, 3, '2024-01-16 09:30:00');


--============================================================
--Exercise 2

select AVG(PricePerNight) as AveragePrice
from Huts
where NumberOfPlaces >= 3;


--============================================================
--Exercise 3

create view FiveStarResorts as
select
    r.Name,
    count(cs.CustomerID) as NumberOfCustomers
from Resorts r
join Huts h on r.ResortID = h.ResortID
join CustomerHuts cs on h.HutID = cs.HutID
where r.NumberOfStart = 5
group by r.Name

select * from FiveStarResorts
order by NumberOfCustomers desc;


--============================================================
--Exercise 4

select c.Name, c.Birthdate, c.CountryOfOrigin
from Customers c
join CustomerActivities ca on c.CustomerID = ca.CustomerID
join Activity a on a.ActivityID = ca.ActivityID
join ActivityCategories ac on a.CategoryID = ac.CategoryID
where ac.Name = 'Sport'
  and c.CustomerID not in (
      select c2.CustomerID
      from Customers c2
      join CustomerActivities ca2 on c2.CustomerID = ca2.CustomerID
      join Activity a2 on ca2.ActivityID = a2.ActivityID
      join ActivityCategories ac2 on a2.CategoryID = ac2.CategoryID
      where ac2.Name = 'Entspannung'
    );