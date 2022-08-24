-- Facturation - Rapport - Rentabilité - Détaillé
SELECT DISTINCT
	TOP 100
	p.divisionFR AS [Division du projet]
	, p.sectorFR AS [Secteur du projet]
	, p.departmentFR AS [Service du projet]
	, p.projectId AS [Projet]
	, p.projectTitle AS [Titre projet client] -- TODO: Fix this
	, p.projectTitle AS [Titre projet]
	, p.startDate AS [Date de début projet]
	, p.endDate AS [Date de fin réelle projet]
	, crma.officialName AS [Client]
	, crma.officialName AS [Client de réalisation] -- TODO: Fix this
	, (
		SELECT COUNT(1)
		FROM projectContracts AS pc
		WHERE pc.projectId = p.projectId
	) AS [Nombre de contrats]
	, p.currencyFR AS [Devise]
	, pac.description AS [Activité]
	, pac.sectorFR AS [Secteur de l'activité]
	, pac.departmentFR AS [Service de l'activité]
	, pac.externalReferenceNo AS [Référence externe]
	, pac.billableFR AS [Facturable]
	, pre.name + ', ' + pre.firstName AS [Ressouce]
	, JSON_VALUE(pre.activityPeriods, '$.activityPeriod.divisionEN') AS [Division de la ressource]
	, JSON_VALUE(pre.positions, '$.position.positionEN') AS [Secteur de la ressource]
	, pre.profileTypeFR AS [Profil]
	, pre.expectedAvailabilityDate AS [Date]
	, pac.scheduledHoursNumber AS [Nombre d'heures]
	, pac.defaultSellRate AS [Tarif /h]
	, prees.averageCostRate AS [Taux coûtant]
	, CAST(pac.scheduledHoursNumber AS FLOAT) * CAST(pac.defaultSellRate AS MONEY) AS [Total revenu]
	, CAST(pac.scheduledHoursNumber AS FLOAT) * CAST(prees.averageCostRate AS MONEY) AS [Total salaire]
	, CAST(pac.scheduledHoursNumber AS FLOAT) * CAST(pac.defaultSellRate AS MONEY) - CAST(pac.scheduledHoursNumber AS FLOAT) * CAST(prees.averageCostRate AS MONEY) AS [Différence]
	, pac.startDate AS [Début]
	, pac.startDate AS [Fin]
FROM projects AS p
	LEFT JOIN CRMAccounts AS crma ON crma.accountId = p.projectAccountId
	LEFT JOIN projectActivities AS pac ON pac.projectId = p.projectId
	--LEFT JOIN projectAssignments AS pas ON pas.projectId = p.projectId
	--LEFT JOIN projectContracts AS pc ON pc.projectId = p.projectId
	--LEFT JOIN projectDeliverables AS pd ON pd.projectId = p.projectId
	--LEFT JOIN employees AS pme ON pme.employeeId = p.projectManagerEmployeeId
	LEFT JOIN employees AS pre ON pre.employeeId = p.projectResponsibleEmployeeId
	LEFT JOIN employeeSalaries AS prees ON prees.employeeId = p.projectResponsibleEmployeeId
	--LEFT JOIN employees AS ire ON ire.employeeId = p.invoicingResponsibleEmployeeId
/*
WHERE 0 = 0
	AND p.startDate >= '2014-01-01 00:00:00'
	AND p.startDate <= '2022-12-31 23:59:59'
*/
/*
ORDER BY p.startDate ASC
	, p.endDate ASC
*/
;
