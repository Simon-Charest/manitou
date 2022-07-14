from sqlite3 import Error
import sqlite3


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
