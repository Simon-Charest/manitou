from sqlite3 import Error
import sqlite3


def import_json_in_sqlite(input_pathname, output_db_file, encoding='utf-8', column='value', datatype='text',
                          ensure_ascii=False):
    from app import io, xml
    import glob
    import convert

    # Connect to database
    connection = create_connection(output_db_file)

    # Get all table names
    tables = get_tables(connection)

    # For each table...
    for table in tables:
        # Empty table
        delete(connection, table)

    # List files
    paths = glob.glob(input_pathname)

    # For each file...
    for path in paths:
        # Read file
        string = io.read(path, encoding)

        # Extract table name and data
        table, data = xml.parse(string, encoding)

        # Create table
        create_table(connection, table, column, datatype)

        # If data are present...
        if data:
            # For each dictionary in list...
            for datum in data:
                # Serialize object to JSON formatted string
                json_string = json.dumps(datum, ensure_ascii=ensure_ascii)

                # Insert data into database
                insert(connection, table, column, json_string)

            # Commit changes
            connection.commit()

    # Disconnect from database
    connection.close()


def create_connection(db_file):
    connection = None

    try:
        connection = sqlite3.connect(db_file)

    except Error as error:
        print(error)

    return connection


def create_table(connection, table, column, datatype):
    try:
        sql = f'CREATE TABLE IF NOT EXISTS {table} ({column} {datatype})'
        cursor = connection.cursor()
        cursor.execute(sql)
        cursor.close()

    except Error as error:
        print(error)


def delete(connection, table):
    try:
        sql = f'DELETE FROM {table}'
        cursor = connection.cursor()
        cursor.execute(sql)
        cursor.close()

    except Error as error:
        print(error)


def get_tables(connection):
    sql = "SELECT name FROM sqlite_schema WHERE type='table'"
    cursor = connection.cursor()
    cursor.execute(sql)
    tables = cursor.fetchall()
    tables = [table[0] for table in tables]
    cursor.close()

    return tables


def insert(connection, table, column, value):
    last_row_id = None

    try:
        value = value.replace("'", '')
        sql = f"INSERT INTO {table} ({column}) VALUES ('{value}')"
        cursor = connection.cursor()
        cursor.execute(sql)
        last_row_id = cursor.lastrowid
        cursor.close()

    except Error as error:
        print(error)

    return last_row_id
