def convert_to_json(input_pathname, output_directory, encoding=None, ensure_ascii=False, indent=None, mode='w',
                    verbose=False, test=False):
    from app import io, xml
    from colorama import Fore
    import glob
    import json
    import os

    # Delete output files
    paths = glob.glob(f'{output_directory}/*.json')

    if not test:
        io.remove(paths)

    if verbose:
        io.print_colored(f'Deleted {len(paths)} JSON files in {output_directory}.', Fore.RED)

    # List input files
    paths = glob.glob(input_pathname)

    if verbose:
        io.print_colored(f'Found {len(paths)} XML files in {os.path.dirname(input_pathname)}.', Fore.YELLOW)

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
        if not test:
            io.write(json_string, file, mode, encoding=encoding)

        if verbose:
            io.print_colored(f'Wrote {length} documents to {file}.', Fore.GREEN)
