# !/usr/bin/env python
def main():
    from app import azure, convert, io

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
    parser.add_argument('--convert', action='store_true', help='Convert data from XML to JSON (default: False)')
    parser.add_argument('--sql', action='store_true', help='Import JSON data to Azure SQL database (default: False)')
    parser.add_argument('--verbose', action='store_true', help='Verbose (default: False)')
    parser.add_argument('--test', action='store_true', help='Skip import process (default: False)')
    arguments = parser.parse_args()

    # Initialise colorama
    colorama.init()

    # Convert XML data to JSON
    if arguments.convert:
        convert.convert_to_json(arguments.input, arguments.output, arguments.encoding, arguments.ensure_ascii,
                                arguments.indent, arguments.mode, arguments.verbose, test=arguments.test)

    # Import JSON files in Azure SQL database
    if arguments.sql:
        azure.import_json_in_azure(arguments.output, 'conf/sql.json', encoding=arguments.encoding,
                                   ensure_ascii=arguments.ensure_ascii, verbose=arguments.verbose, test=arguments.test)

    if arguments.verbose:
        io.print_colored('** DONE **', Fore.GREEN)


if __name__ == '__main__':
    main()
