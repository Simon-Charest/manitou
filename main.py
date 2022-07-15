# !/usr/bin/env python
def main():
    convert_to_json()


def convert_to_json():
    from app import io, xml
    import glob
    import json
    import os

    # Variable declarations
    pathname = 'data/input/*.xml'
    encoding = 'utf-8'
    ensure_ascii = False
    indent = '\t'
    output_directory = 'data/output'
    mode = 'a'

    # List files
    paths = glob.glob(pathname)

    # For each file...
    for path in paths:
        # Read file
        string = io.read(path, encoding)

        # Extract table name and data
        table, data = xml.parse(string, encoding)

        # Serialize object to JSON formatted string
        json_string = json.dumps(data, ensure_ascii=ensure_ascii, indent=indent)

        # Set file name
        file = f'{output_directory}/{table}.json'

        # If file already exists...
        if os.path.exists(file):
            # Delete file
            os.remove(file)

        # Append to file
        io.write(json_string, file, mode, encoding=encoding)


def convert_to_sqlite():
    from app import db, io, xml
    import glob
    import json

    # Variable declarations
    db_file = 'data/output/db.sqlite'
    pathname = 'data/input/*.xml'
    encoding = 'utf-8'
    column = 'value'
    datatype = 'text'
    ensure_ascii = False

    # Connect to database
    connection = db.create_connection(db_file)

    # Get all table names
    tables = db.get_tables(connection)

    # For each table...
    for table in tables:
        # Empty table
        db.delete(connection, table)

    # List files
    paths = glob.glob(pathname)

    # For each file...
    for path in paths:
        # Read file
        string = io.read(path, encoding)

        # Extract table name and data
        table, data = xml.parse(string, encoding)

        # Create table
        db.create_table(connection, table, column, datatype)

        # If data are present...
        if data:
            # For each dictionary in list...
            for datum in data:
                # Serialize object to JSON formatted string
                json_string = json.dumps(datum, ensure_ascii=ensure_ascii)

                # Insert data into database
                db.insert(connection, table, column, json_string)

            # Commit changes
            connection.commit()

    # Disconnect from database
    connection.close()


if __name__ == '__main__':
    main()
