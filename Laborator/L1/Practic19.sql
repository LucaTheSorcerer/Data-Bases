create database Practic19;

use Practic19;

create table Concert(
    ConcertID int primary key,
    ConcertLocation nvarchar(255),
    DateAndTime datetime
);

create table Song(
    SongID int primary key,
    SongName varchar(255),
    Duration int
);

create table Singer(
    SingerID int primary key,
    SingerName varchar(255),
    SingerFollowers int,
    ConcertID int foreign key references Concert(ConcertID)
);

create table SongSinger(
    SongID int foreign key references Song(SongID),
    SingerID int foreign key references Singer(SingerID),
    primary key (SongID, SingerID)
);

create table Label(
    LabelID int primary key,
    LabelName varchar(255),
    LabelRating int
);

create table Album(
    AlbumID int primary key,
    AlbumTitle varchar(255),
    ReleaseDate date,
    LabelID int foreign key references Label(LabelID)
);

create table MusicVideo(
    MusicVideoID int primary key,
    ReleaseDate date,
    SongID int foreign key references Song(SongID)
);

insert into Concert(ConcertID, ConcertLocation, DateAndTime) VALUES
(1, 'a', '2023-12-12 03:00'),
(2, 'b', '2023-12-12 03:00'),
(3, 'c', '2023-12-12 03:00');

insert into Singer(SingerID, SingerName, SingerFollowers, ConcertID) VALUES
(1, 'x', 100, 1),
(1, 'x', 100, 2);
