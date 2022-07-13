# !/usr/bin/env python

# from lib import db, export, io
from app import io
import untangle


def main():
    io.main()

    # export.export()
    # parse_employee_salaries('data/employe_salaire_2_2019-10-01_22-06-35.xml')
    # parse_projects(['data/projets_1_2019-08-27_22-06-33.xml', 'data/projets_2_2019-10-01_22-06-42.xml'])

    """
    values = parse_billed_incomes(['data/revenu_factr_2_2019-10-01_22-06-55.xml'])
    connection = db.create_connection('data/db.sqlite')
    db.create_table(connection, 'billed_income')
    db.inserts(connection, values)
    connection.close()
    """


def parse_billed_incomes(filenames):
    values = []

    for filename in filenames:
        document = untangle.parse(filename)

        for billed_income in document.dataExport.billedIncomes.billedIncome:
            project_id = billed_income.projectId.cdata
            contract_id = billed_income.contractId.cdata
            invoice_no = billed_income.invoiceNo.cdata
            accounting_transfer_date = billed_income.accountingTransferDate.cdata

            values.append(f'''{{
            "projectId": "{project_id}",
            "contractId": {contract_id},
            "invoiceNo": "{invoice_no}",
            "accountingTransferDate": "{accounting_transfer_date}"
            }}''')

    return values


def parse_projects(filenames):
    for filename in filenames:
        document = untangle.parse(filename)

        for project in document.dataExport.projects.project:
            project_id = project.projectId.cdata
            project_title = io.replace(project.projectTitle.cdata)
            start_date = project.startDate.cdata

            if 'expectedEndDate' in project:
                expected_end_date = f'"{project.expectedEndDate.cdata}"'

            else:
                expected_end_date = 'null'

            if 'endDate' in project:
                end_date = f'"{project.endDate.cdata}"'

            else:
                end_date = 'null'

            status_en = project.statusEN.cdata
            project_manager_employee_id = project.projectManagerEmployeeId.cdata
            project_manager_empl_internal_no = project.projectManagerEmplInternalNo.cdata

            if 'Projet interne' not in project_title and status_en != 'Completed':
                print(f'{{'
                      f'"projectId": "{project_id}"'
                      f', "projectTitle": "{project_title}"'
                      f', "startDate": "{start_date}"'
                      f', "expectedEndDate": {expected_end_date}'
                      f', "endDate": {end_date}'
                      f', "projectManagerEmployeeId": {project_manager_employee_id}'
                      f', "projectManagerEmplInternalNo": "{project_manager_empl_internal_no}"'
                      f'}}')


def parse_employee_salaries(filename, coefficient=1321.5859030837):
    document = untangle.parse(filename)

    for employeeSalary in document.dataExport.employeeSalaries.employeeSalary:
        employee_id = employeeSalary.employeeId.cdata
        employee_internal_number = employeeSalary.employeeInternalNumber.cdata
        employee_salary = employeeSalary.value.cdata
        employee_annual_salary = round(coefficient * float(employee_salary), 2)
        start_date = employeeSalary.startDate.cdata

        if 'endDate' in employeeSalary:
            end_date = f'"{employeeSalary.endDate.cdata}"'

        else:
            end_date = 'null'

        print(f'{{'
              f'"employeeId": {employee_id}'
              f', "employeeInternalNumber": "{employee_internal_number}"'
              f', "employeeSalary": {employee_salary}'
              f', "employeeAnnualSalary": {employee_annual_salary}'
              f', "startDate": "{start_date}"'
              f', "endDate": {end_date}'
              f'}}')


if __name__ == '__main__':
    main()
