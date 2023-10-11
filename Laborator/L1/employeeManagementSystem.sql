CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);


---Employees Departments - one to many
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),

);

-- Add a Foreign Key in the Employees Table
ALTER TABLE Employees
ADD DepartmentID INT;

-- Create the Foreign Key Constraint
ALTER TABLE Employees
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID);



---Project Tasks - one to many
CREATE TABLE Projects(
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

---Employee Tasks - one to many
CREATE TABLE Tasks(
    TaskID INT IDENTITY(1,1) PRIMARY KEY,
    TaskName NVARCHAR(100),
    Description NVARCHAR(MAX),
    ProjectID INT,
    AssignedTo INT,
    Status NVARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AssignedTo) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Skills (
    SkillID INT IDENTITY(1,1) PRIMARY KEY,
    SkillName NVARCHAR(50),
)

---Employee Skills many to many
CREATE TABLE EmployeeSkills(
    EmployeeSkillID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    SkillID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

---Employees TimeTracking one to many
CREATE TABLE TimeTracking(
    TimeEntryID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    TaskID INT,
    Date DATE,
    HoursWorked DECIMAL(5,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID)
);

---Employee Salary one to many
CREATE TABLE Salary
(
    SalaryID     INT IDENTITY (1,1) PRIMARY KEY,
    EmployeeID   INT,
    SalaryAmount DECIMAL(10, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
);

---Employee VacationRequests one to many
CREATE TABLE VacationRequests(
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

---Employee Notifications one to many
CREATE TABLE Notifications(
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    Message NVARCHAR(MAX),
    Timestamp DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
);

