create database Practic4;

use Practic4;

create schema dbo;

--============================================================
--Exercise 1

create table ShowCategories(
    CategoryID int primary key identity(1,1),
    CategoryName nvarchar(255) not null
);

create table TVShows(
    ShowID int primary key identity(1,1),
    Rating int,
    CategoryID int foreign key references ShowCategories(CategoryID)
);

alter table TVShows add Name nvarchar(255);
create table Actors(
    ActorID int primary key identity(1,1),
    Name nvarchar(255) not null
);

create table ShowActors(
    ActorID int foreign key references Actors(ActorID),
    ShowID int foreign key references TVShows(ShowID),
    primary key (ShowID, ActorID)
);

create table TVSubscriptions(
    SubscriptionID int primary key identity (1,1),
    Type nvarchar(255) not null,
    Price int
);

create table Viewers(
    ViewerID int primary key identity(1, 1),
    Name nvarchar(255) not null,
    SubscriptionID int foreign key references TVSubscriptions(SubscriptionID)
);

create table ViewerShowHistory(
    ViewerID int foreign key references Viewers(ViewerID),
    ShowID int foreign key references TVShows(ShowID),
    WatchDate DATETIME,
    PRIMARY KEY(ViewerID, ShowID, WatchDate)
);


SELECT * FROM TVShows;
SELECT * FROM Actors;
SELECT * FROM ShowActors;
-- Inserting into ShowCategories
INSERT INTO ShowCategories VALUES ('Comedy');
INSERT INTO ShowCategories VALUES ('Drama');
INSERT INTO ShowCategories VALUES ('Education');

-- Inserting into TVShows
INSERT INTO TVShows VALUES (8, 1,'Funny Times');
INSERT INTO TVShows VALUES (9, 2,'Serious Matters');
INSERT INTO TVShows VALUES (7, 1,'Next Star');
INSERT INTO TVShows VALUES (8, 3,'Financial Education');
INSERT INTO TVShows VALUES (7, 2,'Megastar');

-- Inserting into Actors
INSERT INTO Actors VALUES ('John Doe');
INSERT INTO Actors VALUES ('Jane Smith');
INSERT INTO Actors VALUES ('Alice Johnson');

-- Inserting into ShowActors
INSERT INTO ShowActors VALUES (1, 7);
INSERT INTO ShowActors VALUES (2, 7);
INSERT INTO ShowActors VALUES (3, 8);
INSERT INTO ShowActors VALUES (2, 9);

-- Inserting into TVSubscriptions
INSERT INTO TVSubscriptions VALUES ('Basic', 10.00);
INSERT INTO TVSubscriptions VALUES ('Premium', 20.00);
INSERT INTO TVSubscriptions VALUES ('Gold', 30.00);

-- Inserting into Viewers
INSERT INTO Viewers VALUES ('Mike', 1);
INSERT INTO Viewers VALUES ('Laura', 2);
INSERT INTO Viewers VALUES ('Robert', 3);
INSERT INTO Viewers VALUES ('Emily', 1);

-- Inserting into ViewerShowHistory
INSERT INTO ViewerShowHistory VALUES (1, 7, '2023-01-01 20:00:00');
INSERT INTO ViewerShowHistory VALUES (2, 8, '2023-01-02 21:00:00');
INSERT INTO ViewerShowHistory VALUES (3, 9, '2023-01-03 19:00:00');
INSERT INTO ViewerShowHistory VALUES (1, 8, '2023-01-04 20:00:00');
INSERT INTO ViewerShowHistory VALUES (4, 10, '2023-01-05 18:00:00');
INSERT INTO ViewerShowHistory VALUES (2, 7, '2023-01-06 20:00:00');


--============================================================
--Exercise 2

create view ViewersOfBothShow as
select v.Name
from Viewers v
JOIN ViewerShowHistory VSH on v.ViewerID = VSH.ViewerID
JOIN TVShows TS on VSH.ShowID = TS.ShowID
WHERE ts.Name in ('Next Star', 'Financial Education')
GROUP BY v.Name
HAVING COUNT(DISTINCT ts.Name) = 2;

select * from ViewersOfBothShow;


--============================================================
--Exercise 3

select ts.Name, COUNT(vsh.ViewerID) as ViewerCount
from TVShows ts
join ViewerShowHistory vsh on ts.ShowID = vsh.ShowID
group by ts.Name
HAVING COUNT(vsh.ViewerID) >
       (
           SELECT COUNT(*)
           from ViewerShowHistory
           where ShowID = (SELECT ShowID FROM TVShows where Name = 'Megastar')

           );

--============================================================
--Exercise 4

select ts.type, sum(ts.Price) as TotalAmount
from TVSubscriptions ts
join Viewers v on ts.SubscriptionID = v.SubscriptionID
group by ts.type
having count(v.ViewerID) >= 3;