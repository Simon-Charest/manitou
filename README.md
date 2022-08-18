# Manitou Data Converter

## Introduction
This solution was developed taking into account the absence of a web API for the Manitou application as well as the fact that it is easier to use data from a database than a batch of XML files.

This solution:
1. Expects [XML](https://en.wikipedia.org/wiki/XML) files (i.e., data/input/xml/*.xml), manually extracted from the [Manitou](https://manitousolution.com/application) application (i.e., Log In &rarr; General &rarr; Export data (beta));
2. Reads the said files;
3. Converts them to the [JSON](https://en.wikipedia.org/wiki/JSON) data format;
4. Imports the data to [Azure SQL Database](https://en.wikipedia.org/wiki/Microsoft_Azure_SQL_Database);
5. Which can then be used by solutions such as [Power BI](https://en.wikipedia.org/wiki/Microsoft_Power_BI).

To do:
- Manitou should include access to live data and its statistics, through to a web API, with secure authentication (i.e., OAuth 2.0);
- Manitou data should be segregated (i.e. one database per customer) and fully accessible by its owner, in order to comply with the [Act to modernize legislative provisions as regards the protection of personal information](http://assnat.qc.ca/en/travaux-parlementaires/projets-loi/projet-loi-64-42-1.html), which will come into force on 2023-09-22, in the province of Quebec;
- Manitou data should be segregated so that a superuser account is not required to export basic information;
- Manitou should include a reporting module (i.e., Power BI);
- Manitou data export module must be automatic, recurring and its data must be live (i.e., based on a replication of the production database, via a queuing mechanism).

## Flowchart
```mermaid
flowchart TD
    A[Manitou] -- Daily extraction, at 22 h --> B[XML]
    B[XML] -- Convert --> C[JSON]
    C[JSON] -- Import --> D[Azure SQL Database]
    D[Azure SQL Database] -- Refresh --> E[Power BI]
```

---

## Install this solution
1. Download and extract the project from [GitHub](https://github.com/Simon-Charest/manitou) (e.g., Code &rarr; Download ZIP &rarr; go to This PC &rarr; Downloads &rarr; select file &rarr; context menu &rarr; Extract All... to `C:\temp\manitou`);
2. Run Windows PowerShell as an administrator;
3. Execute: `& "C:\temp\manitou\install.ps1"`;
4. Copy `"conf/sql_template.json"` to `"conf/sql.json"` and contact your system administrator for assistance in completing the Azure SQL Database configuration.

## Export data from Manitou
1. Log in to [Manitou](https://manitousolution.com/application), with a superuser account;
2. Go to General &rarr; Functions &rarr; Export data (beta);
3. Click + Add, select a Start of extraction (i.e., 2022 January), enter a Number of periods to export (i.e., 6 (months, including the selected Start of extraction)) and select a Requestor (i.e., yourself);
4. Wait after 22 h that night for the query to run;
5. Click on the corresponding Consult button (paperclip icon) to download the archive;
6. Right-click the archive &rarr; Extract All... &rarr; Select a destination folder (i.e., `C:\temp\manitou\data\input\xml`) &rarr; Extract;

## Convert and import data using this solution
1. Run Windows PowerShell;
2. Execute `python "mdc.py" --input "data/input/xml/*.xml" --output "data/output/json" --convert --sql --verbose`.

Execution example:
```powershell
[2022-08-09 13:21:22] Deleted 15 JSON files in data/output/json.
[2022-08-09 13:21:22] Found 35 XML files in data/input/xml.
[2022-08-09 13:21:22] Wrote 235 documents to data/output/json/absences.json.
[...]
[2022-08-09 13:21:30] Importing JSON data to 15 tables in Azure SQL Database...
[2022-08-09 13:21:30] Dropped 3 tables.
[2022-08-09 13:21:40] Imported 424 documents to absences.
[...]
[2022-08-09 13:59:16] Creating columns and indexes...
[2022-08-09 13:59:16] Created index_absences_absenceId on absences.absenceId.
[...]
[2022-08-09 13:59:42] ** DONE **
```

For help, use: `python "mdc.py" --help`.

The data will be imported, as JSON, into the "value" field, of the following tables, in a database named "manitoudb", in an Azure SQL Database instance.
- absences;
- activitiesTransfer;
- billedIncomes;
- CRMAccounts;
- employees;
- employeeSalaries;
- projectActivities;
- projectAssignments;
- projectContracts;
- projectDeliverables;
- projects;
- subcontractors;
- summaryDayAssignments;
- summaryDayEmployees;
- timeMoneyAdjustments.

## Execute SQL queries and export results in HTML table format (optional)
1. Run Windows PowerShell;
2. Execute `python "mdc.py" --output "data/output/html" --export`;
3. Find the resulting HTML files in the output subdirectory.

## Import data into Power BI
### Create new report
1. Install [Power BI](https://powerbi.microsoft.com/en-us/downloads/);
2. Run Power BI.

### Get data from JSON data files
3. File &rarr; Get Data &rarr; Get data to get started &rarr; JSON &rarr; Connect;
4. Select the first file &rarr; Open;
5. Home &rarr; New Source &rarr; JSON &rarr; JSON;
6. Select next file &rarr; Open;
7. Repeat steps 5 and 6 for each file.

### Save Power BI file
9. Close & Apply;
10. File &rarr; Save &rarr; File name: `"C:\temp\manitou\data\manitou.pbix"`.

## Refresh reports
1. Repeat export and convert steps;
2. Refresh data in Power BI, using Home &rarr; Refresh;
3. Save Power BI file, using File &rarr; Save.

---

## About Manitou
- Application: [Manitou](https://manitousolution.com/application);
- Developer: [Manitou Solution](https://manitousolution.com);
- Address: [412-825, Lebourgneuf Boulevard, Quebec, QC, G2J 0B9](https://www.google.com/maps/place/825+Bd+Lebourgneuf+bureau+412,+Qu%C3%A9bec,+QC+G2J+0B9);
- Technologies: [APEX](https://en.wikipedia.org/wiki/Oracle_Application_Express), [JS](https://en.wikipedia.org/wiki/JavaScript), [PHP](https://en.wikipedia.org/wiki/PHP), [WordPress](https://en.wikipedia.org/wiki/WordPress);
- Web server: [Nginx](https://en.wikipedia.org/wiki/Nginx);
- Web API: [Oracle REST Data Services (ORDS)](https://en.wikipedia.org/wiki/Oracle_Application_Express#APEX_Service).

## Related solutions
- [Dynamics 365](https://dynamics.microsoft.com/);
- [JIRA](https://www.atlassian.com/software/jira);
- [Nethris](https://nethris.com/);
- [Sage](https://www.sage.com/).

## About this solution
© Simon Charest | [Forensik](https://forensik.ca/) | [In Fidem](https://infidem.biz/) | [Atos](https://atos.net/). All rights reserved.

## Requirements
- [Azure SQL Database](https://en.wikipedia.org/wiki/Microsoft_Azure_SQL_Database);
- [Git](https://git-scm.com/) (optional);
- [GitHub](https://github.com/) (optional);
- [Manitou](https://manitousolution.com/application/);
- [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) (optional);
- [Power BI](https://en.wikipedia.org/wiki/Microsoft_Power_BI) (optional);
- [PowerShell](https://en.wikipedia.org/wiki/PowerShell);
- [PyCharm](https://www.jetbrains.com/pycharm/) (optional);
- [Python](https://www.python.org/);
  - [colorama](https://pypi.org/project/colorama/);
  - [pip](https://pypi.org/project/pip/);
  - [pyodbc](https://pypi.org/project/pyodbc/);
  - [Python O365](https://github.com/O365/python-o365);
  - [setuptools](https://pypi.org/project/setuptools/);
  - [xmltodict](https://pypi.org/project/xmltodict/).

## About the author
Mr. Simon Charest, Software Developer and CEO at SLCIT Inc.
- [Email](mailto:simoncharest@gmail.com);
- [GitHub](https://github.com/Simon-Charest);
- [LinkedIn](https://www.linkedin.com/in/simoncharest/).
