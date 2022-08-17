-- Project Contracts
SELECT DISTINCT
	c.projectId
	, c.contractId
	, CAST(c.accountId AS INT) AS accountId
	, c.accountContractNumber
	, c.statusEN
	, MAX(ISNULL(CAST(c.signedDate AS DATE), '9999-12-31')) AS signedDate
	, SUM(CAST(c.billedAmount AS MONEY)) AS billedAmount
	, SUM(CAST(c.creditAmount AS MONEY)) AS creditAmount
	, SUM(CAST(c.balance AS MONEY)) AS balance
	, SUM(CAST(c.contractAmount AS MONEY)) AS contractAmount
FROM projectContracts AS c
WHERE c.statusEN <> 'Completed'
GROUP BY c.contractId
	, CAST(c.accountId AS INT)
	, c.accountContractNumber
	, c.projectId
	, c.statusEN
ORDER BY c.statusEN ASC
	, MAX(ISNULL(CAST(c.signedDate AS DATE), '9999-12-31')) ASC
	, c.projectId ASC
	, c.contractId ASC
	, CAST(c.accountId AS INT) ASC
;
