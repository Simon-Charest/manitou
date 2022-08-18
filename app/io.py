import datetime


def get_html_table(rows, columns):
    html_table = '''
        <html>
            <head>
                <style>
                    table, th, td
                    {
                        border: 1px solid;
                    }
                    .background-color
                    {
                        background-color: lightgray;
                    }
                </style>
            </head>
            <body>
                <table>
    '''

    row_count = 0

    for row in rows:
        if row_count % 2 == 0:
            class_ = 'background-color'

        else:
            class_ = None

        if row_count == 0:
            html_table += '<tr>\n'

            for column in columns:
                html_table += f'<th>{column}</th>\n'

            html_table += '</tr>\n'

        html_table += '<tr>\n'

        for column in row:
            html_table += f"<td class='{class_}'>"

            if column:
                html_table += str(column)

            else:
                html_table += '</td>\n'

        html_table += '</tr>\n'
        row_count += 1

    html_table += '''
                </table>
            </body>
        </html>
    '''

    return html_table


def get_random_color(minimum=0, maximum=255):
    import random

    red = random.randint(minimum, maximum)
    green = random.randint(minimum, maximum)
    blue = random.randint(minimum, maximum)

    return f"'rgb({red}, {green}, {blue})'"


def print_colored(string, foreground_color=None, fmt='%Y-%m-%d %H:%M:%S'):
    print(f'{foreground_color}[{datetime.datetime.now().strftime(fmt)}] {string}')


def read(file, encoding=None):
    import json

    stream = open(file, encoding=encoding)

    if file[-5:] == '.json':
        # Deserialize JSON document to an object
        data = json.load(stream)

    else:
        data = stream.read()

    stream.close()

    return data


def remove(paths):
    import os

    for path in paths:
        os.remove(path)

    return len(paths)


def write(object_, file, mode='w', encoding=None):
    if object_:
        stream = open(file, mode, encoding=encoding)

        if isinstance(object_, list):
            for element in object_:
                stream.write(f'{element}\n')

        else:
            stream.write(object_)

        stream.close()
