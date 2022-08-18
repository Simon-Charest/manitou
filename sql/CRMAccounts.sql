-- Customer relationship management (CRM) Accounts
SELECT DISTINCT
    crma.accountId
    , crma.code
    , crma.subsidiaryCode
    , crma.name
    , crma.officialName
    , crma.partnerEN
    , crma.competitorEN
    , crma.statusEN
    , crma.typeEN
    , MIN(CAST(crma.income AS MONEY)) AS incomeMin
    , AVG(CAST(crma.income AS MONEY)) AS incomeAvg
    , MAX(CAST(crma.income AS MONEY)) AS incomeMax
    , MIN(CAST(crma.incomeYear AS INT)) AS incomeYearMin
    , MAX(CAST(crma.incomeYear AS INT)) AS incomeYearMax
    , MIN(CAST(crma.score AS INT)) AS scoreMin
    , AVG(CAST(crma.score AS INT)) AS scoreAvg
    , MAX(CAST(crma.score AS INT)) AS scoreMax
    , MIN(CAST(employeesNumber AS INT)) AS employeesNumberMin
    , AVG(CAST(employeesNumber AS INT)) AS employeesNumberAvg
    , MAX(CAST(employeesNumber AS INT)) AS employeesNumberMax
FROM CRMAccounts AS crma
    GROUP BY crma.accountId
    , crma.code
    , crma.subsidiaryCode
    , crma.name
    , crma.officialName
    , crma.partnerEN
    , crma.competitorEN
    , crma.statusEN
    , crma.typeEN
ORDER BY crma.partnerEN DESC
    , crma.competitorEN DESC
    , crma.name ASC
;
