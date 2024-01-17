create database Practic10;

use Practic10;

create schema dbo;

drop table Konto

--============================================================
--Exercise 1

create table Customer(
    CNP int primary key,
    Name varchar(255),
    Vorname varchar(255)
);


create table WahrungTyp(
    WahrungTypID int primary key,
    WahrungName varchar(255)
);

create table Konto(
    KontonummerID int primary key,
    WahrungTypID int foreign key references WahrungTyp(WahrungTypID),
    CustomerID int foreign key references Customer(CNP),
    Balance int
);



create table Kredit(
    KreditID int primary key,
    Beschreibung varchar(255),
    WahrungTypID int foreign key references WahrungTyp(WahrungTypID),
    Laufzeit int
);


create table KundeKredit(
    CNP int foreign key references Customer(CNP),
    KreditID int foreign key references Kredit(KreditID),
    Betrag int,
    Rate int,
    primary key (CNP, KreditID)
);



INSERT INTO Customer (CNP, Name, Vorname) VALUES
(123456789, 'Muller', 'Anna'),
(234567891, 'Schmidt', 'Klaus'),
(345678912, 'Schneider', 'Maria'),
(456789123, 'Fischer', 'Peter'),
(567891234, 'Weber', 'Julia');


INSERT INTO WahrungTyp (WahrungTypID, WahrungName) VALUES
(1, 'EURO'),
(2, 'RON'),
(3, 'USD'),
(4, 'GBP'),
(5, 'JPY');

INSERT INTO Konto (KontonummerID, WahrungTypID, CustomerID) VALUES
(101, 1, 123456789),
(102, 2, 234567891),
(103, 1, 345678912),
(104, 3, 456789123),
(105, 1, 567891234);


INSERT INTO Kredit (KreditID, Beschreibung, WahrungTypID, Laufzeit) VALUES
(1001, 'Hauskredit', 1, 30),
(1002, 'Autokredit', 2, 5),
(1003, 'Bildungskredit', 1, 10),
(1004, 'Geschäftskredit', 3, 15),
(1005, 'Renovierungskredit', 1, 20);


INSERT INTO KundeKredit (CNP, KreditID, Betrag, Rate) VALUES
(123456789, 1001, 2000, 150),
(234567891, 1002, 500, 50),
(345678912, 1003, 1200, 100),
(456789123, 1004, 800, 70),
(567891234, 1005, 1500, 120),
-- Additional tuples for task requirements
(123456789, 1002, 600, 55),
(234567891, 1003, 1300, 110);


--============================================================
--Exercise 2
-- a) Gebe den Mittelwert des Betrags der beantragten Kredite aus

select avg(Betrag) as AverageBetrag
from KundeKredit;


--============================================================
--Exercise 3
-- b) Gebe alle Kunden aus, die ein Kredit haben mit einem Betrag höher als 1000 EURO

select distinct C.CNP, C.Name, C.Vorname
from Customer C
join KundeKredit KK on C.CNP = KK.CNP
join Kredit K on KK.KreditID = K.KreditID
where KK.Betrag > 1000 and K.WahrungTypID = (Select WahrungTypID from WahrungTyp where WahrungName = 'EURO');

--============================================================
--Exercise 4
-- c) Gebe die Anzahl des geöffneten Kontos mit Währung „EURO“
select count(*) as TotalEuroAccounts
from Konto
where WahrungTypID = (select WahrungTypID from WahrungTyp where WahrungName = 'Euro');

select count(W.WahrungID)

--============================================================
--Exercise 4
-- c) Gebe die Anzahl des geöffneten Kontos mit Währung „EURO“