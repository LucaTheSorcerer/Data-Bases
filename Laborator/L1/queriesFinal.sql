use employeeLastV



-- Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
    (1, 'HR'),
    (2, 'Engineering'),
    (3, 'Sales');

-- Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (1, 'John', 'Doe', 'john.doe@email.com', '123-456-7890', 1, 55000.00, 'Active'),
    (2, 'Jane', 'Smith', 'jane.smith@email.com', '987-654-3210', 2, 65000.00, 'Active'),
    (3, 'David', 'Johnson', 'david.johnson@email.com', '555-123-4567', 1, 50000.00, 'Active');

-- Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
    (1, 'Project A', '2023-01-01', '2023-02-28'),
    (2, 'Project B', '2023-03-01', '2023-04-30'),
    (3, 'Project C', '2023-02-15', '2023-05-15');






INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate) VALUES
    (4, 'Autonomous Driving', '2023-01-01', '2023-02-28')

INSERT INTO Projects(PROJECTID, PROJECTNAME, STARTDATE, ENDDATE) VALUES
    (5, 'Defect Detection', '2023-02-04', '2023-08-11'),
    (6, 'Self Driving Trains', '2023-03-11', '2023-09-11')




-- EmployeeProjects
INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 3);


INSERT INTO EmployeeProjects (EmployeeID, ProjectID) VALUES
    (1, 4)

-- Skills
INSERT INTO Skills (SkillID, SkillName) VALUES
    (1, 'Java'),
    (2, 'SQL'),
    (3, 'Project Management');

-- EmployeeSkills
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 3);


INSERT INTO EmployeeSkills (EmployeeID, SkillID, SkillLevel) VALUES
    (16, 1, 'Advanced')

-- Tasks
INSERT INTO Tasks (TaskID, TaskName, Description, ProjectID, AssignedTo, Status) VALUES
    (1, 'Design UI', 'Create user interface design', 1, 1, 'In Progress'),
    (2, 'Database Optimization', 'Optimize database queries', 2, 2, 'Completed'),
    (3, 'Project Planning', 'Create project plan', 3, 2, 'Not Started');

-- TimeTracking
INSERT INTO TimeTracking (TimeEntryID, EmployeeID, TaskID, Date, HoursWorked) VALUES
    (1, 1, 1, '2023-01-15', 5.5),
    (2, 2, 2, '2023-03-10', 8.0),
    (3, 3, 3, '2023-02-20', 3.5);

-- VacationRequests
INSERT INTO VacationRequests (RequestID, EmployeeID, StartDate, EndDate, Status) VALUES
    (1, 1, '2023-04-01', '2023-04-10', 'Approved'),
    (2, 2, '2023-05-15', '2023-05-22', 'Pending'),
    (3, 3, '2023-03-05', '2023-03-09', 'Approved');


-- Notifications
INSERT INTO Notifications (NotificationID, RecipientEmployeeID, Message, Timestamp, SenderEmployeeID, Type) VALUES
    (1, 1, 'New project assigned to you', '2023-02-01 09:30:00', 2, 'Information'),
    (2, 2, 'Performance review scheduled', '2023-02-15 14:45:00', 1, 'Reminder'),
    (3, 1, 'Team meeting tomorrow', '2023-02-20 16:15:00', 3, 'Meeting'),
    (4, 3, 'Budget report submitted', '2023-03-05 11:00:00', 2, 'Information');

-- TimeTracking
INSERT INTO TimeTracking (TimeEntryID, EmployeeID, TaskID, Date, HoursWorked) VALUES
    (4, 1, 4, '2023-03-05', 25)


SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'HR' AND E.SalaryAmount > 50000;


SELECT E.FirstName, E.LastName, COUNT(EP.ProjectID) AS ProjectCount
FROM Employees AS E
JOIN EmployeeProjects AS EP ON E.EmployeeID = EP.EmployeeID
GROUP BY E.FirstName, E.LastName
HAVING COUNT(EP.ProjectID) > 1;



SELECT E.FirstName, E.LastName, S.SkillName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE E.DepartmentID = 2;


SELECT N.NotificationID, N.Message, N.Timestamp, N.SenderEmployeeID, N.Type
FROM Notifications AS N
WHERE N.RecipientEmployeeID = 1;


SELECT E.FirstName, E.LastName, P.ProjectName, TT.Date AS TimeTrackingDate, TT.HoursWorked
FROM Employees AS E
JOIN EmployeeProjects AS EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects AS P ON EP.ProjectID = P.ProjectID
LEFT JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND P.ProjectID = TT.TaskID
WHERE P.ProjectName = 'Project A';



SELECT e.EmployeeID, e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;


SELECT p.ProjectName, e.FirstName, e.LastName, e.CurrentStatus
FROM Projects p
LEFT JOIN EmployeeProjects ep ON p.ProjectID = ep.ProjectID
LEFT JOIN Employees e ON ep.EmployeeID = e.EmployeeID;


-- Attempt to insert a record in the EmployeeSkills table with an EmployeeID that doesn't exist in the Employees table
INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES (100, 1); -- Assuming there is no EmployeeID 100 in the Employees table

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (4, 'Ion', 'Georgescu', 'ion.georgescu@email.com', 1, 55000.00, 'Active')



INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (5, 'Ion', 'Barbu', 'ion.barbu@email.com', '0987-654-321', 1, 55000.00, 'Active')


-- TrainingPrograms
INSERT INTO TrainingPrograms (ProgramID, ProgramName, ProgramProvider, ProgramDate, DurationInHours, ProgramLocation) VALUES
    (1, 'SQL Fundamentals', 'Tech Training Inc.', '2023-05-10', 16, 'Online'),
    (2, 'Project Management Workshop', 'Management Solutions', '2023-06-15', 24, 'In-Person'),
    (3, 'Java Programming Bootcamp', 'Code Masters', '2023-07-20', 40, 'Online'),
    (4, 'Data Analytics Certification', 'Analytics Academy', '2023-08-25', 32, 'Online');

-- EmployeeTraining
INSERT INTO EmployeeTraining (EmployeeID, ProgramID, AttendanceDate, Feedback, Performance) VALUES
    (1, 1, '2023-05-12', 'Excellent training!', 'Highly rated'),
    (2, 2, '2023-06-17', 'Great workshop!', 'Satisfactory'),
    (3, 3, '2023-07-22', 'Very informative', 'Excellent performance'),
    (1, 4, '2023-08-27', 'Good content', 'Good performance');



INSERT INTO EmployeeTraining (EmployeeID, ProgramID, AttendanceDate, Feedback, Performance, TrainingStatus, TrainingScore, CompletionDate) VALUES
    (16, 3, '2023-05-12', 'Excellent training!', 'Highly rated', 'Completed', '100.0', '2022-12-11');


-- Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (4, 'Sarah', 'Williams', 'sarah.williams@email.com', '123-789-4560', 2, 60000.00, 'Active'),
    (5, 'Michael', 'Brown', 'michael.brown@email.com', '987-123-4560', 1, 55000.00, 'Active'),
    (6, 'Emily', 'Davis', 'emily.davis@email.com', '555-987-6543', 2, 62000.00, 'Active'),
    (7, 'James', 'Wilson', 'james.wilson@email.com', '456-123-7890', 3, 58000.00, 'Active'),
    (8, 'Olivia', 'Johnson', 'olivia.johnson@email.com', '555-321-6547', 1, 57000.00, 'Active'),
    (9, 'Daniel', 'Smith', 'daniel.smith@email.com', '123-987-6543', 2, 61000.00, 'Active'),
    (10, 'Ava', 'Jones', 'ava.jones@email.com', '789-456-1230', 3, 59000.00, 'Active'),
    (11, 'Matthew', 'Lee', 'matthew.lee@email.com', '123-456-9870', 2, 63000.00, 'Active'),
    (12, 'Sophia', 'Clark', 'sophia.clark@email.com', '555-789-6540', 1, 58000.00, 'Active'),
    (13, 'William', 'Thomas', 'william.thomas@email.com', '555-123-7890', 3, 60000.00, 'Active');


-- VacationRequests
INSERT INTO VacationRequests (RequestID, EmployeeID, StartDate, EndDate, Status) VALUES
    (4, 4, '2023-04-07', '2023-04-09', 'Approved'),
    (5, 5, '2023-04-05', '2023-04-14', 'Approved');


-- Delete employees who don't have an assigned phone number
DELETE FROM Employees
WHERE Phone IS NULL;


-- Delete employees with specific EmployeeIDs
DELETE FROM Employees
WHERE EmployeeID IN (4, 5);

DELETE FROM TimeTracking
WHERE Date BETWEEN '2023-01-01' AND '2023-03-31';


DELETE FROM Notifications
WHERE Message LIKE '%Reminder%';


---List employees in the IT department who have skills in 'Java'
SELECT E.FirstName, E.LastName, D.DepartmentName
FROM Employees E
JOIN Departments D on E.DepartmentID = D.DepartmentID
JOIN EmployeeSkills ES on E.EmployeeID = ES.EmployeeID
JOIN Skills S on ES.SkillID = S.SkillID
WHERE D.DepartmentName = 'Engineering' AND S.SkillName = 'Java'


---List employees who have worked on more than one project and the total hours worked on each project
SELECT E.FirstName, E.LastName, P.ProjectName, COUNT(EP.ProjectID) AS ProjectCount, SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
JOIN TimeTracking TT ON EP.EmployeeID = TT.EmployeeID AND EP.ProjectID = TT.TaskID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, P.ProjectName
HAVING COUNT(EP.ProjectID) > 1;


---Find employees who haven't been assigned any tasks.
Select E.FirstName, E.LastName
From Employees E
LEFT JOIN Tasks T ON E.EmployeeID = T.AssignedTo
Where T.TaskID is NULL


--List employees who have attended training programs with a program name containing something
SELECT  E.FirstName, E.LastName, TP.ProgramName
FROM Employees E
JOIN EmployeeTraining ET on E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP on ET.ProgramID = TP.ProgramID
WHERE TP.ProgramName LIKE '%SQL%' OR TP.ProgramName LIKE '%Java%';


---List employees who have taken more vacation days than the department average.
SELECT E.FirstName, E.LastName, D.DepartmentName, VR.StartDate, VR.EndDate
FROM Employees E
JOIN VacationRequests VR ON E.EmployeeID = VR.EmployeeID
JOIN Departments D ON E.DepartmentID = D.DepartmentID
GROUP BY E.FirstName, E.LastName, D.DepartmentName, VR.StartDate, VR.EndDate
HAVING D.DepartmentName IS NOT NULL
  AND D.DepartmentName IN (
    SELECT D2.DepartmentName
    FROM Departments D2
    JOIN VacationRequests VR2 ON D2.DepartmentID = VR2.EmployeeID
    GROUP BY D2.DepartmentName
    HAVING AVG(DATEDIFF(day, VR2.StartDate, VR2.EndDate)) < AVG(DATEDIFF(day, VR.StartDate, VR.EndDate))
  );


---Find the department with the highest average employee salary.
SELECT D.DepartmentName, AVG(E.SalaryAmount) AS AvgSalary
FROM Departments D
JOIN Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
HAVING AVG(E.SalaryAmount) = (
    SELECT MAX(AvgSalary)
    FROM (
        SELECT D2.DepartmentName, AVG(E2.SalaryAmount) AS AvgSalary
        FROM Departments D2
        JOIN Employees E2 ON D2.DepartmentID = E2.DepartmentID
        GROUP BY D2.DepartmentName
    ) AS Subquery
);

---List employees who have not received any notifications.
SELECT E.FirstName, E.LastName
FROM Employees E
LEFT JOIN Notifications N on E.EmployeeID = N.RecipientEmployeeID
WHERE N.NotificationID is NULL

--List employees who have skills in both Java and SQL

SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES on E.EmployeeID = ES.EmployeeID
JOIN Skills S on ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
INTERSECT
SELECT E.FirstName, E.LastName
FROM  Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S on ES.SkillID = S.SkillID
WhERE S.SkillName = 'SQL';

SELECT E.FirstName, E.LastName, E.SalaryAmount
FROM Employees E
JOIN Departments D on E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Engineering'
ORDER BY E.SalaryAmount DESC;


---1. JOIN with WHERE -> Employees in the Engineering department who have
    --worked on the Project B and have 'Java' skill

SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP on E.EmployeeID = EP.EmployeeId
JOIN Projects P on EP.ProjectID = P.ProjectID
JOIN EmployeeSkills ES on E.EmployeeID = ES.EmployeeID
JOIN Skills S on ES.SkillID = S.SkillID
WHERE E.DepartmentID = 2 AND P.ProjectName = 'Project B' AND S.SkillName = 'Java';


---2. GROUP BY with HAVING -> Find employees who have worked on more than two projects and list the total
    --hours worked for each of them.
SELECT E.FirstName, E.LastName, COUNT(EP.ProjectID) as ProjectCount, SUM(TT.HoursWorked) as TotalHoursWorked
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN TimeTracking TT on EP.EmployeeID = TT.EmployeeID AND EP.ProjectID = TT.TaskID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING COUNT(EP.ProjectID) = 1

---3. OUTER JOIN: List all employees and their assigned projects, including those without any assigned projects
SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
LEFT JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P ON EP.ProjectID = P.ProjectID;

---4. Subquery with all -> Find employees who have the same skill set as Jane Smith
SELECT E1.FirstName, E1.LastName
FROM Employees E1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employees E2
    WHERE E2.FirstName = 'Jane' AND E2.LastName = 'Smith'
    AND E1.FirstName = E2.FirstName AND E1.LastName = E2.LastName
);

---5. Subquery with ANY -> List employees who have worked on a project that John Doe also worked on
SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
WHERE P.ProjectID = ANY  (
    SELECT EP2.ProjectID
    FROM EmployeeProjects EP2
    WHERE EP2.EmployeeID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'John' AND LastName = 'Doe')
    )

---6. Group by -> Find the average salary and the maximum salary in each department
SELECT D.DepartmentName, AVG(E.SalaryAmount) AS AvgSalary, MAX(E.SalaryAmount) as MaxSalary
FROM Employees E
JOIN Departments D on E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName

---7. UNION -> Combine the results of two queries to list employees with the 'Java' skill and employee
-- with the 'SQL' skill
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES on E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
UNION
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';

---8. INTERSECT: Find employees who have both 'Java' and 'SQL' skills
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
INTERSECT
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';

---9. EXCEPT: List employees who have 'Java' skill but not 'SQL' skill
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
EXCEPT
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';


---10. Order by with TOP: Select the top 3 employees with the highest salaries and order them by salary in descending
--order
SELECT TOP 3 E.FirstName, E.LastName, E.SalaryAmount
FROM Employees E
ORDER BY E.SalaryAmount DESC;

--================================================================
    -- Inner Join
SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID;

-- Outer Join
SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
LEFT JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P ON EP.ProjectID = P.ProjectID;



--ALL Subquery -> Find employees who have a higher salary than all employees in Sales

SELECT E.FirstName, E.LastName
FROM Employees E
WHERE E.SalaryAmount > ALL (
    SELECT E2.SalaryAmount
    FROM Employees E2
    WHERE E2.DepartmentID = 3
    )

--ANY Subquery -> List employees who have worked on a project that any employee in the Sales dep.
SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
WHERE P.ProjectID = ANY (
    SELECT EP2.ProjectID
    FROM EmployeeProjects EP2
    JOIN Employees E2 ON EP2.EmployeeID = E2.EmployeeID
    WHERE E2.DepartmentID = 1
);


--GROUP BY with HAVING and Aggregate Functions: Find projects with more than 2 employees and calculate
--the average salary of employees on those projects

SELECT P.ProjectName, COUNT(EP.EmployeeID) as EmployeeCount, AVG(E.SalaryAmount) AS AvgSalary
FROM Projects P
JOIN EmployeeProjects EP ON P.ProjectID = EP.ProjectID
JOIN Employees E ON EP.EmployeeID = E.EmployeeID
GROUP BY P.ProjectName
HAVING COUNT(EP.EmployeeID) > 2;

--DISTINCT: List distinct department names
SELECT DISTINCT DepartmentName
FROM Departments;



-- Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (14, 'Liam', 'Roberts', 'liam.roberts@email.com', '123-456-7890', 2, 56000.00, 'Active'),
    (15, 'Oliver', 'White', 'oliver.white@email.com', '987-654-3210', 1, 65000.00, 'Active'),
    (16, 'Charlotte', 'Harris', 'charlotte.harris@email.com', '555-123-4567', 1, 50000.00, 'Active');


INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus) VALUES
    (17, 'Johnny', 'Woods', 'john.doe@gmail.com', '123-456-7890', 1, 55000.00, 'Active')



INSERT INTO VacationRequests (RequestID, EmployeeID, StartDate, EndDate, Status) VALUES
    (11, 14, '2023-04-05', '2023-04-10', 'Approved'),
    (12, 15, '2023-04-07', '2023-04-15', 'Approved'),
    (13, 16, '2023-04-02', '2023-04-08', 'Approved');

-- Assign employees to projects 1 and 2
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, IsValidAssignment)
VALUES
    (10, 5, 1),  -- John Doe to Project A
    (11, 6, 1)  -- Jane Smith to Project A



-- Assign employees to projects where they should be valid



-- Check if EmployeeID 4 is working on ProjectID 1
SELECT E.FirstName, E.LastName, P.ProjectName, EP.IsValidAssignment
FROM Employees AS E
JOIN EmployeeProjects AS EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects AS P ON EP.ProjectID = P.ProjectID
WHERE E.EmployeeID = 1 -- Specify the EmployeeID you want to check
ORDER BY P.ProjectName;

ALTER TABLE Skills
ADD SkillCategory NVARCHAR(50),
    SkillLevel NVARCHAR(20);


INSERT INTO Skills (SkillID, SkillName, SkillCategory, SkillLevel) VALUES
    (4, 'Python Programming', 'Programming', 'Intermediate'),
    (5, 'Web Development', 'Programming', 'Advanced'),
    (6, 'Data Analysis', 'Analytics', 'Beginner');


SELECT E.EmployeeID, E.FirstName, E.LastName, S.SkillName, S.SkillCategory, S.SkillLevel
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID;


ALTER TABLE Projects
ADD Budget DECIMAL(10, 2),
    Status NVARCHAR(50),
    Priority NVARCHAR(50);

Alter TABLE Notifications
ADD isRead BIT,
    PriorityLevel NVARCHAR(50);


SELECT E.EmployeeID, E.FirstName, E.LastName, N.NotificationID, N.Message,
       N.Timestamp, N.Type, N.IsRead, N.PriorityLevel
FROM Employees E
LEFT JOIN Notifications N on E.EmployeeID = N.RecipientEmployeeID;


ALTER TABLE EmployeeTraining
ADD TrainingStatus NVARCHAR(50) NULL,
    TrainingScore DECIMAL(5, 2) NULL,
    CompletionDate DATE NULL


SELECT
    ET.EmployeeID,
    ET.ProgramID,
    ET.AttendanceDate,
    ET.Feedback,
    ET.Performance,
    ET.TrainingStatus,
    ET.TrainingScore,
    ET.CompletionDate
FROM EmployeeTraining ET;


---================ LABOR 2 EX 1 ==================
---a. already done
---b. already done
---c.
-- Attempt to insert a record in the EmployeeSkills table with an EmployeeID that doesn't exist in the Employees table
INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES (100, 1); -- Assuming there is no EmployeeID 100 in the Employees table

-- Attempt to insert a record in the EmployeeProjects table with a non-existent ProjectID
INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES (1, 100); -- Assuming there is no Project with ProjectID 100 in the Projects table


---d.

---Update: update the salary in the engineering department with a salary above 60000
UPDATE Employees
SET SalaryAmount = 70000
WHERE DepartmentID = 2 AND SalaryAmount > 60000;

---Delete: Delete employees with no phone number
DELETE FROM Employees
Where Phone is null;


---IN without nested query: Update the status of projects with specific IDs
UPDATE Projects
SET Status = 'Completed'
WHERE ProjectID IN (1, 4)

---Between: Update salary of employees from Sales department within a specified range
UPDATE Employees
SET SalaryAmount = 60000
WHERE SalaryAmount BETWEEN 50000 AND 70000

DELETE FROM Employees
WHERE Email LIKE '%gmail.com'


---================ LABOR 2 EX 2 ==================

---6. UNION between sets -> find employees who have skills in either Java or SQL
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
UNION
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S on ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';





--1. Find employees with higher salary than all employees in the Sales department
SELECT E.FirstName, E.LastName, E.SalaryAmount
FROM Employees as E
WHERE E.SalaryAmount > ALL (
    Select E2.SalaryAmount
    From Employees as E2
    WHERE E2.DepartmentID = 3
    )

--2. Find all employees who worked on project in the Engineering Department with their total hours worked
SELECT E.FirstName, E.LastName, P.ProjectName, SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees AS E
JOIN EmployeeProjects AS EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects AS P on EP.ProjectID = P.ProjectID
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
LEFT JOIN TimeTracking AS TT on E.EmployeeID = TT.EmployeeID
WHERE D.DepartmentID = 1
GROUP BY E.FirstName, E.LastName, P.ProjectName


---3. OUTER JOIN -> Find employees and their assigned projects, including the ones
--without a project assigned

SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees AS E
LEFT JOIN EmployeeProjects AS EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects AS P ON EP.ProjectID = P.ProjectID


---4. GROUP BY with AVG and MAX -> average salary and max salary in each department
SELECT D.DepartmentName, AVG(E.SalaryAmount) AS AvgSalary, MAX(E.SalaryAmount) AS MaxSalary
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName;


---5. HAVING with AVG and COUNT -> find departments where the avg salary is above 60000 and the nr of
---employees is at least 3
SELECT D.DepartmentName, AVG(E.SalaryAmount) AS AvgSalary, COUNT(E.EmployeeID) as EmployeeCount
FROM Employees AS E
JOIN Departments AS D on E.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING AVG(E.SalaryAmount) > 60000 AND COUNT(E.EmployeeID) > 3


---7. INTERSECT between sets -> find employees who have skills in both Java or SQL
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
INTERSECT
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';

---8. INTERSECT between sets -> find employees who have skills in Java but not in SQL
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
EXCEPT
SELECT E.FirstName, E.LastName
FROM Employees AS E
JOIN EmployeeSkills AS ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills AS S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL';



SELECT TOP 3 E.FirstName, E.LastName, E.SalaryAmount
FROM Employees AS E
ORDER BY E.SalaryAmount DESC;


-- Modify EmployeeSkills
ALTER TABLE EmployeeSkills
ADD SkillLevel NVARCHAR(20);

-- Remove SkillLevel from Skills
ALTER TABLE Skills
DROP COLUMN SkillLevel;


INSERT INTO Tasks (TaskID, TaskName, Description, ProjectID, AssignedTo, Status) VALUES
    (4, 'Develop Server Side', 'Write Server Side in Rust', 1, 1, 'In Progress');


-- TimeTracking
INSERT INTO TimeTracking (TimeEntryID, EmployeeID, TaskID, Date, HoursWorked) VALUES
    (4, 1, 4, '2023-05-21', 10.0);

--1. Employees who have worked on more than one task
SELECT E.FirstName, E.LastName, T.TaskName, COUNT(TT.TaskID) AS TaskCount, SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees AS E
JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
WHERE E.EmployeeID IN (
    SELECT E.EmployeeID
    FROM Employees AS E
    JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
    JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
    GROUP BY E.EmployeeID
    HAVING COUNT(TT.TaskID) > 1
)
GROUP BY E.EmployeeID, E.FirstName, E.LastName, T.TaskName;


WITH TaskCounts AS (
    SELECT E.EmployeeID, COUNT(DISTINCT T.TaskID) AS TaskCount
    FROM Employees AS E
    JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
    JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
    GROUP BY E.EmployeeID
    HAVING COUNT(DISTINCT T.TaskID) > 1
)

SELECT E.FirstName, E.LastName, T.TaskName,
       TC.TaskCount,
       SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees AS E
JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
JOIN TaskCounts AS TC ON E.EmployeeID = TC.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, T.TaskName, TC.TaskCount


SELECT E.FirstName, E.LastName, D.DepartmentName, COUNT(DISTINCT T.TaskID) AS TaskCount
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName
HAVING COUNT(DISTINCT T.TaskID) > 1;


-- 1. 2 aggregate function, 3 joins, 1 groupby
-- total hours worked for total tasks
SELECT E.FirstName, E.LastName, D.DepartmentName,
       COUNT(DISTINCT T.TaskID) AS TotalTasksWorked,
       SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName;


--employees who have skill in either java or sql and work on projects
SELECT DISTINCT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
    AND E.EmployeeID IN (
        SELECT EmployeeID
        FROM EmployeeProjects
        WHERE EmployeeID = E.EmployeeID
    )
    AND E.EmployeeID IN (
        SELECT EmployeeID
        FROM EmployeeSkills ES2
        JOIN Skills S2 ON ES2.SkillID = S2.SkillID
        WHERE S2.SkillName = 'SQL'
    )
UNION
SELECT DISTINCT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL'
    AND E.EmployeeID IN (
        SELECT EmployeeID
        FROM EmployeeProjects
        WHERE EmployeeID = E.EmployeeID
    )
    AND E.EmployeeID IN (
        SELECT EmployeeID
        FROM EmployeeSkills ES2
        JOIN Skills S2 ON ES2.SkillID = S2.SkillID
        WHERE S2.SkillName = 'Java'
    );


-- SELECT DISTINCT E.FirstName, E.LastName
-- FROM Employees E
-- JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
-- JOIN Skills S ON ES.SkillID = S.SkillID
-- WHERE
--     (S.SkillName = 'Java' OR S.SkillName = 'SQL')  -- Checking for 'Java' or 'SQL'
--     AND E.EmployeeID IN (
--         SELECT EmployeeID
--         FROM EmployeeProjects
--         WHERE EmployeeID = E.EmployeeID
--     );


--employees who know java and sql, with completed proj in eng
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'Java'
INTERSECT
SELECT E.FirstName, E.LastName
FROM Employees E
JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
JOIN Skills S ON ES.SkillID = S.SkillID
WHERE S.SkillName = 'SQL'
AND E.EmployeeID IN (
    SELECT EP.EmployeeID
    FROM EmployeeProjects EP
    WHERE EP.ProjectID IN (
        SELECT ProjectID
        FROM Projects
        WHERE Status = 'Completed'
    )
)
AND E.DepartmentID = (
    SELECT DepartmentID
    FROM Departments
    WHERE DepartmentName = 'Engineering'
);


--top three salaries in descending order
SELECT E1.FirstName, E1.LastName, E1.SalaryAmount
FROM Employees E1
WHERE E1.SalaryAmount >= (
    SELECT TOP 1 SalaryAmount
    FROM (
        SELECT DISTINCT TOP 3 SalaryAmount
        FROM Employees
        ORDER BY SalaryAmount DESC
    ) AS TopThreeSalaries
    ORDER BY SalaryAmount
)
ORDER BY E1.SalaryAmount DESC;



--employees in eng department with completed orjects
SELECT E.FirstName, E.LastName, D.DepartmentName, P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.EmployeeID IN (
    SELECT E1.EmployeeID
    FROM Employees E1
    JOIN EmployeeProjects EP1 ON E1.EmployeeID = EP1.EmployeeID
    JOIN Projects P1 ON EP1.ProjectID = P1.ProjectID
    WHERE P1.Status = 'Completed'
    INTERSECT
    SELECT E2.EmployeeID
    FROM Employees E2
    WHERE E2.DepartmentID = (
        SELECT DepartmentID
        FROM Departments
        WHERE DepartmentName = 'Engineering'
    )
)
ORDER BY E.FirstName, E.LastName;



--total tasks of employees worked on projects and that have skills in python
SELECT E.FirstName, E.LastName, P.ProjectName, D.DepartmentName, COUNT(T.TaskID) AS TotalTasks
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
JOIN Departments D ON E.DepartmentID = D.DepartmentID
FULL OUTER JOIN Tasks T ON T.ProjectID = P.ProjectID AND T.AssignedTo = E.EmployeeID
WHERE E.EmployeeID = ANY (
    SELECT EmployeeID
    FROM EmployeeSkills ES
    WHERE ES.SkillID = ALL (
        SELECT SkillID
        FROM Skills
        WHERE SkillName = 'Python'
    )
)
GROUP BY E.FirstName, E.LastName, P.ProjectName, D.DepartmentName
HAVING COUNT(T.TaskID) > 0
ORDER BY TotalTasks DESC;




--emloyee with advanced skill in java, completed training programs, is active and is not involved in projects
SELECT E.EmployeeID, E.FirstName, E.LastName, TP.ProgramName
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
WHERE E.EmployeeID NOT IN (
    SELECT E1.EmployeeID
    FROM Employees E1
    JOIN EmployeeProjects EP ON E1.EmployeeID = EP.EmployeeID
    JOIN Projects P ON EP.ProjectID = P.ProjectID
    JOIN Tasks T ON P.ProjectID = T.ProjectID AND T.AssignedTo = E1.EmployeeID
)
AND E.CurrentStatus = 'Active'
AND E.EmployeeID IN (
    SELECT E2.EmployeeID
    FROM Employees E2
    JOIN EmployeeSkills ES ON E2.EmployeeID = ES.EmployeeID
    JOIN Skills S ON ES.SkillID = S.SkillID
    WHERE S.SkillName = 'Java'
    AND ES.SkillLevel = 'Advanced'
)
AND E.EmployeeID IN (
    SELECT EmployeeID
    FROM EmployeeTraining
)
GROUP BY E.EmployeeID, E.FirstName, E.LastName, TP.ProgramName
ORDER BY E.EmployeeID;


--INSERT DATA TO CHECK QUERY
---count of skills + filter employees who were not involved in projects with a higher end date

SELECT E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName,
       COUNT(ES.SkillID) AS NumberOfSkills,
       MAX(P.EndDate) AS LatestProjectEndDate
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Projects P ON EXISTS (
    SELECT *
    FROM EmployeeProjects EP
    WHERE EP.EmployeeID = E.EmployeeID
      AND EP.ProjectID = P.ProjectID
)
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName
EXCEPT
SELECT E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName,
       COUNT(ES.SkillID) AS NumberOfSkills,
       MAX(P.EndDate) AS LatestProjectEndDate
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Projects P ON EXISTS (
    SELECT *
    FROM EmployeeProjects EP
    WHERE EP.EmployeeID = E.EmployeeID
      AND EP.ProjectID = P.ProjectID
      AND P.EndDate > '2023-12-12'
)
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName;



--- count of completed training programs and the latest training date

SELECT E.EmployeeID, E.FirstName, E.LastName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms,
       MAX(TP.ProgramDate) AS CompletionTrainingDate
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
WHERE ET.TrainingStatus = 'Completed'
GROUP BY E.EmployeeID, E.FirstName, E.LastName

UNION

SELECT E.EmployeeID, E.FirstName, E.LastName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms,
       MAX(TP.ProgramDate) AS LatestTrainingDate
FROM Employees E
LEFT JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
LEFT JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
WHERE ET.TrainingStatus = 'Completed' OR ET.TrainingStatus IS NULL
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING COUNT(ET.ProgramID) = 0;



--total projects and the date of the latest projects end date
SELECT E.FirstName,
    E.LastName,
    D.DepartmentName,
    COUNT(DISTINCT EP.ProjectID) AS TotalProjects,
    MAX(P.EndDate) AS LatestProjectEndDate
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID
WHERE E.CurrentStatus = 'Active'
GROUP BY E.FirstName, E.LastName, D.DepartmentName
ORDER BY TotalProjects DESC, LatestProjectEndDate;


--all employees that assigned work on projects and that do not have assigned projects and their tasks
SELECT E.FirstName, E.LastName, D.DepartmentName, P.ProjectName, COUNT(T.TaskID) AS TotalTasks
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P ON EP.ProjectID = P.ProjectID
LEFT JOIN Tasks T ON T.AssignedTo = E.EmployeeID AND T.ProjectID = P.ProjectID
GROUP BY E.FirstName, E.LastName, D.DepartmentName, P.ProjectName
HAVING COUNT(T.TaskID) > 0

UNION

SELECT E.FirstName, E.LastName, D.DepartmentName, 'Not Assigned' AS ProjectName, 0 AS TotalTasks
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.EmployeeID NOT IN (
    SELECT DISTINCT EP.EmployeeID
    FROM EmployeeProjects EP
)
ORDER BY TotalTasks DESC, FirstName, LastName;









SELECT E.FirstName, E.LastName, P.ProjectName
FROM Employees E
LEFT JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P ON EP.ProjectID = P.ProjectID;





---?????????------- de intrebat
ALTER TABLE TimeTracking
DROP COLUMN EmployeeID;


