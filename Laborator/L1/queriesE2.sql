use employee

INSERT INTO Departments (DepartmentName)
VALUES
    ('HR'),
    ('IT'),
    ('Sales');

INSERT INTO Employees (FirstName, LastName, Email, Phone, DepartmentID, SalaryAmount, CurrentStatus, NotificationType)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890', 1, 60000.00, 'Active', 'Email'),
    ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', 2, 70000.00, 'Active', 'SMS'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', '555-555-5555', 1, 55000.00, 'Inactive', 'Email');



INSERT INTO Projects (ProjectName, StartDate, EndDate)
VALUES
    ('Autonomous Driving', '2023-01-01', '2023-12-31'),
    ('Damage Detection', '2023-02-01', '2023-11-30'),
    ('Game Development', '2023-03-01', '2023-10-31');


-- John Doe and Jane Smith work on Project A
INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES
    (1, 1), -- John Doe on Project A
    (2, 1); -- Jane Smith on Project A

-- Jane Smith also works on Project B
INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES
    (2, 2); -- Jane Smith on Project B

-- Alice Johnson works on Project C
INSERT INTO EmployeeProjects (EmployeeID, ProjectID)
VALUES
    (3, 3); -- Alice Johnson on Project C


INSERT INTO Skills (SkillName)
VALUES
    ('Java'),
    ('SQL'),
    ('Project Management');


-- John Doe has Java and SQL skills
INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES
    (1, 1), -- John Doe has Java skill
    (1, 2); -- John Doe has SQL skill

-- Jane Smith has SQL and Project Management skills
INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES
    (2, 2), -- Jane Smith has SQL skill
    (2, 3); -- Jane Smith has Project Management skill

-- Alice Johnson has Java skill
INSERT INTO EmployeeSkills (EmployeeID, SkillID)
VALUES
    (3, 1); -- Alice Johnson has Java skill



INSERT INTO Tasks (TaskName, Description, ProjectID, AssignedTo, Status)
VALUES
    ('Refactor Java Classes', 'Implement using vavr', 1, 1, 'In Progress'),
    ('Update DataBase', 'Optimize SQL queries', 2, 2, 'Pending'),
    ('Design UI', 'Design the UI of the program', 1, 1, 'Completed');


INSERT INTO TimeTracking (EmployeeID, TaskID, Date, HoursWorked)
VALUES
    (1, 1, '2023-01-05', 4.5),
    (2, 2, '2023-02-10', 3.0),
    (1, 3, '2023-01-15', 8.0);


INSERT INTO VacationRequests (EmployeeID, StartDate, EndDate, Status)
VALUES
    (1, '2023-03-01', '2023-03-10', 'Approved'),
    (2, '2023-04-15', '2023-04-20', 'Pending'),
    (3, '2023-05-05', '2023-05-10', 'Approved');



INSERT INTO Notifications (RecipientEmployeeID, Message, Timestamp, SenderEmployeeID, Type)
VALUES
    (1, 'New task assigned to you', '2023-01-10 08:00:00', 2, 'Alert'),
    (2, 'Project update', '2023-02-15 14:30:00', 1, 'Information'),
    (3, 'Training program reminder', '2023-03-05 10:15:00', 2, 'Reminder');



INSERT INTO TrainingPrograms (ProgramName, ProgramProvider, ProgramDate, DurationInHours, ProgramLocation)
VALUES
    ('Java Programming Workshop', 'Tech Institute', '2023-04-01', 8, 'Virtual'),
    ('Project Management Certification', 'PM Academy', '2023-05-01', 16, 'In-Person'),
    ('SQL Fundamentals', 'Tech Institute', '2023-06-01', 6, 'Virtual');


-- John Doe and Jane Smith attend the Java Programming Workshop
INSERT INTO EmployeeTraining (EmployeeID, ProgramID, AttendanceDate)
VALUES
    (1, 1, '2023-04-01'),
    (2, 1, '2023-04-01');

-- Jane Smith and Alice Johnson attend the Project Management Certification
INSERT INTO EmployeeTraining (EmployeeID, ProgramID, AttendanceDate)
VALUES
    (2, 2, '2023-05-01'),
    (3, 2, '2023-05-01');

-- Alice Johnson attends the SQL Fundamentals program
INSERT INTO EmployeeTraining (EmployeeID, ProgramID, AttendanceDate)
VALUES
    (3, 3, '2023-06-01');


SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    P.ProjectName
FROM Employees E
JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
JOIN Projects P ON EP.ProjectID = P.ProjectID;



SELECT
    E.FirstName,
    E.LastName,
    D.DepartmentName,
    S.SkillName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Skills S ON ES.SkillID = S.SkillID;


SELECT
    E.FirstName,
    E.LastName,
    TP.ProgramName,
    TP.ProgramDate
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID;



SELECT
    E.FirstName,
    E.LastName,
    TP.ProgramName,
    TP.ProgramDate
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID;


SELECT
    E.FirstName,
    E.LastName,
    T.TaskName,
    TT.Date,
    TT.HoursWorked
FROM Employees E
JOIN TimeTracking TT ON E.EmployeeID = TT.EmployeeID
JOIN Tasks T ON TT.TaskID = T.TaskID;



SELECT
    E.FirstName,
    E.LastName,
    VR.StartDate,
    VR.EndDate,
    VR.Status
FROM Employees E
JOIN VacationRequests VR ON E.EmployeeID = VR.EmployeeID;


SELECT
    R.FirstName AS RecipientFirstName,
    R.LastName AS RecipientLastName,
    S.FirstName AS SenderFirstName,
    S.LastName AS SenderLastName,
    N.Message,
    N.Timestamp,
    N.Type
FROM Notifications N
JOIN Employees R ON N.RecipientEmployeeID = R.EmployeeID
JOIN Employees S ON N.SenderEmployeeID = S.EmployeeID;


-- Update existing records in EmployeeTraining with feedback and performance data
UPDATE EmployeeTraining
SET Feedback = 'Improved', Performance = 'Good'
WHERE EmployeeID = 1;


-- Update existing records in EmployeeTraining with feedback and performance data
UPDATE EmployeeTraining
SET Feedback = 'Remained persistent', Performance = 'Good'
WHERE EmployeeID = 2;

UPDATE EmployeeTraining
SET Feedback = 'Kinda lazy', Performance = 'Medium'
WHERE EmployeeID = 3;

SELECT ET.EmployeeID, E.FirstName, E.LastName, ET.Feedback, ET.Performance
FROM EmployeeTraining ET
INNER JOIN Employees E ON ET.EmployeeID = E.EmployeeID;


SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Email,
    E.Phone,
    D.DepartmentName,
    ET.Feedback,
    ET.Performance,
    TP.ProgramName,
    TP.ProgramProvider,
    TP.ProgramDate,
    TP.DurationInHours,
    TP.ProgramLocation
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
JOIN Departments D ON E.DepartmentID = D.DepartmentID;
