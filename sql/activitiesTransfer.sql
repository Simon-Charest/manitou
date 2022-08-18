-- Activity Transfers
SELECT DISTINCT
    paf.projectId
    , paf.description
	, at.fromActivityId
	, at.fromAssignmentId
	, at.toActivityId
	, pat.projectId
	, pat.description
	, at.toAssignmentId
	, at.insertionDate
	, e.employeeId
	, e.employeeInternalNumber
	, e.name
    , e.firstName
    , e.email
	, MIN(CAST(at.adjustmentDate AS DATE)) AS adjustmentDateMin
	, MAX(CAST(at.adjustmentDate AS DATE)) AS adjustmentDateMax
	, COUNT(at.adjustmentDate) AS adjustmentDateCount
	, SUM(CAST(at.fromHours AS FLOAT)) AS fromHoursSum
	, SUM(CAST(at.toHours AS FLOAT)) AS toHoursSum
FROM activitiesTransfer AS at
	LEFT JOIN employees AS e ON e.employeeId = at.employeeId AND e.statusEN = 'Active'
	LEFT JOIN projectActivities AS paf ON paf.activityId = at.fromActivityId
	LEFT JOIN projectActivities AS pat ON pat.activityId = at.fromActivityId
GROUP BY at.fromActivityId
	, at.fromAssignmentId
	, paf.projectId
	, paf.description
	, at.toActivityId
	, pat.projectId
	, pat.description
	, at.toAssignmentId
	, at.insertionDate
	, e.employeeId
	, e.employeeInternalNumber
	, e.name
    , e.firstName
    , e.email
ORDER BY paf.projectId ASC
    , e.name ASC
    , e.firstName ASC
;
