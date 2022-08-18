-- Project Activities
SELECT DISTINCT
    p.projectId
	, p.projectTitle
	, MIN(pac.startDate) AS startDateMin
	, MAX(pac.expectedEndDate) AS expectedEndDateMax
	, MAX(pac.endDate) AS endDateMax
	, pac.statusEN
	, AVG(CAST(JSON_VALUE(pac.contracts, '$.contract.invoicingPercentage') AS INT)) AS invoicingPercentageAvg
	, SUM(CAST(pac.scheduledHoursNumber AS FLOAT)) AS scheduledHoursNumberSum
	, AVG(CAST(pac.defaultSellRate AS MONEY)) AS defaultSellRateAvg
	, SUM
	(
		CAST
		(
			CASE pac.billableEN WHEN 'Yes'
				THEN JSON_VALUE(pac.contracts, '$.contract.invoicingPercentage') / 100.0 *
				    ISNULL(pac.scheduledHoursNumber, 0) * pac.defaultSellRate
				ELSE 0
			END
			AS MONEY
		)
	) AS billableSum
FROM projectActivities AS pac
	LEFT JOIN projects AS p ON p.projectId = pac.projectId
WHERE p.projectId IN
(
    'AGENZ21001', 'AVR20001', 'COLLE21001', 'CSDL21002', 'CTECH21001', 'I2T21001', 'LKD20001','MCBAR21001',
    'RESPU20001', 'ROXBO21001', 'SDM21003', 'SMINI21001', 'UQAM21001'
)
GROUP BY p.projectId
    , p.projectTitle
    , pac.statusEN
ORDER BY billableSum DESC
	, p.projectId ASC
;
