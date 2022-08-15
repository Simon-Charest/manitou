-- Daily Summary by Employee
SELECT DISTINCT
    e.employeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
    , s.legalEntityEN
    , s.sectorEN
    , s.divisionEN
    , MIN(s.day) AS dayMin
    , MAX(s.day) AS dayMax
    , COUNT(s.day) AS dayCount

    , MIN(CAST(s.scheduledHours AS MONEY)) AS scheduledHoursMin
    , AVG(CAST(s.scheduledHours AS MONEY)) AS scheduledHoursAvg
    , MAX(CAST(s.scheduledHours AS MONEY)) AS scheduledHoursMax
    , SUM(CAST(s.scheduledHours AS MONEY)) AS scheduledHoursSum

    , MIN(CAST(s.hours AS MONEY)) AS hoursMin
    , AVG(CAST(s.hours AS MONEY)) AS hoursAvg
    , MAX(CAST(s.hours AS MONEY)) AS hoursMax
    , SUM(CAST(s.hours AS MONEY)) AS hoursSum

    , MIN(CAST(s.billedHours AS MONEY)) AS billedHoursMin
    , AVG(CAST(s.billedHours AS MONEY)) AS billedHoursAvg
    , MAX(CAST(s.billedHours AS MONEY)) AS billedHoursMax
    , SUM(CAST(s.billedHours AS MONEY)) AS billedHoursSum

    , MIN(CAST(s.notBillableHours AS MONEY)) AS notBillableHoursMin
    , AVG(CAST(s.notBillableHours AS MONEY)) AS notBillableHoursAvg
    , MAX(CAST(s.notBillableHours AS MONEY)) AS notBillableHoursMax
    , SUM(CAST(s.notBillableHours AS MONEY)) AS notBillableHoursSum

    , MIN(CAST(s.percentageBillableHours AS MONEY)) AS percentageBillableHoursMin
    , AVG(CAST(s.percentageBillableHours AS MONEY)) AS percentageBillableHoursAvg
    , MAX(CAST(s.percentageBillableHours AS MONEY)) AS percentageBillableHoursMax

    , MIN(CAST(s.costRate AS MONEY)) AS costRateMin
    , AVG(CAST(s.costRate AS MONEY)) AS costRateAvg
    , MAX(CAST(s.costRate AS MONEY)) AS costRateMax

    , MIN(CAST(s.billedAmount AS MONEY)) AS billedAmountMin
    , AVG(CAST(s.billedAmount AS MONEY)) AS billedAmountAvg
    , MAX(CAST(s.billedAmount AS MONEY)) AS billedAmountMax
    , SUM(CAST(s.billedAmount AS MONEY)) AS billedAmountSum
FROM summaryDayEmployees AS s
    LEFT JOIN employees AS e ON e.employeeId = s.employeeId
WHERE e.email LIKE '%@forensik.ca'
    OR s.legalEntityEN = 'Enquêtes Forensik Inc.'
GROUP BY e.employeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
    , s.legalEntityEN
    , s.sectorEN
    , s.divisionEN
ORDER BY SUM(CAST(s.billedAmount AS MONEY)) DESC
;
