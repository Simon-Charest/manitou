-- Project Deliverables
SELECT DISTINCT
    pd.deliverableId
    , pd.deliverableCode
    , pd.accountContractNumber
    , pd.projectId
    , pd.name
    , pd.description
    , pd.sectorEN
    , pd.departmentEN
    , pd.typeEN
    , pd.statusEN
    , FORMAT(CAST(pd.deliveryDate AS DATE), 'yyyy-MM') AS deliveryMonth
    , pd.deliveryDate
    , pd.statusDate
    , pd.scheduledEffortHours
    , pd.realEffortHours
    , CAST(pd.billedAmount AS MONEY) - CAST(pd.creditedAmount AS MONEY) AS amount
    , pd.fixedMonthlyIncome
    , pd.deliverableCode
    , pd.deliverableId
    , pd.incomeConsiderationStartDate
    , pd.incomeConsiderationEndDate
    , pd.incomeConsiderationModeEN
    , pd.responsibleEmployeeId
    , e.employeeInternalNumber
    , e.name
    , e.firstName
    , e.email
FROM projectDeliverables AS pd
	LEFT JOIN employees AS e ON e.employeeId = pd.responsibleEmployeeId AND e.statusEN = 'Active'
WHERE pd.statusEN <> 'Completed'
	AND YEAR(pd.statusDate) = YEAR(GETDATE())
ORDER BY pd.deliveryDate ASC
    , pd.statusDate ASC
;
