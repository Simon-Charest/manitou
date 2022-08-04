def connect_sql_server(server='localhost', database='master', port=1433, driver='{SQL Server}',
                       trusted_connection=True):
    import pyodbc

    p_str = f'Server={server},{port};Database={database};Driver={driver};Trusted_Connection={trusted_connection};'

    return pyodbc.connect(p_str)
