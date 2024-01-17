create database Practic18;

use Practic18;

--============================================================
--Exercise 1

create table Band(
    BandID int primary key,
    BandName varchar(255),
    BandScore int
);

create table Contestant(
    ContestantID int primary key,
    ContestantName varchar(255),
    ContestantAge varchar(255),
    BandID int foreign key references Band(BandID)
);

create table MusicGenre(
    MusicGenreID int primary key,
    MusicGenreName varchar(255)
);

create table Song(
    SongID int primary key,
    SongName varchar(255),
    OriginalBand varchar(255),
    MusicGenreID int foreign key references MusicGenre(MusicGenreID)
);

create table Instrument(
    InstrumentID int primary key,
    InstrumentName varchar(255)
);

create table ContestantInstrument(
    ContestantID int foreign key references Contestant(ContestantID),
    InstrumentID int foreign key references Instrument(InstrumentID),
    primary key (ContestantID, InstrumentID)
);

create table Stage(
    StageID int primary key
);

create table Duels(
    DuelID int primary key,
    Band1ID int foreign key references Band(BandID),
    Band2ID int foreign key references Band(BandID),
    WinnerID int foreign key references Band(BandID),
    StageID int foreign key references Stage(StageID),
    SongID int foreign key references Song(SongID)
);

insert into Band(BandID, BandName, BandScore) VALUES
(1, 'Band A', 95),
(2, 'Band B', 100),
(3, 'Band C', 80),
(4, 'Band D', 88);

insert into Contestant(ContestantID, ContestantName, ContestantAge, BandID) VALUES
(1, 'Mike Oxlong', 23, 1),
(2, 'Contestant A', 20, 2),
(3, 'Contestant B', 30, 3),
(4, 'Contestant C', 40, 4);

insert into MusicGenre(MusicGenreID, MusicGenreName) VALUES
(1, 'Rock'),
(2, 'Pop'),
(3, 'Funk');

insert into Song(SongID, SongName, OriginalBand, MusicGenreID) VALUES
(1, 'Its my life', 'Band X', 1),
(2, 'Song A', 'Band Y', 1),
(3, 'Song B', 'Band Z', 2),
(4, 'Song C', 'Band W', 3);

insert into Instrument(InstrumentID, InstrumentName) VALUES
(1, 'Guitar'),
(2, 'Keys'),
(3, 'Drums');

insert into ContestantInstrument(ContestantID, InstrumentID) VALUES
 (1, 1),
 (1, 2),
 (2, 2),
 (3, 3),
 (4, 1);

insert into Stage(StageID) values (1), (2), (3), (4);

insert into Duels(DuelID, Band1ID, Band2ID, WinnerID, StageID, SongID) VALUES
(1, 1, 2, 1, 1, 1),
(2, 2, 3, 3, 2, 2),
(3, 3, 4, 4, 3, 3),
(4, 2, 4, 2, 4, 4);

insert into Duels(DuelID, Band1ID, Band2ID, WinnerID, StageID, SongID) VALUES
(5, 2, 4, 2, 4, 4);



--============================================================
--Exercise 2

select b.BandID, b.BandName, BandScore
from Band b
where b.BandScore = (select max(BandScore) from Band)

--============================================================
--Exercise 3

select s.SongID, s.SongName, count(d.SongID) as TotalCount
from Song s
join Duels D on s.SongID = D.SongID
group by s.SongID, s.SongName
having count(d.SongID) > (select count(d2.SongID) as TotalCount
                          from Song s
                          join Duels D2 on s.SongID = D2.SongID
                          where s.SongName = 'Its my life'
                          )



--============================================================
--Exercise 4

create or alter view ContestantsWith
as
    select distinct c.ContestantID, c.ContestantName, c.ContestantAge
    from Contestant c
    join Band B on B.BandID = c.BandID
    join Duels D on B.BandID = D.WinnerID
    where b.BandScore > 10

select * from ContestantsWith;
