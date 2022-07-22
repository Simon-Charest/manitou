# !/usr/bin/env python
def main():
    from colorama import Fore
    import argparse
    import colorama

    # Parse arguments
    input_pathname = 'data/input/*.xml'
    output_directory = 'data/output'
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', default=input_pathname, help=f'Input pathname (default: {input_pathname})')
    parser.add_argument('--output', default=output_directory, help=f'Output directory (default: {output_directory})')
    parser.add_argument('--encoding', default='utf-8', help='File encoding (default: utf-8)')
    parser.add_argument('--ensure_ascii', action='store_true', help='Ensure ASCII encoding (default: False)')
    parser.add_argument('--indent', default='\t', help='Indentation (default: \\t)')
    parser.add_argument('--mode', default='w', help='File mode (default: w)')
    parser.add_argument('--verbose', action='store_true', help='Verbose (default: False)')
    arguments = parser.parse_args()

    # Initialise colorama
    colorama.init()

    # Convert XML data to JSON
    convert_to_json(arguments.input, arguments.output, arguments.encoding, arguments.ensure_ascii, arguments.indent,
                    arguments.mode, arguments.verbose)

    # Convert XML data to SQLite
    # convert_to_sqlite(arguments.input, 'data/output/db.sqlite')

    if arguments.verbose:
        print(f'{Fore.GREEN}** DONE **')


def convert_to_json(input_pathname, output_directory, encoding=None, ensure_ascii=False, indent=None, mode='w',
                    verbose=False):
    from app import io, xml
    from colorama import Fore
    import glob
    import json
    import os

    # Delete output files
    count = io.remove(f'{output_directory}/*.json')

    if verbose:
        print(f'{Fore.RED}Deleted {count} JSON files in {output_directory}.')

    # List input files
    paths = glob.glob(input_pathname)

    if verbose:
        print(f'{Fore.YELLOW}Found {len(paths)} XML files in {os.path.dirname(input_pathname)}.')

    # For each file...
    for path in paths:
        # Read file
        string = io.read(path, encoding)

        # Parse XML data to JSON
        dictionary = xml.parse(string, encoding)

        # Extract table name and data from dictionary
        table_name, data = xml.get_table_name_and_data(dictionary)

        # Set output file name
        file = f'{output_directory}/{table_name}.json'

        # Set length of the list of new elements
        length = len(data)

        # If preexisting file found...
        if os.path.exists(file):
            # Read and deserialize JSON document to object
            json_objects = io.read(file, encoding)

            # Append to preexisting data
            if isinstance(data, dict):
                data = [data]

            data = json_objects + data

        # Serialize object to JSON document
        json_string = json.dumps(data, ensure_ascii=ensure_ascii, indent=indent)

        # Write to file
        io.write(json_string, file, mode, encoding=encoding)

        if verbose:
            print(f'{Fore.GREEN}Wrote {length} documents to {file}.')


def convert_to_sqlite(input_pathname, output_db_file, encoding='utf-8', column='value', datatype='text',
                      ensure_ascii=False):
    from app import db, io, xml
    import glob
    import json

    # Connect to database
    connection = db.create_connection(output_db_file)

    # Get all table names
    tables = db.get_tables(connection)

    # For each table...
    for table in tables:
        # Empty table
        db.delete(connection, table)

    # List files
    paths = glob.glob(input_pathname)

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
