create database Practic11;

use Practic11;

create schema dbo;


--============================================================
--Exercise 1

create table Flughafen(
  FlughafenID int primary key,
  Name varchar(255),
  Ort varchar(255)
);

create table Flug(
    FlugCode int primary key,
    Fluggesellschaft varchar(255)
);

create table Passagier(
    CNP int primary key,
    Nachname varchar(255),
    Vorname varchar(255),
    Geburtsdatum date
);

create table GepackTyp(
    GepackTypID int primary key,
    GepackTyp varchar(255)
);

create table Gepack(
    GepackID int primary key,
    Gewicht int,
    CNP int foreign key references Passagier(CNP),
    GepackTyp int foreign key references GepackTyp(GepackTypID)
);

create table PassagierFlug(
    CNP int foreign key references Passagier(CNP),
    FlugCode int foreign key references Flug(FlugCode),
);

create table FlugDetails(
    FlugCode int foreign key references Flug(FlugCode),
    AbflugFlughafenID int foreign key references Flughafen(FlughafenID),
    AnkunftFlugafenID int foreign key references Flughafen(FlughafenID),
    Abflugszeit datetime,
    AnkunftFlughafen datetime
);


-- Inserting data into Flughafen
INSERT INTO Flughafen(FlughafenID, Name, Ort) VALUES
(1, 'Frankfurt Airport', 'Frankfurt'),
(2, 'Berlin Tegel Airport', 'Berlin'),
(3, 'Munich Airport', 'Munich');

-- Inserting data into Flug
INSERT INTO Flug(FlugCode, Fluggesellschaft) VALUES
(101, 'Lufthansa'),
(102, 'Air Berlin'),
(103, 'Eurowings');

-- Inserting data into Passagier (including Anamaria)
INSERT INTO Passagier(CNP, Nachname, Vorname, Geburtsdatum) VALUES
(111, 'Muller', 'Anamaria', '1990-05-15'),
(112, 'Schmidt', 'Johann', '1985-03-20'),
(113, 'Fischer', 'Sarah', '1992-08-30');

-- Inserting data into GepackTyp
INSERT INTO GepackTyp(GepackTypID, GepackTyp) VALUES
(1, 'Handgepäck'),
(2, 'Aufgegebenes Gepäck'),
(3, 'Spezialgepäck');

-- Inserting data into Gepack
INSERT INTO Gepack(GepackID, Gewicht, CNP, GepackTyp) VALUES
(1001, 10, 111, 1),
(1002, 15, 112, 2),
(1003, 8, 113, 1),
(1004, 12, 111, 3),
(1005, 18, 113, 2);

-- Inserting data into PassagierFlug (including Anamaria's bookings)
INSERT INTO PassagierFlug(CNP, FlugCode) VALUES
(111, 101),
(112, 102),
(113, 103),
(111, 103);

-- Inserting data into FlugDetails
INSERT INTO FlugDetails(FlugCode, AbflugFlughafenID, AnkunftFlugafenID, Abflugszeit, AnkunftFlughafen) VALUES
(101, 1, 2, '2024-01-15 08:00:00', '2024-01-15 10:00:00'),
(102, 2, 3, '2024-01-16 09:00:00', '2024-01-16 11:30:00'),
(103, 3, 1, '2024-01-17 07:30:00', '2024-01-17 09:45:00');


--============================================================
--Exercise 2
--a) Gebe alle Flüge aus, die „Anamaria“ (Vorname eines Kunden) gebucht hat

select F.FlugCode, F.Fluggesellschaft
from Flug F
join PassagierFlug PF on F.FlugCode = PF.FlugCode
join Passagier P on PF.CNP = P.CNP
where P.Vorname = 'Anamaria';


--============================================================
--Exercise 3
--b) Gebe die Anzahl der gebuchten Flüge für jeden Passagier aus

select P.CNP, P.Vorname, P.Nachname, count(PF.FlugCode) as TotalFlights
from Passagier P
join PassagierFlug PF on P.CNP = PF.CNP
group by P.CNP, P.Vorname, P.Nachname

--============================================================
--Exercise 4
--c) Gebe den Mittelwert der Anzahl der Passagiere pro Flug aus


SELECT AVG(SubQuery.AnzahlPassagiere) AS DurchschnittPassagiereProFlug
FROM (
    SELECT COUNT(*) AS AnzahlPassagiere
    FROM PassagierFlug PF
    GROUP BY PF.FlugCode
) AS SubQuery;


--============================================================
--Exercise 5
--d) Gebe alle Flughäfen (Name und Ort) aus, auf denen wenigstens 2 Flüge landen

select FH.Name, FH.Ort
from Flughafen FH
join FlugDetails FD on FH.FlughafenID = FD.AnkunftFlugafenID
group by FH.Name, FH.Ort
having count(FD.FlugCode) >= 2;

--============================================================
--Exercise 6
--e) Gebe das gesamte Gewicht der Gepäcke für jeden Flug aus.

select PF.FlugCode, sum(G.Gewicht) as TotalWeight
from Gepack G
join PassagierFlug PF on G.CNP = PF.CNP
group by pf.FlugCode;


--============================================================
--Exercise 7
--f) Gebe für jeden Flughafen die totale Anzahl der Flüge aus, die von diesem Flughafen abfliegen oder auf diesem Flughafen landen.

select FH.Name, COUNT(*) as TotalFlights
from Flughafen FH
join FlugDetails FD on FH.FlughafenID = FD.AbflugFlughafenID or FH.FlughafenID = FD.AnkunftFlugafenID
group by FH.Name
order by TotalFlights desc;