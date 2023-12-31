use master

INSERT INTO Departments (DepartmentName)
VALUES ('HR'), ('Finance'), ('IT');


INSERT INTO Employees (FirstName, LastName, Email, Phone, DepartmentID)
VALUES
    ('John', 'Doe', 'johndoe@example.com', '123-456-7890', 1),
    ('Jane', 'Smith', 'janesmith@example.com', '987-654-3210', 2),
    ('Michael', 'Johnson', 'michaeljohnson@example.com', '555-123-4567', 3);


SELECT EmployeeID, FirstName, LastName, Email, Phone, DepartmentID
FROM Employees;

SELECT e.EmployeeID, e.FirstName, e.LastName, e.Email, e.Phone, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;


INSERT INTO Projects (ProjectName, StartDate, EndDate)
VALUES
    ('Project A', '2023-01-01', '2023-02-28'),
    ('Project B', '2023-03-15', '2023-05-31');


INSERT INTO Tasks (TaskName, Description, ProjectID, AssignedTo, Status)
VALUES
    ('Task 1', 'Complete task 1', 1, 1, 'Active'),
    ('Task 2', 'Complete task 2', 1, 2, 'Active'),
    ('Task 3', 'Complete task 3', 2, 1, 'Active');


INSERT INTO Skills (SkillName)
VALUES ('SQL'), ('Java'), ('Python'), ('Project Management');


INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES
    (1, 1),
    (1, 2),
    (2, 2),
    (3, 3),
    (3, 4);


INSERT INTO TimeTracking (EmployeeID, TaskID, Date, HoursWorked)
VALUES
    (1, 1, '2023-01-05', 8.5),
    (1, 2, '2023-01-06', 7.0),
    (2, 3, '2023-03-20', 6.5);


INSERT INTO Salary (EmployeeID, SalaryAmount)
VALUES
    (1, 60000.00),
    (2, 75000.00),
    (3, 80000.00);


INSERT INTO VacationRequests (EmployeeID, StartDate, EndDate, Status)
VALUES
    (1, '2023-03-01', '2023-03-05', 'Approved'),
    (2, '2023-04-10', '2023-04-15', 'Pending'),
    (3, '2023-02-15', '2023-02-20', 'Declined');


INSERT INTO Notifications (EmployeeID, Message, Timestamp, SenderEmployeeID)
VALUES
    (1, 'You have a new task assigned.', '2023-01-02 10:30:00', 2),
    (2, 'Project update: Meeting scheduled.', '2023-03-16 14:45:00', 1),
    (3, 'Important announcement: Company policy update.', '2023-02-18 09:15:00', 1);


SELECT e.FirstName, e.LastName, s.SkillName
FROM Employees e
INNER JOIN EmployeeSkills es ON e.EmployeeID = es.EmployeeID
INNER JOIN Skills s ON es.SkillID = s.SkillID;


SELECT e.FirstName, e.LastName, vr.StartDate, vr.EndDate, vr.Status
FROM VacationRequests vr
INNER JOIN Employees e ON vr.EmployeeID = e.EmployeeID;


SELECT p.ProjectName, t.TaskName, t.Description, t.Status
FROM Projects p
INNER JOIN Tasks t ON p.ProjectID = t.ProjectID;


SELECT e.FirstName, e.LastName, n.Message, n.Timestamp
FROM Notifications n
INNER JOIN Employees e ON n.EmployeeID = e.EmployeeID;


-- Insert sample training program data
INSERT INTO TrainingPrograms (ProgramName, ProgramProvider, ProgramDate, DurationInHours, ProgramLocation)
VALUES
    ('Introduction to Python', 'Google', '2023-10-20', 16, 'Training Center A'),
    ('Effective Communication Skills', 'Apple Inc', '2023-11-05', 8, 'Online'),
    ('Software Development in Java', 'MSG', '2023-09-15', 24, 'Tech Center B');


-- Insert data to associate employees with training programs
-- For demonstration purposes, assume EmployeeID 1 and 2 attended the first program, and EmployeeID 3 attended the second program.
INSERT INTO EmployeeTraining (EmployeeID, ProgramID)
VALUES
    (1, 1), -- Employee 1 attended Program 1
    (2, 1), -- Employee 2 attended Program 1
    (3, 2); -- Employee 3 attended Program 2


    -- Query to retrieve employee details along with training program information
SELECT e.FirstName, e.LastName, tp.ProgramName, tp.ProgramDate, tp.ProgramProvider
FROM Employees AS e
INNER JOIN EmployeeTraining AS et ON e.EmployeeID = et.EmployeeID
INNER JOIN TrainingPrograms AS tp ON et.ProgramID = tp.ProgramID;




-- Query time tracking data
SELECT
    tt.TimeEntryID,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    t.TaskName,
    tt.Date,
    tt.HoursWorked
FROM TimeTracking tt
JOIN Employees e ON tt.EmployeeID = e.EmployeeID
JOIN Tasks t ON tt.TaskID = t.TaskID;
