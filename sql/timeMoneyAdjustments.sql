-- Time and Money Adjustments
SELECT DISTINCT
    tma.activityId
    , tma.billableEN
    , tma.employeeId
    , tma.employeeInternalNo
    , e.name
    , e.firstName
    , e.email
    , MAX(CAST(tma.insertionDate AS DATE)) AS insertionDateMax
    , MAX(CAST(tma.adjustmentDate AS DATE)) AS adjustmentDateMax
    , SUM(CAST(tma.hours AS FLOAT)) AS hoursSum
FROM timeMoneyAdjustments AS tma
    LEFT JOIN employees AS e ON e.employeeId = tma.employeeId AND e.statusEN = 'Active'
GROUP BY tma.activityId
    , tma.billableEN
    , tma.employeeId
    , tma.employeeInternalNo
    , e.name
    , e.firstName
    , e.email
ORDER BY tma.activityId ASC
    , e.name ASC
    , e.firstName ASC
    , e.email ASC
    , hoursSum ASC
;
