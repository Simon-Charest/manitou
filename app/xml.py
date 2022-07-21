def get_array_name(dictionary, table_name, root_element='dataExport'):
    return list(dictionary[root_element][table_name])[0]


def get_data(dictionary, table_name, array_name, root_element='dataExport'):
    return dictionary[root_element][table_name][array_name]


def get_length(dictionary, root_element='dataExport'):
    table_name = get_table_name(dictionary)
    length = 0

    if dictionary[root_element][table_name]:
        array_name = get_array_name(dictionary, table_name)
        data = get_data(dictionary, table_name, array_name)
        length = len(data)

    return length


def get_table_name(dictionary, root_element='dataExport'):
    return list(dictionary[root_element])[-1]


def get_table_name_and_data(dictionary, root_element='dataExport'):
    table_name = get_table_name(dictionary)
    data = []

    if dictionary[root_element][table_name]:
        array_name = get_array_name(dictionary, table_name)
        data = get_data(dictionary, table_name, array_name)

    return table_name, data


def parse(xml_input, encoding=None):
    import xmltodict

    return xmltodict.parse(xml_input, encoding)
