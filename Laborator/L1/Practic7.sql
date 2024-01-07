create database Practic7;

use Practic7;

create schema dbo;

--============================================================
--Exercise 1

create table Instructors(
    InstructorID int primary key,
    Name nvarchar(255),
    FieldOfExpertise nvarchar(100),
    YearsOfExperience int
);

create table Courses(
    CourseID int primary key,
    Title nvarchar(100),
    SubjectArea nvarchar(100),
    DifficultyLevel nvarchar(100),
    InstructorID int foreign key references Instructors(InstructorID)
);

create table Students(
    StudentID int primary key,
    Name nvarchar(255),
    DateOfBirth date,
    CountryOfOrigin nvarchar(100)
);

create table Assignments(
    AssignmentID int primary key,
    Title nvarchar(100),
    Description nvarchar(200),
    DueDate date,
    Category nvarchar(100),
    CourseID int foreign key references Courses(CourseID)
);

create table Enrollments(
    EnrollmentID int primary key,
    StudentID int foreign key references Students(StudentID),
    CourseID int foreign key references Courses(CourseID)
);

create table Grades(
    GradeID int primary key,
    Grade decimal(5, 2),
    SubmissionDate date,
    AssignmentID int foreign key references Assignments(AssignmentID),
    StudentID int foreign key references Students(StudentID)
);

INSERT INTO Instructors (InstructorID, Name, FieldOfExpertise, YearsOfExperience) VALUES
(1, 'John Smith', 'Physics', 10),
(2, 'Emily Johnson', 'Mathematics', 8),
(3, 'Michael Brown', 'Literature', 5);


INSERT INTO Courses (CourseID, Title, SubjectArea, DifficultyLevel, InstructorID) VALUES
(101, 'Physics 101', 'Science', 'Beginner', 1),
(102, 'Advanced Mathematics', 'Mathematics', 'Advanced', 2),
(103, 'World Literature', 'Literature', 'Intermediate', 3);


INSERT INTO Students (StudentID, Name, DateOfBirth, CountryOfOrigin) VALUES
(201, 'Alice Green', '2001-04-15', 'USA'),
(202, 'Bob White', '2002-07-20', 'Canada'),
(203, 'Charlie Black', '2000-01-05', 'UK');


INSERT INTO Assignments (AssignmentID, Title, Description, DueDate, Category, CourseID) VALUES
(301, 'Introduction to Physics', 'Basics of Physics', '2024-02-15', 'Homework', 101),
(302, 'Calculus Quiz', 'Quiz on Calculus', '2024-03-01', 'Quiz', 102),
(303, 'Shakespeare Essay', 'Essay on Shakespeare', '2024-03-15', 'Project', 103);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID) VALUES
(401, 201, 101),
(402, 202, 102),
(403, 203, 103),
(404, 201, 102); -- Alice also enrolls in Advanced Mathematics


INSERT INTO Grades (GradeID, AssignmentID, StudentID, Grade, SubmissionDate) VALUES
(501, 301, 201, 85.0, '2024-02-16'),
(502, 302, 202, 90.0, '2024-03-02'),
(503, 303, 203, 75.0, '2024-03-16'),
(504, 302, 201, 88.0, '2024-03-02'); -- Alice's grade for the Calculus Quiz


--============================================================
--Exercise 2

select avg(Grade) as AverageGrade
from Grades g
join Assignments a on g.AssignmentID = a.AssignmentID
where a.Category = 'Quiz'


--============================================================
--Exercise 3

create view ScienceCoursesStudentCount as
select Courses.Title, count()
from Courses