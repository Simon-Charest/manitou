-- Project Activities
SELECT DISTINCT
    p.projectId
	, p.projectTitle
	, MIN(a.startDate) AS startDateMin
	, MAX(a.expectedEndDate) AS expectedEndDateMax
	, MAX(a.endDate) AS endDateMax
	, a.statusEN
	, AVG(CAST(JSON_VALUE(a.contracts, '$.contract.invoicingPercentage') AS INT)) AS invoicingPercentageAvg
	, SUM(CAST(a.scheduledHoursNumber AS FLOAT)) AS scheduledHoursNumberSum
	, AVG(CAST(a.defaultSellRate AS MONEY)) AS defaultSellRateAvg
	, SUM
	(
		CAST
		(
			CASE a.billableEN WHEN 'Yes'
				THEN JSON_VALUE(a.contracts, '$.contract.invoicingPercentage') / 100.0 *
				    ISNULL(a.scheduledHoursNumber, 0) * a.defaultSellRate
				ELSE 0
			END
			AS MONEY
		)
	) AS billableSum
FROM projectActivities AS a
	LEFT JOIN projects AS p ON p.projectId = a.projectId
WHERE p.projectId IN
(
    'AGENZ21001', 'AVR20001', 'COLLE21001', 'CSDL21002', 'CTECH21001', 'I2T21001', 'LKD20001','MCBAR21001',
    'RESPU20001', 'ROXBO21001', 'SDM21003', 'SMINI21001', 'UQAM21001'
)
GROUP BY p.projectId
    , p.projectTitle
    , a.statusEN
ORDER BY billableSum DESC
	, p.projectId ASC
;
