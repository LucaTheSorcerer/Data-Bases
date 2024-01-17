create database Practic721_1;

use Practic721_1;

--============================================================
--Exercise 1

create table Kunde(
    KundeID int primary key,
    KundeName nvarchar(255),
    KundeEmail nvarchar(255),
    KundeTel nvarchar(255)
);

create table Kuchen(
    KuchenID int primary key,
    KuchenName nvarchar(255),
    Beschreibung nvarchar(max),
);

create table Massenheit(
    MassenheitID int primary key,
    MassenheitTyp nvarchar(100)
);

create table Zutaten(
    ZutatenID int primary key,
    ZutatenName nvarchar(255),
    MassenheitID int foreign key references Massenheit(MassenheitID)
);

create table KuchenZutaten(
    KuchenID int foreign key references Kuchen(KuchenID),
    ZutatenID int foreign key references Zutaten(ZutatenID),
    primary key (KuchenID, ZutatenID)
);



create table CandyBar(
    CandyBarID int primary key,
    KundeID int foreign key references Kunde(KundeID),
    CandyBarThema nvarchar(255),
    Datum date,
);

-- drop table CandyBarMenu;

create table CandyBarMenuKuchen(
    CandyBarID int foreign key references CandyBar(CandyBarID),
    KuchenID int foreign key references Kuchen(KuchenID),
    Kilogram int,
    primary key(CandyBarID, KuchenID)

);

insert into Kunde(KundeID, KundeName, KundeEmail, KundeTel) values
(1, 'Mike Oxlong', 'm.oxlong@gmail.com', '111-111-111'),
(2, 'Ben Dover', 'b.dover@gmail.com', '222-222-222'),
(3, 'Moe Lester', 'm.lester@gmail.com', '333-333-333'),
(4, 'Peter File', 'p.file@gmail.com', '444-444-444');

insert into Massenheit(MassenheitID, MassenheitTyp) values
(1, 'ml'),
(2, 'g');

insert into Kuchen(KuchenID, KuchenName, Beschreibung) VALUES
(1, 'Himbeertraum', 'xyz'),
(2, 'Erdbeer-Cupcake', 'xyz'),
(3, 'Kokos Tortchen', 'xyz'),
(4, 'Vanilla-Cupcake', 'xyz'),
(5, 'Zitronen Mousse', 'xyz'),
(6, 'Nutellakuchen', 'xyz');

insert into Kuchen(KuchenID, KuchenName, Beschreibung) VALUES
(7, 'Schokoladenmousse', 'xyz');

insert into Zutaten(ZutatenID, ZutatenName, MassenheitID) VALUES
(1, 'Milk', 1),
(2, 'Sugar', 2),
(3, 'Flower', 2),
(4, 'Vanilla', 2),
(5, 'Chocolate', 2),
(6, 'Ice Cream', 2),
(7, 'Powdered Sugar', 2),
(8, 'Cherries', 2);

insert into KuchenZutaten(KuchenID, ZutatenID) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(5, 1),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(6, 1),
(6, 2),
(6, 3);

insert into KuchenZutaten(KuchenID, ZutatenID) VALUES
(7, 1),
(7, 2),
(7, 3),
(7, 4);

select * from CandyBar;
select * from CandyBarMenuKuchen;

insert into CandyBar(CandyBarID, KundeID, CandyBarThema, Datum) VALUES
(1, 1, 'Hochzeit', '2024-01-01'),
(2, 2, 'Weinachtsparty', '2024-02-11'),
(3, 3, 'Geburtstagparty', '2024-05-15'),
(4, 4, 'Osterreichparty', '2024-06-06');

insert into CandyBarMenuKuchen(CandyBarID, KuchenID, Kilogram) VALUES
(1, 1, 10),
(2, 2, 20),
(3, 3, 25),
(4, 4, 30);

insert into CandyBarMenuKuchen(CandyBarID, KuchenID, Kilogram) VALUES
(1, 7, 40);

--============================================================
--Exercise 2

select c.CandyBarID, c.CandyBarThema, c.Datum
from CandyBar c
join CandybarMenuKuchen cbmk on c.CandyBarID = cbmk.CandyBarID
join Kuchen k on cbmk.KuchenID = k.KuchenID
where k.KuchenName = 'Himbeertraum'

intersect

select c.CandyBarID, c.CandyBarThema, c.Datum
from CandyBar c
join CandybarMenuKuchen cbmk on c.CandyBarID = cbmk.CandyBarID
join Kuchen k on cbmk.KuchenID = k.KuchenID
where k.KuchenName = 'Schokoladenmousse';


--============================================================
--Exercise 3

select top 1 with ties k.KuchenName, k.Beschreibung, count(kz.KuchenID) as SmallestNrOfIngredients
from Kuchen k
join KuchenZutaten kz on k.KuchenID = kz.KuchenID
group by k.KuchenName, k.Beschreibung
order by count(kz.KuchenID) asc;


select  k.KuchenName, k.Beschreibung, count(kz.KuchenID) as SmallestNrOfIngredients
from Kuchen k
join KuchenZutaten kz on k.KuchenID = kz.KuchenID
group by k.KuchenName, k.Beschreibung
having count(kz.KuchenID) = (select min(minimum) from (
                                                        select count(k.KuchenID) as minimum
                                                        from KuchenZutaten k
                                                        group by k.KuchenID
                                                      )as subquery)















select c.CandyBarID, c.CandyBarThema, c.Datum
from CandyBar c
join CandyBarMenuKuchen CBMK on c.CandyBarID = CBMK.CandyBarID
join Kuchen K on CBMK.KuchenID = K.KuchenID
where k.KuchenName = 'Himbeertraum'
intersect
select c.CandyBarID, c.CandyBarThema, c.Datum
from CandyBar c
join CandyBarMenuKuchen CBMK on c.CandyBarID = CBMK.CandyBarID
join Kuchen K on CBMK.KuchenID = K.KuchenID
where k.KuchenName = 'Schokoladenmousse';


select k.KuchenID, k.KuchenName, k.Beschreibung, count(kz.KuchenID) as NumberOfIngredients
from Kuchen k
join KuchenZutaten KZ on k.KuchenID = KZ.KuchenID
group by k.KuchenID, k.KuchenName, k.Beschreibung
having count(kz.KuchenID) = (select min(minimum) from (
                                                        select count(kz.KuchenID) as minimum
                                                        from KuchenZutaten kz
                                                        group by kz.KuchenID
                                                     )subquery)

select top 1 with ties k.KuchenID, k.KuchenName, k.Beschreibung, count(kz.KuchenID) as NumberOfIngredients
from Kuchen K
join KuchenZutaten KZ on K.KuchenID = KZ.KuchenID
group by k.KuchenID, k.KuchenName, k.Beschreibung
order by NumberOfIngredients asc;








