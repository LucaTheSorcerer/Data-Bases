use employeeLastV


-- 1.
-- total hours worked for total tasks

SELECT E.FirstName, E.LastName, D.DepartmentName,
       COUNT(DISTINCT T.TaskID) AS TotalTasksWorked,
       SUM(TT.HoursWorked) AS TotalHoursWorked
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
JOIN Tasks AS T ON E.EmployeeID = T.AssignedTo
JOIN TimeTracking AS TT ON E.EmployeeID = TT.EmployeeID AND T.TaskID = TT.TaskID
WHERE E.EmployeeID = ANY (
    SELECT EmployeeID
    FROM TimeTracking
    GROUP BY EmployeeID
    HAVING SUM(HoursWorked) > 10
)
GROUP BY E.FirstName, E.LastName, D.DepartmentName, E.EmployeeID;


-- 2.
--employees who have skill in either java or sql and work on projects
-- SELECT E.FirstName, E.LastName, D.DepartmentName, P.ProjectName
-- FROM Employees E
-- JOIN Departments D ON E.DepartmentID = D.DepartmentID
-- JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
-- JOIN Projects P ON EP.ProjectID = P.ProjectID
-- WHERE (D.DepartmentName = 'Engineering' OR D.DepartmentName = 'Marketing')
--     AND E.CurrentStatus = 'Active'
-- ORDER BY E.FirstName, E.LastName, D.DepartmentName, P.ProjectName;


-- Find employees assigned to high-priority projects OR with specific skills
SELECT DISTINCT E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeProjects EP ON E.EmployeeID = EP.EmployeeID
LEFT JOIN Projects P ON EP.ProjectID = P.ProjectID
LEFT JOIN EmployeeSkills ES ON E.EmployeeID = ES.EmployeeID
LEFT JOIN Skills S ON ES.SkillID = S.SkillID
WHERE P.Priority = 'High'
    OR S.SkillName IN ('Java', 'SQL')
ORDER BY E.EmployeeID;



-- 3.
--employees who know java and sql, with active proj in eng
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



-- 4.
--top three salaries in descending order
SELECT E1.FirstName, E1.LastName, E1.SalaryAmount
FROM Employees E1
WHERE E1.SalaryAmount IN (
    SELECT DISTINCT TOP 3 SalaryAmount
    FROM Employees
    ORDER BY SalaryAmount DESC
)
ORDER BY E1.SalaryAmount DESC;


-- 5.
--employees in eng department with completed projects
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
ORDER BY E.FirstName;




-- 6.
SELECT E.FirstName, E.LastName, E.SalaryAmount, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE E.SalaryAmount >= ALL (
    SELECT MAX(E2.SalaryAmount)
    FROM Employees E2
    WHERE E2.DepartmentID = D.DepartmentID
    GROUP BY E2.DepartmentID
)



-- List employees with the highest average training scores in each department


-- 7.
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


-- 8.
-- List of employees who have not attended any training programs
SELECT E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
LEFT JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName
EXCEPT
SELECT E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, D.DepartmentName;


-- 9.
--- count of training programs and the latest training date
SELECT E.EmployeeID, E.FirstName, E.LastName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms,
       MAX(TP.ProgramDate) AS LatestTrainingDate
FROM Employees E
JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
GROUP BY E.EmployeeID, E.FirstName, E.LastName

UNION

SELECT E.EmployeeID, E.FirstName, E.LastName,
       COUNT(ET.ProgramID) AS TotalTrainingPrograms,
       MAX(TP.ProgramDate) AS LatestTrainingDate
FROM Employees E
LEFT JOIN EmployeeTraining ET ON E.EmployeeID = ET.EmployeeID
LEFT JOIN TrainingPrograms TP ON ET.ProgramID = TP.ProgramID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
HAVING COUNT(ET.ProgramID) = 0;


-- 10.
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
