-- Billed Incomes
SELECT DISTINCT
    p.projectId
    , MAX(i.accountingTransferDate) AS accountingTransferDateMax
    , MAX(i.sentDate) AS sentDateMax
    , MAX(i.WiPABDate) AS WiPABDateMax
    , SUM(CAST(i.billedInAdvanceAmount AS MONEY)) AS billedInAdvanceAmountSum
	, SUM(CAST(i.billedAmount AS MONEY)) AS billedAmountSum
    , SUM(CAST(i.workInProgressAmount AS MONEY)) AS workInProgressAmountSum
    , SUM(CAST(i.creditedAmount AS MONEY)) AS creditedAmountSum
    , SUM(CAST(i.incomeAmount AS MONEY)) AS incomeAmountSum
FROM billedIncomes AS i
    LEFT JOIN projects AS p ON p.projectId = i.projectId
    LEFT JOIN employees AS e ON e.employeeId = i.WiPABemployeeId
GROUP BY p.projectId
ORDER BY SUM(CAST(i.incomeAmount AS MONEY)) DESC
;
