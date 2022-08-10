-- Employees
SELECT DISTINCT
    e.employeeId
    , e.employeeInternalNumber
    , e.statusEN
    , e.name
    , e.firstName
    , e.sexEN
    , e.languageEN
    , e.email
    , e.countryOfOriginEN
    , e.birthDate
    , e.hireDate
    , e.employementEndDate
    , e.workplaceEN
    , JSON_VALUE(e.positions, '$.positionEN') AS positionEN
FROM employees AS e
WHERE e.statusEN = 'Active'
    AND e.employementEndDate IS NULL
    AND e.email LIKE '%@forensik.ca'
ORDER BY e.name ASC
    , e.firstName ASC
;
