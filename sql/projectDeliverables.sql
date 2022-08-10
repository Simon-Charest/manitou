-- Project deliverables
SELECT DISTINCT
    p.deliverableId
    , p.deliverableCode
    , p.accountContractNumber
    , p.projectId
    , p.name
    , p.description
    , p.sectorEN
    , p.departmentEN
    , p.typeEN
    , p.statusEN
    , FORMAT(CAST(p.deliveryDate AS DATE), 'yyyy-MM') AS deliveryMonth
    , p.deliveryDate
    , p.statusDate
    , p.scheduledEffortHours
    , p.realEffortHours
    , CAST(p.billedAmount AS MONEY) - CAST(p.creditedAmount AS MONEY) AS amount
    , p.fixedMonthlyIncome
    , p.deliverableCode
    , p.deliverableId
    , p.incomeConsiderationStartDate
    , p.incomeConsiderationEndDate
    , p.incomeConsiderationModeEN
    , p.responsibleEmployeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
FROM projectDeliverables AS p
	LEFT JOIN employees AS e ON e.employeeId = p.responsibleEmployeeId
WHERE p.statusEN <> 'Completed'
	AND YEAR(p.statusDate) = YEAR(GETDATE())
ORDER BY p.deliveryDate ASC
    , p.statusDate ASC
;
