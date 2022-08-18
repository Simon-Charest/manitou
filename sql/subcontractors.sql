-- Subcontractors
SELECT DISTINCT
    s.employeeId
    , s.employeeInternalNumber
    , s.statusEN
    , s.name
    , s.firstName
    , s.sexEN
    , s.languageEN
    , s.email
	, s.supplier
	, s.profileTypeEN
	, JSON_VALUE(s.activityPeriods, '$.activityPeriod.divisionEN') AS divisionEN
    , s.expectedAvailabilityDate
	, JSON_VALUE(s.activityPeriods, '$.activityPeriod.startDate') AS startDate
	, DATEDIFF(day, CAST(JSON_VALUE(s.activityPeriods, '$.activityPeriod.startDate') AS DATE), GETDATE()) AS startDay
FROM subcontractors AS s
WHERE
	(
		s.activityPeriods LIKE '%"divisionEN": "Forensik"%'
		OR s.email LIKE '%@forensik.ca'
	)
	AND
	(
		s.statusEN = 'Active'
	)
ORDER BY s.name ASC
    , s.firstName ASC
;
