-- Database: EmployeeManagement
-- Purpose: This database stores information related to employees, departments, projects, and skills.
-- Author: Luca Tudor
-- Date: October 15, 2023



CREATE TABLE Departments (
    ---DepartmentID: A unique identifier for each department
    ---DepartmentName: The name of the department
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);


---Employees Departments - one to many
CREATE TABLE Employees (
    ---EmployeeID: A unique identifier
    ---FirstName: The first name of the employee
    ---LastName: The last name of the employee
    ---Email: The email address of the employees
    ---Phone: The contact phone number of the employees
    --DepartmentID: A reference to the department the employee belongs to
    ---Purpose: This table contains employee information and their departments
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
    ---ProjectID: A unique identifier for each project
    ---ProjectName: The name of the project
    ---StartDate: The start date of the project
    ---EndDate: The end date of the project
    ---Purpose: This table stores details about various projects
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName NVARCHAR(50),
    StartDate DATE,
    EndDate DATE
);

---Employee Tasks - one to many
CREATE TABLE Tasks(
    ---TaskID: A unique identifier for each task
    ---TaskName: The name of the task
    ---Description: A detailed description of the task
    ---ProjectID: A reference to the project the task belongs to
    ---AssignedTo: A reference to the employee responsible for the task
    ---Status: The current status of the task
    ---Purpose: This table tracks tasks in relation to project and employees
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
    ---SkillID: A unique identifier for each skill
    ---SkillName: The name of the skill
    ---Purpose: This stable stores information about various skills that employees can possess
    SkillID INT IDENTITY(1,1) PRIMARY KEY,
    SkillName NVARCHAR(50),
)

---Employee Skills many to many
CREATE TABLE EmployeeSkills(
    ---EmployeeSkillID: A unique identifier for each employee-skill association
    ---EmployeeID: A reference to the employee possessing the skill
    ---SkillID: A reference to the skill the employees possesses
    ---Purpose: This table represents the many-to-many relationship between
    ---employees and skills, indicating the skills possessed by each employee
    EmployeeSkillID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    SkillID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

---Employees TimeTracking one to many
CREATE TABLE TimeTracking(
    ---TimeEntryID: A unique identifier for each time tracking entry
    ---EmployeeID: A reference to the employee recording time
    ---TaskID: A reference to the task to which the time entry is related
    ---Date: The date of the time entry
    ---HoursWorked: The number of hours worked for the task on the specified date
    ---Purpose: This table records time tracking entries for various tasks and employees
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
    ---SalaryID: A unique identifier for each salary record
    ---EmployeeID: A reference to the employee to whom the salary is associated
    ---SalaryAmount: The amount of the salary
    ---Purpose: This table stores salary information for employees
    SalaryID INT IDENTITY (1,1) PRIMARY KEY,
    EmployeeID INT,
    SalaryAmount DECIMAL(10, 2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
);

---Employee VacationRequests one to many
CREATE TABLE VacationRequests(
    ---RequestID: A unique identifier for each vacation request
    ---EmployeeID: A reference to the employees making the request
    ---StartDate: The start date of the vacation
    ---EndDate: The end date of the vacation
    ---Status: The status of the vacation request
    ---Purpose: This table tracks vacation requests
    RequestID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    StartDate DATE,
    EndDate DATE,
    Status NVARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

---Employee Notifications one to many
CREATE TABLE Notifications(
    ---NotificationID: A unique identifier for each notification
    ---EmployeeID: A reference to the employee receiving
    ---Message: The content of the notification
    ---Timestamp: The date and time of the notification
    ---SenderEmployeeID: The employee that sent the notification
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    Message NVARCHAR(MAX),
    Timestamp DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
);

-- Alter the Notifications Table to Add a New Column
ALTER TABLE Notifications
ADD SenderEmployeeID INT;

-- Add a Foreign Key Constraint for the New Column
ALTER TABLE Notifications
ADD CONSTRAINT FK_SenderEmployee
FOREIGN KEY (SenderEmployeeID)
REFERENCES Employees(EmployeeID);



-- Add a Foreign Key in the Employees Table
ALTER TABLE Employees
ADD DepartmentID INT;

-- Create the Foreign Key Constraint
ALTER TABLE Employees
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID);


ALTER TABLE Employees
ADD CONSTRAINT UQ_Employee_Email UNIQUE (Email);


ALTER TABLE Employees
ALTER COLUMN FirstName NVARCHAR(50) NOT NULL;
ALTER TABLE Employees
ALTER COLUMN LastName NVARCHAR(50) NOT NULL;


ALTER TABLE Projects
ADD CONSTRAINT CHK_Project_Dates CHECK (EndDate > StartDate);



ALTER TABLE Tasks
ADD CONSTRAINT DF_Task_Status DEFAULT ('Active') FOR Status;


ALTER TABLE EmployeeSkills
ADD FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE Salary
ADD CONSTRAINT CHK_Salary_Amount CHECK (SalaryAmount >= 0);

