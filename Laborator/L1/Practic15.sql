create database Practic15;

use Practic15;

--============================================================
--Exercise 1

drop table Song;

drop table SingerSong;
drop table MusicVideo;
create table Song(
    SongID int primary key,
    SongName nvarchar(255),
    SongDuration int,
    AlbumID int foreign key references Album(AlbumID)
);

create table Singer(
    SingerID int primary key,
    SingerName nvarchar(255),
    SingerPopularity int
);


create table SingerSong(
    SingerID int foreign key references Singer(SingerID),
    SongID int foreign key references Song(SongID),
    primary key (SingerID, SongID)
);

create table Label(
    LabelID int primary key,
    LabelName nvarchar(255),
    Rating int
);

create table Album(
    AlbumID int primary key,
    AlbumName nvarchar(255),
    ReleaseDate date,
    LabelID int foreign key references Label(LabelID)
);


create table MusicVideo(
    MusicVideoID int primary key,
    Title nvarchar(100),
    ReleaseDate date,
    SongID int foreign key references Song(SongID)
);

create table Concert(
    ConcertID int primary key,
    Date date,
    Location nvarchar(100)
);

create table SingerConcert(
    SingerID int foreign key references Singer(SingerID),
    ConcertID int foreign key references Concert(ConcertID),
    primary key (SingerID, ConcertID)
);



INSERT INTO Label (LabelId, LabelName, Rating) VALUES (1, 'Epic Tunes', 5);
INSERT INTO Label (LabelId, LabelName, Rating) VALUES (2, 'Groove Galaxy', 4);
INSERT INTO Label (LabelId, LabelName, Rating) VALUES (3, 'Harmonic Horizons', 3);
INSERT INTO Album (AlbumId, AlbumName, ReleaseDate, LabelId) VALUES (1, 'Journey Through Sound', '2023-07-15', 1);
INSERT INTO Album (AlbumId, AlbumName, ReleaseDate, LabelId) VALUES (2, 'Rhythmic Roads', '2024-01-20', 2);
INSERT INTO Song (SongId, SongName, SongDuration, AlbumId) VALUES (1, 'Melodic Voyage', 210, 1);
INSERT INTO Song (SongId, SongName, SongDuration, AlbumId) VALUES (2, 'Echoes of the Universe', 180, 1);
INSERT INTO Song (SongId, SongName, SongDuration, AlbumId) VALUES (3, 'Groove of the Galaxy', 200, 2);
INSERT INTO Singer (SingerId, SingerName, SingerPopularity) VALUES (1, 'Rammstein', 500000);
INSERT INTO Singer (SingerId, SingerName, SingerPopularity) VALUES (2, 'Jazzrausch', 300000);
INSERT INTO SingerSong (SingerId, SongId) VALUES (1, 1);
INSERT INTO SingerSong (SingerId, SongId) VALUES (2, 2);
INSERT INTO SingerSong (SingerId, SongId) VALUES (1, 3);
INSERT INTO MusicVideo (MusicVideoId, Title, ReleaseDate, SongId) VALUES (1, 'Voyage Visuals', '2023-08-05', 1);
INSERT INTO MusicVideo (MusicVideoId, Title, ReleaseDate, SongId) VALUES (2, 'Echoes in Space', '2024-02-10', 2);
INSERT INTO Concert (ConcertId, Date, Location) VALUES (1, '2024-05-30', 'Madison Square Garden');
INSERT INTO Concert (ConcertId, Date, Location) VALUES (2, '2024-06-15', 'The O2 Arena');
INSERT INTO SingerConcert (SingerId, ConcertId) VALUES (1, 1);
INSERT INTO SingerConcert (SingerId, ConcertId) VALUES (2, 2);
INSERT INTO SingerConcert (SingerId, ConcertId) VALUES (1, 2);


--============================================================
--Exercise 2

create or alter view AlbumWithDuration
as
    select a.AlbumID, a.AlbumName, sum(s.SongDuration) as TotalDuration
    from Album a
    join Song s on a.AlbumID = s.AlbumID
    group by a.AlbumID, a.AlbumName

select * from AlbumWithDuration;


--============================================================
--Exercise 3

select c.ConcertID, c.Location, c.Date
from Concert c
join SingerConcert sc on c.ConcertID = sc.ConcertID
join Singer s on sc.SingerID = s.SingerID
where s.SingerName = 'Rammstein'

except


select c.ConcertID, c.Location, c.Date
from Concert c
join SingerConcert sc on c.ConcertID = sc.ConcertID
join Singer s on sc.SingerID = s.SingerID
where s.SingerName = 'Jazzrausch'


--============================================================
--Exercise 4

select c.ConcertID, c.Location, c.Date, count(s.SingerID) as minimum
from Concert c
join SingerConcert sc on c.ConcertID = sc.ConcertID
join Singer s on sc.SingerID = s.SingerID
group by c.ConcertID, c.Location, c.Date
having count(s.SingerID) = (
                            select min(minimum)
                            from (
                                select(sc.SingerID) as minimum
                                from SingerConcert sc
                                group by sc.SingerID

                                 ) as subquery
                            );

select top 1 with ties c.ConcertID, c.Location, c.Date, count(sc.SingerID) as TotalSingers
from Concert c
join SingerConcert SC on c.ConcertID = SC.ConcertID
group by c.ConcertID, c.Location, c.Date
order by count(sc.SingerID) asc;