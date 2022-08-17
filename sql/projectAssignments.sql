-- Project Assignments
SELECT DISTINCT
	a.projectId
	, a.agreementNo
	, a.employeeId
	, a.employeeInternalNo
	, ISNULL(e.name, s.name) AS name
	, ISNULL(e.firstName, s.firstName) AS firstName
	, ISNULL(e.email, s.email) AS email
	, MIN(CAST(a.startDate AS DATE)) AS startDateMin
	, MAX(CAST(a.expectedEndDate AS DATE)) AS expectedEndDateMax
	, MAX(CAST(a.endDate AS DATE)) AS endDateMax
	, AVG(CAST(a.hourlyRate AS MONEY)) AS hourlyRateAvg
	, SUM(CAST(a.scheduledHours AS FLOAT)) AS scheduledHoursSum
	, AVG(CAST(a.hourlyRate AS MONEY)) * SUM(CAST(a.scheduledHours AS FLOAT)) AS scheduledTotal
	, SUM(CAST(a.toBeDoneHours AS FLOAT)) AS toBeDoneHoursSum
	, AVG(CAST(a.hourlyRate AS MONEY)) * SUM(CAST(a.toBeDoneHours AS FLOAT)) AS toBeDoneTotal
FROM projectAssignments AS a
	LEFT JOIN employees AS e ON e.employeeId = a.employeeId AND e.statusEN = 'Active'
	LEFT JOIN subcontractors AS s ON s.employeeId = a.employeeId AND s.statusEN = 'Active'
GROUP BY a.projectId
	, a.agreementNo
	, a.employeeId
	, a.employeeInternalNo
	, ISNULL(e.name, s.name)
	, ISNULL(e.firstName, s.firstName)
	, ISNULL(e.email, s.email)
ORDER BY AVG(CAST(a.hourlyRate AS MONEY)) * SUM(CAST(a.scheduledHours AS FLOAT)) DESC
	, AVG(CAST(a.hourlyRate AS MONEY)) * SUM(CAST(a.toBeDoneHours AS FLOAT)) DESC
	, a.projectID ASC
;
