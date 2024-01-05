create database Practic2;

use Practic2;

create schema dbo;

CREATE TABLE Singers (
    SingerID INT PRIMARY KEY IDENTITY (1, 1),
    Name VARCHAR(255) NOT NULL,
    Popularity INT
);

CREATE TABLE Songs (
    SongID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(255) NOT NULL,
    DurationMinutes INT
);


CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY IDENTITY (1, 1),
    AlbumTitle VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    SingerID INT FOREIGN KEY REFERENCES Singers(SingerID)
);

CREATE TABLE MusicVideos(
    VideoID INT PRIMARY KEY IDENTITY(1, 1),
    VideoTitle VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    SongID INT FOREIGN KEY REFERENCES Songs(SongID)
);

CREATE TABLE Concerts(
    ConcertID INT PRIMARY KEY IDENTITY(1,1),
    Venue VARCHAR(255) NOT NULL,
    ConcertDate DATE,
    ConcertTime TIME,
    SingerID INT FOREIGN KEY REFERENCES Singers(SingerID)
);

CREATE TABLE Collaborators(
    SingerID INT FOREIGN KEY REFERENCES Singers(SingerID),
    SongID INT FOREIGN KEY REFERENCES Songs(SongID),
    PRIMARY KEY(SingerID, SongID)
);

CREATE TABLE RecordLabels (
    LabelID INT PRIMARY KEY IDENTITY(1,1),
    LabelName VARCHAR(255) NOT NULL,
    Rating INT
);

CREATE TABLE AlbumRecordLabels(
    AlbumID INT FOREIGN KEY REFERENCES Albums(AlbumID),
    LabelID INT FOREIGN KEY REFERENCES RecordLabels(LabelID),
    PRIMARY KEY(AlbumID, LabelID)
);

--============================================================
--Exercise 1

INSERT INTO Singers(Name, Popularity) VALUES ('Rammstein', 90), ('Jazzrausch', 80), ('Adele', 95);
INSERT INTO Songs(Title, DurationMinutes) VALUES ('Du Hast', 4), ('Sonne', 5), ('Rolling in the Deep', 4);
INSERT INTO Albums(AlbumTitle, ReleaseDate, SingerID) VALUES ('Mutter', '2001-04-02', 1), ('Jazzrausch', '2019-09-15', 2), ('21', '2011-01-19', 3);
INSERT INTO MusicVideos(VideoTitle, ReleaseDate, SongID) VALUES ('Du Hast (Music Video)', '2001-03-30', 1), ('Sonne (Music Video)', '2001-02-13', 2);
INSERT INTO Collaborators(SingerID, SongID) VALUES (1, 1), (1, 2), (3,3);
INSERT INTO Concerts(Venue, ConcertDate, ConcertTime, SingerID)
VALUES
    ('Stadium A', '2024-01-10', '19:00', 1),
    ('Club A', '2024-02-15', '20:30', 2),
    ('Arena C', '2024-03-20', '18:45', 1);

INSERT INTO RecordLabels(LabelName, Rating) VALUES ('Label X', 4), ('Label Y', 3);
INSERT INTO AlbumRecordLabels(ALBUMID, LABELID) VALUES (1, 1), (2, 2), (3, 1);



SELECT * FROM Singers;

--============================================================
--Exercise 2

CREATE VIEW AlbumDuration AS
    SELECT a.AlbumTitle, SUM(s.DurationMinutes) as TotalDurationMinutes
    FROM Albums a
    JOIN Collaborators c ON c.SingerID = a.SingerID
    JOIN Songs s on c.SongID = s.SongID
    GROUP BY a.AlbumTitle;

SELECT * FROM AlbumDuration;


--============================================================
--Exercise 3

SELECT c.ConcertID, c.Venue, c.ConcertDate, c.ConcertTime
FROM Concerts c
JOIN Singers s on c.SingerID = s.SingerID
WHERE s.Name = 'Rammstein'
AND c.ConcertID NOT IN (
    SELECT c2.ConcertID
    FROM Concerts c2
    JOIN Singers s2 on s2.SingerID = c2.SingerID
    WHERE s2.Name = 'Jazzrausch'
    );


--============================================================
--Exercise 4

WITH SingerCount AS (
    SELECT c.ConcertID, COUNT(*) as NumberOfSingers
    FROM Concerts c
    GROUP BY c.ConcertID
)
SELECT c.ConcertID, c.Venue, c.ConcertDate, c.ConcertTime
FROM Concerts c
JOIN SingerCount sc ON c.ConcertID = sc.ConcertID
WHERE sc.NumberOfSingers = (SELECT MIN(NumberOfSingers) FROM SingerCount);