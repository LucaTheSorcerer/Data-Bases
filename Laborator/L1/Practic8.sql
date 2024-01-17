create database Practic8;

create schema dbo;
use Practic8;

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
     Name varchar(255),
     Description varchar(max),
     Website varchar(255)
 );

create table Game(
    GameID int primary key,
    Name varchar(255),
    ReleaseDate date,
    CompanyID int foreign key references Company(CompanyID)
);

create table Hero(
    HeroID int primary key,
    Name varchar(255),
    Description varchar(max),
    Importance int
);

create table Cinematic(
    CinematicID int primary key,
    Name varchar(255),
    GameID int foreign key references Game(GameID)
);

create table CinematicHeroes(
    EntryMoment time,
    CinematicID int foreign key references Cinematic(CinematicID),
    HeroID int foreign key references Hero(HeroID),
    primary key (CinematicID, HeroID)
);


INSERT INTO Company (CompanyID, Name, Description, Website) VALUES
(1, 'GameCorp', 'A leading game development company', 'http://gamecorp.com'),
(2, 'PlayWell Studios', 'Innovative and creative game studio', 'http://playwell.com'),
(3, 'Epic Fantasy Games', 'Specializing in fantasy and adventure games', 'http://epicfantasygames.com');


INSERT INTO Game (GameID, Name, ReleaseDate, CompanyID) VALUES
(1, 'Space Adventure', '2022-05-15', 1),
(2, 'Mystical Quest', '2023-03-20', 2),
(3, 'Battle of Empires', '2024-01-10', 3);


INSERT INTO Hero (HeroID, Name, Description, Importance) VALUES
(1, 'Zara the Warrior', 'A fearless warrior with unmatched skills', 10),
(2, 'Eldor the Wizard', 'A wise and powerful mage', 8),
(3, 'Lira the Archer', 'A stealthy archer with deadly accuracy', 9);


INSERT INTO Cinematic (CinematicID, Name, GameID) VALUES
(1, 'The Galactic Battle', 1),
(2, 'The Enchanted Forest', 2),
(3, 'Empires Fall', 3);

INSERT INTO CinematicHeroes (EntryMoment, CinematicID, HeroID) VALUES
('00:01:30', 1, 1),
('00:02:15', 2, 2),
('00:03:00', 3, 3);

--============================================================
--Exercise 2

create or alter procedure UpdateEntryMoment
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
            insert into CinematicHeroes(CinematicID, HeroID, EntryMoment) values (@CinematicID, @HeroID, @EntryMoment)

        end
    end

exec UpdateEntryMoment @HeroID = 1, @CinematicID = 1, @EntryMoment = '00:02:00';

select * from CinematicHeroes;


--============================================================
--Exercise 3

create or alter view ShowHeroesAndImportance
as
    select h.Name, h.Importance
    from Hero h
    join CinematicHeroes ch on h.HeroID = ch.HeroID

select * from ShowHeroesAndImportance;

--============================================================
--Exercise 4

create or alter function ShowCompanies (@StartDate date, @EndDate date)
returns table
as
return (
        select c.Name as CompanyName, g.Name as GameName, ci.Name as CinematicName
        from Company c
        Join Game g on g.CompanyID = c.CompanyID
        Join Cinematic ci on g.GameID = ci.GameID
        where g.ReleaseDate >= @StartDate and g.ReleaseDate <= @EndDate

    );

select * from ShowCompanies('2001-01-01', '2023-01-01');

