-- Projects
SELECT DISTINCT p.projectId
    , p.projectTitle
    , p.startDate
    , p.expectedEndDate
    , p.endDate
    , p.statusEN
    , e.employeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
FROM projects AS p
    LEFT JOIN employees AS e ON e.employeeId = p.projectManagerEmployeeId
WHERE p.endDate IS NULL
    AND p.projectTitle NOT LIKE 'Projet interne%'
ORDER BY p.startDate ASC
    , p.expectedEndDate ASC
    , p.projectTitle ASC
;
