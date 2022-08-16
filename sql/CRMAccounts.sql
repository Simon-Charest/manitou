-- Customer relationship management (CRM) Accounts
SELECT DISTINCT
    a.accountId
    , a.code
    , a.subsidiaryCode
    , a.name
    , a.officialName
    , a.partnerEN
    , a.competitorEN
    , a.statusEN
    , a.typeEN
    , MIN(CAST(a.income AS MONEY)) AS incomeMin
    , AVG(CAST(a.income AS MONEY)) AS incomeAvg
    , MAX(CAST(a.income AS MONEY)) AS incomeMax
    , MIN(CAST(a.incomeYear AS INT)) AS incomeYearMin
    , MAX(CAST(a.incomeYear AS INT)) AS incomeYearMax
    , MIN(CAST(a.score AS INT)) AS scoreMin
    , AVG(CAST(a.score AS INT)) AS scoreAvg
    , MAX(CAST(a.score AS INT)) AS scoreMax
    , MIN(CAST(employeesNumber AS INT)) AS employeesNumberMin
    , AVG(CAST(employeesNumber AS INT)) AS employeesNumberAvg
    , MAX(CAST(employeesNumber AS INT)) AS employeesNumberMax
FROM CRMAccounts AS a
    GROUP BY a.accountId
    , a.code
    , a.subsidiaryCode
    , a.name
    , a.officialName
    , a.partnerEN
    , a.competitorEN
    , a.statusEN
    , a.typeEN
ORDER BY a.partnerEN DESC
    , a.competitorEN DESC
    , a.name ASC
;
