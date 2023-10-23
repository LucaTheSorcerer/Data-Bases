use employeeLastV

create schema dbo



-- Master table for Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Master table for Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    DepartmentID INT REFERENCES Departments(DepartmentID),
    SalaryAmount DECIMAL(10, 2) CHECK (SalaryAmount >= 0),
    CurrentStatus NVARCHAR(50),
);

-- Master table for Projects
CREATE TABLE Projects(
    ProjectID INT PRIMARY KEY,
    ProjectName NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    CHECK (EndDate > StartDate)
);

-- Relationship table between Employees and Projects
CREATE TABLE EmployeeProjects(
    EmployeeID INT REFERENCES Employees(EmployeeID),
    ProjectID INT REFERENCES Projects(ProjectID),
    PRIMARY KEY (EmployeeID, ProjectID)
);

-- Master table for Skills
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY,
    SkillName NVARCHAR(50)
);

-- Relationship table between Employees and Skills
CREATE TABLE EmployeeSkills(
    EmployeeID INT REFERENCES Employees(EmployeeID),
    SkillID INT REFERENCES Skills(SkillID),
    PRIMARY KEY (EmployeeID, SkillID)
);

-- Master table for Tasks
CREATE TABLE Tasks(
    TaskID INT PRIMARY KEY,
    TaskName NVARCHAR(100),
    Description NVARCHAR(MAX),
    ProjectID INT REFERENCES Projects(ProjectID),
    AssignedTo INT REFERENCES Employees(EmployeeID),
    Status NVARCHAR(50)
);

-- Master table for TimeTracking
CREATE TABLE TimeTracking(
    TimeEntryID INT PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    TaskID INT REFERENCES Tasks(TaskID),
    Date DATE,
    HoursWorked DECIMAL(5,2)
);

-- Master table for VacationRequests
CREATE TABLE VacationRequests(
    RequestID INT PRIMARY KEY,
    EmployeeID INT REFERENCES Employees(EmployeeID),
    StartDate DATE,
    EndDate DATE,
    CHECK (EndDate > StartDate),
    Status NVARCHAR(50)
);

-- Master table for Notifications
CREATE TABLE Notifications(
    NotificationID INT PRIMARY KEY,
    RecipientEmployeeID INT REFERENCES Employees(EmployeeID),
    Message NVARCHAR(MAX),
    Timestamp DATETIME,
    SenderEmployeeID INT REFERENCES Employees(EmployeeID),
    Type NVARCHAR(50)
);

-- Master table for TrainingPrograms
CREATE TABLE TrainingPrograms (
    ProgramID INT PRIMARY KEY,
    ProgramName NVARCHAR(100),
    ProgramProvider NVARCHAR(100),
    ProgramDate DATE,
    DurationInHours INT,
    ProgramLocation NVARCHAR(100)
);

-- Relationship table between Employees and TrainingPrograms
CREATE TABLE EmployeeTraining (
    EmployeeID INT REFERENCES Employees(EmployeeID),
    ProgramID INT REFERENCES TrainingPrograms(ProgramID),
    AttendanceDate DATE,
    Feedback NVARCHAR(MAX) NULL,
    Performance NVARCHAR(50) NULL,
    PRIMARY KEY (EmployeeID, ProgramID)
);

