def read(file, encoding=None):
    stream = open(file, encoding=encoding)
    string = stream.read()
    stream.close()

    return string


def remove(path):
    import os

    for file in os.scandir(path):
        os.remove(file.path)


def write(string, file, mode='w', encoding=None):
    if string:
        stream = open(file, mode, encoding=encoding)
        stream.write(string)
        stream.close()
