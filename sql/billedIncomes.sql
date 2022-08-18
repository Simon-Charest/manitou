-- Billed Incomes
SELECT DISTINCT
    p.projectId
    , MAX(bi.accountingTransferDate) AS accountingTransferDateMax
    , MAX(bi.sentDate) AS sentDateMax
    , MAX(bi.WiPABDate) AS WiPABDateMax
    , SUM(CAST(bi.billedInAdvanceAmount AS MONEY)) AS billedInAdvanceAmountSum
	, SUM(CAST(bi.billedAmount AS MONEY)) AS billedAmountSum
    , SUM(CAST(bi.workInProgressAmount AS MONEY)) AS workInProgressAmountSum
    , SUM(CAST(bi.creditedAmount AS MONEY)) AS creditedAmountSum
    , SUM(CAST(bi.incomeAmount AS MONEY)) AS incomeAmountSum
FROM billedIncomes AS bi
    LEFT JOIN projects AS p ON p.projectId = bi.projectId
    LEFT JOIN employees AS e ON e.employeeId = bi.WiPABemployeeId AND e.statusEN = 'Active'
GROUP BY p.projectId
ORDER BY incomeAmountSum DESC
;
