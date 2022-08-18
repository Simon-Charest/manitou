-- Project Assignments
SELECT DISTINCT
	pas.projectId
	, pas.agreementNo
	, pas.employeeId
	, pas.employeeInternalNo
	, ISNULL(e.name, s.name) AS name
	, ISNULL(e.firstName, s.firstName) AS firstName
	, ISNULL(e.email, s.email) AS email
	, MIN(CAST(pas.startDate AS DATE)) AS startDateMin
	, MAX(CAST(pas.expectedEndDate AS DATE)) AS expectedEndDateMax
	, MAX(CAST(pas.endDate AS DATE)) AS endDateMax
	, AVG(CAST(pas.hourlyRate AS MONEY)) AS hourlyRateAvg
	, SUM(CAST(pas.scheduledHours AS FLOAT)) AS scheduledHoursSum
	, AVG(CAST(pas.hourlyRate AS MONEY)) * SUM(CAST(pas.scheduledHours AS FLOAT)) AS scheduledTotal
	, SUM(CAST(pas.toBeDoneHours AS FLOAT)) AS toBeDoneHoursSum
	, AVG(CAST(pas.hourlyRate AS MONEY)) * SUM(CAST(pas.toBeDoneHours AS FLOAT)) AS toBeDoneTotal
FROM projectAssignments AS pas
	LEFT JOIN employees AS e ON e.employeeId = pas.employeeId AND e.statusEN = 'Active'
	LEFT JOIN subcontractors AS s ON s.employeeId = pas.employeeId AND s.statusEN = 'Active'
GROUP BY pas.projectId
	, pas.agreementNo
	, pas.employeeId
	, pas.employeeInternalNo
	, ISNULL(e.name, s.name)
	, ISNULL(e.firstName, s.firstName)
	, ISNULL(e.email, s.email)
ORDER BY scheduledTotal DESC
	, toBeDoneTotal DESC
	, pas.projectID ASC
;
