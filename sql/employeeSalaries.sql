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
	, es.unit
	, MIN(CAST(es.value AS MONEY)) AS valueMin
	, AVG(CAST(es.value AS MONEY)) AS valueAvg
	, MAX(CAST(es.value AS MONEY)) AS valueMax
	, CAST(ROUND(MIN(CAST(es.value AS MONEY)) * 1321.5859030837, 0) AS MONEY) AS annualValueMin
	, CAST(ROUND(AVG(CAST(es.value AS MONEY)) * 1321.5859030837, 0) AS MONEY) AS annualValueAvg
	, CAST(ROUND(MAX(CAST(es.value AS MONEY)) * 1321.5859030837, 0) AS MONEY) AS annualValueMax
FROM employeeSalaries AS es
	LEFT JOIN employees AS e ON e.employeeId = es.employeeId AND e.statusEN = 'Active'
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
	, es.unit
ORDER BY valueMax DESC
	, valueAvg DESC
	, valueMin DESC
;
