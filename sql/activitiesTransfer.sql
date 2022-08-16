-- Activity Transfers
SELECT DISTINCT
	a.fromActivityId
	, a.fromAssignmentId
	, f.projectId
	, f.description
	, a.toActivityId
	, t.projectId
	, t.description
	, a.toAssignmentId
	, a.insertionDate
	, e.employeeId
	, e.employeeInternalNumber
	, e.name
    , e.firstName
    , e.email
	, MIN(CAST(a.adjustmentDate AS DATE)) AS adjustmentDateMin
	, MAX(CAST(a.adjustmentDate AS DATE)) AS adjustmentDateMax
	, COUNT(a.adjustmentDate) AS adjustmentDateCount
	, SUM(CAST(a.fromHours AS FLOAT)) AS fromHoursSum
	, SUM(CAST(a.toHours AS FLOAT)) AS toHoursSum
FROM activitiesTransfer AS a
	LEFT JOIN employees AS e ON e.employeeId = a.employeeId
	LEFT JOIN projectActivities AS f ON f.activityId = a.fromActivityId
	LEFT JOIN projectActivities AS t ON t.activityId = a.fromActivityId
GROUP BY a.fromActivityId
	, f.projectId
	, f.description
	, a.fromAssignmentId
	, a.toActivityId
	, t.projectId
	, t.description
	, a.toAssignmentId
	, a.insertionDate
	, e.employeeId
	, e.employeeInternalNumber
	, e.name
    , e.firstName
    , e.email
;
