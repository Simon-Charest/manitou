-- Daily Summary by Assignment
SELECT DISTINCT
    sda.projectId
    , sda.divisionEN
    , sda.departmentEN
    , sda.contracts
    , sda.deliverableCode
    , sda.invoices
    , sda.employeeId
    , sda.employeeInternalNo
    , e.name
    , e.firstName
    , e.email

    , MIN(sda.day) AS dayMin
    , MAX(sda.day) AS dayMax

    , SUM(CAST(sda.billedHours AS FLOAT)) AS billedHoursSum
    , SUM(CAST(sda.notBilledAccountHours AS FLOAT)) AS notBilledAccountHoursSum
    , SUM(CAST(sda.notBilledInternalHours AS FLOAT)) AS notBilledInternalHoursSum

    , MIN(CAST(sda.costRate AS MONEY)) AS costRateMin
    , AVG(CAST(sda.costRate AS MONEY)) AS costRateAvg
    , MAX(CAST(sda.costRate AS MONEY)) AS costRateMax

    , MIN(CAST(sda.sellRate AS MONEY)) AS sellRateMin
    , AVG(CAST(sda.sellRate AS MONEY)) AS sellRateAvg
    , MAX(CAST(sda.sellRate AS MONEY)) AS sellRateMax
FROM summaryDayAssignments AS sda
    LEFT JOIN employees AS e ON e.employeeId = sda.employeeId AND e.statusEN = 'Active'
WHERE sda.divisionEN = 'Forensik'
GROUP BY sda.projectId
    , sda.divisionEN
    , sda.departmentEN
    , sda.contracts
    , sda.deliverableCode
    , sda.invoices
    , sda.employeeId
    , sda.employeeInternalNo
    , e.name
    , e.firstName
    , e.email
ORDER BY sda.projectId
    , e.name ASC
    , e.firstName ASC
;
