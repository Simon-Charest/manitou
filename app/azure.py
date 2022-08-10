def import_json_in_azure(json_directory, sql_configuration, encoding=None, ensure_ascii=True, verbose=False,
                         test=False):
    # Microsoft Azure (https://portal.azure.com)

    from app import io
    from colorama import Fore
    from pathlib import Path
    import glob

    # List JSON files
    paths = glob.glob(f'{json_directory}/*.json')

    # Read database configuration
    sql_configuration = io.read(sql_configuration)

    # Connection to database
    connection = connect_azure_sql(sql_configuration['server'], sql_configuration['uid'], sql_configuration['pwd'],
                                   sql_configuration['database'], sql_configuration['port'],
                                   sql_configuration['driver'], sql_configuration['protocol'],
                                   sql_configuration['persist_security_info'],
                                   sql_configuration['multiple_active_result_sets'],
                                   sql_configuration['connection_timeout'])

    if verbose:
        io.print_colored(f'Importing JSON data to {len(paths)} tables in Azure SQL Database...', Fore.YELLOW)

    table_names = get_table_names(connection)
    indexes = io.read('conf/indexes.json', encoding=encoding)

    if not test:
        # Drop tables
        drop_many(connection, table_names, True)

    if verbose:
        io.print_colored(f'Dropped {len(table_names)} tables.', Fore.RED)

    for path in paths:
        # Read JSON data
        data = io.read(path, encoding=encoding)

        # Create table
        table_name = Path(path).stem
        current_indexes = [index.get('column') for index in indexes if index.get('table') == table_name]
        columns = get_columns(data, current_indexes, True, str.casefold)
        sql = f"""
            IF NOT EXISTS
            (
                SELECT 1
                FROM sys.objects AS o
                WHERE o.name = '{table_name}'
                    AND o.type = 'U'
            )
                CREATE TABLE {table_name}
                (
                    {columns}
                )
        """

        if not test:
            execute(connection, sql, True)

        # For each object in JSON document...
        for datum in data:
            values = get_values(datum.values(), ensure_ascii)

            # Insert JSON data into corresponding table
            if not test:
                column_names = get_column_names(datum.keys())
                sql = f"""
                    INSERT
                    INTO {table_name}
                    (
                        {column_names}
                    )
                    VALUES
                    (
                        {values}
                    )
                """
                execute(connection, sql)

        if not test:
            connection.commit()

        if verbose:
            io.print_colored(f'Imported {len(data)} documents to {table_name}.', Fore.GREEN)

    if verbose:
        io.print_colored('Creating columns and indexes...', Fore.YELLOW)

    prefix = 'index'

    for index in indexes:
        # Create index
        index_name = f"{prefix}_{index['table']}_{index['column']}"

        if not test:
            sql = f"""
                IF NOT EXISTS
                (
                    SELECT 1
                    FROM sys.indexes AS i
                    WHERE i.name = '{index_name}'
                        AND i.object_id = OBJECT_ID('{index['table']}')
                )
                    CREATE INDEX {index_name}
                        ON {index['table']} ({index['column']})
            """
            execute(connection, sql, True)

        if verbose:
            io.print_colored(f"Created {index_name} on {index['table']}.{index['column']}.", Fore.GREEN)

    connection.close()


def execute_and_export(pathname, output_directory):
    from app import io
    import glob
    import os
    from pathlib import Path

    paths = glob.glob(pathname)

    for path in paths:
        sql = io.read(path)
        file = f'{output_directory}/{Path(os.path.basename(path)).stem}.htm'
        export_html_table(sql, file)


def export_html_table(sql, file, sql_configuration='conf/sql.json'):
    from app import io

    sql_configuration = io.read(sql_configuration)
    connection = connect_azure_sql(sql_configuration['server'], sql_configuration['uid'], sql_configuration['pwd'],
                                   sql_configuration['database'], sql_configuration['port'],
                                   sql_configuration['driver'], sql_configuration['protocol'],
                                   sql_configuration['persist_security_info'],
                                   sql_configuration['multiple_active_result_sets'],
                                   sql_configuration['connection_timeout'])
    cursor = execute(connection, sql)
    html_table = io.get_html_table(cursor)
    io.write(html_table, file)
    close([cursor, connection])


def connect_azure_sql(server='localhost', uid='sa', pwd=None, database='master', port=1433,
                      driver='{ODBC Driver 17 for SQL Server}', protocol='tcp', persist_security_info=False,
                      multiple_active_result_sets=False, connection_timeout=30):
    import pyodbc

    p_str = f'''Server={protocol}:{server};port={port};Database={database};UID={uid};Pwd={pwd};Driver={driver};
    Persist Security Info={persist_security_info};MultipleActiveResultSets={multiple_active_result_sets};
    Connection Timeout={connection_timeout};'''

    return pyodbc.connect(p_str)


def delete(connection, table_name, commit=False):
    cursor = connection.cursor()
    sql = f'DELETE FROM {table_name}'
    cursor.execute(sql)

    if commit:
        connection.commit()


def get_columns(data, indexes, sort=False, key=None):
    keys = set()

    for datum in data:
        keys |= set(datum.keys())

    if sort:
        keys = sorted(keys, key=key)

    return ', '.join([f'{key} NVARCHAR(900)\n' if key in indexes else f'{key} NVARCHAR(MAX)\n' for key in keys])


def get_column_names(keys):
    return ', '.join([f'{key}\n' for key in keys])


def get_values(values, ensure_ascii=False):
    old = "'"
    new = "''"

    return ', '.join([f"'{try_replace(get_string(value, ensure_ascii), old, new)}'\n" for value in values])


def try_replace(object_, old, new):
    if object_:
        return object_.replace(old, new)

    return object_


def get_string(obj, ensure_ascii=False):
    import json

    if isinstance(obj, dict):
        # Serialize object to a JSON document
        return json.dumps(obj, ensure_ascii=ensure_ascii)

    return obj


def get_table_names(connection):
    cursor = connection.cursor()
    sql = """
        SELECT table_name
        FROM information_schema.tables
        WHERE table_type = 'base table'
    """
    cursor.execute(sql)
    table_names = [table_name[0] for table_name in cursor]

    return table_names


def drop_many(connection, table_names, commit=False):
    for table_name in table_names:
        drop(connection, table_name)

    if commit:
        connection.commit()


def drop(connection, table_name, commit=False):
    cursor = connection.cursor()

    sql = f'DROP TABLE {table_name}'
    cursor.execute(sql)

    if commit:
        connection.commit()


def execute(connection, sql, commit=False):
    cursor = connection.cursor()
    cursor.execute(sql)

    if commit:
        connection.commit()

    return cursor


def print_cursor(cursor):
    for row in cursor:
        print(row)


def close(objects):
    for obj in objects:
        obj.close()


def test_azure_sql():
    from app import io

    sql_configuration = io.read('conf/sql.json')
    connection = connect_azure_sql(sql_configuration['server'], sql_configuration['uid'], sql_configuration['pwd'],
                                   sql_configuration['database'], sql_configuration['port'],
                                   sql_configuration['driver'], sql_configuration['protocol'],
                                   sql_configuration['persist_security_info'],
                                   sql_configuration['multiple_active_result_sets'],
                                   sql_configuration['connection_timeout'])
    sql = 'SELECT 1, 2, 3 UNION SELECT 4, 5, 6'
    cursor = execute(connection, sql)
    print_cursor(cursor)
    close([cursor, connection])
