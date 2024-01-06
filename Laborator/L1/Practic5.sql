create database Practic5;
use Practic5;
create schema dbo;

--============================================================
--Exercise 1

create table Bands(
    BandID int primary key,
    Name nvarchar(255),
    Score int
);

create table Contestants(
    ContestantID int primary key,
    Name nvarchar(255),
    Age int,
    BandID int foreign key references Bands(BandID)
);

create table MusicGenres(
    MusicGenreID int primary key,
    Name nvarchar(255)
);

create table Songs(
    SongID int primary key,
    Title nvarchar(255),
    OriginalBandName nvarchar(100),
    GenreID int foreign key references MusicGenres(MusicGenreID)
);

create table Instruments(
    InstrumentID int primary key,
    Name nvarchar(100)
);

create table ContestantInstruments(
    ContestantID int foreign key references Contestants(ContestantID),
    InstrumentID int foreign key references Instruments(InstrumentID)
);

create table Duels(
    DuelID int primary key,
    StageNumber int,
    SongID int foreign key references Songs(SongID),
    Band1ID int foreign key references Bands(BandID),
    Band2ID int foreign key references Bands(BandID),
    WinningBandID int foreign key references Bands(BandID)
);

insert into MusicGenres (MusicGenreID, Name) values (1, 'Rock');
insert into MusicGenres (MusicGenreID, Name) values (2, 'Pop');
insert into MusicGenres (MusicGenreID, Name) values (3, 'Jazz');

insert into Bands (BandID, Name, Score) values (1, 'The Rockers', 15);
insert into Bands (BandID, Name, Score) values (2, 'Pop Stars', 12);
insert into Bands (BandID, Name, Score) values (3, 'Jazz Masters', 20);

insert into Songs (SongID, Title, OriginalBandName, GenreID) values (1, 'It''s my life', 'The Rockers', 1);
insert into Songs (SongID, Title, OriginalBandName, GenreID) values (2, 'Pop Anthem', 'Pop Stars', 2);
insert into Songs (SongID, Title, OriginalBandName, GenreID) values (3, 'Jazz Blues', 'Jazz Masters', 3);


insert into Instruments(InstrumentID, Name) values (1, 'Guitar');
insert into Instruments(InstrumentID, Name) values (2, 'Drums');
insert into Instruments(InstrumentID, Name) values (3, 'Piano');

INSERT INTO Contestants (ContestantID, Name, Age, BandID) VALUES (1, 'John Doe', 25, 1);
INSERT INTO Contestants (ContestantID, Name, Age, BandID) VALUES (2, 'Jane Smith', 22, 2);
INSERT INTO Contestants (ContestantID, Name, Age, BandID) VALUES (3, 'Alice Jones', 30, 3);

INSERT INTO ContestantInstruments (ContestantID, InstrumentID) VALUES (1, 1);
INSERT INTO ContestantInstruments (ContestantID, InstrumentID) VALUES (2, 2);
INSERT INTO ContestantInstruments (ContestantID, InstrumentID) VALUES (3, 3);

INSERT INTO Duels (DuelID, StageNumber, SongID, Band1ID, Band2ID, WinningBandID) VALUES (1, 1, 1, 1, 2, 1);
INSERT INTO Duels (DuelID, StageNumber, SongID, Band1ID, Band2ID, WinningBandID) VALUES (2, 1, 2, 2, 3, 3);
INSERT INTO Duels (DuelID, StageNumber, SongID, Band1ID, Band2ID, WinningBandID) VALUES (3, 2, 1, 1, 3, 3);
INSERT INTO Duels (DuelID, StageNumber, SongID, Band1ID, Band2ID, WinningBandID) VALUES (4, 2, 3, 2, 3, 3);

--============================================================
--Exercise 2

Select Name, Score
From Bands
where Score = (Select max(Score) from Bands);

--============================================================
--Exercise 3

select S.Title, COUNT(*) as TimePlayed
from Duels D
join Songs s on d.SongID = s.SongID
group by s.Title
having count(*) > (select count(*) from Duels where SongID = (select SongID from Songs where Title = 'It''s my life'));


--============================================================
--Exercise 4

create view V_ContestantsInWinningBands as
select C.Name, C.Age
from Contestants C
join Bands B on C.BandID = B.BandID
where B.Score > 10 and B.BandID in (select WinningBandID from duels);

Select * from V_ContestantsInWinningBands;