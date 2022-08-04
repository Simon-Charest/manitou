def import_json_in_azure(json_directory, sql_configuration, encoding=None, ensure_ascii=True, verbose=False,
                         test=False):
    from app import io
    from colorama import Fore
    from pathlib import Path
    import glob
    import json

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
    cursor = None

    if verbose:
        print(f'{Fore.YELLOW}Importing JSON data to {len(paths)} tables in Azure SQL Database...')

    for path in paths:
        # Create table
        table_name = Path(path).stem
        sql = f"""
            IF NOT EXISTS
            (
                SELECT 1
                FROM sys.objects AS o
                WHERE o.name = '{table_name}'
                    AND o.type = 'U'
            )
                CREATE TABLE {table_name} (value NVARCHAR(MAX))
        """
        if not test:
            execute(connection, sql)
            connection.commit()

            # Empty table
            delete(connection, table_name)

        # Read JSON data
        data = io.read(path, encoding=encoding)

        # For each object in JSON document...
        for datum in data:
            # Serialize object to a JSON document
            value = json.dumps(datum, ensure_ascii=ensure_ascii).replace("'", "''")

            # Insert JSON data into corresponding table
            if not test:
                sql = f"""
                    INSERT
                    INTO {table_name} (value)
                    VALUES ('{value}')
                """
                execute(connection, sql)

        if not test:
            connection.commit()

        if verbose:
            print(f'{Fore.GREEN}Imported {len(data)} documents to {table_name}.')

    if verbose:
        print(f"{Fore.YELLOW}Creating columns and indexes...")

    # Read index data
    indexes = io.read('conf/indexes.json', encoding=encoding)
    prefix = 'index'

    for index in indexes:
        if not test:
            # Create column
            sql = f"""
                IF NOT EXISTS
                (
                    SELECT 1
                    FROM sys.columns AS c
                    WHERE c.name = '{index['column']}'
                        AND c.object_id = OBJECT_ID('{index['table']}')
                )
                    ALTER TABLE {index['table']}
                        ADD {index['column']} AS JSON_VALUE(value, '$.{index['column']}')
            """
            execute(connection, sql)
            connection.commit()

        # Create index
        index_name = f"{prefix}_{index['table']}_{index['column']}"

        if not test:
            sql = f"""
                IF NOT EXISTS
                (
                    SELECT 1 FROM sys.indexes AS i WHERE i.name = '{index_name}'
                        AND i.object_id = OBJECT_ID('{index['table']}')
                )
                    CREATE INDEX {index_name}
                        ON {index['table']} ({index['column']})
            """
            execute(connection, sql)
            connection.commit()

        if verbose:
            print(f"{Fore.GREEN}Created {index_name} on {index['table']}.{index['column']}.")

    connection.close()


def connect_azure_sql(server='localhost', uid='sa', pwd=None, database='master', port=1433,
                      driver='{ODBC Driver 17 for SQL Server}', protocol='tcp', persist_security_info=False,
                      multiple_active_result_sets=False, connection_timeout=30):
    import pyodbc

    p_str = f'Server={protocol}:{server};port={port};Database={database};UID={uid};Pwd={pwd};' \
            f'Driver={driver};Persist Security Info={persist_security_info};' \
            f'MultipleActiveResultSets={multiple_active_result_sets};Connection Timeout={connection_timeout};'

    return pyodbc.connect(p_str)


def delete(connection, table_name):
    cursor = connection.cursor()
    sql = f'DELETE FROM {table_name}'
    cursor.execute(sql)


def execute(connection, sql):
    cursor = connection.cursor()
    cursor.execute(sql)

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
