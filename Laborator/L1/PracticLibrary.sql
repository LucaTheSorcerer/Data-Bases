create database Practic6;

use Practic6;

create schema dbo;

--============================================================
--Exercise 1

create table Members(
    MemberID int primary key,
    Name nvarchar(255),
    Age INT
);


create table Authors(
    AuthorID int primary key,
    Name nvarchar(100) not null,
    Nationality nvarchar(100) not null
);

create table Genres(
    GenreID int primary key,
    GenreName nvarchar(100)
);

create table Publishers(
    PublisherID int primary key,
    Name nvarchar(100),
    Address nvarchar(255)
);

create table Books(
    ISBN int primary key,
    Title nvarchar(100),
    AuthorID int foreign key references Authors(AuthorID),
    GenreID int foreign key references Genres(GenreID),
    PublisherID int foreign key references Publishers(PublisherID)
);

create table Loans(
    LoanID int primary key,
    MemberID int foreign key references Members(MemberID),
    ISBN int foreign key references Books(ISBN),
    LoanDate date,
    DueDate date
);

INSERT INTO Members (MemberID, Name, Age) VALUES
(1, 'Alice Smith', 25),
(2, 'Bob Johnson', 30),
(3, 'Carol Williams', 22);


INSERT INTO Authors (AuthorID, Name, Nationality) VALUES
(1, 'J.K. Rowling', 'British'),
(2, 'George Orwell', 'British'),
(3, 'Isaac Asimov', 'American');

INSERT INTO Genres (GenreID, GenreName) VALUES
(1, 'Fiction'),
(2, 'Science Fiction'),
(3, 'Dystopian');


INSERT INTO Publishers (PublisherID, Name, Address) VALUES
(1, 'Penguin Books', '123 Penguin Street, London'),
(2, 'HarperCollins', '456 Harper Road, New York');

INSERT INTO Books (ISBN, Title, AuthorID, GenreID, PublisherID) VALUES
(123456789, '1984', 2, 3, 1),
(987654321, 'Harry Potter and the Sorcerer Stone', 1, 1, 2),
(111213141, 'Foundation', 3, 2, 1);


INSERT INTO Books (ISBN, Title, AuthorID, GenreID, PublisherID) VALUES
(111111111, 'iron flame', 1, 2, 2)

INSERT INTO Loans (LoanID, MemberID, ISBN, LoanDate, DueDate) VALUES
(1, 1, 123456789, '2023-01-01', '2023-01-15'),
(2, 2, 987654321, '2023-01-05', '2023-01-20'),
(3, 1, 111213141, '2023-01-10', '2023-01-24');


--============================================================
--Exercise 2

select b.ISBN, b.Title
from Books b
left join Loans l on b.ISBN = l.ISBN
where l.ISBN is null;

--============================================================
--Exercise 3

select top 1 g.GenreName
from Genres g
join books b on g.GenreID = b.GenreID
join Loans l on b.ISBN = l.ISBN
group by g.GenreName
order by count(l.LoanID) desc;

--============================================================
--Exercise 4

create view UpcomingReturn as
select m.Name as MemberName, b.Title as BookTitle, l.DueDate
from Loans l
join Members m on l.MemberID = m.MemberID
join Books b on l.ISBN = b.ISBN
where l.DueDate between getdate() and dateadd(day, 7, getdate());

select * from UpcomingReturn;