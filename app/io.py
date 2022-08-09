import datetime


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
