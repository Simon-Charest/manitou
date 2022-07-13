from sqlite3 import Error
import glob
import json
import sqlite3
import xmltodict


def main():
    # Variable declarations
    db_file = 'data/db.sqlite'
    pathname = 'data/*.xml'
    encoding = 'utf-8'
    column = 'value'
    datatype = 'blob'
    ensure_ascii = False

    connection = create_connection(db_file)
    paths = glob.glob(pathname)

    for path in paths:
        xml_input = read(path, encoding)
        table, json_string = parse(xml_input, encoding, ensure_ascii)
        create_table(connection, table, column, datatype)
        delete(connection, table)
        insert(connection, table, column, json_string)

    connection.close()


def parse(xml_input, encoding=None, ensure_ascii=True):
    dictionary = xmltodict.parse(xml_input, encoding)
    table = list(dictionary['dataExport'])[-1]
    json_string = json.dumps(dictionary, ensure_ascii=ensure_ascii)

    return table, json_string


def read(file, encoding=None):
    stream = open(file, encoding=encoding)
    string = stream.read()
    stream.close()

    return string


def create_connection(db_file):
    connection = None

    try:
        connection = sqlite3.connect(db_file)

    except Error as error:
        print(error)

    finally:
        return connection


def create_table(connection, table, column, datatype):
    try:
        sql = f'CREATE TABLE IF NOT EXISTS {table} ({column} {datatype})'
        cursor = connection.cursor()
        cursor.execute(sql)
        cursor.close()

    except Error as error:
        print(error)


def insert(connection, table, column, value):
    try:
        value = value.replace("'", "''")
        sql = f"INSERT INTO {table} ({column}) VALUES ('{replace(value)}')"
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


def replace(string, old="'", new=''):
    return string.replace(old, new)
