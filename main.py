# !/usr/bin/env python
def main():
    from colorama import Fore
    import argparse
    import colorama

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', default='data/input/*.xml', help='Input pathname (default: data/input/*.xml)')
    parser.add_argument('--output', default='data/output', help='Output directory (default: data/output)')
    parser.add_argument('--encoding', default='utf-8', help='File encoding (default: utf-8)')
    parser.add_argument('--ensure_ascii', action='store_true', help='Ensure ASCII encoding (default: False)')
    parser.add_argument('--indent', default='\t', help='Indentation (default: \\t)')
    parser.add_argument('--mode', default='a', help='File mode (default: a)')
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

    # List previous output files
    paths = glob.glob(f'{output_directory}/*.json')

    # For each file...
    for path in paths:
        # Delete file
        os.remove(path)

    if verbose:
        print(f'{Fore.RED}Deleted {len(paths)} JSON files in {output_directory}.')

    # List input files
    paths = glob.glob(input_pathname)

    if verbose:
        print(f'{Fore.YELLOW}Found {len(paths)} XML files in {os.path.dirname(input_pathname)}.')

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

        # Append to file
        io.write(json_string, file, mode, encoding=encoding)

        if verbose and data:
            print(f'{Fore.GREEN}Wrote {len(data)} documents to {file}.')


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
