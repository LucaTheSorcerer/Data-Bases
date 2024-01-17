create database Practic16;

use Practic16;


--============================================================
--Exercise 1
create table Flughafen(
    FlughafenID int primary key,
    FlughafenName nvarchar(255),
    FlughafenOrt nvarchar(255)
);

create table Flug(
    Flugcode int primary key,
    Fluggesellschaft nvarchar(255)
);

create table Passagiere(
    CNP int primary key,
    Nachname nvarchar(255),
    Vorname nvarchar(255),
    Geburtsdatum date
);

create table GepackTyp(
    GepackTypID int primary key,
    GepackTyp nvarchar(255)
);

create table Gepack(
    GepackID int primary key,
    GepackGewicht int,
    GepackTyp int foreign key references GepackTyp(GepackTypID),
    CNP int foreign key references Passagiere(CNP)
);

create table PassagiereFlug(
    CNP int foreign key references Passagiere(CNP),
    Flugcode int foreign key references Flug(Flugcode)
);

create table FlugDetails(
    Flugcode int foreign key references Flug(Flugcode),
    AbflugFlughafenID int foreign key references Flughafen(FlughafenID),
    AnkunftFlughafenID int foreign key references Flughafen(FlughafenID),
    Abflugzeit datetime,
    Ankunftzeit datetime
);

insert into Flughafen(FlughafenID, FlughafenName, FlughafenOrt) VALUES
(1, 'Aeroport Timisoara', 'Timisoara'),
(2, 'Aeroport Cluj', 'Cluj'),
(3, 'Aeroport Bucuresti', 'Bucuresti');

insert into Flug(Flugcode, Fluggesellschaft) values
(1, 'Tarom'),
(2, 'Wizzair'),
(3, 'Wizzair');

insert into Passagiere(CNP, Nachname, Vorname, Geburtsdatum) VALUES
(1, 'Mike', 'Oxlong', '1980-12-12'),
(2, 'Ben', 'Dover', '1985-03-01'),
(3, 'Peter', 'File', '1970-12-12'),
(4, 'Moe', 'Lester', '2000-12-12'),
(5, 'Moe', 'Anamaria', '2000-12-12');

insert into GepackTyp(GepackTypID, GepackTyp) VALUES
(1, 'Greu sa mor'),
(2, 'Din ala de student'),
(3, 'Din ala de sarac');


insert into Gepack(GepackID, GepackGewicht, GepackTyp, CNP) VALUES
(1, 50, 2, 1),
(2, 80, 1, 2),
(3, 40, 3, 3),
(4, 10, 3, 4);

insert into PassagiereFlug(CNP, Flugcode) VALUES
(1, 1),
(5, 2),
(5, 1),
(2, 2),
(3, 3);

select * from PassagiereFlug;

insert into FlugDetails(Flugcode, AbflugFlughafenID, AnkunftFlughafenID, Abflugzeit, Ankunftzeit) VALUES
(1, 1, 2, '08:00:00', '13:00:00'),
(2, 2, 3, '08:00:00', '10:30:00'),
(3, 1, 3, '12:00:00', '16:30:00'),
(3, 1, 2, '02:00:00', '10:00:00');


--============================================================
--Exercise 2

select  f.Flugcode, f.Fluggesellschaft
from Flug f
join FlugDetails FD on f.Flugcode = FD.Flugcode
join PassagiereFlug PF on f.Flugcode = PF.Flugcode
join Passagiere P on PF.CNP = P.CNP
where p.Vorname = 'Anamaria';


--============================================================
--Exercise 3
select P.CNP, P.Nachname, P.Vorname, count(PF.Flugcode)
from Passagiere P
join PassagiereFlug PF on P.CNP = PF.CNP
group by P.CNP, P.Nachname, P.Vorname;

--============================================================
--Exercise 4

select avg(subquery.AnzahlPassagiere) as TotalPassangers
from(
    select count(*) as AnzahlPassagiere
    from PassagiereFlug pf
    group by pf.Flugcode
    ) subquery


--============================================================
--Exercise 5

select fh.FlughafenID, fh.FlughafenName, fh.FlughafenOrt
from Flughafen fh
join FlugDetails FD on fh.FlughafenID = FD.AnkunftFlughafenID
group by fh.FlughafenID, fh.FlughafenName, fh.FlughafenOrt
having count(fd.Flugcode) >= 2;

--============================================================
--Exercise 6

select pf.Flugcode, sum(g.GepackGewicht) as TotalWeigth
from PassagiereFlug pf
join Passagiere P on pf.CNP = P.CNP
join Gepack G on P.CNP = G.CNP
group by pf.Flugcode;

--============================================================
--Exercise 7

select fh.FlughafenID, fh.FlughafenName, count(fh.FlughafenID) as TotalFlights
from Flughafen fh
join FlugDetails FD on fh.FlughafenID = FD.AbflugFlughafenID or fh.FlughafenID = FD.AnkunftFlughafenID
group by fh.FlughafenID, fh.FlughafenName
order by TotalFlights desc;