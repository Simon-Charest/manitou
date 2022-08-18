-- Project Contracts
SELECT DISTINCT
	pc.projectId
	, pc.contractId
	, CAST(pc.accountId AS INT) AS accountId
	, pc.accountContractNumber
	, pc.statusEN
	, MAX(ISNULL(CAST(pc.signedDate AS DATE), '9999-12-31')) AS signedDate
	, SUM(CAST(pc.billedAmount AS MONEY)) AS billedAmount
	, SUM(CAST(pc.creditAmount AS MONEY)) AS creditAmount
	, SUM(CAST(pc.balance AS MONEY)) AS balance
	, SUM(CAST(pc.contractAmount AS MONEY)) AS contractAmount
FROM projectContracts AS pc
WHERE pc.statusEN <> 'Completed'
GROUP BY pc.contractId
	, accountId
	, pc.accountContractNumber
	, pc.projectId
	, pc.statusEN
ORDER BY pc.statusEN ASC
	, signedDate ASC
	, pc.projectId ASC
	, pc.contractId ASC
	, accountId ASC
;
