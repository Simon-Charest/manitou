-- Absences
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
	, a.absenceTypeEN
	, COUNT(a.absenceDate) AS absenceDateCount
	, SUM(CAST(a.hours AS FLOAT)) AS hoursSum
FROM absences AS a
	LEFT JOIN employees AS e ON e.employeeId = a.employeeId
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
	, DATEDIFF(year, e.birthDate, GETDATE())
    , e.hireDate
    , e.employementEndDate
	, DATEDIFF(day, e.hireDate, e.employementEndDate)
    , e.workplaceEN
    , JSON_VALUE(e.positions, '$.position.positionEN')
	, JSON_VALUE(e.activityPeriods, '$.activityPeriod.divisionEN')
	, a.absenceTypeEN
ORDER BY e.name ASC
    , e.firstName ASC
;
