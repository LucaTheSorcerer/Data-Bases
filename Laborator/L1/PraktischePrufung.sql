create database PraktsichePrufung;

use PraktsichePrufung;

create table Genre(
    GenreID int primary key,
    GenreTyp varchar(255)
);

create table Schallplatte(
    SchallplatteID int primary key,
    SchallplatteName varchar(255),
    GenreID int foreign key references Genre(GenreID),
);

create table Lied(
    LiedID int primary key,
    LiedTitle varchar(255),
    LiedArtistName varchar(255),
    Duration int,
);

create table Kunde(
    KundeID int primary key,
    KundeName varchar(255),
    KundeEmail varchar(255)
);

create table Bestellung(
    BestellungID int primary key,
    BestellungLieferungAdresse varchar(255),
    KundeID int foreign key references Kunde(KundeID)
);

create table BestellungSchallplatte(
    BestellungID int foreign key references Bestellung(BestellungID),
    SchallplatteID int foreign key references Schallplatte(SchallplatteID),
    primary key (BestellungID, SchallplatteID),
    Stucke int
);

drop table BestellungSchallplatte;

create table SchallplateLieder(
    SchallplateID int foreign key references Schallplatte(SchallplatteID),
    LiedID int foreign key references Lied(LiedID),
    primary key (SchallplateID, LiedID)
);

drop table Lied;

-- drop table SchallplatteLieder;

select * from Genre;
select * from Schallplatte;
select * from Lied;
select * from Kunde;
select * from Bestellung;
select * from BestellungSchallplatte;
select * from SchallplateLieder;


insert into Genre(GenreID, GenreTyp) VALUES
(1, 'Rock'),
(2, 'Pop'),
(3, 'Funk');

insert into Schallplatte(SchallplatteID, SchallplatteName, GenreID) VALUES
(1, 'Schallplatte 1', 1),
(2, 'Schallplatte 2', 2),
(3, 'Schallplatte 3', 3);

insert into Lied(LiedID, LiedTitle, LiedArtistName, Duration) VALUES
(1, 'Rammstein', 'Rammstein', 4),
(2, 'ACDC', 'ACDC', 5),
(3, 'Gummi', 'Gummi', 4),
(4, 'Pink Floyd', 'Pink Floyd', 3);

insert into SchallplateLieder(SchallplateID, LiedID) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

insert into Kunde(KundeID, KundeName, KundeEmail) VALUES
(1, 'Joe Johnson', 'joe@gmail.com'),
(2, 'Donald Trump', 'trump@gmail.com'),
(3, 'Ion Popescu', 'joe@gmail.com');

insert into Bestellung(BestellungID, BestellungLieferungAdresse, KundeID) VALUES
(1, 'str. Eminescu', 1),
(2, 'str. Eminescu', 1),
(3, 'str. Lucian Blaga', 2),
(4, 'str. Lucian Blaga', 3);

insert into BestellungSchallplatte(BestellungID, SchallplatteID, Stucke) VALUES
(1, 1, 5),
(2, 1, 5),
(3, 2, 5);


select *
from Schallplatte s;

select s.SchallplatteID,s.SchallplatteName, g.GenreTyp
from Schallplatte s
join Genre G on s.GenreID = G.GenreID
join SchallplateLieder SL on s.SchallplatteID = SL.SchallplateID
join Lied L on L.LiedID = SL.LiedID
where L.LiedTitle = 'Rammstein'

except

select s.SchallplatteID,s.SchallplatteName, g.GenreTyp
from Schallplatte s
join Genre G on s.GenreID = G.GenreID
join SchallplateLieder SL on s.SchallplatteID = SL.SchallplateID
join Lied L on L.LiedID = SL.LiedID
where L.LiedTitle = 'Gummi'


select top 1 with ties s.SchallplatteID, s.SchallplatteName, g.GenreTyp, count(l.LiedID) as TotalNumberOfLieds
from Schallplatte s
join Genre G on s.GenreID = G.GenreID
join SchallplateLieder SL on s.SchallplatteID = SL.SchallplateID
join Lied L on L.LiedID = SL.LiedID
group by s.SchallplatteID, s.SchallplatteName, g.GenreTyp
order by count(l.LiedID) desc;



select s.SchallplatteID, s.SchallplatteName, g.GenreTyp, count(l.LiedID) as TotalNumberOfLieds
from Schallplatte s
join Genre G on s.GenreID = G.GenreID
join SchallplateLieder SL on s.SchallplatteID = SL.SchallplateID
join Lied L on L.LiedID = SL.LiedID
group by s.SchallplatteID, s.SchallplatteName, g.GenreTyp



