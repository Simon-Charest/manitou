-- Daily Summary by Employee
SELECT DISTINCT
    e.employeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
    , sde.legalEntityEN
    , sde.sectorEN
    , sde.divisionEN
    , MIN(sde.day) AS dayMin
    , MAX(sde.day) AS dayMax
    , COUNT(sde.day) AS dayCount

    , MIN(CAST(sde.scheduledHours AS MONEY)) AS scheduledHoursMin
    , AVG(CAST(sde.scheduledHours AS MONEY)) AS scheduledHoursAvg
    , MAX(CAST(sde.scheduledHours AS MONEY)) AS scheduledHoursMax
    , SUM(CAST(sde.scheduledHours AS MONEY)) AS scheduledHoursSum

    , MIN(CAST(sde.hours AS MONEY)) AS hoursMin
    , AVG(CAST(sde.hours AS MONEY)) AS hoursAvg
    , MAX(CAST(sde.hours AS MONEY)) AS hoursMax
    , SUM(CAST(sde.hours AS MONEY)) AS hoursSum

    , MIN(CAST(sde.billedHours AS MONEY)) AS billedHoursMin
    , AVG(CAST(sde.billedHours AS MONEY)) AS billedHoursAvg
    , MAX(CAST(sde.billedHours AS MONEY)) AS billedHoursMax
    , SUM(CAST(sde.billedHours AS MONEY)) AS billedHoursSum

    , MIN(CAST(sde.notBillableHours AS MONEY)) AS notBillableHoursMin
    , AVG(CAST(sde.notBillableHours AS MONEY)) AS notBillableHoursAvg
    , MAX(CAST(sde.notBillableHours AS MONEY)) AS notBillableHoursMax
    , SUM(CAST(sde.notBillableHours AS MONEY)) AS notBillableHoursSum

    , MIN(CAST(sde.percentageBillableHours AS MONEY)) AS percentageBillableHoursMin
    , AVG(CAST(sde.percentageBillableHours AS MONEY)) AS percentageBillableHoursAvg
    , MAX(CAST(sde.percentageBillableHours AS MONEY)) AS percentageBillableHoursMax

    , MIN(CAST(sde.costRate AS MONEY)) AS costRateMin
    , AVG(CAST(sde.costRate AS MONEY)) AS costRateAvg
    , MAX(CAST(sde.costRate AS MONEY)) AS costRateMax

    , MIN(CAST(sde.billedAmount AS MONEY)) AS billedAmountMin
    , AVG(CAST(sde.billedAmount AS MONEY)) AS billedAmountAvg
    , MAX(CAST(sde.billedAmount AS MONEY)) AS billedAmountMax
    , SUM(CAST(sde.billedAmount AS MONEY)) AS billedAmountSum
FROM summaryDayEmployees AS sde
    LEFT JOIN employees AS e ON e.employeeId = sde.employeeId AND e.statusEN = 'Active'
WHERE e.email LIKE '%@forensik.ca'
    OR sde.legalEntityEN = 'Enquêtes Forensik Inc.'
GROUP BY e.employeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
    , sde.legalEntityEN
    , sde.sectorEN
    , sde.divisionEN
ORDER BY billedAmountSum DESC
;
