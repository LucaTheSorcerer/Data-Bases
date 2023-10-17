use employee

-- Master table for Departments
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Each employee belongs to one department (One-to-Many with Departments)
-- An employee can have multiple skills (Many-to-Many with Skills through EmployeeSkills)
-- An employee can work on multiple projects (Many-to-Many with Projects through EmployeeProjects)
-- An employee can be assigned multiple tasks (One-to-Many with Tasks)
-- An employee can have multiple time entries (One-to-Many with TimeTracking)
-- An employee can request multiple vacations (One-to-Many with VacationRequests)
-- An employee can receive multiple notifications (One-to-Many with Notifications as Recipient)
-- An employee can send multiple notifications (One-to-Many with Notifications as Sender)
-- An employee can attend multiple training programs (One-to-Many with EmployeeTraining)
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    DepartmentID INT REFERENCES Departments(DepartmentID),
    SalaryAmount DECIMAL(10, 2) CHECK (SalaryAmount >= 0),
    CurrentStatus NVARCHAR(50), -- Using VARCHAR for Status
    NotificationType NVARCHAR(50) -- Using VARCHAR for NotificationType
);

-- Each project can have multiple tasks (One-to-Many with Tasks)
-- A project can have multiple employees (Many-to-Many with Employees through EmployeeProjects)
CREATE TABLE Projects(
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    CHECK (EndDate > StartDate)
);
-- Many-to-Many relationship table between Employees and Projects
CREATE TABLE EmployeeProjects(
    EmployeeID INT REFERENCES Employees(EmployeeID),
    ProjectID INT REFERENCES Projects(ProjectID),
    PRIMARY KEY (EmployeeID, ProjectID)
);

-- Master table for Skills
-- A skill can belong to multiple employees (Many-to-Many with Employees through EmployeeSkills)
CREATE TABLE Skills (
    SkillID INT IDENTITY(1,1) PRIMARY KEY,
    SkillName NVARCHAR(50)
);

-- Many-to-Many relationship table between Employees and Skills
CREATE TABLE EmployeeSkills(
    EmployeeID INT REFERENCES Employees(EmployeeID),
    SkillID INT REFERENCES Skills(SkillID),
    PRIMARY KEY (EmployeeID, SkillID)
);

-- Each task is related to one project (One-to-Many with Projects)
-- Each task is assigned to one employee (One-to-Many with Employees)
CREATE TABLE Tasks(
    TaskID INT IDENTITY(1,1) PRIMARY KEY,
    TaskName NVARCHAR(100),
    Description NVARCHAR(MAX),
    ProjectID INT REFERENCES Projects(ProjectID),
    AssignedTo INT REFERENCES Employees(EmployeeID),
    Status NVARCHAR(50) -- Using VARCHAR for Status
);

-- Each time entry is for one employee (One-to-Many with Employees)
-- Each time entry is related to one task (One-to-Many with Tasks)
CREATE TABLE TimeTracking(
    TimeEntryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    TaskID INT REFERENCES Tasks(TaskID),
    Date DATE,
    HoursWorked DECIMAL(5,2)
);

-- Each vacation request is for one employee (One-to-Many with Employees)
CREATE TABLE VacationRequests(
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    StartDate DATE,
    EndDate DATE,
    CHECK (EndDate > StartDate),
    Status NVARCHAR(50) -- Using VARCHAR for Status
);

-- Each notification has one recipient (One-to-Many with Employees as Recipient)
-- Each notification has one sender (One-to-Many with Employees as Sender)
CREATE TABLE Notifications(
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    RecipientEmployeeID INT REFERENCES Employees(EmployeeID),
    Message NVARCHAR(MAX),
    Timestamp DATETIME,
    SenderEmployeeID INT REFERENCES Employees(EmployeeID),
    Type NVARCHAR(50) -- Using VARCHAR for NotificationType
);

-- Master table for TrainingPrograms
-- Each training program can have multiple employee attendees (One-to-Many with EmployeeTraining)
CREATE TABLE TrainingPrograms (
    ProgramID INT IDENTITY(1,1) PRIMARY KEY,
    ProgramName NVARCHAR(100),
    ProgramProvider NVARCHAR(100),
    ProgramDate DATE,
    DurationInHours INT,
    ProgramLocation NVARCHAR(100)
);

-- Each training attendance entry is for one employee (One-to-Many with Employees)
-- Each training attendance entry is related to one training program (One-to-Many with TrainingPrograms)
CREATE TABLE EmployeeTraining (
    EmployeeTrainingID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    ProgramID INT REFERENCES TrainingPrograms(ProgramID),
    AttendanceDate DATE
);