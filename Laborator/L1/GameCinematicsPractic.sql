create database GameCinematics;

use GameCinematics;

create schema dbo;

/*
 1. You must create a database that manages cinematics from different games. The purpose of the database is to
contain all the information about the cinematics of all games and some details about the heroes that appear in cinematics.
	A) The entities of interest for the problem domanin are: Heroes, Cinematics, Games and Companies.
	B) Each game has a name, a release date and belongs to a company. The company has a name, a description and a website.
	C) Each cinematic has a name, an associated game and a list of heroes with an entry moment for each hero.
	The entry moment is represented as an hour/minute/second pair (ex: a hero appears at 00:02:33). Every hero
	has a name, a description and an importance.

1) Write a SQL script to create a relational data model in order to represent the required data. (4 points)

2) Create a store procedure that receives a hero, a cinematic, and an entry moment and adds the new cinematic to
the hero. If the cinematic already exists, the entry moment is updated. (2 points)

3) Create a view that shows the name and the importance of all heroes that appear in all cinematics. (1 point)

4) Create a function that lists the name of the company, the name of the game and the title of the cinematic for all
games that have the release date greater than or equal to '2000-12-02' and less than or equal to '2016-01-01'. (2 points)
 */

--============================================================
--Exercise 1

 create table Company(
     CompanyID int primary key,
     Name nvarchar(100),
     Description nvarchar(max),
     Website nvarchar(255)
 );

create table Games(
    GameID int primary key,
    Name nvarchar(255),
    ReleaseDate date,
    CompanyID int foreign key references Company(CompanyID)
);

create table Heroes(
    HeroID int primary key,
    Name nvarchar(255),
    Description nvarchar(max),
    Importance int
);

create table Cinematics(
    CinematicID int primary key,
    Name nvarchar(255),
    GameID int foreign key references Games(GameID)
);

create table CinematicHeroes(
    EntryMoment time,
    CinematicID int foreign key references Cinematics(CinematicID),
    HeroID int foreign key references Heroes(HeroID),
    PRIMARY KEY (CinematicID, HeroID)
);

INSERT INTO Company (CompanyID, Name, Description, Website) VALUES
(1, 'Epic Games', 'American video game and software developer and publisher based in Cary, North Carolina.', 'https://www.epicgames.com'),
(2, 'Blizzard Entertainment', 'American video game developer and publisher based in Irvine, California.', 'https://www.blizzard.com'),
(3, 'Ubisoft', 'French video game company headquartered in Montreuil, with several development studios across the world.', 'https://www.ubisoft.com');

INSERT INTO Games (GameID, Name, ReleaseDate, CompanyID) VALUES
(1, 'Fortnite', '2017-07-25', 1),
(2, 'Overwatch', '2016-05-24', 2),
(3, 'Assassin''s Creed', '2007-11-13', 3);


INSERT INTO Heroes (HeroID, Name, Description, Importance) VALUES
(1, 'Lara Croft', 'Fictional character and the main protagonist of the video game franchise Tomb Raider.', 10),
(2, 'Master Chief', 'Fictional character and the protagonist of the Halo multimedia franchise.', 9),
(3, 'Ezio Auditore', 'Fictional character in the video game series Assassin''s Creed.', 8);

INSERT INTO Cinematics (CinematicID, Name, GameID) VALUES
(1, 'Fortnite Trailer', 1),
(2, 'Overwatch Intro', 2),
(3, 'Assassin''s Creed Reveal', 3);


INSERT INTO CinematicHeroes (CinematicID, HeroID, EntryMoment) VALUES
(1, 1, '00:00:30'),
(2, 2, '00:01:15'),
(3, 3, '00:02:00');

select * from CinematicHeroes;

--============================================================
--Exercise 2


create or alter procedure AddOrUpdateCinematicEntry
@HeroID int,
@CinematicID int,
@EntryMoment time
as
begin
    if exists(select * from CinematicHeroes where HeroID = @HeroID and CinematicID = @CinematicID)
    begin
        update CinematicHeroes
        set EntryMoment = @EntryMoment
        where HeroID = @HeroID and CinematicID = @CinematicID
    end
    else
    begin
        insert into CinematicHeroes(CinematicID, HeroID, EntryMoment)
        values(@CinematicID, @HeroID, @EntryMoment)
    end
end


execute AddOrUpdateCinematicEntry @HeroID = 1, @CinematicID = 1, @EntryMoment='00:01:00';


--============================================================
--Exercise 3

create or alter view HeroesInCinematics as
select h.Name, h.Importance
from Heroes h
join CinematicHeroes ch on h.HeroID = ch.HeroID;

select * from HeroesInCinematics;

--============================================================
--Exercise 4

create function GetGamesAndCinematics(@StartDate date, @EndDate date)
returns table
as
return (
        select c.Name as CompanyName, G.Name as GameName, CI.Name as CinematicName
        from Company C
        join Games G on C.CompanyID = G.CompanyID
        join Cinematics CI on G.GameID = CI.GameID
        where G.ReleaseDate >= @StartDate and G.ReleaseDate <= @EndDate
    );


SELECT * from GetGamesAndCinematics('2000-01-01','2024-01-01');