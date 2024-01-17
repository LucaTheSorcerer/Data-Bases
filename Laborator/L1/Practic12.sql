create database Practic12;

use Practic12;

--============================================================
--Exercise 1
create table ShowCategory(
    ShowCategoryID int primary key,
    CategoryName varchar(255)
);

create table TVShow(
    TVShowID int primary key,
    ShowName varchar(255),
    ShowRating int,
    ShowCategoryID int foreign key references ShowCategory(ShowCategoryID)
);

create table Actor(
    ActorID int primary key,
    ActorName varchar(255)
);

create table TVShowActors(
    TVShowID int foreign key references TVShow(TVShowID),
    ActorID int foreign key references Actor(ActorID),
    primary key(TVShowID, ActorID)
);

create table TVSubscriptions(
    SubscriptionID int primary key,
    SubscriptionType varchar(255),
    SubscriptionPrice int
);

create table Viewer(
    ViewerID int primary key,
    ViewerName varchar(255),
    SubscriptionID int foreign key references TVSubscriptions(SubscriptionID)
);

create table TVShowViewer(
    ViewerID int foreign key references Viewer(ViewerID),
    TVShowID int foreign key references TVShow(TVShowID),
    WatchDate datetime,
    primary key (ViewerID, TVShowID, WatchDate)
);


-- Inserting data into ShowCategory
INSERT INTO ShowCategory VALUES (1, 'Reality Show');
INSERT INTO ShowCategory VALUES (2, 'Educational');
INSERT INTO ShowCategory VALUES (3, 'Drama');
INSERT INTO ShowCategory VALUES (4, 'Comedy');
INSERT INTO ShowCategory VALUES (5, 'Thriller');

-- Inserting data into TVShow
INSERT INTO TVShow VALUES (1, 'Next Star', 8, 1);
INSERT INTO TVShow VALUES (2, 'Financial Education', 9, 2);
INSERT INTO TVShow VALUES (3, 'Megastar', 7, 1);
INSERT INTO TVShow VALUES (4, 'History Unveiled', 8, 2);
INSERT INTO TVShow VALUES (5, 'Mystery of Space', 9, 5);

-- Inserting data into Actor
INSERT INTO Actor VALUES (1, 'John Doe');
INSERT INTO Actor VALUES (2, 'Jane Smith');
INSERT INTO Actor VALUES (3, 'Emily Stone');
INSERT INTO Actor VALUES (4, 'Mark Twain');
INSERT INTO Actor VALUES (5, 'Sophia Turner');

-- Inserting data into TVShowActors
INSERT INTO TVShowActors VALUES (1, 1);
INSERT INTO TVShowActors VALUES (2, 2);
INSERT INTO TVShowActors VALUES (3, 3);
INSERT INTO TVShowActors VALUES (4, 4);
INSERT INTO TVShowActors VALUES (5, 5);

-- Inserting data into TVSubscriptions
INSERT INTO TVSubscriptions VALUES (1, 'Basic', 10);
INSERT INTO TVSubscriptions VALUES (2, 'Premium', 20);
INSERT INTO TVSubscriptions VALUES (3, 'Deluxe', 30);
INSERT INTO TVSubscriptions VALUES (4, 'Standard', 15);
INSERT INTO TVSubscriptions VALUES (5, 'Gold', 25);

-- Inserting data into Viewer
INSERT INTO Viewer VALUES (1, 'Alice', 1);
INSERT INTO Viewer VALUES (2, 'Bob', 1);
INSERT INTO Viewer VALUES (3, 'Charlie', 1);
INSERT INTO Viewer VALUES (4, 'David', 4);
INSERT INTO Viewer VALUES (5, 'Eva', 5);

-- Inserting data into TVShowViewer
-- Ensuring some viewers watch both 'Next Star' and 'Financial Education'
INSERT INTO TVShowViewer VALUES (1, 1, '2024-01-10'); -- Next Star
INSERT INTO TVShowViewer VALUES (1, 2, '2024-01-12'); -- Financial Education
INSERT INTO TVShowViewer VALUES (2, 1, '2024-01-11'); -- Next Star
INSERT INTO TVShowViewer VALUES (2, 2, '2024-01-13'); -- Financial Education
INSERT INTO TVShowViewer VALUES (3, 1, '2024-01-14'); -- Next Star
-- Additional data to meet other conditions
INSERT INTO TVShowViewer VALUES (4, 3, '2024-01-15'); -- Megastar
INSERT INTO TVShowViewer VALUES (5, 3, '2024-01-16'); -- Megastar
INSERT INTO TVShowViewer VALUES (3, 4, '2024-01-17'); -- History Unveiled
INSERT INTO TVShowViewer VALUES (4, 5, '2024-01-18'); -- Mystery of Space
INSERT INTO TVShowViewer VALUES (5, 2, '2024-01-19'); -- Financial Education


--============================================================
--Exercise 2

create or alter view ViewerName
as
    select V.ViewerID, V.ViewerName
    from Viewer V
    join TVShowViewer TSV on V.ViewerID = TSV.ViewerID
    join TVShow TS on TSV.TVShowID = TS.TVShowID
    where TS.ShowName = 'Next Star'

    intersect

    select V.ViewerID, V.ViewerName
    from Viewer V
    join TVShowViewer TSV on V.ViewerID = TSV.ViewerID
    join TVShow TS on TSV.TVShowID = TS.TVShowID
    where TS.ShowName = 'Financial Education'


select * from ViewerName;

--============================================================
--Exercise 3

select TS.TVShowID ,TS.ShowName, count(TSV.TVShowID) as TotalNumberOfViews
from TVShow TS
join TVShowViewer TSV on TS.TVShowID = TSV.TVShowID
group by TS.TVShowID, TS.ShowName
having count(TSV.TVShowID) > (
    select count(TSV2.TVShowID)
    from TVShowViewer TSV2
    join TVShow TV2 on TSV2.TVShowID = TV2.TVShowID
    where TV2.ShowName = 'Megastar'
    )


--============================================================
--Exercise 4
select TVSub.SubscriptionType, sum(TVSub.SubscriptionPrice)
from TVSubscriptions TVSub
join Viewer V on TVSub.SubscriptionID = V.SubscriptionID
group by TVSub.SubscriptionType
having count(V.ViewerID) >= 3;

