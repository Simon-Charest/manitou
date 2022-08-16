-- Employee Salaries
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
	, DATEDIFF(year, e.birthDate, GETDATE()) AS age
    , e.hireDate
    , e.employementEndDate
	, DATEDIFF(day, e.hireDate, e.employementEndDate) AS employementDay
    , e.workplaceEN
    , JSON_VALUE(e.positions, '$.position.positionEN') AS positionEN
	, JSON_VALUE(e.activityPeriods, '$.activityPeriod.divisionEN') AS divisionEN
	, s.unit
	, MIN(CAST(s.value AS MONEY)) AS valueMin
	, AVG(CAST(s.value AS MONEY)) AS valueAvg
	, MAX(CAST(s.value AS MONEY)) AS valueMax
	, ROUND(MIN(CAST(s.value AS MONEY)) * 1321.5859030837, 0) AS annualValueMin
	, ROUND(AVG(CAST(s.value AS MONEY)) * 1321.5859030837, 0) AS annualValueAvg
	, ROUND(MAX(CAST(s.value AS MONEY)) * 1321.5859030837, 0) AS annualValueMax
FROM employeeSalaries AS s
	LEFT JOIN employees AS e ON e.employeeId = s.employeeId
WHERE
	(
		e.activityPeriods LIKE '%"divisionEN": "Forensik"%'
		OR e.email LIKE '%@forensik.ca'
	)
	AND
	(
		e.employementEndDate IS NULL
		OR e.statusEN = 'Active'
	)
GROUP BY e.employeeId
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
    , JSON_VALUE(e.positions, '$.position.positionEN')
	, JSON_VALUE(e.activityPeriods, '$.activityPeriod.divisionEN')
	, s.unit
ORDER BY MAX(CAST(s.value AS MONEY)) DESC
	, AVG(CAST(s.value AS MONEY)) DESC
	, MIN(CAST(s.value AS MONEY)) DESC
;
