create database practice;

create schema dbo;


use practice;

go

drop table Kunden

create table Kunden(
id int primary key,
Nachname varchar(20),
Vorname varchar(20),
Geburtsdatum date,
Email varchar(20))

--database test, table Kunden
select * from Kunden

insert into Kunden
values (1,'Pop','Marcel','1-3-1988','pop@gmail.com'),
(2,'Tamas', 'Ana','11-3-1991','tamas@gmail.com'),
(3,'Vanea','Ioana','2-4-1990','vanea@gmail.com'),
(4,'Toma','Andrei','10-10-1995','toma@gmail.com'),
(5,'Pricop','Maria','12-3-1989','pricop@gmail.com'),
(6,'Tamas','George','1-8-1987','tamas2@gmail.com')

delete from Kunden where id = 13
select * from Kunden

--überprüfe existierende Indexe
EXEC sys.sp_helpindex @objname = N'Kunden'

SELECT *
FROM sys.indexes
WHERE object_id = OBJECT_ID('Kunden')


--können wir einen unique nonclustered Index auf der Spalte Name erstellen?
--putem crea un index unique nonclustered pe Name?
create unique nonclustered index KundenNameIndex on Kunden(Nachname);

--können wir einen clustered Index auf der Spalte Name erstellen?
--putem crea un index clustered pe Name?
create clustered index KundenNameIndex on Kunden(Nachname);

--können wir einen nonclustered Index auf der Spalte Name erstellen?
--putem crea un index nonclustered pe Name?
create nonclustered index KundenNameIndex on Kunden(Nachname);


drop index Kunden.KundenNameIndex;

--welche Operation wird für die nächste Anfrage benutzt? Benutzt man einen Index?
--ce operatie va fi folosita pentru urmatoarea interogare? se foloseste vreun index?
select * from Kunden;

-- gibt es einen Unterschied in den Ausführungspläne der folgenden Anfragen?
--va fi vreo diferenta intre operatiile folosite pentru urmatoarele interogari?


select Nachname from Kunden where Nachname like 'P%';

select Nachname,Id from Kunden where Nachname like 'P%';
--index nonclustered pe Nachname: (Nachname, PK) = (Nachname, Id)

select * from Kunden where Nachname like 'P%';


select * from Kunden where Id = 3;

select Nachname,Vorname from Kunden where Nachname like 'P%';


drop index Kunden.KundenNameIndex;

---------------------------------------------------
create nonclustered index KundenNameIndex on Kunden(Nachname) include (Vorname);
--(Nachname - Suchschl., Vorname, Id- RID)

--ändert sich jetzt etwas an dem Ausfürungsplan?
select Nachname,Vorname from Kunden where Nachname like 'P%';

drop index Kunden.KundenNameIndex;
---------------------------------------------------
-- Tabelle: OrderStatistics(Id, OrderId, Amount)
create table OrderStatistics(
Id int primary key,
OrderId int,
Amount int)


select * from OrderStatistics
EXEC sys.sp_helpindex @objname = N'OrderStatistics'

create nonclustered index OrderAmount on OrderStatistics(Amount);
drop index OrderStatistics.OrderAmount;
-- wasfür Operationen und Indexe kommen in den folgenden Ausführungspläne vor?

SET SHOWPLAN_TEXT ON;
GO

select * from OrderStatistics
SET SHOWPLAN_TEXT OFF;
GO


select * from OrderStatistics where Id > 5000

select Amount from OrderStatistics

select Amount from OrderStatistics where Amount <=1500

select Amount, OrderId from OrderStatistics where Amount = 1500
select Amount, OrderId from OrderStatistics where Amount = 16

select Amount, OrderId from OrderStatistics where Amount <= 1000

select * from OrderStatistics order by Amount

select Amount from OrderStatistics order by Amount

drop index OrderStatistics.OrderAmount;

---------------------------------------------------

create nonclustered index OrderAmount1 on OrderStatistics(Amount) where Amount<2000;
create nonclustered index OrderAmount2 on OrderStatistics(Amount) where Amount>=2000;
drop index OrderStatistics.OrderAmount1;
drop index OrderStatistics.OrderAmount2;

select * from OrderStatistics where Amount <= 100

select * from OrderStatistics where Amount = 3000

select * from OrderStatistics where Amount < 3000

select * from OrderStatistics where Amount between 1800 and 2100

select Amount from OrderStatistics order by Amount

---------------------------------------------------------

create nonclustered index OrderAmount3 on OrderStatistics(Amount ASC,OrderId DESC);



select * from OrderStatistics WITH (INDEX(OrderAmount3))

select * from OrderStatistics where Amount = 3000

select Amount from OrderStatistics where Amount > 3000

select Amount from OrderStatistics where OrderId = 19
--clustered - pe Id

select Amount from OrderStatistics where Amount = 3000 and OrderId > 30

select Amount from OrderStatistics where OrderId = 37 and Amount > 2000

select Amount from OrderStatistics where OrderId = 37 or Amount > 2000

drop index OrderStatistics.OrderAmount3

-------------------
--views


create view KundenView
as
select K.Id, K.Nachname,K.Vorname,K.Geburtsdatum
from dbo.Kunden K
where K.Nachname like 'P%'

drop view KundenView


create unique clustered index KV on KundenView(Id)

--schemabinding: This means that the underlying tables and views cannot be modified
--in a way that would affect the definition of the schema-bound object

create view KundenView
WITH SCHEMABINDING as
select K.Id, K.Nachname,K.Vorname,K.Geburtsdatum
from dbo.Kunden K
where K.Nachname like 'P%'
--the underlying tables and views cannot be modified in a way that would affect
--the definition of the schema-bound object

drop view KundenView

create unique clustered index KV on KundenView(Id)

select Nachname from KundenView

select * from KundenView where id = 3


----------------
create view KundenView2
WITH SCHEMABINDING as
select K.Id, K.Nachname,K.Vorname,K.Geburtsdatum, GETDATE() as Datum
from dbo.Kunden K
where K.Nachname like 'P%'

drop view KundenView2

create unique clustered index KV on KundenView2(Id)


--Statistiken eines Indexes

select * from sys.dm_db_index_physical_stats(DB_ID(N'test'), OBJECT_ID(N'Kunden'),NULL,NULL,'DETAILED');
 --operanzi: database_id, object_id, index_id, partition_numer, mode



 -------------------------------------------------------------
 --wie können wir Systemtabellen und Sichten benutzen
 --utilizarea tabelelor si a view-urilor de sistem

 --was geben folgende Anfragen aus?
 --ce afiseaza urmatoarele interogari?

SELECT COLUMN_NAME, ORDINAL_POSITION
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
AND TABLE_NAME = 'Kunden'


SELECT DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Kunden' and COLUMN_NAME = 'Name'


SELECT
    fk.name,
    OBJECT_NAME(fk.parent_object_id) 'Parent table',
    c1.name 'Parent column',
    OBJECT_NAME(fk.referenced_object_id) 'Referenced table',
    c2.name 'Referenced column'
FROM
    sys.foreign_keys fk
INNER JOIN
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN
    sys.columns c1 ON fkc.parent_column_id = c1.column_id AND fkc.parent_object_id = c1.object_id
INNER JOIN
    sys.columns c2 ON fkc.referenced_column_id = c2.column_id AND fkc.referenced_object_id = c2.object_id




select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Kunden' and DATA_TYPE like '%char%'



SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Kunden'
ORDER BY ORDINAL_POSITION

